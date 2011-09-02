"""
Servlet for the main search page on the www site.
"""

import bisect
import datetime
import logging
import math
import random
import socket
import webob.exc

import config
import config.concierge
import config.locations
import config.search
import config.summarization
import util.summarization
import util.uri
import yelp.ad.match_utils.search
import yelp.bootstrapped.category_yelp
from cmds._action_mapper import ActionMapper
from cmds._action_mapper import expose
from cmds._cmd import StdCmd
from cmds.sitemap import BizSiteMapLinks
from cmds.threadpool import THREADPOOL
from util import localization, ranger, text, timeutil, units, validate, http, tzworld
from util.addr.format import format_address, format_canonical_address, format_city, format_city_name, format_neighborhood, format_neighborhood_name
from util.addr.location import extract_point, to_city, to_place
from util.addr.named_place import (from_city_tuple, from_place_key, from_place_keys, get_city_and_related_cities, hood_cities_in_geo_box, hoods_in_city, hoods_in_geo_box, known_cities_containing_point, lookup_hood, place_key_to_place_key_for_city, place_key_to_place_key_for_super_city, to_city_tuple, to_deaccented_city_tuple, to_place_key)
from util.category_yelp_from_query import category_yelp_from_query
from util.geom import LngLat, LngLatBounds
from util.localization import safe_language_to_base_lang
from util.search import get_biz_attr_group
from util.search import parse_places_url_param
from util.search import pick_category_filters
from util.uri import ConfigurableUrl, SearchURI
from util.validate import InvalidLongitudeLatitudeBounds
from util.yelpy import flatten, get_deep, get_int, uniq, without_none
from yelp.ad.user_activity import update_user_latest_search
from yelp.bootstrapped.category_yelp.business_search_category_info import BUSINESS_SEARCH_CATEGORY_INFO
from yelp.core.category_yelp import CategoryYelp
from yelp.logic import errors
from yelp.logic.category_yelp import AliasNotFoundError
from yelp.logic.encapsulation import decid
from yelp.logic.encapsulation import ObjectID
from yelp.logic.search_front_end import MapSize
from yelp.util.deals_logging import DetailedDealLogger
from yelp.util.deals_logging import Platform
from yelp.util.deals_logging import ImpressionType
from yelp.util.seo import CanonicalURIInfo, SEOCategory
from yelp.web.pagination import fill_pagination
from yelp.util.helpers import concierge as concierge_helpers
import yelp_lib.location


log = logging.getLogger('y_app.cmds.search')

SEARCH_URL_FIELDS = set(('start', 'rpp', 'z', 'find_desc', 'find_loc', 'places', 'cflt', 'bbox', 'debug', 'attrs', 'boost', 'open_time', 'open_now', 'unfold', 'l'))

ZOOMLEVELS_TO_DISPLAY_IN_FILTER_PANEL = (11, 12, 13, 14, 16)

# unfiltered, unlocalized CategoryYelp:
CATEGORY_YELP = CategoryYelp()

# category alias-to-translation maps, keyed on servlet/logic country
# TODO(15636) we use these to translate certain aliases that we pass
# through to the template directly (as 'top_categories' and 'more_categories').
# This should be replaced with code that requests the appropriate category rows from self.logic.CategoryYelp,
# or else invokes gettext on the aliases at template time.
COUNTRY_LANGUAGE_TO_ALIAS_TO_TRANSLATION = {}
def get_category_alias_to_translation(country, language):
	"""
	Gets a map from unlocalized category aliases to their localized
	title translations.

	Args:
		country - country as a string, as returned from, e.g., logic.country()
		language - language as a string, e.g., 'EN', 'EN_GB' (we'll normalize to baselang)
	"""
	language = safe_language_to_base_lang(language)
	try:
		return COUNTRY_LANGUAGE_TO_ALIAS_TO_TRANSLATION[(country, language)]
	except KeyError:
		get_translated_title = \
			lambda node: CATEGORY_YELP._translate_title(node, override_country=country, override_language=language)['title']

		# get the untranslated, unfiltered structure, with unlocalized category aliases:
		alias_to_translation = dict((alias, get_translated_title(node)) for alias, node in BUSINESS_SEARCH_CATEGORY_INFO.iteritems())
		# and memoize it:
		COUNTRY_LANGUAGE_TO_ALIAS_TO_TRANSLATION[(country, language)] = alias_to_translation
		return alias_to_translation


def pick_place_filters(country, _, place_stats, location, geo_box, place_filters=[], current_top_places=[]):
	"""Returns a dictionary containing information on neighborhoods around a particular a location.
	For more details, see _pick_place_filters
	"""

	# add in all hoods that are in cities in the geobox,
	# or related cities

	cities_in_geo_box = hood_cities_in_geo_box(geo_box)
	city_tuples = set(to_city_tuple(c) for city in cities_in_geo_box for c in get_city_and_related_cities(city))

	places_in_geobox = flatten(hoods_in_city(from_city_tuple(ct)) for ct in city_tuples)

	place_config = {}
	(place_config['top_places'],
		place_config['more_places'],
		place_config['more_subplaces'],
		place_config['more_places_to_expand'],
		place_config['place_list_type'],
		place_config['place_names'],
		place_config['place_counts'],
		place_config['place_weights']) = search._pick_place_filters(
			country,
			_,
			place_stats,
			location,
			places_in_geobox,
			checked_place_filters=place_filters,
			current_top_places=current_top_places,
			max_top_filters=config.search.NUM_TOP_PLACES)

	return place_config

class InvalidDescription(validate.ValidationError):
	pass

class InfiniteRedirectException(Exception):
	"""Error to raise if we think the code is doing infinite redirects."""
	pass

class search(StdCmd, ActionMapper, BizSiteMapLinks):
	"""Search servlet, handles all our user and machine generated searches on the site."""


	# Setting this value to True will keep URL fields alive even after the user has unchecked the option which requires them.
	# For example, selecting a neighborhood will add a 'places=<placename>' to the url,
	# which, after removal of the neighborhood selection, will remain as 'places' (no =<val>) instead of dissapearing completely
	# This behavior results in https://trac.yelpcorp.com/ticket/2857 where the presence of the redundant 'places' causes the map
	# to not zoom out fully after the user has unselected a neighborhood
	# Setting this to False fixes that bug and does not seem to break anything else right now
	#
	# Had to re-set to true to fix a very very very bad bug where searching
	# with find_loc set to some neighborhood name would make you unable to
	# ever un-check that neighborhood filter.  Futher investigation an a better
	# solution to 2857 is needed.
	keep_blank_values = True

	@expose
	@ranger.set_servlet_action('search')
	def search(self, *args):
		"""Called on a regular call to the servlet"""
		try:
			self._search()
		except Exception, e:
			self.add_seo_attributes(SEOCategory.ERROR_PAGE, None, None, None)

			err_class = type(e)
			if issubclass(err_class, errors.InvalidLocationError):
				if isinstance(e, errors.MultipleMatchingLocationsError):
					self.display['multiple_matching_locations'] = e.desc
				return self.xtmpl('search.invalid_location', use_content_filter=True)
			elif issubclass(err_class, InvalidDescription):
				return self.xtmpl('search.invalid_description', use_content_filter=True)
			elif issubclass(err_class, errors.ExcessivePagingError):
				return self.xtmpl('search.excessive_paging', use_content_filter=True)
			else:
				# We don't have a good way of handling this exception, so re-raise it
				raise

		return self.xtmpl('search.search', use_content_filter=True)

	default = search

	# TODO: jtwang - get rid of this in Lang Prefs phase 2 when we get rid off language/domain based
	# redirection
	def allow_redirect(self):
		return False

	def xjson_redirect(self, server_return, path='/'):
		"""Converts a Webob redirect server-return exception into a
		JSON redirection response.
		1. Looks at the server exception for the redirect location.
		2. If the redirect url contains a url query string
		   parameter (redirect from cookie bridge) use that as
		   the redirect url. Otherwise use the provided location.
		3. Normalize the path of the redirect url.
		4. Return a json representation of the redirect to be used
		   for client-side redirection.
		"""

		# This function only applies to redirects.
		if not isinstance(server_return, webob.exc.HTTPSeeOther):
			raise server_return

		location = server_return.headers['Location']
		redirect_url = ConfigurableUrl(location)
		redirect_urls = redirect_url.getlist('url')

		# If there is a url query parameter we should
		# be redirecting to that url (domain redirect).
		if len(redirect_urls) > 0:
			# Parse the cookie bridge url, extracting the real destination.
			snippet_location = redirect_urls[0]
			search_url = ConfigurableUrl(snippet_location)
		else:
			search_url = redirect_url

		# Change the redirect path.
		search_url.path = path

		redirect_url = redirect_url.set('url', str(search_url))
		log.debug('xjson redirect to %s', redirect_url)

		return self.xjson({'redirect': str(redirect_url)})

	@expose
	@ranger.set_servlet_action('concierge')
	@concierge_helpers.if_concierge_enabled()
	def concierge(self):
		"""This is called to satisfy AJAX requests
		when the user checks filters, etc. The logic is the same
		as for search(), but the output format is different
		"""
		self.response.headers['Cache-Control'] = 'no-cache'
		try:
			self._search(disable_redirect=True)
		except errors.InvalidLocationError, e:
			if isinstance(e, errors.MultipleMatchingLocationsError):
				self.display['multiple_matching_locations'] = e.desc

			return self.xjson({'status': 'invalid_location'},
								template='concierge.invalid_location_snippet',
								use_content_filter=True)

		if len(self.display['biz_list']) == 0:
			_, encoded_location = self._parse_and_handle_location_params(True)
			self.display['neighborhood_specific'] = encoded_location.startswith('p:')

			return self.xjson({'status': 'no_recommendations'},
							template='concierge.no_recommendations',
							method_name='no_recommendation',
							use_content_filter=True)
		else:
			self.display['biz_list'] = [biz for biz in self.display['biz_list'] if concierge_helpers.include_biz_in_results(biz)]
			biz_ids = [biz['id'] for biz in self.display['biz_list']]

			return self.xjson({'status': 'recommendations',
							'biz_ids': biz_ids},
							template='concierge.biz_summary',
							method_name='concierge_results',
							use_content_filter=True)

	@expose
	@ranger.set_servlet_action('snippet')
	def snippet(self):
		"""This is called to satisfy AJAX requests
		when the user checks filters, etc. The logic is the same
		as for search(), but the output format is json
		"""
		self.response.content_type = 'application/json'
		self.response.headers['Cache-Control'] = 'no-cache'
		self.response.headers['Pragma'] = 'no-cache'
		try:
			self._search(disable_redirect=True)
			return self.xtmpl('search.snippet') # do not use content literals, json output
		except webob.exc.HTTPSeeOther, server_return:
			return self.xjson_redirect(server_return=server_return, path='/search')
		except errors.InvalidLocationError, e:
			if isinstance(e, errors.MultipleMatchingLocationsError):
				self.display['multiple_matching_locations'] = e.desc
			return self.xtmpl('search.invalid_location_snippet') # do not use content literals, json output
		except InvalidDescription:
			return self.xtmpl('search.invalid_description_snippet') # do not use content literals, json output
		except errors.ExcessivePagingError:
			return self.xtmpl('search.excessive_paging_snippet')

