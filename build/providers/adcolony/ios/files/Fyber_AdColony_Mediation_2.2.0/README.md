# AdColony  - adapter info

***<font color='red'>This is a recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| AdColony | 2.2.0 | 2.5.0 | 7.0.3 + |

**Important:** *The AdColony SDK supports iOS 6 or higher.*

## Example parameters

* **name**: `AdColony`
* **settings**:
	* **SPAdColonyAppId**
	* **SPAdColonyInterstitialZoneId**
	* **SPAdColonyV4VCZoneId**
	
## Required frameworks

* `libz.1.2.5.dylib`
* `AdColony.framework`
* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CoreGraphics.framework`
* `CoreMedia.framework`
* `CoreTelephony.framework`
* `EventKit.framework`
* `EventKitUI.framework`
* `MediaPlayer.framework`
* `MessageUI.framework`
* `QuartzCore.framework`
* `Social.framework` (Mark as Optional to support < iOS 6.0)
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
* `WebKit.framework` (Mark as Optional to support < iOS 8.0)
        
## Required linker flags
*  `ObjC`
*  `objc-arc`