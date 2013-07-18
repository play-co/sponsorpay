//
//  OfferWallInterstitialViewController.m
//  SponsorPaySample
//
//  Created by David Davila on 1/14/13.
//  Copyright (c) 2013 SponsorPay. All rights reserved.
//

#import "SPOfferWallInterstitialViewController.h"
#import "iosVersioning.h"

static NSString *const SPPersistedBackgroundURLKey = @"SPPersistedBackgroundURLKey";
static NSString *const SPPersistedSkinNameKey = @"SPPersistedSkinNameKey";
static NSString *const SPPersistedCloseOnFinishKey = @"SPPersistedCloseOnFinishKey";


@interface SPOfferWallInterstitialViewController ()

//@property (retain) SPOfferWallViewController *offerWallViewController;
//@property (retain) SPInterstitialViewController *interstitialViewController;

//@property (readonly, nonatomic) SPCustomParamsUtil *additionalParameters;

@end

@implementation SPOfferWallInterstitialViewController {
//    SPCustomParamsUtil *_additionalParameters;
    CGRect _parametersGroupFrame;
    CGRect _launchOfferWallButtonFrame;
    CGRect _interstitialGroupFrame;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.lastCredentialsToken = nil;
		self.appDelegate = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _parametersGroupFrame = self.parametersGroup.frame;
    _launchOfferWallButtonFrame = self.launchOfferWallButton.frame;
    _interstitialGroupFrame = self.interstitialGroup.frame;
    [self restorePersistedUserEnteredValues];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustUIToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void)viewWillDisappear:(BOOL)animated // TODO: move up
{
    [self persistUserEnteredValues];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - OfferWall

- (IBAction)launchOfferWall
{
    @try {
        SPOfferWallViewController *offerWallVC =
        [SponsorPaySDK offerWallViewControllerForCredentials:self.lastCredentialsToken];
        offerWallVC.delegate = self;
        offerWallVC.shouldFinishOnRedirect = self.closeOnFinishSwitch.on;
        [offerWallVC showOfferWallWithParentViewController:self];
    } @catch (NSException *exception) {
		[SPLogger log:@"Exception: %@", exception];
    }
}

- (void)offerWallViewController:(SPOfferWallViewController *)offerwallVC
           isFinishedWithStatus:(int)status {
	[SPLogger log:@"Did receive SPOfferWallViewController callback with status: %@", status];

	UIWindow *window = self.appDelegate.window;
	
	if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
		[self.view removeFromSuperview];

		[window addSubview:self.appDelegate.tealeafViewController.view];
	} else {
		[window setRootViewController:self.appDelegate.tealeafViewController];
	}
}

#pragma mark - Interstitial

- (IBAction)launchInterstitial
{
    @try {
        SPInterstitialViewController *interstitialVC =
        [SponsorPaySDK interstitialViewControllerForCredentials:self.lastCredentialsToken];
        interstitialVC.backgroundImageUrl = self.backgroundURLField.text;
        interstitialVC.skin = self.skinNameField.text;
        interstitialVC.delegate = self;
        interstitialVC.shouldFinishOnRedirect = self.closeOnFinishSwitch.on;

        [interstitialVC startLoadingWithParentViewController:self];
    } @catch (NSException *exception) {
		[SPLogger log:@"Exception: %@", exception];
    }
}

- (void)interstitialViewController:(SPInterstitialViewController *)interstitialVC
                   didChangeStatus:(SPInterstitialViewControllerStatus)status {
    
    NSString *statusAsString;
    
    switch (status) {
        case AD_SHOWN:
            statusAsString = @"AD_SHOWN";
            break;
        case NO_INTERSTITIAL_AVAILABLE:
            statusAsString = @"NO_INTERSTITIAL_AVAILABLE";
            break;
        case ERROR_NETWORK:
            statusAsString = @"ERROR_NETWORK";
            break;
        case ERROR_TIMEOUT:
            statusAsString = @"ERROR_TIMEOUT";
            break;
        case CLOSED:
            statusAsString = @"CLOSED";
            break;
    }

    [SPLogger log:@"Did receive InterstitialViewController callback with status %@", statusAsString];
}

#pragma mark -

- (void)persistUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:self.backgroundURLField.text forKey:SPPersistedBackgroundURLKey];
    [defaults setValue:self.skinNameField.text forKey:SPPersistedSkinNameKey];
    [defaults setBool:self.closeOnFinishSwitch.on forKey:SPPersistedCloseOnFinishKey];
    [defaults synchronize];
}

- (void)restorePersistedUserEnteredValues
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.backgroundURLField.text = [defaults valueForKey:SPPersistedBackgroundURLKey];
    self.skinNameField.text = [defaults valueForKey:SPPersistedSkinNameKey];
    self.closeOnFinishSwitch.on = [defaults boolForKey:SPPersistedCloseOnFinishKey];
}

- (void)adjustUIToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    static const CGFloat halfMargin = 2;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        CGRect leftBlock = self.parametersGroup.frame;
        leftBlock.origin.x = halfMargin * 2;
        leftBlock.size.width = (self.view.frame.size.width / 2) - (3 * halfMargin);
        self.parametersGroup.frame = leftBlock;
        
        CGRect launchOFWBlock = self.launchOfferWallButton.frame;
        launchOFWBlock.origin.x = leftBlock.origin.x;
        launchOFWBlock.origin.y = leftBlock.origin.y + leftBlock.size.height + 2 * halfMargin;
        launchOFWBlock.size.width = leftBlock.size.width;
        self.launchOfferWallButton.frame = launchOFWBlock;
        
        CGRect rightBlock = self.interstitialGroup.frame;
        rightBlock.size.width = leftBlock.size.width;
        rightBlock.origin.y = leftBlock.origin.y;
        rightBlock.origin.x = leftBlock.origin.x + leftBlock.size.width + 2 * halfMargin;
        self.interstitialGroup.frame = rightBlock;
    } else {
        self.parametersGroup.frame = _parametersGroupFrame;
        self.launchOfferWallButton.frame = _launchOfferWallButtonFrame;
        self.interstitialGroup.frame = _interstitialGroupFrame;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self adjustUIToInterfaceOrientation:toInterfaceOrientation];
}

- (void)dealloc
{
    [_backgroundURLField release];
    [_skinNameField release];
    [_closeOnFinishSwitch release];
    [_parametersGroup release];
    [_launchOfferWallButton release];
    [_interstitialGroup release];
	self.lastCredentialsToken = nil;
	self.appDelegate = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setBackgroundURLField:nil];
    [self setSkinNameField:nil];
    [self setCloseOnFinishSwitch:nil];
    [self setParametersGroup:nil];
    [self setLaunchOfferWallButton:nil];
    [self setInterstitialGroup:nil];
    [super viewDidUnload];
}

@end