###
# START Initialization functions
###
	def _setup_display(self, disable_redirect=False):
		"""Initialize self.display and self.params from the form and cookies.

		Returns: Tuple of (form_vars, allowed_display_vars)
			form_vars - Map of variables read from the 'form' submitted for the search
			allowed_display_vars - The set of allowed display variables.  Doesn't really work right
				because nobody checks the debug messages indicating there were some bad form vars
				that made it in.
		"""
		# Set safe defaults for all display variables
		self._init_display_vars()

		# Keep track of which display vars were set, so we can
		# make sure the script doesn't add extra vars
		allowed_display_vars = set(self.display.keys())

		# Read in the various form variables, and redirect if we see non-canonical versions
		form_vars = self._parse_form_vars_or_redirect(disable_redirect=disable_redirect)

		# If we didn't redirect, take the parsed form vars and use them to
		# initialize display and other global parameters for the servlet
		self._initialize_parameters_from_form_and_cookies(form_vars)

		# XXX: Get rid of `form_vars` dependencies in _search
		return form_vars, allowed_display_vars

	def _parse_form_vars_or_redirect(self, disable_redirect):
		"""This method loads all the various form variables,
		or redirects if it sees a variable in a non-canonical
		form (e.g. start=0 is the same as not setting it)'

		If disable_redirect is True, don't redirect to the canonical
		version (useful for snippets or other non-seo'd services)

		Form vars supported:
		find_desc (str) -- Search query. Redirects to
			remove extra whitespace (blank is okay)
		find_loc (str) -- Search location, as a string. Redirects to
			remove extra whitespace (blank is okay)
		start (int) -- Index of first result to return. Redirects
			on blank or 0 to remove this variable.
		rpp (int or None) -- Results per page, or none if not set
		f -- the current state of the form;
			True, False, or None
		open_time (int) -- Open time filter, as minutes since
			midnight Monday, or None if not set
			(warning: 0 is valid, and different from None!)
		open_now (int) -- Same as open_time, except set through
			the "open_now" checkbox
		attrs -- attribute filters, as a list of str
		boost -- attribute boosts, as a list of str
		cflt -- Category aliases to filter on,
			as a list of strings, or None (FIXME: should probably be [])
		places -- Places to filter on, as a list of strings, or
			None if not set at all (which means we can set a default)
		z -- Zoom level as int, or None if not set
		ns -- True if a new search is being conducted
		sortby -- sortby options (one of the SORT variables in
			logic.search_front_end).
		bbox -- geobox to limit by. a comma-separated list of numbers
			or None. FIXME: we should parse this up-front
		mapsize -- size of the map, large or small.
		"""
		form_vars = {}
		# keep these in alpha order, for easy reference
		form_vars['attrs'] = self._parse_attrs('attrs', disable_redirect)
		form_vars['boost'] = self._parse_attrs('boost', disable_redirect)
		form_vars['cflt'] = self._parse_list_from_form('cflt')

		form_vars['find_desc'] = unicode(self._parse_stripped_string_from_form('find_desc', disable_redirect, allow_quotes=True))

		# Handle all location stuff in one place
		form_vars['find_loc'], form_vars['l'] = self._parse_and_handle_location_params(disable_redirect)

		form_vars['main_places'] = parse_places_url_param(self.form.getfirst('main_places'))
		form_vars['mapsize'] = self.form.getfirst('mapsize', self.read_mapsize_from_cookie(self.request.cookies))
		form_vars['ns'] = bool(self.form.getfirst('ns'))
		form_vars['open_time'] = self._parse_int_from_form('open_time', disable_redirect)
		form_vars['open_now'] = self._parse_int_from_form('open_now', disable_redirect)
		form_vars['unfold'] = bool(self.form.getfirst('unfold', False))

		# XXX: Should get rid of this param.  It was used by Stop when
		# he first implemented lserv.  Not any compelling reason to
		# keep it around any more.
		form_vars['parallel'] = bool(self.form.getfirst('parallel'))

		form_vars['rpp'] = self._parse_int_from_form('rpp', disable_redirect)
		form_vars['show_filters'] = self._parse_show_filters()
		form_vars['sortby'] = self._parse_sortby(disable_redirect)
		form_vars['start'] = self._parse_start(disable_redirect)

		# Form vars used to force a sample ad to show on the search page
		# XXX (14657): Add better validation.  validate.EncryptedID for
		# the first two, and 3rd should validate that it is in the set
		# of valid ad types
		# This is an encrypted biz_id
		form_vars['sample_biz_id'] = self.form.getfirst('sample_biz_id')
		# This is an AD_TYPE_ constant from yelp.ad.constant
		form_vars['sample_ad_type'] = self.form.getfirst('sample_ad_type')

		return form_vars

	def _init_display_vars(self):
		"""
		All the display variables we wish to set.
		Besides preventing crashes, this provides an
		list of everything this script can output.
		"""
		d = self.display
		# please keep these in alpha order, for easy reference
		d['ad_type'] = None
		# adsense_category is for Adsense custom channeling
		d['adsense_category'] = None
		d['attr_counts'] = {}
		d['attr_flags'] = {}
		d['attr_map'] = self.search_attr_map
		d['attrs'] = []
		d['attr_weights'] = {}
		d['autocorrected_biz_list'] = ()
		d['az_sitemap_links'] = []
		d['az_sitemap_location'] = None
		d['biz_list'] = []
		d['attrs_to_boost'] = []
		d['business_ads'] = None
		d['canonical_find_loc'] = None
		d['canonical_url'] = None
		d['category_alias_to_translation'] = None
		d['category_counts'] = {}
		d['category_filters'] = None
		d['category_folding_disabled_by_user'] = False
		d['category_folding'] = False
		d['category_weights'] = {}
		d['category_yelp_correction'] = None
		d['category_yelp_suggestion'] = None
		d['city_name'] = ''
		d['cost_attr_group'] = {} # filled in only if we show cost filters
		d['cost_attr_group_title'] = config.search.COST_ATTR_GROUP_TITLE
		d['description'] = ''
		d['display_filters'] = []
		d['distance_units'] = units.MI
		d['filter_polys'] = []
		d['final_lucy_query'] = None
		d['find_cat_filters'] = []
		d['find_desc'] = ''
		d['find_loc'] = ''
		d['googlead_attrs'] = []
		d['googlead_slots'] = []
		d['is_demo_advertisement'] = False
		d['l'] = ''
		d['location'] = ''
		d['location_suggestion'] = None
		d['longitude'], d['latitude'] = self.mru_location['longitude'], self.mru_location['latitude']
		d['main_places'] = []
		d['mapsize'] = ''
		d['max_search_zoom'] = config.search.MAX_SEARCH_ZOOM
		d['message_board_topics'] = ()
		d['message_board_topics_total'] = 0
		d['meta_location'] = ''
		d['more_attr_groups'] = []
		d['more_attrs_standalone'] = []
		d['more_categories'] = []
		d['more_places'] = []
		d['more_places_to_expand'] = []
		d['more_subplaces'] = []
		d['multiple_matching_locations'] = ()
		d['neighborhood'] = None
		d['neighborhoods_in_viewport'] = ()
		d['new_business_link'] = ''
		d['open_now_desc'] = ''
		d['open_now'] = None
		d['open_time_day'] = None
		d['open_time_desc'] = ''
		d['open_time_desc_full'] = ''
		d['open_time'] = None
		d['original_place_filters'] = []
		d['pager'] = {'start': 0, 'total': 0, 'rpp': config.search.DEFAULT_RPP, 'maximum_depth': config.search.MAX_PAGING_DURING_FEDERATION}
		fill_pagination(d['pager'])
		d['place_counts'] = []
		d['place_filters'] = []
		d['place_list_type'] = ''
		d['place_names'] = []
		d['place_weights'] = []
		d['precise_location'] = False
		d['radii'] = {}
		# Extra info passed back from Lucy, to be put in ranger
		d['ranger_extra_search_info'] = {}
		d['related_lists'] = ()
		d['relevance_mode'] = config.search.DEFAULT_SORT
		# if the query was rewritten for example it was a 'near' query.
		d['rewritten_description'] = ''
		d['rewritten_find_loc'] = ''
		d['search_biz_ad_extra'] = {}
		d['selected_categories'] = None
		d['selected_category_ancestors'] = []
		d['selected_category_breadcrumbs'] = []
		d['shorten_location'] = False
		d['concierge'] = {'show': False}
		d['show_filter_panel_at_all'] = True
		# Used to determine presentation of the restaurant attributes.
		d['show_autocorrected_results'] = False
		d['show_filters'] = False
		d['show_googlead'] = False
		d['show_open_time_filters'] = []
		d['show_spelling_suggestion_at_top'] = True
		d['sortby_display'] = 'best_match'
		d['spelling_suggestion'] = ''
		# this is for the purposes of the DYM FR launch experiment, and should be
		# removed afterward -- indicates that a DYM FR suggestion was ignored due
		# to the user being in the wrong cohort.
		d['ignored_fr_spelling_suggestion'] = False
		d['sub_cats_for_browse'] = ()
		d['talk_archive_link'] = ''
		d['top_attrs'] = []
		d['top_categories'] = []
		d['top_places'] = []
		d['url'] = self._here()
		d['url'].path = '/search'
		d['yelp_local_ads'] = None
		d['zoomed_too_far'] = False
		d['zoomlevel_descs'] = []
		d['zoomlevel'] = config.search.DEFAULT_ZOOM

	def _initialize_parameters_from_form_and_cookies(self, form_vars):
		"""Initialize search parameters from form/defaults"""

		d = self.display

		# Display variables taken directly from form_vars
		d['find_desc'] = form_vars['find_desc']
		d['find_loc'] = form_vars['find_loc']
		d['l'] = form_vars['l']

		d['mapsize'] = form_vars['mapsize']
		d['pager'] = {'start': form_vars['start'], 'total': 0, 'maximum_depth': config.search.MAX_PAGING_DURING_FEDERATION}
		d['pager']['rpp'] = form_vars['rpp'] or self.read_rpp_from_cookie(self.request.cookies) or config.search.DEFAULT_RPP
		if d['pager']['rpp'] > config.search.MAX_RPP:
			self.external_redirect_url(self._here().set_many(rpp=config.search.DEFAULT_RPP))
		d['relevance_mode'] = form_vars['sortby']
		d['sortby_display'] = {
			config.search.COMPOSITE_SORT: 'best_match',
			config.search.COMPOSITE_RATING_SORT: 'rating',
			config.search.COMPOSITE_MOST_REVIEWED_SORT: 'review_count',
			config.search.CATEGORY_SORT: 'best_match',
			config.search.RATING_SORT: 'rating',
			config.search.MOST_REVIEWED_SORT: 'review_count',
		}[form_vars['sortby']]
		d['attrs'] = form_vars['attrs'] or []
		d['attrs_to_boost'] = form_vars['boost'] or []
		d['category_folding_disabled_by_user'] = form_vars['unfold']

		# Search parameters that are not display variables but we want to be visible
		# to all methods within the search servlet.
		#
		# XXX This is just an extra class-global variable.  Kill if you can!
		self.param = {}
		self.param['attr_flags'] = form_vars['attrs'] or []
		self.param['attr_flags_to_boost'] = form_vars['boost'] or []
		self.param['open_time_filter'] = self._setup_open_time_filter(form_vars)
		self.param['category_filters'] = form_vars['cflt'] or []
		self.param['current_top_places'] = form_vars['main_places'] or []
		self.param['exec_parallel'] = form_vars['parallel'] or config.percent_requests_through_lserv_rpc_backend > random.random()
		self.param['ns'] = form_vars['ns']
		self.param['open_time'] = form_vars.get('open_time')
		self.param['open_now'] = form_vars.get('open_now')
		self.param['sample_biz_id'] = form_vars['sample_biz_id']
		self.param['sample_ad_type'] = form_vars['sample_ad_type']
		self.param['category_folding_disabled_by_user'] = form_vars['unfold']

		# Place to boost on in our search query.  If
		# we do a place boost, this is filled in by
		# location parsing.  (NOTE, I'm being bad
		# and using a global to do this...)
		self.param['place_to_boost'] = ''
		# Just keep getting worse... need to be able to
		# roll this forward and back to comply with the
		# horrific, loopy logic in the search servlet
		self.param['original_place_to_boost'] = ''

	def _build_attribute_and_group_info(self):
		"""Takes config.search.SEARCH_ATTRIBUTES and packages it up in a way that's easier to use on the front-end."""
		search_attr_map = {}
		search_attr_group_map = {}

		for group_title, attrs in config.search.SEARCH_ATTRIBUTES:
			group_info = {
				'title': group_title,
				'attrs': []
			}

			for attr_alias in attrs:
				attr_info = {
					'alias': attr_alias,
					'group': group_title,
					# Set title & title_full below
				}

				# Figure out title & title_full for this attr.  We have to special-case
				# this to avoid having fake search attributes (ActiveDeal) create a dependency
				# to the biz attribute system
				if attr_alias in config.search.SEARCH_FAKE_BIZ_ATTRS:
					attr_info.update(config.search.SEARCH_FAKE_BIZ_ATTRS[attr_alias])
				else:
					attr_info['title'] = self.logic.business_attribute_alias_to_title(attr_alias)
					attr_info['title_full'] = \
						self.logic.business_attribute_alias_to_title(attr_alias, full_title=True)

				if not attr_info['title'] or not attr_info['title_full']:
					# config.search.SEARCH_ATTRIBUTES has specified a value that  doesn't apply to this locale, so let's skip it.
					# (for example, they don't validate parking in the UK, so we don't show "validated" as a possible search filter there.)
					continue

				search_attr_map[attr_alias] = attr_info
				group_info['attrs'].append(attr_info)

			search_attr_group_map[group_info['title']] = group_info

		return search_attr_map, search_attr_group_map

###
# END Initialization functions
###

###
# START Form parsing functions
###
# XXX: We should probably change to use an actual Form instead of
# having ghetto parsing code and minimal validation
	def _parse_and_handle_location_params(self, disable_redirect):
		"""Handle all location parameters together to ensure that
		legacy params work and all params work harmoniously in
		a well-defined way.
		"""
		# Location vars.
		# find_loc - whatever the user entered in the Near box.  Free text
		# l - encoded location for more advanced searches.  Overides find_loc
		find_loc = self._parse_stripped_string_from_form('find_loc', disable_redirect)
		l = self._parse_stripped_string_from_form('l', disable_redirect)

		# Preservation of popular legacy location parameters.  We shoud regularly
		# run a MR job to check on url param usage and see if we can phase
		# out these oldschool params (bbox, places).

		# If bbox AND places are set, a bbox param will be written into
		# l, prevening places from doing the same thing.  Thus, the bbox
		# param has a higher priority than places.
		bbox = self._parse_bounds('bbox')
		if bbox and not l:
			l = 'g:' + bbox.to_url_param()

		places = parse_places_url_param(self.form.getfirst('places'))
		if places and not l:
			l = 'p:' + ','.join(places)

		# Redirects so that deprecated urls get re-written to use the 'l' param
		#
		# Eventually we can simplify this by removing 'bbox' and 'places from
		# SEARCH_URL_FIELDS.  However, if we do that now then redirects that
		# can happen earlier in param parsing could potentially unset 'bbox' or
		# 'places', and we would lose location information.
		if not disable_redirect and (places or bbox):
			url = self._here().clear('places').clear('bbox')
			url = url.set('l', l)
			self.external_redirect_url(url, status_code=http.HTTP_MOVED_PERMANENTLY)

		return unicode(find_loc), unicode(l)

	def _parse_bounds(self, var_name):
		"""
		Parse a LngLatBounds from a form variable
		"""
		bbox = self.form.getfirst(var_name)
		if not bbox:
			return None

		# Ignore a malformed bbox
		try:
			return validate.LongitudeLatitudeBounds().parse_validate_string(bbox)
		except InvalidLongitudeLatitudeBounds:
			log.warn('User passed in an invalid LngLatBounds in the %s param.  Ignoring' % (var_name,))
			return None

	def _parse_sortby(self, disable_redirect):
		"""
		Parse the sortby variable: redirect if it's blank
		or set to the default.
		"""
		sortby = self.form.getfirst('sortby')
		if sortby is None:
			return config.search.DEFAULT_SORT

		sortby_map = {
			# regular search
			('best_match', True): config.search.COMPOSITE_SORT,
			('rating', True): config.search.COMPOSITE_RATING_SORT,
			('review_count', True): config.search.COMPOSITE_MOST_REVIEWED_SORT,
			# category browse
			('best_match', False): config.search.CATEGORY_SORT,
			('rating', False): config.search.RATING_SORT,
			('review_count', False): config.search.MOST_REVIEWED_SORT,
		}
		sort_type = sortby_map.get((sortby, bool(self.form.getfirst('find_desc'))))

		if sort_type is None:
			if disable_redirect:
				return config.search.DEFAULT_SORT
			else:
				self.external_redirect_url(self._here().clear(['sortby']), status_code=http.HTTP_MOVED_PERMANENTLY)
				return

		return sort_type

	def _parse_stripped_string_from_form(self, varname, disable_redirect, allow_quotes=False):
		"""Get the given form variable as a string, redirecting if there's extra whitespace.
		HTML tags are also stripped from input.
		Used for find_desc and find_loc."""

		value = self.form.getfirst(varname, '')
		stripped = text.strip_html_strict(value.strip(), allow_quotes=allow_quotes)

		if not disable_redirect and stripped != value:
			self.external_redirect_url(self._here().set(varname, stripped), status_code=http.HTTP_MOVED_PERMANENTLY)
		else:
			return stripped

	def _parse_list_from_form(self, varname):
		"""Convert a comma-separated list into a list of
		strings, or return none if the given variable is not
		set."""
		values = self.form.getfirst(varname)
		if values is None:
			return []
		elif type(values) in (list, tuple):
			return values

		values = text.strip_html_strict(values.strip())
		return values.split(',') if values else []

	def _parse_int_from_form(self, varname, disable_redirect):
		"""Get an integer value from a form variable, deleting
		the form variable and redirecting if it's blank or
		not an integer
		"""
		value = self.form.getfirst(varname)
		# if it's not set, return None
		if value is None:
			return None
		int_value = get_int(value, None)
		# if we can't parse it, redirect to delete it
		# usually this is because it's set to blank ('')
		if int_value is None:
			if disable_redirect:
				return None
			else:
				self.external_redirect_url(self._here().clear([varname]), status_code=http.HTTP_MOVED_PERMANENTLY)
		return int_value

	def _parse_start(self, disable_redirect):
		"""Get start as an int, redirecting if start is 0 or blank
		"""
		start = self._parse_int_from_form('start', disable_redirect)
		# start=0 is the same as not set at all
		if start == 0 and not disable_redirect:
			self.external_redirect_url(self._here().clear(['start']), status_code=http.HTTP_MOVED_PERMANENTLY)
		elif start < 0:
			start = 0
		return start or 0

	def _parse_show_filters(self):
		"""Parse the "show_filters", variable,
		which tells us the current state of the search options
		panel. Returns True if 'show_filters' is
		set to 'true' (lowercase, it's set by JavaScript)
		None if it's not set, and False otherwise
		"""
		panel_state = self.form.getfirst('show_filters', None)
		if panel_state is None:
			return None
		return panel_state in ('true', '1')

	def _parse_attrs(self, query_param, disable_redirect):
		"""Return the attributes from the 'attrs' variable
		in the request URL, redirecting if any invalid/legacy
		attributes are found.

		'attrs' is just a comma-separated list of
		attribute flags, e.g. GoodForGroups,WiFi.free

		See logic.business_search.convert_biz_attribute_for_search
		for more info about attribute flags.
		"""
		attrs = self._parse_list_from_form(query_param)

		bad_attrs = 0
		if not attrs:
			return []
		else:
			# break attrs apart, and only keep attrs
			# that we know about
			valid_attrs = set()
			for a in attrs:
				# add attrs we know about
				if a in self.search_attr_map:
					valid_attrs.add(a)
				else:
					bad_attrs += 1
					legacy_attrs = self._parse_legacy_attr(a)
					if not legacy_attrs:
						self.errors.append(self._("$attr is not a valid filter.", attr=a))
					valid_attrs.update(legacy_attrs)

		if not disable_redirect and bad_attrs:
			if not valid_attrs:
				url = self._here().clear(['attrs'])
			else:
				url = self._here().set('attrs', ','.join(valid_attrs))
			self.flash.data['errors'] = self.errors

			self.external_redirect_url(url, status_code=http.HTTP_MOVED_PERMANENTLY)

		return list(valid_attrs)

	def _parse_legacy_attr(self, a):
		"""
		Given a legacy attribute form variable (e.g. costs=2:3),
		convert into a list of new-style attributes, or
		empty list.
		"""
		key_and_maybe_value = a.split('=')
		# the simple case, e.g. 'gkids' -> ['GoodForKids']
		if len(key_and_maybe_value) == 1:
			if a in config.search.LEGACY_ATTR_MAP:
				return [config.search.LEGACY_ATTR_MAP[a]]
		# the complex case, e.g. costs=3:4 -> $$$ and $$$$
		elif len(key_and_maybe_value) == 2:
			key, value = key_and_maybe_value
			if key in config.search.LEGACY_ATTR_MAP:
				new_key = config.search.LEGACY_ATTR_MAP[key]
				values = value.split(':')
				return [new_key + '.' + v for v in values]
		# oops, can't read that
		return []

	def _parse_cflt(self):
		"""Return the category aliases derived from the url."""
		cats = self.form.getfirst('cflt', None)
		if not cats:
			return None
		cats = text.strip_html_strict(cats.strip()).split(',')
		return tuple(cats)

