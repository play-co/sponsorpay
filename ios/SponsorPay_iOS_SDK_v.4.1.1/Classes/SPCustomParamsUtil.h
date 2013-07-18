//
//  SPCustomParamsUtil.h
//  SponsorPaySample
//
//  Created by David on 9/14/12.
//  Copyright (c) 2012 SponsorPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPURLGenerator.h"

@interface SPCustomParamsUtil : NSObject <SPURLParametersProvider> {

    NSMutableArray *keysArray;
    NSMutableDictionary *paramsDictionary;
}

@property (nonatomic, retain) NSMutableArray *keysArray;
@property (nonatomic, retain) NSMutableDictionary *paramsDictionary;

-(void)addValue:(NSString *)value forKey:(NSString *)key ;

-(void)removeObjectForKey:(NSString *)key ;

-(NSString *)objectAtIndex:(int)index ;

-(NSString *)keyAtIndex:(int)index ;

-(void)removeObjectForIndex:(NSUInteger)index;

-(NSString *)objectDescriptionForIndex:(int)index;

@end
