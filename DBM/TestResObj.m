//
//  TestResObj.m
//  DBM
//
//  Created by Baitian on 13-5-23.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "TestResObj.h"

@implementation TestResObj
@synthesize data_str;
- (void)dealloc
{
    [data_str release];
    [super dealloc];
}
@end