###
# END Form parsing functions
###

###
# START Filter logic
###

	def _show_filters(self, biz_list, sub_cats_for_browse):
		"""Decide whether to open the 'More Search Options'
		panel, based on form variables and the results returned
		"""

		# for starters, preseve the current state of the
		# search options panel
		panel_state = self.form.getfirst('show_filters', None)
		if panel_state == 'true' or panel_state == '1':
			return True
		elif panel_state is not None:
			return False

		# don't show the panel if we're in browse mode
		# and there are sub-categories
		find_desc = self.form.getfirst('find_desc', '')
		if not find_desc and sub_cats_for_browse:
			return False

		# show the panel past the first page of results
		start = self.form.getfirst('start', '0')
		if start and start != '0':
			return True

		# don't show the panel if there's no results to filter!
		if not biz_list:
			return False

		# hide the filter if there's not very many results
		if len(biz_list) < config.search.MIN_RESULTS_TO_SHOW_POPUP:
			return False

		# otherwise, only hide the panel if there some
		# exact or partial name matches, but not too many
		biz_match_types = [biz['field_matches']['name'] for biz in biz_list]
		num_name_matches = len([bmt for bmt in biz_match_types if bmt in ('exact', 'partial')])
		return (num_name_matches == 0 or num_name_matches > config.search.MAX_NAME_MATCHES_TO_HIDE_POPUP)

	def _show_filter_panel_at_all(self, biz_list):
		"""
		Decide whether to show the "More Search Options"
		panel at all (even closed)
		"""
		# if there are results, show the panel
		if biz_list:
			return True

		# if any filter is set, show the panel
		for filter_form_var in ('attrs', 'open_time', 'places', 'cflt'):
			if self.form.getfirst(filter_form_var, None):
				return True

		return False

	def _display_filters(self):
		d = self.display
		display_filters = []
		for a in d['attr_flags']:
			if a in d['attr_map']:
				display_filters.append(d['attr_map'][a]['title_full'])
			else:
				display_filters.append(a)

		if d['neighborhood'] and d['neighborhood'][0]:
			display_filters.append(d['neighborhood'][0])

		if d['category_filters']:
			for cf in d['category_filters']:
				display_filters.append(cf.capitalize())

		# I THINK this is what decides which of the "Distance" filters should
		# currently be highlighted, not at all sure.  My guess is:
		# Check to see if zoom level is in radii, and if there's not a
		# neighborhood (?)
		if d['zoomlevel'] in d['radii'] and not (d['neighborhood'] and d['neighborhood'][0]):
			display_filters.append(self._zoomlevel_descs_dict().get(d['zoomlevel'], ''))

		d['display_filters'] = display_filters

	def _setup_category_filters(self, description, category_filters):
		"""
		All this does is a category fill from the DB on
		category_filters, then create a list of sub-categories
		of that filter.

		Args:
			description - string:  search query
			category_filters - list: category aliases e.g. ('homeandgarden', '...')

		Returns:
			None, but updates self.display's 'selected_categories', 'sub_cats_for_browse',
			 and 'category_filters' entries.
		"""
		d = self.display
		d['find_cat_filters'] = ','.join(category_filters)

		if category_filters:
			# fix old category aliases
			category_filters = self.repllogic.category_yelp_rewrite_old_aliases(category_filters)
			# dump empty categories
			category_filters = [text.asciify(cf) for cf in category_filters if cf]

			# If a user types in an invalid category for a category filter, 404
			try:
				# This is the only time that selected_categories is ever written to, and it is used lots
				# of places in this function.  I think that a better approach (though not a change I want
				# to make right now) would be to use entirely local variables within in the function,
				# and then return a big tuple that can be assigned into all of the display variables
				# that are populated here.
				d['selected_categories'] = self.repllogic.CategoryYelp.get_nodes_by_aliases(category_filters)
			except AliasNotFoundError:
				self.http_notfound()

			if d['selected_categories']:
				d['selected_category_ancestors'] = reversed(self.repllogic.CategoryYelp.walk_up_tree(d['selected_categories'][0]))

			d['sub_cats_for_browse'] = ()
			if not description: # No search query was specified.
				sub_cats = []
				for cat in d['selected_categories']:
					sub_cats.append(self.repllogic.CategoryYelp.get_children(cat))
				if sub_cats:
					d['sub_cats_for_browse'] = tuple(sub_cats[0])

			# Reset category folding link if user selects a category filter
			d['category_folding_disabled_by_user'] = False
		else:
			d['selected_categories'] = None
			if not description:
				d['sub_cats_for_browse'] = self.repllogic.CategoryYelp.list_tree()
			else:
				d['sub_cats_for_browse'] = ()

		d['sub_cats_for_browse'] = sorted(d['sub_cats_for_browse'], key=lambda c:text.asciify(c['title']))
		d['category_filters'] = category_filters

	def _pick_attribute_filters(self, attr_flag_stats, current_attr_flags, max_top_filters, min_count=1, min_proportion_of_weight=config.search.ATTR_MIN_PROPORTION, group_min_proportion_of_weight=config.search.ATTR_GROUP_MIN_PROPORTION):
		"""
		Pick which attributes to display in the various parts of
		the page.

		This is still imperfect; a search for manicure still shows
		restaurant attributes.

		The tricky thing is that we can't just base this off the category list
		because clicking on the attribute filters changes the category list,
		and would thus affect itself.

		Args:
		attr_flag_stats -- a dictionary containing:
			total_count -- the total count of all bizs that passed
				all filters other than our attribute filter
			counts -- a dictionary mapping attributes and
				attribute groups to the total number of bizs
				in that category
			total_weight, weights -- analogous to total_count and
				counts, except weighted by the relevance for each
				biz.
		max_top_filters -- the maximum number of attributes to
			return in top_attrs

		Returns a tuple of:
		(top_attrs, cost_attr_group, more_attrs_standalone, more_attr_groups, counts)

		"""

		d = self.display

		# unpack attr_flag_stats
		relevance_attr_weights = attr_flag_stats['weights']
		counts = attr_flag_stats['counts']
		total_weight = attr_flag_stats['total_weight']

		# create the final weights dictionary by multiplying
		# any custom weights by the relevance-based weights
		weights = dict(
			(elt, weight * config.search.CUSTOM_ATTR_WEIGHTS.get(elt, 1.0))
			for (elt, weight) in relevance_attr_weights.iteritems()
		)

		min_weight = total_weight * min_proportion_of_weight
		min_group_weight = min_proportion_of_weight * group_min_proportion_of_weight

		# make a list of attributes that can appear in the
		# top 4 checkboxes. This is everything but cost
		# (which should appear in a separate panel if at all).
		def is_candidate_top_attribute(attr):
			"""Filter to decide which of the `self.search_attr_map` attributes
			can be shown in the top attribute list

			Filter out cost attributes (which have their own section) and
			attributes which are too infrequent to show on the front
			page.
			"""
			alias = attr['alias']
			group = attr['group']

			# Filter out cost attributes.  They have their own section
			if group == config.search.COST_ATTR_GROUP_TITLE:
				return False

			# Filter out attributes that don't happen enough times to
			# make an interesting filter
			if counts.get(alias, 0) < min_count:
				return False

			# Filter out attributes that represent an insubstantial portion
			# of the search results that came back, unless they are one
			# of the exempt 'exciting' attributes
			if not (alias in config.search.EXCITING_ATTRS or
				    weights.get(alias, 0.0) >= min_weight
				):
				return False

			return True

		candidate_top_attrs = [
			attr for attr in self.search_attr_map.values()
			if is_candidate_top_attribute(attr)
		]

		def pick_top_attrs_sort_key(attr):
			"""Sort key used to rank potential top attributes.  The top
			`max_top_filters` will be used.

			Returns: (excitingness, weight)
				excitingness: 1 if attr is exciting, -1 if boring, 0 otherwise
				weight: The weight of the attribute from the backend.

			The end result of this return value is that sorting by this key
			shows:
			 * Exciting attributes
			 * Attributes sorted by weight
			 * Boring attributes
			in that order.

			More complicated orderings can be obtained by extending the tuple
			(yay for lexicographic tuple ordering!)
			"""
			alias = attr['alias']
			group = attr['group']
			weight = weights.get(alias, 0.0)

			if alias in config.search.EXCITING_ATTRS:
				return (1, weight)

			if (alias in config.search.BORING_ATTRS or
				group in config.search.BORING_ATTR_GROUPS
				):
				return (-1, weight)

			return (0, weight)

		top_attrs = sorted(
			candidate_top_attrs,
			key=pick_top_attrs_sort_key,
			reverse=True
		)[:max_top_filters]

		# Final sort to make the filter order more stable
		def top_attr_final_sort(attr):
			"""Sort key used to create a semi-stable ordering once we have
			picked the top attribute filters.

			We want to be alphabetical to give an illusion of consistency, but we
			also want exciting attributes to come first no matter what.
			"""
			if attr['alias'] in config.search.EXCITING_ATTRS:
				return float('-inf')
			return attr['title_full']
		top_attrs.sort(key=top_attr_final_sort)
		top_attr_aliases = [attr['alias'] for attr in top_attrs]

		price_aliases = [attr['alias'] for attr in self.search_attr_group_map[config.search.COST_ATTR_GROUP_TITLE]['attrs']]
		# checked attributes should always appear in the top_attrs
		# if there's space. So kick out unchecked top attrs
		# if we can, starting at the bottom
		for checked_attr in current_attr_flags:
			# don't put cost attrs here because they
			# have their own checklist
			if checked_attr in price_aliases:
				continue

			if checked_attr not in top_attr_aliases:
				for index in xrange(len(top_attrs)-1, -1, -1):
					if top_attrs[index]['alias'] not in current_attr_flags:
						top_attrs[index] = self.search_attr_map[checked_attr]
						break
		top_attr_aliases = [a['alias'] for a in top_attrs]

		# show all standalone attrs that are common enough,
		# and aren't already in top_attrs
		more_attrs_standalone = [
			attr for
			attr in self.search_attr_group_map['']['attrs']
			if (
				attr['alias'] not in top_attr_aliases and
				weights.get(attr['alias'], 0.0) >= min_weight
			)
		]

		# figure out which groups to show
		def should_show_group(group):
			for attr in group['attrs']:
				if weights.get(attr['alias'], 0.0) >= min_weight:
					return True
				if weights.get(get_biz_attr_group(attr['alias']), 0.0) >= min_group_weight:
					return True
			return False

		# decides if we wish to show cost options based on how many of
		# the shown results have a price attribute to begin with
		show_cost_options = True

		biz_list = d['biz_list']

		number_biz_without_cost_attr = sum(1 for biz in biz_list if not biz['cost_attr'])

		# show cost options only if the proportion of shown businesses without a price attribute is below a certain threshold
		if len(biz_list) and (float(number_biz_without_cost_attr) / len(biz_list)) >= config.search.SHOW_COST_OPTIONS_THRESHOLD:
			show_cost_options = False

		# decide whether to show the Cost group
		cost_attr_group = self.search_attr_group_map[config.search.COST_ATTR_GROUP_TITLE]
		if not should_show_group(cost_attr_group) or not show_cost_options:
			cost_attr_group = None

		# decide which other attr groups to show
		more_attr_groups = [
			g for
			title, g in self.search_attr_group_map.iteritems()
			if (
				title not in ['', config.search.COST_ATTR_GROUP_TITLE] and
				should_show_group(g)
			)
		]

		return top_attrs, cost_attr_group, more_attrs_standalone, more_attr_groups, counts, weights

	@classmethod
	def _pick_hoods_and_cities_from_places(cls, country, all_places, search_location):
		'''
		Takes a list of location dictionaries, filters them for quality,
		gets rid of duplicates, and separates them into a lists of cities
		and hoods.

		Args:
			all_places -- list of location dictionaries for cities and hoods
			search_location -- a location dictionary for the place the user
				is searching in, possibly None
		Returns:
			all_cities -- valid cities in `all_places`
			all_hoods -- valid hoods in `all_places`
		'''

		# Make sure any places are reasonable and have canonical naming conventions
		def clean_up_place(place):
			if not place:
				return None

			# we used to check that place['state'] represented a valid state,
			# but all these places have been retrieved from Lucy, so they should
			# be legitimate.

			# verify that the country is visible
			if not localization.country_is_visible(place['country'], from_country=country):
				return None

			# city name spelled the way we like it? (e.g. display "New York City" as just "New York")
			place['city'] = config.locations.place_filter_city_name_fix.get(place['city']) or place['city']

			if not place['city']:
				return None

			return place

		all_places = [clean_up_place(place) for place in all_places]
		all_places = [p for p in all_places if p is not None]

		# Remove "NY:Astoria::" if we already have "NY:New_York:Queens:Astoria"
		# (but leave both MO:Kansas_City:: and KS:Kansas_City:: or NY:New_York:Manhattan:Chelsea and NY:New_York:Staten_Island:Chelsea)
		cities_to_hide = set(
			to_city_tuple({
				'city': p['neighborhood'],
				'state': p['state'],
				'country': p['country'],
			}) for p in all_places if p['neighborhood'])

		if search_location:
			cities_to_hide.discard(to_city_tuple(search_location))

		all_cities = [p for p in all_places if not p['neighborhood'] and
					  to_city_tuple(p) not in cities_to_hide]
		all_cities = list(uniq(all_cities, key=to_deaccented_city_tuple))

		all_hoods = [p for p in all_places if p['neighborhood']]
		all_hoods = list(uniq(all_hoods, key=lambda x: x['place_key']))

		return all_cities, all_hoods

	@classmethod
	def _organize_place_filter_list(cls, country, _, all_cities, all_hoods, search_location):
		"""
		Takes a list of cities and hoods to provide data to form
		the "More Neighborhoods/More Cities" box on search filters.

		(For more details on args/returns, see _pick_place_filters)
		Args:
			all_cities -- list of location dicts for cities
			all_hoods -- list of location dicts for hoods
			search_location -- primary location for this search (may be None)
		Returns:
			more_places -- place keys for the top level nodes in the more box
			more_subplaces -- place keys for the places under each top level node
			more_places_to_expand -- which elements in more_places should start expanded instead of collapsed?
			place_names -- how should we display each location? (map place key to name)
			place_list_type -- should the 4 filters in the main filter box be neighborhoods or cities?
		"""
		## Organize the "More ..." box
		# Build a tree from top-level-node to expanded filterables
		more_subplaces = {}
		keys_for_hoods_and_their_cities = set()
		place_names = {} # map from place key to display name

		## Organize the neighborhoods
		for hood in all_hoods:
			hood_key = hood['place_key']
			city_key = place_key_to_place_key_for_city(hood_key)
			super_city_key = place_key_to_place_key_for_super_city(hood_key)

			# Put this hood under the right city/borough
			more_subplaces.setdefault(city_key, [])
			more_subplaces[city_key].append(hood_key)

			# include display names for the hood and city
			place_names[hood_key] = format_neighborhood_name(hood, from_country=country)
			if not city_key in place_names:
				place_names[city_key] = format_city_name(hood, from_country=country)

			# Mark these locations as 'seen' (so they don't appear under 'More Cities')
			keys_for_hoods_and_their_cities.add(hood_key)
			keys_for_hoods_and_their_cities.add(city_key)
			# if we're in a NY borough, don't show "New York" in More Cities
			keys_for_hoods_and_their_cities.add(super_city_key)

		## Organize "More Cities". These go under the key ''
		states_for_cities = set((c['state'], c['country']) for c in all_cities)
		show_state = len(states_for_cities) > 1

		for city in all_cities:
			city_key = city['place_key']

			# give every city a label, just in case
			if show_state and city_key not in keys_for_hoods_and_their_cities:
				city_name = format_city(city, from_country=country)
			else:
				city_name = format_city_name(city, from_country=country)
			place_names[city_key] = city_name

			# Only allow filtering on cities that don't already have more fine-grained filters
			if not city_key in keys_for_hoods_and_their_cities:
				more_subplaces.setdefault('', [])
				more_subplaces[''].append(city_key)

		# add a name for the "More Cities" list
		place_names[''] = _('More Cities')

		# Display lists of neighborhoods (and More Cities) alphabetically
		for place_list in more_subplaces.itervalues():
			place_list.sort(key=lambda pk: place_names[pk])

		# Decide which lists to expand
		more_places_to_expand = set()
		if search_location:
			more_places_to_expand.add(to_place_key(to_city(search_location)))

		if search_location and not search_location['neighborhood']:
			point = extract_point(search_location)
			more_places_to_expand.update(to_place_key(c) for c in known_cities_containing_point(point))

		# only keep place keys which correspond to actual lists
		more_places_to_expand = set(pk for pk in more_places_to_expand if pk in more_subplaces)

		# Display list of cities in a logical order
		def more_places_sort(pk):
			return (not pk in more_places_to_expand, # expanded places first
					not bool(pk), # ''/"More Cities" should show up last
					-config.locations.search_filter_priority.get(pk, 0), # sort nearby cities by usage
					place_names[pk]) # alphabetically otherwise
		more_places = sorted(more_subplaces.iterkeys(), key=more_places_sort)

		## Will we show neighborhoods or cities?
		# Show neighborhoods if the user is searching in a location with neighborhoods (whether its a neighborhood itself or a city/borough with neighborhoods)
		if to_place_key(search_location) in keys_for_hoods_and_their_cities:
			place_list_type = 'neighborhood'
		else:
			place_list_type = 'city'

		return more_places, more_subplaces, more_places_to_expand, place_names, place_list_type

	@classmethod
	def _pick_top_place_keys(cls, current_top_places, checked_place_filters, place_list_type, all_hoods, all_cities, search_location, weights, max_top_filters):
		"""
		Of all the options for places we're going to allow the user to filter by, which `max_top_filters` (default 4) places
		should get to go in the main search filter box?

		Args:
			current_top_places -- if this is an AJAX request, what did the previous searches have as the top places?
			checked_place_filters -- did the user request we filter by any particular places?
			place_list_type -- are we going to choose neighborhoods or cities?
			all_hoods -- what hoods can the user filter by?
			all_cities -- what cities can the user filter by?
			search_location -- what's the primary location for this search?
			weights -- how often did each place appear in the search results?
			max_top_filters -- how many places can fit in the search filter box?
		Returns:
			list of up to `max_top_filters` place keys in order of how they should appear
		"""
		# On AJAX requests, keep the original `max_top_filters` filters from the original search request
		if current_top_places:
			top_place_keys = [p['place_key'] for p in current_top_places]
		else:
			# Only choose places of the appropriate type
			if place_list_type == 'neighborhood':
				candidate_top_places = all_hoods
			else:
				candidate_top_places = all_cities

			candidate_top_place_keys = [place['place_key'] for place in candidate_top_places]

			# put filters in the same city as the search first,
			# and after that, sort by weight
			search_city_key = to_place_key(to_city(search_location)) if search_location else None
			top_place_keys = sorted(
				candidate_top_place_keys,
				key=lambda pk: ((place_key_to_place_key_for_city(pk) == search_city_key),
								  weights.get(pk), 0.0),
				reverse=True)[:max_top_filters]

		## Move any places the user selected to filter by up to the top places
		## list, if they are of the right type. If a top place is also checked,
		## we leave it alone. Otherwise, we replace unchecked top places
		## with checked places of the right type (neighborhood or city),
		## putting the replacements as close to the bottom as possible
		checked_top_place_keys = set()
		replacement_place_keys = set()
		for place in checked_place_filters:
			place_key = to_place_key(place)

			if place_key in top_place_keys:
				checked_top_place_keys.add(place_key)
			# grab keys that are of the right type (city or hood)
			# and not already in the top place keys
			elif (bool(place['neighborhood']) ==
				  (place_list_type == 'neighborhood')):
				replacement_place_keys.add(place_key)

		# don't replace items that are already checked!
		top_place_indices_to_replace = [
			i for (i, pk) in enumerate(top_place_keys)
			if pk not in checked_top_place_keys]

		# take the bottom-most spots if that's all we need
		top_place_indices_to_replace = top_place_indices_to_replace[-len(replacement_place_keys):]

		for i, rpk in zip(top_place_indices_to_replace, replacement_place_keys):
			top_place_keys[i] = rpk

		return top_place_keys

	@classmethod
	def _pick_place_filters(cls, country,
			_,
			place_stats,
			location,
			places_in_geobox,
			checked_place_filters,
			current_top_places,
			max_top_filters,
			min_count=config.search.PLACE_MIN_COUNT):
		"""
		Pick place filters. If at least a certain proportion of businesses are in neighborhoods,
		the "top 4" list should be a list of neighborhoods; else it should be a list of cities
		(never a list of boroughs).

		Args:
			places_stats - info on where results occurred, an example dict:
				for a ['burritos', 'nyc'] search:
				{'total_count': 5000.0,
				'counts': {
					'NY:New_York:Staten_Island:Emerson_Hill': 1,
					'NY:New_York:Manhattan:TriBeCa': 56,
					'NY:New_York:Staten_Island:Stapleton': 2,
					'NY:New_York:Brooklyn:Bath_Beach': 8, ... },
				'weights': {
					'NY:New_York:Staten_Island:Emerson_Hill': 0.0093826474621891975,
					'NY:New_York:Manhattan:TriBeCa': 1.7379232156090438, ... },
				'total_weight': 188.80445991759188}
			location - location dict.
			places_in_geobox - a list of locations corresponding to hoods that occur in the geo box from the lucy query (doesn't currently contain cities, but those should work too)
			checked_place_filters - list of place keys: places which have already been selected by the user, as place keys
			current_top_places - list of place keys: places which are we currently showing as the top places
			max_top_filters - int: the number of top places.
			min_count - filters out locations from lucy with only a few results (see comment of PLACE_MIN_COUNT at the top)
		Returns:
			top_place_keys - list of places that show on the search page, e.g.
								['NY:New_York:Manhattan:Theater_District',
									'NY:New_York:Manhattan:East_Village',
									'NY:New_York:Manhattan:Greenwich_Village']
			more_places - list of the expandable top-level nodes in the "More" filters box
							['NY:New_York:Manhattan:',
								'NY:New_York:Brooklyn:',
								'NY:New_York:Bronx:',
								'NY:New_York:Queens:',
								'NY:New_York:Staten_Island:', '']
			more_subplaces - dict from top-level node to list of filterable places under that node
							{'': ['NY:Astoria::',
								  'NY:New_York_City::'],
							 'NY:New_York:Queens:': ['NY:New_York:Queens:Arverne',
										'NY:New_York:Queens:Astoria_Heights',
										'NY:New_York:Queens:Auburndale',
										'NY:New_York:Queens:Bay_Terrace',
										'NY:New_York:Queens:Bayside',
										'NY:New_York:Queens:Beechurst', ... }
			more_places_to_expand - collection of place keys that should be auto-expanded in the "More" place filter box
									subset of more_places
									set(['NY:New_York:Manhattan:'])
			place_list_type  - 'city' or 'neighborhood'
			place_names - mapping of place key ("CA:San_Francisco::"  to name ("San Francisco")
						- for things like "Kansas City" we need to add disambiguators ("Kansas City, MO" vs "Kansas City, KS")
						 {'CA:San_Francisco::Hayes_Valley': "Hayes Valley", "MO:Kansas_City::", "Kansas City, MO"}
			counts - place_stats['counts']
			weights - place_stats['weights']
		"""
		# Unpacking place stats
		counts = place_stats['counts']
		weights = place_stats['weights']

		# Figure out what we're searching near. in rare cases, this may be None
		# also don't use Google's PREMISE level geocodes as valid cities
		# (e.g. Holy Ghost Ukrainian Cath Scho, NY)
		if location and location['accuracy'] != yelp_lib.location.Accuracy.PREMISE:
			search_location = location
		else:
			search_location = None

		# Re-encode passed in place keys as locations
		checked_place_filters = from_place_keys(checked_place_filters)
		current_top_places = from_place_keys(current_top_places)

		## Which places do we know about for this location?
		## Make up a list of location dictionaries:
		all_places = []
		# Include the current place and the surrounding places from the geobox of the search
		if search_location:
			all_places.append(to_place(search_location))
		all_places.extend(places_in_geobox)
		# Include any important places that we knew about before any AJAX calls (filtering, map moving, etc.)
		all_places.extend(checked_place_filters)
		all_places.extend(current_top_places)

		# precompute place keys for these places:
		for place in all_places:
			place['place_key'] = to_place_key(place)

		# Include places from search stats that have at least a few results
		for place_key, count in counts.iteritems():
			if count >= min_count:
				place = from_place_key(place_key)
				if place is not None:
					place['place_key'] = place_key
					all_places.append(place)

		## Of all those places, which cities and hoods do we want to allow filtering on?
		# Note: this assumes that if we have boroughs then we'll always have neighborhoods
		# (and then the borough will show up as the parent of its hoods)
		all_cities, all_hoods = cls._pick_hoods_and_cities_from_places(country, all_places, search_location)

		## How are we going to organize all our filterable locations
		more_places, more_subplaces, more_places_to_expand, place_names, place_list_type = cls._organize_place_filter_list(country, _, all_cities, all_hoods, search_location)

		## Which 4 places do we show directly in the search filters?
		top_place_keys = cls._pick_top_place_keys(current_top_places, checked_place_filters, place_list_type, all_hoods, all_cities, search_location, weights, max_top_filters)

		## Final Display Cleanup
		# Don't show any cities that we show in the "Top Places" in the "More Places"
		if place_list_type == 'city':
			if '' in more_subplaces:
				more_subplaces[''] = [pk for pk in more_subplaces[''] if not pk in top_place_keys]
				# Don't need to show more "More Cities" if there aren't any beyond the top places
				if not more_subplaces['']:
					more_places = [pk for pk in more_places if pk != '']

		# If we only have one root-level node, expand it
		if len(more_places) == 1:
			# If we just have cities, eliminate the whole concept of the tree
			# and display each city directly
			if more_places[0] == '':
				more_places = more_subplaces['']
				more_places_to_expand = set()
			else:
				more_places_to_expand = more_places

		return top_place_keys, more_places, more_subplaces, more_places_to_expand, place_list_type, place_names, counts, weights

	def _setup_open_time_filter(self, form_vars):
		"""
		Populate open-time filter and display vars.
		"""
		d = self.display

		# read in open_time/open_now
		# remember, 0 (Monday midnight) is a valid open time!
		d['open_time'] = form_vars['open_time']
		d['open_now'] = form_vars['open_now']

		open_time_filter = None
		if d['open_time'] is not None:
			open_time_filter = d['open_time']
		# if both are set, open_now takes precedence
		if d['open_now']:
			open_time_filter = d['open_now']
			d['open_time'] = None

		# either way, it's just a filter on a time,
		# rounded to the nearest half hour
		if open_time_filter is not None:
			open_time_filter = int(math.floor(float(open_time_filter) / config.search.DEFAULT_HOURS_TIME_PERIOD)) * config.search.DEFAULT_HOURS_TIME_PERIOD

		# make descriptions for open_time, open_now
		if d['open_time'] is not None:
			open_datetime = timeutil.midnight_last_monday() + datetime.timedelta(minutes=d['open_time'])
			d['open_time_day'] = open_datetime.date().weekday()
			d['open_time_day_desc'] = self.date_formatter.format_business_day(open_datetime)
			d['open_time_desc'] = self.date_formatter.format_business_time(open_datetime)
			d['open_time_desc_full'] = '%(open_time_day_desc)s %(open_time_desc)s' % d # XXX safe?
		else:
			# default to selecting current day of week at search location
			# NOTE this uses the most recent search location, which may be different
			# from the current search location (the current search location is calculated
			# later in _get_location_params).  This will cause the wrong day to be
			# selected when crossing new-day boundaries between locations.
			now_datetime = timeutil.current_datetime_at_point(d['longitude'], d['latitude'])
			d['open_time_day'] = now_datetime.date().weekday() if now_datetime else None
		if d['open_now'] is not None:
			open_now_datetime = timeutil.midnight_last_monday() + datetime.timedelta(minutes=d['open_now'])
			d['open_now_desc'] = self.date_formatter.format_business_time(open_now_datetime)

		return open_time_filter

	def _show_open_time_filters(self, hours_stats, min_proportion_of_weight=config.search.OPEN_TIME_MIN_PROPORTION):
		"""
		Decide whether to show the "Open Time" and "Open Now"
		filters in the attribute list
		"""
		# if open time is already set, always show the filters
		if self.param['open_time'] is not None or self.param['open_now'] is not None:
			return True

		if not hours_stats:
			return False

		total_weight = hours_stats['total_weight']
		weights = hours_stats['weights']
		any_hours_weight = weights.get(config.search.ANY_HOURS_INFO, 0.0)

		return any_hours_weight >= total_weight * min_proportion_of_weight

	def _zoomlevel_descs_dict(self):
		"""Get a mapping from zoom level to a description of it."""
		return config.mapsearch_zoom_descs_by_units[self._distance_units()]

