from biz_cmds.coming_soon import BusinessComingSoonURI
from biz_cmds.support import SupportURI, SupportSectionURI
from cmds._cmd import StdCmd
from cmds._request_mapper import And
from cmds._request_mapper import GET
from cmds._request_mapper import Path
from cmds._request_mapper import RequestMapper
from util.uri import full_biz

class business(StdCmd, RequestMapper):

	def rules(self):
		return (
			(And(GET(), Path(r'^$')), self.default),
			(And(GET(), Path(r'^unlocking/?$')), self.unlocking),
			(And(GET(), Path(r'^using_yelp/?$')), self.using_yelp),
			(And(GET(), Path(r'^review_response/?$')), self.review_response),
			(And(GET(), Path(r'^common_questions/?$')), self.common_questions),
			(And(GET(), Path(r'^advertising/?$')), self.advertising),
		)

	def servlet_init(self, *args, **kwargs):
		super(business, self).servlet_init(*args, **kwargs)

		if not self.features['biz_site.active']:
			self.external_redirect_url(full_biz(BusinessComingSoonURI.uri(), country=self.country()))

		self.set_country_from_form_and_maybe_redirect()

	def default(self):
		return self.external_redirect_url(full_biz(SupportURI.uri(), country=self.country_from_hostname()))

	def unlocking(self):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('unlocking'), country=self.country_from_hostname()))

	def using_yelp(self):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('using_business_account'), country=self.country_from_hostname()))

	def review_response(self):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('responding_to_reviews'), country=self.country_from_hostname()))

	def common_questions(self):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('common_questions'), country=self.country_from_hostname()))

	def advertising(self):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('advertising'), country=self.country_from_hostname()))
