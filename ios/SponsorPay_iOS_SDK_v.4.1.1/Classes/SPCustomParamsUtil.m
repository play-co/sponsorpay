//
//  SPCustomParamsUtil.m
//  SponsorPaySample
//
//  Created by David on 9/14/12.
//  Copyright (c) 2012 SponsorPay. All rights reserved.
//

#import "SPCustomParamsUtil.h"

@implementation SPCustomParamsUtil

@synthesize keysArray;
@synthesize paramsDictionary;


-(NSMutableArray *)keysArray
{
    if(!keysArray) {
        keysArray = [[NSMutableArray alloc] init];
    }
    return keysArray;
}

-(NSMutableDictionary *)paramsDictionary
{
    if (!paramsDictionary) {
        paramsDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return paramsDictionary;
}

-(void)addValue:(NSString *)value forKey:(NSString *)key {
    if (![self.paramsDictionary valueForKey:key]) {
        [keysArray addObject:key];
    }
    [self.paramsDictionary setValue:value forKey:key];
}

-(void)removeObjectForKey:(NSString *)key {
    if([self.paramsDictionary valueForKey:key]) {
        [self.keysArray removeObject:key];
        [self.paramsDictionary removeObjectForKey:key];
    }
}

-(void)removeObjectForIndex:(NSUInteger)index
{
    if([keysArray count] >= index+1 ) {
        [paramsDictionary removeObjectForKey:[keysArray objectAtIndex:index]];
        [keysArray removeObjectAtIndex:index];
    }
}

-(NSString *)objectDescriptionForIndex:(int)index
{
    NSString *description = @"";
    if([keysArray count] >= index+1 ) {
        NSString *key = [keysArray objectAtIndex:index];
        NSString *value = [paramsDictionary objectForKey:key];
        description = [NSString stringWithFormat:@"%@ - %@", key, value];
    }
    return description;
}

-(NSString *)objectAtIndex:(int)index {
    return [self.paramsDictionary objectForKey:[keysArray objectAtIndex:index]];
}

-(NSString *)keyAtIndex:(int)index {
    return [self.keysArray objectAtIndex:index];
}

-(NSDictionary *)dictionaryWithKeyValueParameters
{
    return [NSDictionary dictionaryWithDictionary:paramsDictionary];
}

-(void) dealloc {
    self.keysArray = nil;
    self.paramsDictionary = nil;
    [super dealloc];
}

@end