###
# END Filter logic
###

###
# START Ranger log population & helper functions
###

	def _ranger_extra_search_info(self, location, num_searches_attempted, search_timing_info):
		"""Call this at the end of the servlet; read
		self.display, and return a dictionary of appropriate
		extra ranger info.
		"""
		d = self.display
		info = {}

		# log location info
		if location:
			info['parsed_location'] = dict((k, v) for (k, v) in location.iteritems() if k not in ('display', 'unformatted'))
		else:
			info['parsed_location'] = None

		# log search description
		info['description'] = d['description']

		# log bizs in search results
		biz_info = self._dump_biz_infos_to_dict(d['biz_list'])
		if 'show_autocorrected_results' in self.modified_query_history:
			autocorrected_biz_info = self._dump_biz_infos_to_dict(d['autocorrected_biz_list'])
			info['autocorrected_biz_results'] = {'biz_list' : autocorrected_biz_info, 'total' : len(autocorrected_biz_info)}

		info['results'] = {'biz_list' : biz_info, 'total' : len(biz_info)}
		# log related lists
		info['related_list'] = {'total' : len(d.get('related_lists', [])) }

		# log message board topics
		info['message_board_topics'] = {'total' : d.get('message_board_topics_total', 0) }

		if d.get('category_yelp_correction'):
			info['category_yelp_correction'] = \
				{'id' : d['category_yelp_correction']['unenc_id'], 'alias' : d['category_yelp_correction']['alias']}
		else:
			info['category_yelp_correction'] = None

		# do we have the various kinds of filters?
		info['has_categories'] = bool(d['top_categories'])
		info['has_costs'] = bool(d['cost_attr_group'])
		info['has_attrs'] = bool(d['top_attrs'])
		info['has_places'] = bool(d['top_places'])
		info['filters_open'] = d['show_filters']

		# log spelling suggestion, if any
		info['spelling_suggestion'] = d['spelling_suggestion']
		info['show_spelling_suggestion_at_top'] = d['show_spelling_suggestion_at_top']

		# timr: log a special value to indicate that DYM FR has returned a result,
		# or ignored a suggested result (for experimental purposes).
		# this is temporary, for the use of the DYM FR search experiment.
		if (self.base_lang() == 'fr' and
			(d['ignored_fr_spelling_suggestion'] or d['spelling_suggestion'])):
			info['has_dym_fr_suggestion'] = True

		# log performance information
		info['num_searches_attempted'] = num_searches_attempted
		info['timing_info'] = search_timing_info

		# log any rewritten attributes
		info['modified_query_history'] = self.modified_query_history

		# log the rewritten location and description
		if 'preposition' in info['modified_query_history']:
			info['rewritten_find_loc'] = d['rewritten_find_loc']
			info['rewritten_description'] = d['rewritten_description']

		# log search suggestions to ranger
		search_suggest_info = self._read_search_suggest_info_from_cookie()
		if search_suggest_info:
			info['search_suggest'] = search_suggest_info

		# log return status of category folding for this search
		info['folded'] = d['category_folding']

		# extra info from lucy, to be logged to the ranger extra.search dict
		info['lucy_extra'] = d['ranger_extra_search_info']
		return info

	def _read_search_suggest_info_from_cookie(self):
		"""
		Read the SEARCH_SUGGEST cookie if it exists.

		This cookie is used to collect useful info about search suggest
		so that we can log it in ranger.  In particular it has:
			text_typed - The actual text the user typed
			rank - The rank of the particular suggest result returned

		This cookie is only set when there was a suggest, so it
		implicitly indicates that search suggest was used.  We can
		retrieve the suggestion by looking at the actual query.
		"""

		if not config.cookies.SEARCH_SUGGEST_INFO in self.request.cookies:
			return None

		c_val = self.request.cookies[config.cookies.SEARCH_SUGGEST_INFO]
		try:
			search_suggest_info = util.json.loads(c_val)
		except util.json.DecodeError:
			return None

		return search_suggest_info

	def _dump_biz_infos_to_dict(self, biz_list):
		biz_info = []
		for biz in biz_list:
			# Record whether search had a partial or exact match hit,
			# None is used if it wasn't exact or partial.
			match_type = get_deep(biz, 'field_matches.name') or None
			has_review_snippet = bool(biz.get('review_snippet'))
			biz_dec_id = decid(biz['id'])
			category_ids = [cat.get('unenc_id') for cat in biz.get('category_yelp', [])]
			out_biz_dict = {
				'id' : biz_dec_id,
				'rating' : biz['rating'],
				'score_components': biz['score_components'],
				'match_type': match_type,
				'has_review_snippet' : has_review_snippet,
				'review_count' : biz['review_count'],
				'categories' : category_ids,
				'follow_review_count' : biz['follow_review_count'],
				'friend_review_count' : biz['friend_review_count'],
				'foldable' : biz['foldable']
			}

			# !TODO! minh, this is only dumped to ranger
			announcement_id = biz.get('announcement_id')
			if announcement_id:
				out_biz_dict['announcement_id'] = decid(announcement_id)

			biz_info.append(out_biz_dict)
		return biz_info

