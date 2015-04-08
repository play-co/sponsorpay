# Game Closure DevKit Module: SponsorPay / Fyber


This module allows you to display video ads from the
[Fyber](https://fyber.com)/SponsorPay mediation service.

Both iOS and Android targets are supported.

NOTE: requires devkit-core v2.4.0 or later


## Installation

Install the module into your application using the standard
devkit install process.

~~~
devkit install https://github.com/gameclosure/sponsorpay
~~~

## Setup

Before you can use SponsorPay/Fyber you must specify your game's
Fyber App ID and Security Token from the Fyber dashboard. Edit the
`manifest.json` "android" and "ios" sections to include `sponsorPayAppID`
and `sponsorPaySecurityToken` as shown below.

~~~
  "android": {
    "sponsorPayAppID": "15085",
    "sponsorPaySecurityToken": "3bd0293059760d7da1e957ea29e61211"
  },
~~~

~~~
  "ios": {
    "sponsorPayAppID": "15085",
    "sponsorPaySecurityToken": "3bd0293059760d7da1e957ea29e61211"
  },
~~~

Note that the manifest keys are case-sensitive.


## Usage

To start using SponsorPay/Fyber in your game, first import the sponsorPay
object:

~~~
import sponsorpay;
~~~

You should initialize the module before any other functions.

~~~
sponsorpay.initializeSponsorPay();
~~~

If you want fyber/sponsorpay to track users, you can initialize sponsorpay
with an object with userId as a property:

~~~
sponsorpay.initializeSponsorPay({
  userId: 'xyz'
});
~~~

After initialization, sponsorpay will emit an `Initialized` event. Any time
after initialization you can tell Sponsorpay/Fyber to cache a video from
one of the ad providers. Listen for the `VideoAvailable` event to be notified
when a video ad is available, at which point call `sponsorpay.showVideo()` to
display it.

This is an overly simple example. Check out the [demo
application](https://github.com/gameclosure/demoSponsorpay) for a full
implementation.

~~~
// if a video is available, show it immediately
sponsorpay.on('VideoAvailable', function () {
  sponsorpay.showVideo();
});

// try to cache a video
sponsorpay.cacheVideo();
~~~

Note: fyber suggests caching videos close to where you are going to display it
to the user in order to give the ad providers enough time to fully initialize.


####Methods
`sponsorpay.initializeSponsorPay`
`sponsorpay.cacheVideo`
`sponsorpay.showVideo`


####Events
`Initialized`
`VideoAvailable`
`VideoNotAvailable`
`VideoError`
`VideoCompleted`


## Integrating Additional Providers
When integrating additional ad providers, first follow the instructions on the
Fyber and Ad Provider website to properly set up the necessary information for
your application. Next, follow the instructions below to get devkit to
include the necessary files in your build process.

For now, integrating additional networks requires manually changing the
config.json files inside the android and ios folders in your sponsorpay plugin
folder itself.

The [project wiki](https://github.com/gameclosure/sponsorpay/wiki) includes
instructions for setting up various additional providers.

This has been tested with the UnityAds integration for both Android and iOS.
Other providers may require additional steps.

###Android
- If you are using customized `adapters.config` and `adapters.info`, add
them to your application's `src` folder.
- Add any .jar files to the sponsorpay/android folder.

- Edit sponsorpay/android/config.json:
  - Add any .jar files to the "jars" list.
  - Add `adapters.config` and `adapters.info` to the `copyGameFiles` list
  if you are using them.

###iOS
- Add any .bundle and .framework files to the sponsorpay/ios folder.
- Add the network adaptors to the sponsorpay/ios folder.

- Edit sponsorpay/ios/config.json
  - Add .framework files to the "frameworks" list.
  - Add .bundle files to the "resources" list.
  - Add each of the mentioned .m and .h files from the instructions to the
  "code" list. NOTE: if the code must have ARC enabled (like Unity, for
  example), add the files to the `arccode` list *instead of* the `code` list.
  - If the framework you are integrating requires additional linker flags, add
  them to the `additionalLinkerFlags` list (can be a string if there is just
  one).
  - If the framework you are integrating requires additional frameworks,
  add them to the "frameworks" list (NOTE: sometimes this is undocumented -
  for example, Unity required CoreMedia)



## Important Notes
The iOS fyber/sponsorpay sdk requires the `-ObjC` linker flag added to your
xcode project. This is done automatically by the module, but be aware of how
it may change your application. [Read more](https://developer.apple.com/library/mac/qa/qa1490/_index.html).

This requires the latest devkit-core (v2.4.0 or later) to correctly set linker
flags and move files into the correct places. If you cannot update your
devkit-core, you can manually add the `-ObjC` flag and move files into your
android build folder and xcode project, but be aware of the build process
overwriting your changes on new builds.


## Creating Integration Documentation
Integrating each network provider can be a little hairy (adding Unity to iOS
involved a few more steps than the Fyber or Unity docs included), so detailed
start-to-finish integration docs for each network would be fantastic.


## Demo Application
Check out the [demo application](https://github.com/gameclosure/demoSponsorpay)
for a full implementation.
