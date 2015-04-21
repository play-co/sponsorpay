# Unity Ads (formerly Applifier)  - adapter info

***<font color='red'>This is recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Unity Ads | 2.4.3 | 1.3.10 | 7.0.3 + |

## Migration guide from Fyber SDK 6.x to 7.x

After migration to Fyber SDK 7.x, the `name` parameter should be set to `Applifier` instead of `UnityAds`. The minimum recommended adapter version for Fyber SDK 7.x is **2.3.1**.

## Example parameters

* **name**: `Applifier`
* **settings**:
	* **SPUnityAdsGameId**
	* **SPUnityAdsInterstitialZoneId**
	* **SPUnityAdsRewardedVideoZoneId**
	
## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
         
## Required linker flags

_none_