###
# END Ranger log population & helper functions
###

###
# START Query Construction
###
	def _construct_lucy_query(self, location):
		"""Construct the query object passed to Lucy"""
		d = self.display
		query = self.repllogic.GeoboxLucyQuery(request=self.request)
		query.set_lang(self.base_lang())
		if d['debug_level'] >= 1:
			query.set_explain(True)
		if d['debug_level'] >= 2:
			query.set_lucene_plan(True)

		# If we rewrote the query, send the re-written version to Lucy (but show the original
		# query on the front-end)
		query.set_description(d['rewritten_description'] or d['description'])
		query.set_location_accuracy(location['accuracy'] or 0.0)
		query.set_offset_and_count(d['pager']['start'], d['pager']['rpp'])
		query.set_attr_flags_to_match(self.param['attr_flags'])
		query.set_attr_flags_to_boost(self.param['attr_flags_to_boost'])
		query.set_places_to_match(d['place_filters'])
		query.set_places_to_boost([self.param['place_to_boost']] if self.param['place_to_boost'] else [])
		# don't gather category stats in browse mode
		query.set_gather_category_stats(bool(d['description']))
		query.set_gather_place_stats(True)
		query.set_gather_hours_stats(True)
		query.set_gather_attr_flag_stats(True)
		# convert open time to half hour
		if self.param['open_time_filter'] is not None: # 0 is okay
			query.set_hours_to_match([self.param['open_time_filter']])
		query.set_relevance(d['relevance_mode'])
		d['attr_flags'] = self.param['attr_flags']

		# The search servlet participates in all experiments relevant
		# to the 'search' group, and will always send experiment
		# information to the backend.  Other uses of GeoboxLucyQuery
		# should use this as an example of how to participate in
		# experiments
		experiments_for_yuv = dict(self.logic.Experiments.relevant_experiments_for_yuv(self.unique_visitor_id, 'search'))

		query.set_experiments(experiments_for_yuv)

		# If user clicked 'show omitted results', disable result folding; otherwise enable folding
		query.set_enable_category_folding(not self.param['category_folding_disabled_by_user'])

		# If we're in category filter mode ...
		# (cflt is set, or no cflt is set and neither is find_desc)
		if self.param['category_filters'] or d['find_desc'] == '':
			# Disable category folding when in category filter mode
			query.set_enable_category_folding(False)

			# add the category filters to the query
			for cat_filter in self.param['category_filters']:
				query.category_aliases_to_match().add(cat_filter)

			# If we're in category filter mode and there is no query then
			# we either do a most reviewed sort, a standard rating sort, or
			# a category sort (which is an extension of rating sort for category browse)
			if not d['description']:
				if d['relevance_mode'] == config.search.MOST_REVIEWED_SORT:
					query.set_relevance(config.search.MOST_REVIEWED_SORT)
				elif d['relevance_mode'] == config.search.RATING_SORT:
					query.set_relevance(config.search.RATING_SORT)
				else:
					query.set_relevance(config.search.CATEGORY_SORT)
					d['relevance_mode'] = config.search.CATEGORY_SORT
		# ... Or if we have a category suggestion and are not filtering by category explicitly
		elif d['category_yelp_correction'] and not self.param['category_folding_disabled_by_user']:
			# Add category suggestion to the query to ensure that this category does not get automatically filtered
			query.set_category_suggestions([d['category_yelp_correction']['unenc_id']])

		# Should we do a backtracking search with this query?
		# TODO: Consider pulling this out into a common area so that
		# it can be shared with the api.
		do_backtracking = (
			# Only if there was a non-empty query was given...
			d['description'] is not None and
			len(d['description']) > 0 and
			# ...and a location was specified...
			location and
			# ...and we are using the default sort...
			query.relevance() == config.search.DEFAULT_SORT and
			# ...and no place, attribute, or category filters have been specified...
			not d['place_filters'] and
			not self.param['attr_flags'] and
			not self.param['category_filters'] and
			# ...and there was no extra l parameter, which corresponds to 'more advanced' location filtering
			# for things like geobox searches, place searches, and biz searches
			not d['l']
		)

		return query, do_backtracking

	def _construct_business_search(self, query, geo_box, zoomlevel, do_backtracking):
		"""Construct a dict that specifies the logic method with which to call lucy for business search

		   Args:
			query - lucy query object
			geo_box - geobox defining area to search
			zoomlevel - zoom to search at
			do_backtracking - if this is a new search that requires backtracking"""

		d = self.display
		backtracking_search = False
		business_search = None

		# Fetch this many Review Highlights summaries per biz to show in the mo-map hovercards
		summary_count = config.summarization.MAX_SENTENCES_TO_DISPLAY if config.review_highlights_enabled else 0

		if zoomlevel < config.search.MAX_SEARCH_ZOOM:
			d['zoomed_too_far'] = True
		else:
			d['zoomed_too_far'] = False
			if do_backtracking:
				mapsize = MapSize.from_name(d['mapsize'])
				# Don't send a query with any geoboxes (meaning don't call query.set_geoboxes(..),
				# the backtracking logic will take care of creating them from the geo_box sent in
				# here as an argument.
				business_search = (self.repllogic.business_search_with_review_and_user_photo_using_backtracking,
						(query, geo_box, zoomlevel, mapsize),
						{
							'summary_count': summary_count,
							'include_neighborhoods': True,
						})
				backtracking_search = True
			else:
				query.set_geoboxes([geo_box])
				business_search = (
					self.repllogic.business_search_with_review_and_user_photo,
					(query,),
					{
						'include_hours': True,
						'include_attribs': True,
						'include_biz_page_offers': True,
						'include_deals': True,
						'summary_count': summary_count,
						'include_neighborhoods': True,
					},
				)
		return business_search, backtracking_search

	def _strip_hidden_categories_for_country(self, reply, country=None):
		"""Remove any categories from self.display that should be hidden."""

		for biz in reply['business_list']:
			biz['category_yelp'] = without_none(self.repllogic.CategoryYelp.get_node_by_id(cat['id']) for cat in biz['category_yelp'])

###
# END Query Construction
###

