#import "PluginManager.h"
#import "SponsorPaySDK.h"
#import "SPOfferWallInterstitialViewController.h"

@interface SponsorPayPlugin : GCPlugin

@property (nonatomic, retain) TeaLeafAppDelegate *appDelegate;
@property (nonatomic, retain) NSString *credentialsToken;
@property (nonatomic, retain) SPOfferWallInterstitialViewController *vc;

@end

