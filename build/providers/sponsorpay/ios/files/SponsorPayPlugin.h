#import "PluginManager.h"
#import "sponsorpay-sdk-lib/SponsorPaySDK.h"

/* @interface SponsorPayPlugin : GCPlugin<SPInterstitialClientDelegate, SPBrandEngageClientDelegate> */
@interface SponsorPayPlugin : GCPlugin<SPBrandEngageClientDelegate>

@property (nonatomic, retain) TeaLeafAppDelegate *appDelegate;
/* @property (nonatomic, retain) SPInterstitialClient *interstitialClient; */
@property (nonatomic, retain) SPBrandEngageClient *videoClient;

@end

