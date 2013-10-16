//
//  BasePO.m
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import "BasePO.h"

@implementation BasePO
@synthesize childrenClassKey;
- (void)addobject:(NSObject*)target_obj IntoDic:(NSMutableDictionary*)data_list forKey:(NSString*)key
{
    if (!target_obj) {
        [data_list setObject:[NSNumber numberWithInt:-1] forKey:key];
    }
    else
        [data_list setObject:target_obj forKey:key];
}

- (void)dealloc
{
    [childrenClassKey release];
    [super dealloc];
}
@end
