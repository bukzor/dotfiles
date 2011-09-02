from cmds._cmd import StdCmd
from cmds._request_mapper import And
from cmds._request_mapper import GET
from cmds._request_mapper import Path
from cmds._request_mapper import RequestMapper
from util import uri
from util import validate
from util.validate import NoValueError
from util.validate import ValidationError
from yelp.logic.errors import RateLimitReachedError
from yelp.web.ro_mode import ro_mode


class bookmark(StdCmd, RequestMapper):
	# Treat 'label=' in query string differently from
	# not setting label (same with note)
	def rules(self):
		return (
			(And(GET(), Path(r'^add_biz/?$')), self.add_biz),
			(And(GET(), Path(r'^add_biz_confirm/?$')), self.add_biz_confirm),
			(And(GET(), Path(r'^edit_biz/?$')), self.edit_biz),
			(And(GET(), Path(r'^remove_biz/?$')), self.remove_biz),
			(And(GET(), Path(r'^remove_biz_confirm/?$')), self.remove_biz_confirm),
			(And(GET(), Path(r'^biz_public/?$')), self.biz_public),
			(And(GET(), Path(r'^biz_private/?$')), self.biz_private),
		)

	keep_blank_values = True

	def servlet_init(self, *args, **kwargs):
		super(bookmark, self).servlet_init(*args, **kwargs)

		if not self.unauth_userid:
			#send to biz page with variable to show bookLog popup
			if self.form_get('biz_id'):
				bizUrl = '/biz/' + self.form_get('biz_id') + '#popup:bookmark'
				if self.form_get('review_id',optional=True):
					bizUrl+='#hrid:'+self.form_get('review_id')
				return self.external_redirect_url(bizUrl)
			else:
				self.forward_to_login()
		else:
			

	def set_success_message(self, name):
		if 'from_confirm_prefs' in self.form:
			msg = self._("You have added %(name)s to your <a href=\"%(bookmarks_url)s\">bookmarks</a> and your settings have been saved.")
		else:
			msg = self._("Added to bookmarks.")
		self.flash.messages.append(msg % {'name': name, 'bookmarks_url': uri.user_details_bookmarks.uri(self.unauth_userid)})

	def add_biz(self):
		"""Ask the user to confirm adding a bookmark for this business.

		This is the JS-disabled entry point.

		"""
		self.require_user()

		biz_id = self.form.get('biz_id', None)
		review_id = self.form.get('review_id', None)
		return_url = uri.safe_return_url(self.form.get('return_url', '/'))

		try:
			validate.EncryptedID().validate(biz_id)
		except (ValidationError, NoValueError):
			error_msg = self._("Sorry, we couldn\'t find the page you were looking for.")
			self.flash.errors.append(error_msg)
			self.external_redirect_url(return_url)

		# review_id optional, but if it's malformed, abort
		try:
			validate.EncryptedID().validate(review_id)
		except NoValueError:
			review_id = None
		except ValidationError:
			error_msg = self._("Sorry, we couldn\'t find the page you were looking for.")
			self.flash.errors.append(error_msg)
			self.external_redirect_url(return_url)

		# get details about the business so the confirmation page isn't so boring
		biz, _ = self.logic.get_business_from_id_or_alias(biz_id)

		self.display['bookmark_confirm_action'] = BookmarkAddBizConfirmURI.uri()
		self.display['bookmark_confirm_message'] = self._('Click below to confirm your bookmark for the following business.')
		self.display['bookmark_confirm_button_text'] = self._('Add Bookmark')
		self.display['return_url'] = return_url
		self.display['biz_name'] = biz['name']
		self.display['biz_id'] = biz_id
		self.display['review_id'] = review_id

		return self.xtmpl('bookmark_confirm')

	def add_biz_confirm(self):
		"""Add the bookmark for this business.

		JS-disabled form post only.  The AJAX add is handled by pop_fill/bookmark.

		"""
		if not self._is_post():
			error_msg = self._("Sorry, we couldn\'t find the page you were looking for.")
			self.flash.errors.append(error_msg)
			return self.external_redirect_url('/', append_fsid=True)

		self.require_user()

		biz_id = self.form.get('biz_id', None)
		review_id = self.form.get('review_id', None)
		return_url = uri.safe_return_url(self.form.get('return_url', '/'))

		# FIXME: we should remove items from the bookmark dict that we don't want to display on the front-end, like score and such
		try:
			(bookmark, bookmark_is_new) = self.getlogic().Bookmark.add_biz_bookmark(self.unauth_userid, biz_id, review_id)
			self.set_success_message(bookmark['business']['name'])
		except RateLimitReachedError:
			error_msg = self._('Yelp is overworked right now.')
			self.flash.errors.append(error_msg)

		return self.external_redirect_url(return_url, append_fsid=True)

	def edit_biz(self):
		bookmark_id = self.form.get('bookmark_id', None)
		if not bookmark_id or not self._is_post():
			return self.http_notfound()

		# if label, note aren't set in the form, use None
		# so that they won't be edited
		label = self.form_get('label', optional=True, default=None)
		note = self.form_get('note', optional=True, default=None)

		bookmark = self.getlogic().Bookmark.edit_biz_bookmark_by_id(self.unauth_userid, bookmark_id, label, note)
		success_msg = self._("Bookmark updated.")
		self.successes.append(success_msg)

		# tell javascript whether the user has already reviewed this biz
		bookmark['has_reviewed'] = bool(self.getlogic().Review.review_lookup(self.unauth_userid, bookmark['business_id']))

		if self.errors:
			reply = {'msg': self.errors[0], 'success':False, 'bookmark': None}
		else:
			reply = {'msg': self.successes[0], 'success':True, 'bookmark': bookmark }

		if 'return_url' in self.form:
			return_url = uri.safe_return_url(self.form_get('return_url'))
			return self.external_redirect_url(return_url)
		else:
			self.clear_context()
			return self.xjson(reply)

	def remove_biz(self):
		"""Ask the user to confirm deleting a bookmark.

		This is the JS-disabled entry point.

		"""
		self.require_user()

		bookmark_id = self.form.get('bookmark_id', None)
		return_url = uri.safe_return_url(self.form.get('return_url', '/'))

		try:
			validate.EncryptedID().validate(bookmark_id)
		except (ValidationError, NoValueError):
			error_msg = self._("Sorry, we couldn\'t find the page you were looking for.")
			self.flash.errors.append(error_msg)
			self.external_redirect_url(return_url)

		self.display['bookmark_confirm_action'] = BookmarkRemoveBizConfirmURI.uri()
		self.display['bookmark_confirm_message'] = self._('Are you sure you want to delete this bookmark?')
		self.display['bookmark_confirm_button_text'] = self._('Delete')
		self.display['bookmark_id'] = bookmark_id
		self.display['return_url'] = return_url

		return self.xtmpl('bookmark_confirm')

	def remove_biz_confirm(self):
		"""Delete the business bookmark.

		Unlike the 'add' functions, this request may be AJAX.

		"""
		async = self.is_xhr_request()
		bookmark_id = self.form.get('bookmark_id', None)
		return_url = uri.safe_return_url(self.form.get('return_url', '/'))

		if not self._is_post() or not bookmark_id:
			if async:
				return self.http_notfound()
			error_msg = self._("Sorry, we couldn\'t find the page you were looking for.")
			self.flash.errors.append(error_msg)
			return self.external_redirect_url(return_url, append_fsid=True)

		self.logic.Bookmark.remove_biz_bookmark_by_id(self.unauth_userid, bookmark_id)

		success_msg = self._('Bookmark deleted.')

		if async:
			self.clear_context()
			resp = {'msg': success_msg, 'success': True}
			return self.xjson(resp)
		else:
			self.flash.messages.append(success_msg)
			return self.external_redirect_url(return_url, append_fsid=True)

	@ro_mode.error
	def biz_public(self):
		self.getlogic().User.set_preferences(self.unauth_userid, is_pref_biz_bookmarks_private=False)
		self.external_redirect_url(uri.safe_return_url(self.form['return_url']))

	@ro_mode.error
	def biz_private(self):
		self.getlogic().User.set_preferences(self.unauth_userid, is_pref_biz_bookmarks_private=True)
		self.external_redirect_url(uri.safe_return_url(self.form['return_url']))

	def _is_post(self):
		return self.request.method.lower() == 'post'

class BookmarkAddBizURI(uri.TemplateURI):
	path_template = '/bookmark/add_biz'

class BookmarkAddBizConfirmURI(uri.TemplateURI):
	path_template = '/bookmark/add_biz_confirm'

class BookmarkRemoveBizURI(uri.TemplateURI):
	path_template = '/bookmark/remove_biz'

class BookmarkRemoveBizConfirmURI(uri.TemplateURI):
	path_template = '/bookmark/remove_biz_confirm'