###
# START Post-search data-filling
###

	def _populate_biz_list(self, biz_list):
		"""Get details for each business and populate the list of search results"""

		for biz in biz_list:
			# add cost info to each biz
			biz['cost_attr'] = self._cost_attr_for_biz(biz)

			# add formatted hours to each biz if we're showing them
			biz['hours_desc'], biz['open'] = self._hours_desc_for_biz(biz, self.param['open_time_filter'])

			# add matched attribute info to each biz
			matched_attr_lines = []
			for group_title, attrs in config.search.SEARCH_ATTRIBUTES:
				for attr_alias in attrs:
					if attr_alias in biz['matched_attrs']:
						matched_attr_lines.append([group_title, self.repllogic.business_attribute_alias_to_title(attr_alias, full_title=True), attr_alias])
			# sort matched attributes alphabetically
			matched_attr_lines.sort()
			biz['matched_attr_lines'] = matched_attr_lines

			# get biz review summaries
			relevant_cat_aliases = util.summarization.get_all_relevant_aliases(self.repllogic.CategoryYelp, biz['category_yelp'])

			if (config.review_highlights_enabled and
				util.summarization.qualifies_for_summarization(relevant_cat_aliases, biz['score'], biz['review_count'])):
				biz['snapshot'] = biz['summaries']

	def _log_deals_impressions(self, biz_list):
		"""For each business that has a deal running, log the impression of
		that deal to the deal_event_log.
		"""
		deal_logger = DetailedDealLogger.for_servlet(self, Platform.web)
		user_geoquad = self.logic.User.get_geoquad(self.unauth_userid) if self.unauth_userid else None

		for biz in biz_list:
			deal_offer = biz.get('deal')
			if deal_offer:
				deal_logger.log_impression(deal_offer, ImpressionType.biz_search_result_block, user_geoquad)

	def _add_friends_and_following(self, biz_list, friends, follows):
		# Shortcut if the feature is disabled
		if not self.show_friend_and_follow_review_count:
			for biz in biz_list:
				biz['friend_review_count'] = biz['follow_review_count'] = 0
			return

		# friends and follows are unencrypted IDs: retrieve unencrypted reviewer IDs for each business:
		biz_to_user_map = self.repllogic.Review._biz_to_user_id_map([decid(biz['id']) for biz in biz_list])
		for biz in biz_list:
			reviewers = set(biz_to_user_map[decid(biz['id'])])
			# then count the intersections:
			biz['friend_review_count'] = len(friends & reviewers)
			biz['follow_review_count'] = len(follows & reviewers)

	def _populate_list_results(self, list_search_results):
		"""Populate the list results with details

		   Args:
			list_search_results - list results as returned from lserve"""

		d = self.display
		if list_search_results and 'result' in list_search_results:
			d['related_lists'] = list_search_results['result'][0]
			for l in d['related_lists']:
				potential_alias = self.repllogic.FavoritesListAlias.get_alias_by_dst_id(l['id'])
				if potential_alias:
					l['list_url'] = util.uri.list_details.uri(potential_alias)
				else:
					l['list_url'] = util.uri.list_details.uri(l)
				l['user_url'] = util.uri.ConfigurableUrl('/user_details').set('userid', l['user_info']['id'])
		elif list_search_results and 'exception' in list_search_results:
			pass

	def _populate_message_board_results(self, message_board_search_results):
		"""Populate message board results with details"""
		d = self.display
		if message_board_search_results and 'result' in message_board_search_results:
			d['message_board_topics'], d['message_board_topics_total'] = message_board_search_results['result']
		elif message_board_search_results and 'exception' in message_board_search_results:
			log.error("message board search exception: %r" % (message_board_search_results['exception']))

	def _add_neighborhood_labels_and_polys(self, geo_box, zoomlevel):
		"""Prepares neighborhood polygons and labels for the map"""
		d = self.display
		filter_hoods = [lookup_hood(from_place_key(pk)) for pk in d['place_filters']]
		# filter out keys for cities, nonexistent hoods, etc.
		filter_hoods = [h for h in filter_hoods if h]
		d['filter_polys'] = [h['poly'] for h in filter_hoods]

		# set up clickable neighborhood labels for viewport
		d['neighborhoods_in_viewport'] = []
		if d['zoomlevel'] >= config.search.MIN_ZOOM_TO_DISPLAY_HOODS:
			for hood in hoods_in_geo_box(geo_box):
				# set up image URLs
				hoodname = config.search.HOOD_SEPARATOR_RE.sub(r' \1 ', format_neighborhood_name(hood, from_country=self.country()))
				# place the label at the centroid of the poly
				# urls for the image
				image = { 'identifier_normal': util.uri.hood_image.uri(zoomlevel, hoodname, 0),
						  'identifier_hi': util.uri.hood_image.uri(zoomlevel, hoodname, 1),
					}

				new_find_loc = format_neighborhood(hood, from_country=self.country())

				d['neighborhoods_in_viewport'].append({
					'position': LngLat.from_geocode(hood),
					'name': hoodname,
					'image': image,
					'key': to_place_key(hood),
					'find_loc': new_find_loc,
					})


	def _fill_category_and_place_stats(self, reply, location, geo_box):
		"""Guess categories and compute statistics for the neighborhoods and nearby cities"""
		if reply:
			d = self.display

			category_suggestion = d['category_yelp_correction']['alias'] if d['category_yelp_correction'] else None

			# TODO(15636) this should eventually go away
			d['category_alias_to_translation'] = get_category_alias_to_translation(self.logic.country(), self.logic.language())

			(d['top_categories'],
				d['more_categories'],
				d['category_counts'],
				d['category_weights']) =  \
				pick_category_filters(reply['category_stats'],
							  BUSINESS_SEARCH_CATEGORY_INFO,
							  current_category_filters=d['category_filters'],
							  category_suggestion=category_suggestion,
							  max_top_filters=config.search.NUM_TOP_CATEGORIES)

			# Did search execute category folding?
			d['category_folding'] = reply.get('category_folding', False)

			# do we want to show open time filters?
			d['show_open_time_filters'] = self._show_open_time_filters(reply['hours_stats'])

			# open time filters take up a slot in the attributes
			# list
			num_top_attributes = config.search.NUM_TOP_ATTRIBUTES
			if d['show_open_time_filters'] is not None:
				num_top_attributes -= 1

			if reply['attr_flag_stats']:
				(d['top_attrs'],
					d['cost_attr_group'],
					d['more_attrs_standalone'],
					d['more_attr_groups'],
					d['attr_counts'],
					d['attr_weights']) = self._pick_attribute_filters(
							reply['attr_flag_stats'],
							current_attr_flags=self.param['attr_flags'],
							max_top_filters=num_top_attributes)
			elif self.param['attr_flags']:
				# When there is no search results but filter has been applied,
				# make sure we show the checked attributes for user to uncheck.
				d['top_attrs'] = [self.search_attr_map[checked_attr] for checked_attr in self.param['attr_flags']]

			if reply['place_stats']:
				d.update(pick_place_filters(self.country(),
					self._,
					reply['place_stats'],
					location,
					geo_box,
					place_filters=d['place_filters'],
					current_top_places=self.param['current_top_places']))


	def _fill_ads_based_on_categories_and_results(self, reply, friends, follows, location, geo_box):
		"""Choose the business add shown at the top of search results"""
		if not (location and self.display['biz_list']):
			return

		try:
			self._load_local_ads(reply, friends, follows, location, geo_box)
		except:
			self.log.exception("Ad delivery exception:\n")

	def _load_local_ads(self, reply, friends, follows, location, geo_box):
		query_desc = self.display['rewritten_description'] or self.display['description']

		load_demo_advertisement = bool(self.param['sample_biz_id'])
		self.display['is_demo_advertisement'] = load_demo_advertisement

		winner_ad_asset = None

		if load_demo_advertisement:
			from biz_cmds.demo import _generate_fake_ad_asset
			winner_ad_asset = _generate_fake_ad_asset(
				self,
				self.param['sample_biz_id'],
				prefer_ad_type=self.param['sample_ad_type'],
				skip_review_qualification=True)

			self.meta_robots.index = False
			self.meta_robots.follow = False
		elif self.request_features.is_feature_enabled(config.feature_names.yelp_ads):
			self.log.debug("Q2C: %r", reply['q2c_boost'])

			query_cat_filters = None
			if self.param['category_filters']:
				query_cat_filters = [alias for alias in self.param['category_filters']]

			# Bookmark is only set by an AJAX request and is TRUE if we knew we clobbered a search page
			bookmark_value = self.form.getfirst('bookmark')
			raw_parent_request_id = self.form.getfirst('parent_request_id')

			# Splice in the parent request ID if we know this impression immediately clobbered someone else
			if bookmark_value == 'true' and raw_parent_request_id:
				parent_request_id = str(raw_parent_request_id)
			else:
				parent_request_id = None

			ad_opportunity = yelp.ad.match_utils.search.match_for_search(
						self.logic,
						query_desc,
						location,
						query_cat_filters,
						self.display['biz_list'],
						geo_box,
						reply['q2c_boost'],
						yuv=self.unique_visitor_id,
						request=self.request,
						enc_user_id=self.unauth_userid,
						parent_request_id=parent_request_id)
			winner = ad_opportunity.winner
			if winner is not None:
				winner_ad_asset = winner.ad_row.ad_asset

		if winner_ad_asset is not None:
			# We'll need this later in the template
			winner_ad_asset.location.business.requesting_neighborhoods()

			# Ads are in SQLAlchemy objects but the search servlet really wants businesses in EZA form for rendering
			advertising_business = self.logic.biz_get_info(winner_ad_asset.location.business_id, include_neighborhoods=True)

			specialty_def, specialty_val = self.logic.business_attribute_def_load_attribute_value_by_alias("AboutThisBizSpecialties", advertising_business['id'])
			advertising_business['specialties'] = specialty_val or ''

			if not self.param['sample_biz_id']:
				advertising_business['name'] = text.highlight_text(advertising_business['name'], self.display['description'])

			advertising_business['friend_review_count'] = 0
			advertising_business['follow_review_count'] = 0
			if self.show_friend_and_follow_review_count:
				all_reviewed_businesses = self.repllogic.Review.get_reviewers_for_businesses([advertising_business['id']])
				reviewers = set(all_reviewed_businesses[ObjectID(advertising_business['id'])])
				advertising_business['friend_review_count'] = len(friends.intersection(reviewers))
				advertising_business['follow_review_count'] = len(follows.intersection(reviewers))

			self.set_timing_checkpoint('before_ad_snippet')
			# Try to find a snippet for the ad
			if config.use_highlighted_snippet_for_search_ad_unit:
				review, review_snippet = \
					self.repllogic.Review.get_positive_advertisable_matching_snippet(advertising_business['id'], query_desc, base_lang=self.base_lang())
				winner_ad_asset.creative.review_snippet = review_snippet
				if review:
					winner_ad_asset.creative.review = review

			self.set_timing_checkpoint('after_ad_snippet')

			winner_ad_asset.business_for_rendering = advertising_business

			self.display['yelp_local_ads'] = winner_ad_asset
			self.display['search_biz_ad_extra'] = {
				'find_loc': self.display['find_loc'] or '',
				'find_desc': self.display['find_desc'] or '',
				'find_cat_filters': self.display['find_cat_filters'] or '',
				'unformatted_city_name': self.display['current_location']['unformatted'] or '',
				'url': self.display['url']
			}

			if not load_demo_advertisement:
				ranger.request_info['extra']['ads'] = [dict(biz_id=advertising_business['id'],
															ad_type=str(winner_ad_asset.creative.type))]
		else:
			self.display['yelp_local_ads'] = None
			self.display['search_biz_ad_extra'] = {}

		if not load_demo_advertisement and self.request_features.is_feature_enabled(config.feature_names.yelp_ads):
			self.logic.AdEvent.log_ad_opportunity(ad_opportunity)
			DetailedDealLogger.for_servlet(self, Platform.web).log_cpa_impression(ad_opportunity, None)

###
# END Post-search data-filling
###

###
# START Location determination logic
###
	def _get_location_params(self, disable_redirect=False):
		d = self.display

		# Get a mapsize object from the mapsize description
		mapsize = MapSize.from_name(d['mapsize'])

		# Depending on which location handler gets dispatched to
		# the function might need lots o' kwargs... :PPPPP
		kwargs = {
			'from_country': self.country(),
			'request': self.request,
			'description': d['description'],
			'try_rewrite': not d['rewritten_description'],
			'mru_location': self.mru_location,
			'mapsize': mapsize,
			'yuv': self.unique_visitor_id,
			'find_loc': d['find_loc'], # Places logic needs this in a special case
		}

		# If 'l' is set it overrides find_loc (which is just for tracking what should
		# be displayed).  Otherwise, fall back to 'find_loc'
		raw_loc_str = d['l'] or d['find_loc']
		zoomlevel, geo_box, location, kwreturns = self.logic.SearchLocation.get_loc(raw_loc_str, self.base_lang(), **kwargs)

		# Redirect and start over if we need to
		if 'execute_external_redirect' in kwreturns:
			redir_url = self._here().set_many(**kwreturns['execute_external_redirect'])

			# At this point in the code the servlet expects to do a redirect,
			# so we cannot just skip the redirect and continue running.
			# However, the redirect would loop forever, so we crash instead.
			if str(self._here()) == str(redir_url):
				data = 'Raw Loc Str: "%r".  Kwargs: %r' % (raw_loc_str, kwargs)
				msg = 'Infinite redirect chain at "%s".  %s' % (self._here(), data)
				raise InfiniteRedirectException(msg)
			self.external_redirect_url(redir_url)

		## Fill in data from kwreturns
		if 'place_filters' in kwreturns:
			d['place_filters'] = kwreturns['place_filters']

		if 'place_to_boost' in kwreturns:
			self.param['place_to_boost'] = kwreturns['place_to_boost']

		if 'rewritten_description' in kwreturns and 'rewritten_find_loc' in kwreturns:
			d['rewritten_description'] = kwreturns['rewritten_description']
			d['rewritten_find_loc'] = kwreturns['rewritten_find_loc']

		# Add a temporary extra field to ranger ( :-((( ) to pass back information
		# about what query rewrite was done. Remove after #14443 is done.
		if 'preposition_rewrite_explanation' in kwreturns:
			ranger.request_info['extra']['preposition_rewrite_explanation'] = kwreturns['preposition_rewrite_explanation']
		else:
			ranger.request_info['extra']['preposition_rewrite_explanation'] = -1
		## Done filling in from kwreturns

		# If this is a new search, or we have no cookies, store location in a cookie
		if not self.cookie_location or self.param['ns'] and location:
			self.set_mru_location(location)

		# Set the country.  We do NOT want to redirect off the tld.
		self.set_country_and_maybe_redirect(location.get('country'))

		# XXX We really seem to be passing too much to the templates
		if location:
			d['neighborhood'] = (location['neighborhood'], location['city'], location['state'])
			d['meta_location'] = format_city_name(location)

			# If we don't have a find location set use the map center as the new find location
			if not d['find_loc']:
				d['find_loc'] = ', '.join(format_address(location))

			# this is the city name seen in the 'you have
			# results in this city' thing
			d['city_name'] = format_city_name(location)
			d['location'] = ', '.join(format_address(location))

			# This is a 'precise' location (we should drop a pin on the map) if
			# it is an address or cross street
			d['precise_location'] = location['accuracy'] > yelp_lib.location.Accuracy.ZIPCODE and location.get('address1')

		d['zoomlevel'] = zoomlevel
		d['distance_units'] = self._distance_units()

		# Setup the bounds (radii) and descriptions of the allowed zoom levels (ZOOMLEVELS_TO_DISPLAY_IN_FILTER_PANEL)
		#
		# radii is a map from zoom level -> bounding box containing that zoom level, given lng/lat & mapsize
		radii = {}
		d['longitude'], d['latitude'] = geo_box.mid().lnglat()
		for z in ZOOMLEVELS_TO_DISPLAY_IN_FILTER_PANEL:
			radii[z] = self.repllogic.SearchFrontEnd.bounds_by_longitude_latitude_pixelsize_zoom(d['longitude'], d['latitude'], mapsize, z)
		d['radii'] = radii

		# get zoom level descriptions
		zldd = self._zoomlevel_descs_dict()
		d['zoomlevel_descs'] = [(z, zldd.get(z, '')) for z in ZOOMLEVELS_TO_DISPLAY_IN_FILTER_PANEL]

		# set the canonical find_loc for googlebot
		d['canonical_find_loc'] = format_canonical_address(location)

		return zoomlevel, geo_box, location
###
# END Location determination logic
###

