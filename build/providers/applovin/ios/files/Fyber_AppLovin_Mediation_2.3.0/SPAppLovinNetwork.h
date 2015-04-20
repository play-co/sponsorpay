//
//  SPProviderAppLovin.h
//
//  Copyright (c) 2014 Fyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPBaseNetwork.h"

/**
 Network class in charge of integrating AppLovin library
 
 ## Version compatibility
 
 - Adapter version: 2.3.0
 - Fyber SDK version: 7.0.3
 - AppLovin SDK version: 2.5.4
 
 */

@class ALSdkSettings;

@interface SPAppLovinNetwork : SPBaseNetwork

@property (nonatomic, copy, readonly) NSString *apiKey;
@property (nonatomic, strong) ALSdkSettings *alSDKSettings;

@end
