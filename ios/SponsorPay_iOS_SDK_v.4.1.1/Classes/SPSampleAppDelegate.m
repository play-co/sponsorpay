//
//  SPPublishAppDelegate.m
//  SponsorPay iOS Test App
//
//  Copyright 2011 SponsorPay. All rights reserved.
//

#import "SPSampleAppDelegate.h"
#import "SPAdvertiserManager.h"
#import "SPLogger.h"

@implementation SPSampleAppDelegate

#pragma mark - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SPLogger defaultLogger].shouldOutputToSystemLog = YES;
    [SPLogger defaultLogger].shouldBufferLogMessages = YES;
    
    self.window.rootViewController = self.viewController; // TODO clean this up
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Shared among controllers

// TODO move this to SPTestAppBaseViewController

- (void)showSDKException:(NSException *)exception {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"The SDK threw an exception"
                                                     message:exception.reason
                                                    delegate:self cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil] autorelease];
    [alert show];
}

#pragma mark - Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{

}

- (void)dealloc
{
    self.viewController = nil;
    self.window = nil;
    [super dealloc];
}

@end