###
# START Misc. helper functions
###
	def canonical_uri(self, locale):
		return str(self._here())

	def _here(self):
		"""Current URL, as a ConfigurableUrl"""
		return ConfigurableUrl(self.request.unparsed_uri).restrict(SEARCH_URL_FIELDS)

	def _distance_units(self):
		"""Get the distance units to use (either util.units.MI or util.units.KM)"""
		return localization.country_to_distance_units(self.country())


	def _hours_desc_for_biz(self, biz, to_match):
		"""
		Given a business, biz, and a timestamp, to_match, return (hours_desc, is_open).

		If None is passed in for the value of to_match, we will match against the current time

		hours_desc - a formatted string denoting the business hours of biz that contain to_match
		if biz is not open at the time of to_match, house_desc is a formatted string denoting biz's hours on the day of to_match
		if biz is not open on the day of to_match, house_desc is set to the empty string

		is_open - boolean which is true iff biz is open at the time of to_match
		"""

		hours_desc, is_open = '', False

		if not biz['hours']:
			return hours_desc, is_open

		# business hours are stored in the DB as minutes since midnight monday (MMM for short)
		# to_match is a timestamp also in the format of MMM

		if to_match is None:
				# set to_match to current time in MMM form
				biz_tz = tzworld.timezone_for_location(biz)
				to_match = timeutil.time_delta_total_seconds(datetime.datetime.now(biz_tz) - timeutil.midnight_last_monday(tzinfo=biz_tz)) / 60

		sorted_hours = sorted(list(biz['hours']), key=lambda hours: hours['open'])

		# convert the to_match MMM to a datetime in the current timezone
		# use the first open time in sorted_hours as a date reference point
		match_datetime = timeutil.midnight_last_monday(relative_to=sorted_hours[0]['open']) + datetime.timedelta(minutes=to_match)

		# index of the largest value in sorted_hours that is less than or equal to match_datetime
		match_index = bisect.bisect_right([hours['open'] for hours in sorted_hours], match_datetime) - 1

		if match_index < 0:
			# there are no open hours <= match_datetime
			return hours_desc, is_open

		hours_for_day = sorted_hours[match_index]

		if hours_for_day['open'] <= match_datetime <= hours_for_day['close']:
			is_open = True
		elif hours_for_day['open'].day != match_datetime.day:
			# consider a business open from 6am - 6pm every day
			# assume match_datetime is set to 5am Wednesday
			# hours_for_day will be on Tuesday, but, we should show Wednesday's hours instead
			# this is the logic to handle that case

			match_index += 1

			# check next set of business hours to see if biz is open on the same day as match_datetime
			if match_index < len(sorted_hours) and sorted_hours[match_index]['open'].day == match_datetime.day:
				hours_for_day = sorted_hours[match_index]
			else:
				hours_for_day = None

		if hours_for_day is not None:
			# special case for businesses that are open 24 hours
			if (hours_for_day['close'] - hours_for_day['open']) >= datetime.timedelta(days=1):
				hours_desc = self._('$weekday_name 24 hours', weekday_name=self.date_formatter.format_business_day(hours_for_day['open']))
			else:
				hours_for_display = [hours for hours in sorted_hours[match_index:] if hours['open'].day == hours_for_day['open'].day]
				hours_desc = self.date_formatter.format_business_split_hours(hours_for_display)

		return hours_desc, is_open

	def _cost_attr_for_biz(self, biz):
		"""
		Figure out the price range for the given biz. Return
		an attribute dictionary if it has a price, otherwise
		None.
		"""
		cost_attr_group = self.search_attr_group_map[config.search.COST_ATTR_GROUP_TITLE]
		matching_cost_attrs = [a for a in cost_attr_group['attrs'] if a['alias'] in biz['attr_flags']]
		if matching_cost_attrs:
			return matching_cost_attrs[0]
		else:
			return None

############################################
# SEO attribute methods - see yelp.util.seo
#
	def _prepare_and_add_seo_attributes(self, form_vars):
		uri_info = self.get_uri_info_for_canonical_url(form_vars)
		overrides = self.get_seo_overrides(form_vars)
		self.add_seo_attributes(SEOCategory.CANON_TO_WORLDWIDE_DOMAIN,
					 self.country(),
					 uri_info,
					 noindex_override=overrides.get('noindex_override', None),
					 canonical_url_override=overrides.get('canonical_url_override', None))

	def get_uri_info_for_canonical_url(self, form_vars):
		"""Returns information that SEOConfigurator can use to generate canonical urls."""

		# There will always be a location we want to canonicalize to, even if find_loc
		# is missing from the url (ie. canon to sf if not specified)
		kwargs = {'location': self.display['canonical_find_loc'],}

		if 'find_desc' in form_vars:
			kwargs['query'] = form_vars['find_desc']

		if 'cflt' in form_vars:
			kwargs['categories'] = form_vars['cflt']

		return CanonicalURIInfo(SearchURI, kwargs=kwargs)

	def get_seo_overrides(self, form_vars):
		"""Check to see if there are any search-specific cases where we want to force
		the addition of noindex or canonical url.

		Returns:
		    a dict indicating which SEO attributes should be overridden and with what value
		"""
		# TODO jtwang 22127 - move this whitelisting stuff into seo class and use this to "allow" 'hl'
		# Because my brain is fried, these names suck
		# indexable_params - these are the only params allowed in indexable urls.  If any other params
		#     exist, then either the page is noindexed or it has a canonical url.
		# canon_away_params - the presence of these parameters means that the current page
		#     potentially has a canonical url
		#
		indexable_params = set(['find_desc', 'find_loc', 'cflt', 'hl'])
		canon_away_params = set(['ns'])

		overrides = {}

		# set noindex=true if the parameter is not in the allowed list
		for key in self.form.keys():
			param = str(key)
			if param not in indexable_params:
				if param in canon_away_params:
					overrides['canonical_url_override'] = True
				else:
					overrides['noindex_override'] = True
					break

		# Additionally, we noindex if the page has
		# - search terms starting with + (advanced search)
		# - no results
		if (form_vars.get('find_desc').startswith('+') or
		    not self.display['biz_list']):
			overrides['noindex_override'] = True

		# Add canonical url if the location is not _the_ canonical location
		if self.display['find_loc'] != self.display['canonical_find_loc']:
			overrides['canonical_url_override'] = True

		return overrides

#
# end SEO
################

	def _get_categories_for_tagging(self, results):
		"""
		This is used to determine categories for Google Ad Manager,
		which we use to display our brand ads.
		"""
		filter_google_cats = set()

		# add the category aliases for the user selected categories.
		if 'selected_categories' in results and results['selected_categories'] is not None:
			for cat in results['selected_categories']:
				filter_google_cats.add(cat['alias'])
				# get the ancestors of the current category and add them too.
				for ancestor_cat in self.repllogic.CategoryYelp.walk_up_tree(cat):
					filter_google_cats.add(ancestor_cat['alias'])

		for cat in results.get('top_categories', []):
			filter_google_cats.add(cat)

		top_cats = set()
		sub_cats = set()
		# Separate categories into top level and sub level.
		for cat_node in self.repllogic.CategoryYelp.get_nodes_by_aliases(filter_google_cats):
			found = False
			while cat_node['min_depth'] > 1 and len(cat_node['parents']) > 0:
				if cat_node['alias'] in filter_google_cats:
					found = True
					if cat_node['min_depth'] == 2:
						sub_cats.add(cat_node['alias'])
				cat_node = cat_node['parents'][0]
			if cat_node['alias'] in filter_google_cats:
				found = True
			if found:
				top_cats.add(cat_node['alias'])
		return top_cats, sub_cats

	def _category_yelp_correction(self, description):
		"""Get category browse suggestion.

		Used to help pick top categories.
		"""
		if description:
			guesses, total = category_yelp_from_query(description, 1)
			if guesses:
				try:
					return self.repllogic.CategoryYelp.get_by_alias(guesses[0])
				except errors.OldAlias:
					return self.repllogic.CategoryYelp.get_by_alias(yelp.bootstrapped.category_yelp.alias_rerouting[guesses[0]])

	def _validate_description(self, description):
		"""Validates a description (search query)

		If there is an exception during validation, return
		an empty string and the exception in question.

		We return an empty string because a non-empty string
		is not safe to return if it failed validation.  We
		return the exception so that we can defer raising it
		until we have filled in the minimum data necessary
		for the search template to preserve user data.
		"""
		validated_description = ''
		setup_exception = None
		try:
			if description:
				validated_description = validate.Search().parse_validate_string(description[:validate.Search().maxlength])
		except (validate.NoValidCharactersError, validate.DisallowedCharacterError):
			setup_exception = InvalidDescription()
		return validated_description, setup_exception

	def _fit_map_to_results(self, reply, geobox, location):
		"""Zoom in and center the map to fit the results returned from a search.

		Algorithm overview:
		1. Ensure that we are performing a regular location search.  For example, we don't want to run this
		   logic if we've got a neighbourhood, or the user has dragged the map.
		2. Calculate the (minimal) geobox containing all businesses.  Note that we ignore business
		   for which the accuracy is <= 5.0 because they are not displayed on the map anyway, and often
		   have rather unhelpful geocodes like the center of San Francisco.
		3. Scale this geobox by 'slop' in order to prevent business appearing at extreme margins of the map.
		4. Pass the scaled geobox to SearchFrontEnd.zoom_map_to_include to find the map view that is
		   - Centered upon the scaled geobox and,
		   - Maximally zoomed (up to MAX_ZOOM_FOR_FIT_MAP_TO_RESULTS) whilst still containing the scaled geobox.
		5. Check that the new map view is strictly included in the original geobox.  Without this check, unsearched
		   map can be revealed in the following cases:
		   - If we didn't actually zoom in, but just recentered the map view.
		   - Or, if we did zoom in, but recentered near the edge of the map.
		"""

		# Default early-return value.
		default = geobox, location

		# Bail if the user is not included in the experiment
		cohort = self.repllogic.Experiments.get_cohort_for_yuv(self.unique_visitor_id,
															   'fit_map_to_results_experiment_1')
		if cohort != 'on':
			return default

		# Bail if this isn't a regular location search.
		d = self.display
		handler, _ = self.logic.SearchLocation.get_handler_loc(d['l'] or d['find_loc'])
		if handler == self.logic.SearchLocation._default_parse_loc:
			if d['place_filters']:
				# Even though we are in the default location handler, we've hit a hood, so bail.
				return default
		elif handler == self.logic.SearchLocation._places_parse_loc:
			# After a places filter is checked and then unchecked, the places handler is invoked
			# with ALL_PLACE_FILTERS_UNCHECKED_SENTINEL (even though it's now a regular location search).
			# Continue as if this is a regular location search.
			if d['l'] != 'p:' + config.search.ALL_PLACE_FILTERS_UNCHECKED_SENTINEL:
				return default
		else:
			# We've hit some other handler, so bail.
			return default

		# Find valid business coordinates, and bail if we don't have any.
		points = [ LngLat(biz['longitude'], biz['latitude']) for biz in reply['business_list']
				   if biz['longitude'] is not None and
				   biz['latitude'] is not None and
				   (biz['accuracy'] is None or biz['accuracy'] > 5.0) ]
		if len(points) == 0:
			return default

		# Calculate our new geobox and corresponding map view
		slop = 1.2  # Make the geobox 20% larger (i.e. 10% margin each side)
		biz_geobox = LngLatBounds.from_geoms(points).scale(slop)
		mapsize = MapSize.from_name(d['mapsize'])
		new_zoomlevel, new_geobox, _ = \
			self.repllogic.SearchFrontEnd.zoom_map_to_include(mapsize, geo_box=biz_geobox,
									  zoomlevel=config.search.MAX_ZOOM_FOR_FIT_MAP_TO_RESULTS)

		# Must ensure that we only ever display areas of the map for which we have actually
		# searched over.  For this we check the containment with our new map geobox.
		if not new_geobox.inside_or_equals(geobox):
			return default

		# Create a new location by setting a new center and bounds on a copy of the original
		# location.  We can't rely upon the location returned by zoom_map_to_include as it will
		# be None if there isn't a mapping in the longitude_latitude_zipcode_id table.
		center = new_geobox.mid()
		new_location = dict(location)
		new_location['longitude'] = center.lng()
		new_location['latitude'] = center.lat()
		new_location['min_longitude'] = new_geobox.sw().lng()
		new_location['min_latitude'] = new_geobox.sw().lat()
		new_location['max_longitude'] = new_geobox.ne().lng()
		new_location['max_latitude'] = new_geobox.ne().lat()

		# Set the new map view.
		d['zoomlevel'] = new_zoomlevel
		d['longitude'] = new_location['longitude']
		d['latitude'] = new_location['latitude']

		return new_geobox, new_location

	@concierge_helpers.if_concierge_enabled(lambda: {'show': False})
	def _init_concierge(self, selected_categories, place_stats, query_to_category, location, geo_box):
		"""Retrieve all information needed to display concierge.

			Args:
			selected_categories - selected categories for search results
			query_to_category - A dict of category_id to statistics used to match query to cuisines
			location - The location of the search

		"""
		settings = {}

		# A dict mapping category alias to ctr, # of clicks, and category
		filtered_q2c = {}

		for category_id, stats in query_to_category.items():
			cat = self.logic.CategoryYelp._get_by_id(category_id)
			# cat may be None if the category is blacklisted in our country
			if cat:
				filtered_q2c[cat['alias']] = {'confidence': stats['percent_clicks'], 'category': cat, 'clicks': stats['num_nonname_clicks']}

		concierge_cuisine = concierge_helpers.relevant_cuisine(self.logic.CategoryYelp, selected_categories, filtered_q2c)

		settings['show'] = concierge_cuisine is not None

		if settings['show']:
			settings['address'] = location.get('address1', '')
			settings['city'] = location.get('city', '')
			settings['state'] = location.get('state', '')
			settings['flow'] = 'occasion' # the only flow we're using for now
			settings['cuisine'] = concierge_cuisine
			settings['top_cuisines'] = concierge_helpers.top_cuisines(self.logic, location)
			settings['cuisine_map'] = concierge_helpers.cuisine_map(concierge_cuisine, settings['top_cuisines'])

			settings['location_state'] = {
				'location': location,
				'geo_box': geo_box.to_json_param() if geo_box else None,
				'place_stats': place_stats
			}

		return settings

