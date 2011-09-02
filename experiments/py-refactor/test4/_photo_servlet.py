"""Base classes for servlets which serve images out of S3."""
import logging
import re
import time

import config
from util import http
import util.applog
import util.domain
import webob.exc
from cmds._action_mapper import ActionMapper
from cmds._action_mapper import expose
from cmds._cmd import StdCmd
from util import json
from util.timeutil import rfc1123_date
from yelp_lib import clog


log = logging.getLogger(util.applog.LOGGER_NAME + '.cmds._photo_servlet')

JPG_ENDING = re.compile(r'\.jpg$')

# Regex to determine whether the request can be served by this servlet
PHOTO_REGEX = re.compile('^/((b|e|d|bu|w)?photo|(b|u)pthumb)/[-a-zA-Z0-9_]{22}/[a-z]{1,3}(.inactive)?')

class PhotoCmd(StdCmd):
	is_image_servlet = True

	def allowed_server_name(self, server_name):
		# Unfortunately, we support serving images out of www (with a redirect).
		# Also, need to include media to match the CDN names in dev
		return server_name.startswith("images.") or server_name == "me" or server_name.startswith("www.") or server_name.startswith("media")

	def require_ssl(self):
		"""We don't care about protocol"""
		return None

	def process_hostname_and_maybe_redirect(self, permanent=True, *args, **kwargs):
		"""This just makes redirects permanent"""
		return super(PhotoCmd, self).process_hostname_and_maybe_redirect(permanent, *args, **kwargs)

	def _hostname_to_country_or_maybe_redirect(self):
		hostname = self.request.host

		# Squid hack, don't change
		if hostname == 'me':
			return 'US'

		return util.domain.images_domain_to_country(hostname) or util.domain.cdn_domain_to_country(hostname)

	def _canonical_hostname(self, country=None, base_lang=None):
		if self.request.is_https:
			return util.domain.images_domain()
		return util.domain.pick_cdn_hostname(config.domain.CDN_ORIGIN_YELP)

class PhotoServlet(PhotoCmd, ActionMapper):
	@expose
	def default(self, photo_id=None, photo_size=None, *args):
		# Redirect for legacy urls. These are URLs of the form
		# /photo?id=foo&s=l
		if set(self.form.keys()) == set(['id', 's']):
			servlet, _ = self.request.unparsed_uri.lstrip('/').split('?', 1)
			return self.external_redirect_url('/%s/%s/%s' % (servlet, self.form['id'], self.form['s']), status_code=http.HTTP_MOVED_PERMANENTLY)

		# Return a 404 if the URL isn't in the canonical form.
		if not PHOTO_REGEX.match(self.request.path):
			raise webob.exc.HTTPNotFound

		# Should be covered by the above case, but just to be safe...
		# We only have the *args to make this fail more gracefully
		# when someone completely mangle a url.
		if len(args) > 0:
			raise webob.exc.HTTPNotFound

		if not self.validate_photo_id(photo_id):
			raise webob.exc.HTTPNotFound

		return self.serve_photo(photo_id, photo_size)

	def validate_photo_id(self, photo_id):
		return self.logic.is_id_valid(photo_id)

	def blank_image(self, size_key):
		"""This should return a string for the "default" image for this servlet,
		e.g. the head-with-a-question-mark for user photos."""
		raise webob.exc.HTTPNotFound

	def serve_photo(self, photo_id, photo_size):
		# Stripping this ending from photos is a standard thing in our code; I'm not
		# really sure why, must be some sort of legacy thing.
		photo_size = JPG_ENDING.sub('', photo_size)

		request_info = dict( (k, self.request.__getattr__(k) or None) for k in ('user_agent', 'referrer', 'url', 'is_xhr', 'remote_addr') )
		try:
			request_info['yuv'] = self.yuv_record
			request_info['uniqueRequestID'] = self.unique_visitor_id
			request_info['unauth_userid'] = self.unauth_userid
		except AttributeError:
			pass

		clog.log_line('tmp_photo_servlet_base', json.dumps(request_info))

		result = self.logic.Photo.fetch(photo_id, photo_size, self.PHOTO_CONFIG_CLS)

		if not result['data']:
			raise webob.exc.HTTPNotFound

		self.response.content_type = result['Content-Type'] or 'image/jpeg'

		# Caching headers
		self.response.headers['Expires'] = rfc1123_date(time.time() + config.photo_cache_expire_time)

		return result['data']
