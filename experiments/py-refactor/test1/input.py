from biz_cmds.coming_soon import BusinessComingSoonURI
from biz_cmds.support import SupportURI, SupportSectionURI
from cmds._action_mapper import ActionMapper
from cmds._action_mapper import expose
from cmds._cmd import StdCmd
from util.uri import full_biz

class business(StdCmd, ActionMapper):

	def execute(self):
		if not self.features['biz_site.active']:
			self.external_redirect_url(full_biz(BusinessComingSoonURI.uri(), country=self.country()))

		self.set_country_from_form_and_maybe_redirect()
		return self._consume_action()

	@expose
	def default(self, *qargs):
		return self.external_redirect_url(full_biz(SupportURI.uri(), country=self.country_from_hostname()))

	@expose
	def unlocking(self, *args):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('unlocking'), country=self.country_from_hostname()))

	@expose
	def using_yelp(self, *args):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('using_business_account'), country=self.country_from_hostname()))

	@expose
	def review_response(self, *args):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('responding_to_reviews'), country=self.country_from_hostname()))

	@expose
	def common_questions(self, *args):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('common_questions'), country=self.country_from_hostname()))

	@expose
	def advertising(self, *args):
		return self.external_redirect_url(full_biz(SupportSectionURI.uri('advertising'), country=self.country_from_hostname()))