###
# END Misc. helper functions
###

	def _search(self, disable_redirect=False):
		"""Do the work of the search servlet.

		   Args:
			disable_redirect - disable country redirects (toronto to yelp.ca, etc)
		"""
		# Style note: I (jfennell) have inserted a bunch of double-newlines
		# between sections of this method that are somewhat functionally
		# independent.  This is not generally good style, but this method is such
		# a mess that the extra newlines are an attempt to begin the fight
		# against bit rot.  Please refactor bits into separate functions, or
		# simplify logic as you can.

		# use this alias for self.display so that we can
		# use the contents of self.display like regular variables
		#
		# For example: d['foo'] = ... rather than:
		#   foo = ...
		#   self.display['foo'] = foo
		label = {
			'hostname': socket.gethostname(),
			'unique_request_id': self.request.unique_request_id,
			'loggedin': bool(self.unauth_userid),
		}
		self.init_timing_checkpoints(label=label, log_name=config.search.SERVLET_TIMING_CHECKPOINTS_CLOG_NAME)

		self.search_attr_map, self.search_attr_group_map = self._build_attribute_and_group_info()

		d = self.display

		# Set up self.display and self.params from the form and cookies,
		# which also computes and returns the allowed set of display keys
		form_vars, allowed_display_vars = self._setup_display(disable_redirect=disable_redirect)

		update_user_latest_search(self.unique_visitor_id, (d['find_desc'], 'Yelp'))

		# fail fast if the user is beyond the paging limit
		# (the federator will throw this error as well, but why wait?)
		if d['pager']['maximum_depth'] < d['pager']['start'] + d['pager']['rpp']:
			raise errors.ExcessivePagingError

		# Do we have results yet?
		have_results = False
		# The location we query on (from find_loc or moved map)
		location = None
		# If we don't set all display variables before throwing
		# an exception we will delete user input.  This variable stores
		# any exceptions until all the display variables are set up.
		setup_exception = None

		spelling_result = {}
		list_search_results = {}
		message_board_search_results = {}
		backtracking_search = False

		# count the number of times the while loop repeats the search logic:
		num_searches_attempted = 0
		# these sum over all repetitions of the search logic:
		search_timing_info = {
			'list' : 0,
			'cathy' : 0,
			'lucy' : 0,
		}
		self.modified_query_history = {}

		# This while loop is used to frame the logical progression of query modifications
		# to be made to a query when we have no results.
		# CURRENT SPECIAL CASES:
		#	Try trimming location to a city tuple
		#	Try searching with DYM suggestion
		#
		# while we don't have results:
		#	prepare the query from the parameters
		#	run the query
		#
		#	if we have results:
		#		if we have changed internal params (ex. find_loc for trimming location):
		#			log changes and finalize display variables (like restore the original
		#				description and enable a display flag to say the results are for
		#				a description modified in x way)
		#		break
		#
		#	if don't have any results:
		#		# Roll back any failed attempts at changing parameters
		#		if we changed x:
		#			change x back to it's original value
		#		if we changed y:
		#			change y back to it's original value
		#
		#		# Try changing things
		#		if we haven't changed x:
		#			change x
		#			continue
		#		if we haven't changed y:
		#			change y
		#			continue
		#
		#		# Nothing else to try!
		#		break

		while not have_results:
			num_searches_attempted += 1

			d['description'], setup_exception = self._validate_description(d['find_desc'])

			# FIXME: Currently this means that we'll do a DYM query per each
			# backtracking iteration, even though that's not normally
			# necessary. However, the flow control logic here is fairly complex
			# which makes it difficult to fix, and at some point DYM will be
			# location-aware, making this necessary anyway.
			#
			# Start the dym query -- this runs in a separate thread
			dym_enabled = config.use_dym and self.features[config.feature_names.search_dym]
			if dym_enabled:
				# disable use_thread, since the threadpool will provide the thread for the call:
				dym_call = {
					'method': self.logic.did_you_mean,
					'args': [d['description']],
					'kwargs': {'language': self.language, 'use_thread': False},
					'without_database': True
				}
				dym_result_group = THREADPOOL.work({'dym': dym_call}, block=False)
			else:
				dym_result_group = None

			# Zoomlevel & geo_box should be redundant... that information should be in location....
			# if it is not accurate we should just update it to be accurate!
			#
			# Need to do this here because we are dependent on find_desc & thus the find_desc re-write
			# to do location parsing.  However, we should really only do this the first time around, hence
			# the conditional.
			self.set_timing_checkpoint('before_location_parsing')
			if not location:
				zoomlevel, geo_box, location = self._get_location_params(disable_redirect=disable_redirect)
			self.set_timing_checkpoint('after_location_parsing')

			# Return 0 results for non-scouts in stealth countries (where the geobox wouldn't be visible)
			if not localization.geo_box_is_visible(geo_box, from_country=self.country()):
				break


			self._setup_category_filters(d['description'], self.param['category_filters'])

			# Decide if we should suggest a category browse.  Also helps support category folding.
			d['category_yelp_correction'] = self._category_yelp_correction(d['description'])

			# Done setting up display parameters, so we can now raise an exception without obliviating user input
			if setup_exception is not None:
				raise setup_exception


			lucy_query, do_backtracking = self._construct_lucy_query(location)

			# Use the title of the category for list and message search if we have no description
			best_description = lucy_query.description()
			if (not d.get('description')) and d.get('selected_categories'):
				if d.get('selected_categories')[0] is not None:
					best_description = d.get('selected_categories')[0]['title']

			small_search_calls = {}
			business_search_call, backtracking_search = self._construct_business_search(lucy_query, geo_box, zoomlevel, do_backtracking)

			# Only run the following searches if this is not an autocorrected search and the search query is non empty
			if not d['show_autocorrected_results'] and d['find_desc']:
				if config.enable_list_in_search and self.features[config.feature_names.search_related_lists]:
					small_search_calls['list_search'] = {
						'method': self.repllogic.ListSearch.search,
						'args': (best_description, location['longitude'], location['latitude'], 0, 3, 'relevance'),
						'kwargs': {}
					}

				if config.enable_talk_in_search and self.features[config.feature_names.search_related_talk]:
					small_search_calls['message_search'] = {
						'method': self.repllogic.message_board_search,
						'args': (best_description, location, 'relevance', 0, config.search.MAX_MSGS_FROM_MSG_BOARDS, True),
						'kwargs': {}
					}

			# do all our logic!
			self.set_timing_checkpoint('before_logic')

			small_search_group = THREADPOOL.work(small_search_calls, block=False)

			time_after_smallsearch_start = self.set_timing_checkpoint('after_small_search_start')

			# do the business search on the main thread:
			search_results = {}
			search_method, args, kwargs = business_search_call
			business_search_result = search_method(*args, **kwargs)
			time_after_bizsearch = self.set_timing_checkpoint('after_business_search')

			search_results['business_search'] = {'result': business_search_result,
				'elapsed_time': time_after_bizsearch - time_after_smallsearch_start}

			# join on the threads doing the small searches:
			small_search_results = small_search_group.join()
			search_results.update(small_search_results)
			# we recover transparently from these failures, but we should log them as apperrors:
			for small_search_result in small_search_results.itervalues():
				exception = small_search_result.get('exception')
				if exception is not None:
					log.exception(exception)

			self.set_timing_checkpoint('after_logic')
			# logic complete!

			# Add in timing info as a list of execution times for each type of request
			search_timing_info['lucy'] += (time_after_bizsearch - time_after_smallsearch_start)

			self.set_timing_checkpoint('before_dym_join')
			if not d['show_autocorrected_results'] and d['find_desc']:
				spelling_result = None
				if dym_result_group is not None:
					#XXX three layers to unpack; the ThreadRequestGroup, the lserv wrapper, and the FakeThread
					response = dym_result_group.join()['dym']
					if 'result' in response:
						spelling_result = response['result'].result
					elif 'exception' in response:
						log.exception(response['exception'])
					else:
						log.error('Empty DYM response.')
				list_search_results = search_results.get('list_search', {})
				message_board_search_results = search_results.get('message_search', {})
				search_timing_info['list'] += list_search_results.get('elapsed_time', 0)
				search_timing_info['cathy'] += message_board_search_results.get('elapsed_time', 0)
			self.set_timing_checkpoint('after_dym_join')

			have_results = bool((backtracking_search and business_search_result[0]['business_list'])
				or (not backtracking_search and business_search_result['business_list']))

			# Re-written stuff used for
			# 1. Tracking between multiple loops
			# 2. Determine if a rewrite happened or not in the template
			# 3. For ranger logging
			# We may be able to store less info (did we rewrite or not?)
			# We definitely should not store in the *global* display dict :-P
			#
			#### This shit is HORRIFIC.  I think the correct way of doing things is to have all the
			# *above* code in the loop pulled out into a function, and then allow the function
			# to be run with different parameters depending on results from the first run
			#
			# Finalize display variables and bail if we have results
			if have_results:
				if d['show_autocorrected_results']:
					d['description'], d['find_desc'] = d['original_description'], d['original_find_desc']
				break

			# If we don't have results and we've already modified something set it back (if necessary)
			if d['shorten_location']:
				self.modified_query_history['shorten_location']['rewritten'] = False
				d['place_filters'] = d['original_place_filters']
				self.param['place_to_boost'] = self.param['original_place_to_boost']
			if d['show_autocorrected_results']:
				self.modified_query_history['show_autocorrected_results']['rewritten'] = False
				d['description'], d['find_desc'] = d['original_description'], d['original_find_desc']

			# Conditionally modify the search and re-run it
			# CASE: We have no results and can bubble out to city, rerun search with new location
			if not have_results and location['accuracy'] > yelp_lib.location.Accuracy.TOWN and not d['shorten_location']:
				log.debug('Re-trying search but at city-level accuracy')
				d['original_place_filters'] = d['place_filters']
				d['place_filters'] = []
				location = self.repllogic.Geocoder.parse_location(to_city(location), 'en', from_country=self.country())
				self.param['original_place_to_boost'] = self.param['place_to_boost']
				self.param['place_to_boost'] = to_place_key(location)
				d['shorten_location'] = True
				self.modified_query_history['shorten_location'] = {'attempted': True, 'rewritten': True}
				continue

			# CASE: We have no results and a dym suggestion, rerun search with suggested spelling
			if not have_results and spelling_result and not d['show_autocorrected_results']:
				# timr: only show french spelling suggestions if the user is in
				# the 'on' cohort for the DYM FR experiment.
				if (self.base_lang() != 'fr' or
					self.logic.Experiments.yuv_in_cohort(self.unique_visitor_id,
														 'say_bonjoor_to_dym_french', 'on')):
					log.debug("Re-trying search with DYM's suggested find_desc")
					d['original_description'], d['original_find_desc'] = d['description'], d['find_desc']
					d['find_desc'] = spelling_result
					d['show_autocorrected_results'] = True
					self.modified_query_history['show_autocorrected_results'] = {
						'attempted': True,
						'rewritten': True
						}
					continue

			# No results and no more options to try, reset and bail
			d['show_autocorrected_results'] = False
			d['shorten_location'] = False
			if 'show_autocorrected_results' in self.modified_query_history:
				self.modified_query_history['show_autocorrected_results']['rewritten'] = False
			if 'shorten_location' in self.modified_query_history:
				self.modified_query_history['shorten_location']['rewritten'] = False
			break


		# Finish off timing ("search_total" is a legacy name meaning "total time in search logic calls",
		# which is basically accurate)
		total_search_time = self.set_timing_checkpoint('after_while_loop')
		search_timing_info['search_total'] = total_search_time

		# rewritted_description/rewritten_find_loc is present if we've rewritten a query containing a preposition
		if d['rewritten_description'] or d['rewritten_find_loc']:
			self.modified_query_history['preposition'] = {'attempted': True, 'rewritten': True}

		# Handle the difference between backtracking and regular results
		if backtracking_search:
			reply, geo_box, d['zoomlevel'] = business_search_result
		else:
			reply = business_search_result

		geo_box, location = self._fit_map_to_results(reply, geo_box, location)

		self._strip_hidden_categories_for_country(reply)

		friends, follows = [], []
		if reply:
			# If we are showing suggested results then move the business list to the autocorrected_biz_list
			relevant_list = 'biz_list'
			if d['show_autocorrected_results']:
				d['autocorrected_biz_list'] = reply['business_list'][:config.search.NUM_AUTOCORRECTED_RESULTS]
				relevant_list = 'autocorrected_biz_list'
			else:
				d['pager']['total'] = int(reply['total'])
				fill_pagination(d['pager'])
				d['biz_list'] = reply['business_list']

			# Get friends and follows for friend/follow review count (pending we have results)
			self.show_friend_and_follow_review_count = self.unauth_userid and config.enable_reviews_by_friends_and_follows_in_search and len(d[relevant_list]) > 0
			if self.show_friend_and_follow_review_count:
				raw_user_id = decid(self.unauth_userid)
				# store friends and follows as unencrypted IDs, to save on crypto:
				friends = set(self.repllogic.User._list_friend_ids(self.repllogic.conns.primary.cursor(), raw_user_id))
				follows = set(self.repllogic.User._list_following_ids(self.repllogic.conns.primary.cursor(), raw_user_id))
			else:
				friends = follows = set()

			self._populate_biz_list(d[relevant_list])
			self._log_deals_impressions(d[relevant_list])
			self._add_friends_and_following(d[relevant_list], friends, follows)

			if lucy_query.explain():
				d['final_lucy_query'] = reply['final_lucy_query']

			# Don't show top-of-search-results DYM suggestion if there are any exact matches
			d['show_spelling_suggestion_at_top'] = not any(x['exact_name_match_to_query'] for x in reply['business_list'])


		# Populate display vars with dym result
		if spelling_result:
			# timr: don't show DYM results for french unless the user is in the 'on' cohort
			# for the DYM FR experiment
			if (self.base_lang() != 'fr' or
				self.logic.Experiments.yuv_in_cohort(self.unique_visitor_id,
													 'say_bonjoor_to_dym_french', 'on')):
				# Refactoring notes:
				# Why not d['spelling_suggestion'] = spelling_result or ''
				# Or do we even need it, since it is already defaulted to '' ?
				d['spelling_suggestion'] = spelling_result
			else:
				# record that a suggestion WOULD have been made, so that
				# we can log the event to ranger.
				d['ignored_fr_spelling_suggestion'] = spelling_result




		self._populate_list_results(list_search_results)
		self._populate_message_board_results(message_board_search_results)
		self._add_neighborhood_labels_and_polys(geo_box, zoomlevel)
		self.set_timing_checkpoint('before_fill_category_place_stats')
		self._fill_category_and_place_stats(reply, location, geo_box)
		self.set_timing_checkpoint('after_fill_category_place_stats')
		self._display_filters()

		d['concierge'].update(
			self._init_concierge(
				d['selected_categories'],
				reply.get('place_stats'),
				reply.get('q2c_boost', {}),
				location,
				geo_box
			)
		)

		# TODO (jfennell): These appear to be pretty much redundant in the
		# template... not sure why they are separated out.  Should combine into a
		# single method that gives a single value.
		d['show_filters'] = self._show_filters(d['biz_list'], d['sub_cats_for_browse'])
		d['show_filter_panel_at_all'] = self._show_filter_panel_at_all(d['biz_list'])

		# make hella money:
		msec_elapsed_before_ads = self.set_timing_checkpoint('before_ads')
		self._fill_ads_based_on_categories_and_results(reply, friends, follows, location, geo_box)
		msec_elapsed_after_ads = self.set_timing_checkpoint('after_ads')
		search_timing_info['ads'] = msec_elapsed_after_ads - msec_elapsed_before_ads

		# Fetch a parent category to pick the right custom channel in Adsense
		if reply['q2c_boost']:
			max_ctr_category_id = int(max(reply['q2c_boost'], key=lambda k: reply['q2c_boost'][k]['percent_clicks']))
			max_ctr_category = self.repllogic.CategoryYelp._get_by_id(max_ctr_category_id)
			d['adsense_category'] = self.repllogic.CategoryYelp.random_top_level_parent_alias([max_ctr_category])
		elif d['selected_categories']:
			d['adsense_category'] = self.repllogic.CategoryYelp.random_top_level_parent_alias(d['selected_categories'])

		top_cats, sub_cats = self._get_categories_for_tagging(d)

		# !TODO! consolidate different ways to disable google ads
		if self.request_features.is_feature_enabled(config.feature_names.google_ads):
			d['googlead_slots'] = ('Search_Sponsor_915x35',)
			d['show_googlead'], d['googlead_attrs'] = self.repllogic.GoogleAdManager.get_googlead_params(
				section='search', location=location, categories=list(top_cats), sub_categories=list(sub_cats),
				viewing_user_id=self.unauth_userid, in_cookies=self.request.cookies)

		# SEO optimization
		category = d['selected_categories'][0] if d.get('selected_categories') else None
		d.update(self.sitemap_link_info(location, category))
		self._prepare_and_add_seo_attributes(form_vars)

		# pull any extra info from the lucy reply
		d['ranger_extra_search_info'] = reply['ranger_extra_search_info']
		# and then add extra search info to ranger log
		ranger.request_info['extra']['search'] = self._ranger_extra_search_info(location, num_searches_attempted, search_timing_info)

		# log ad info
		# there's never more than one ad
		biz_ad = d.get('business_ads')


		if not form_vars['sample_biz_id'] and biz_ad and d.get('ad_type'):
			ranger.request_info['extra']['ads'] = [dict(biz_id=decid(biz_ad['business_id']), ad_type=d['ad_type'])]



		# check for display variables that aren't in _init_display_vars()
		### XXX: This shit doesn't work, for instance 'original_description' is not in init_display_vars, but it does get added to display in some cases :-P
		display_vars = set(d.keys())
		extra_display_vars = display_vars.difference(allowed_display_vars)
		if extra_display_vars:
			log.warn("These display variables should be added to _init_display_vars(): %r" % sorted(extra_display_vars))

		self.set_timing_checkpoint('display_filled')
