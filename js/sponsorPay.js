var SponsorPay = Class(function () {
	this.showInterstitial = function () {
		logger.log("{sponsorPay} Showing interstitial");

		if (NATIVE && NATIVE.plugins && NATIVE.plugins.sendEvent) {
			NATIVE.plugins.sendEvent("SponsorPayPlugin", "showInterstitial",
				JSON.stringify({}));
		}
	};
});

exports = new SponsorPay();
