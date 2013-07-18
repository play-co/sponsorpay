#import "SponsorPayPlugin.h"
#include "iosVersioning.h"

@implementation SponsorPayPlugin

// The plugin must call super dealloc.
- (void) dealloc {
	self.appDelegate = nil;
	self.credentialsToken = nil;
	self.vc = nil;

	[super dealloc];
}

// The plugin must call super init.
- (id) init {
	self = [super init];
	if (!self) {
		return nil;
	}

	self.appDelegate = nil;
	self.credentialsToken = nil;
	self.vc = nil;

	return self;
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
	self.appDelegate = appDelegate;
	
	@try {
		NSDictionary *ios = [manifest valueForKey:@"ios"];
		NSString *sponsorPayAppID = [ios valueForKey:@"sponsorPayAppID"];
		NSString *sponsorPaySecurityToken = [ios valueForKey:@"sponsorPaySecurityToken"];

		NSLog(@"{sponsorPay} Initializing with manifest sponsorPayAppID: '%@'", sponsorPayAppID);

		self.credentialsToken = [SponsorPaySDK startForAppId:sponsorPayAppID
													  userId:nil
											   securityToken:sponsorPaySecurityToken];
	}
	@catch (NSException *exception) {
		NSLog(@"{sponsorPay} Failure to get ios:sponsorPay keys from manifest file: %@", exception);
	}
}

- (void) showInterstitial:(NSDictionary *)jsonObject {
	@try {
		if (!self.vc) {
			self.vc = [[[SPOfferWallInterstitialViewController alloc] initWithNibName:nil bundle:nil] autorelease];
			self.vc.lastCredentialsToken = self.credentialsToken;
			self.vc.appDelegate = self.appDelegate;
		}

		UIWindow *window = self.appDelegate.window;
		
		if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
			[self.appDelegate.tealeafViewController.view removeFromSuperview];

			[window addSubview:self.vc.view];
		} else {
			[window setRootViewController:self.vc];
		}

		[SponsorPaySDK showOfferWallWithParentViewController:self.vc];
	}
	@catch (NSException *exception) {
		NSLog(@"{sponsorPay} Failure during interstitial: %@", exception);
	}
}

@end
