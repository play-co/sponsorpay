# Game Closure DevKit Plugin: SponsorPay

This plugin allows you to collect analytics using the [SponsorPay](https://sponsorpay.com/) toolkit.  Both iOS and Android targets are supported.

## Usage

Create a test application on the [SponsorPay](https://sponsorpay.com/) website for iOS or Android and copy down the App ID and Security Token.

Install the addon with `basil install sponsorpay`.

Include it in the `manifest.json` file under the "addons" section for your game:

~~~
"addons": [
	"sponsorpay"
],
~~~

To specify your game's App ID and security token, edit the `manifest.json "android" and "ios" sections as shown below:

~~~
	"android": {
		"versionCode": 1,
		"icons": {
			"36": "resources/icons/android36.png",
			"48": "resources/icons/android48.png",
			"72": "resources/icons/android72.png",
			"96": "resources/icons/android96.png"
		},
		"sponsorPayAppID": "15085",
		"sponsorPaySecurityToken": "3bd0293059760d7da1e957ea29e61211"
	},
~~~

~~~
	"ios": {
		"bundleID": "mmp",
		"appleID": "568975017",
		"version": "1.0.3",
		"icons": {
			"57": "resources/images/promo/icon57.png",
			"72": "resources/images/promo/icon72.png",
			"114": "resources/images/promo/icon114.png",
			"144": "resources/images/promo/icon144.png"
		},
		"sponsorPayAppID": "15085",
		"sponsorPaySecurityToken": "3bd0293059760d7da1e957ea29e61211"
	},
~~~

Note that the manifest keys are case-sensitive.

Then you can edit your game JavaScript code to import the SponsorPay object:

~~~
import plugins.sponsorpay.sponsorPay as sponsorPay;
~~~

And use the `showInterstitial` method to show an ad:

~~~
sponsorPay.showInterstitial();
~~~
