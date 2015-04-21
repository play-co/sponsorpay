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
and `sponsorPaySecurityToken` as shown below. You will likely need
other changes for each additional provider you select - see the
`Pre-Integrated Providers` section below for details.

#### Manifest.json
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

You must add all of the providers you wish to bundle with your application
to the `addons.sponsorpay.<PLATFORM>.providers` lists or they will not be
included in the build and you will not be able to use them in your game.
~~~
"addons": {
    "sponsorpay": {
        "android": {
            "providers": [
                "unityAds"
            ]
        },
        "ios": {
            "providers": [
                "unityAds"
            ]
        }
    }
}
~~~

See the `Pre-Integrated Providers` section below for a list of working
providers you can add to these list.

Note that the manifest keys are case-sensitive.

#### adapters.config

Sponsorpay/Fyber uses a local config file (`adapters.config`) to
set up additional providers on android. You will need to download the
default adapters.config file for Fyber/SponsorPay version 7.1.0 and enter your
credentials for all of the providers you may wish to use. Put this file in
your application's `src` folder.

Unlike a standard Fyber integration, this plugin will automatically
choose the correct parts of the adapter files and only use those
you specify in your manifest, so you can include all of your accounts and not
worry about it breaking your build if you add/remove a key in your config.


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


## Pre-Integrated Providers

The Fyber/SponsorPay plugin comes with several ad providers already
available in order to make using the plugin as easy as possible.

Adding one of the included providers is usually as easy as adding
the provider name to the manifest `addons.sponsorpay.[platform].providers`
list and adding any necessary SDK keys. The SponsorPay module will
use the providers list to automatically create all of your configuration

For android builds, ensure you have properly included and filled out the
`adapters.config` file in your application's `src` folder (see the `setup`
section above for more details).


#### UnityAds
1. Add `unityAds` to the `manifest.addons.sponsorpay.<PLATFORM>.providers` lists
   in your manifest.
1. Enter your UnityAds credentials in `adapters.config`.

#### AppLovin
1. Add `applovin` to the `manifest.addons.sponsorpay.<PLATFORM>.providers` lists
   in your manifest.
1. Add the `android.appLovinSdkID` fields to your manifest with the AppLovin
   SDK ID from the applovin dashboard.


## Integrating Additional Providers

If your desired provider has not been added to the plugin, you'll need to
manually add all of the files and configuration to the correct locations in
the build/providers/provider name folder.

EXTREMELY IMPORTANT - the auto-configuration being done for providers means
the standard android and ios folders are deleted before build every time and
created as necessary. DO NOT PUT FILES YOU NEED IN THESE FOLDERS (or check out
a previous version of the plugin).

You will likely need a combination of config.json, manifest.xml, manifest.xsl,
adapters.config, adapters.info, and various file changes to create a working
integration. Follow the existing integrations as a guide and consider
contributing your successful integrations back to the project so others
can use that provider without additional work.



## Important Notes
The iOS fyber/sponsorpay sdk requires the `-ObjC` linker flag added to your
xcode project. This is done automatically by the module, but be aware of how
it may change your application. [Read more](https://developer.apple.com/library/mac/qa/qa1490/_index.html).

This requires the latest devkit-core (v2.4.0 or later) to correctly set linker
flags and move files into the correct places. If you cannot update your
devkit-core, you can manually add the `-ObjC` flag and move files into your
android build folder and xcode project, but be aware of the build process
overwriting your changes on new builds.


## Creating Integration Documentation for Manual Integrations
Integrating each network provider can be a little hairy (adding Unity to iOS
involved a few more steps than the Fyber or Unity docs included), so detailed
start-to-finish integration docs for each network would be fantastic.


## Demo Application
Check out the [demo application](https://github.com/gameclosure/demoSponsorpay)
for a full implementation.
