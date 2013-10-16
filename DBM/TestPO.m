//
//  TestPO.m
//  DBM
//
//  Created by Baitian on 13-5-20.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "TestPO.h"

@implementation TestPO
@synthesize test_attr;

- (void)setValueWithDataArray:(NSArray*)data_array
{
    NSLog(@"data arr is %d length",[data_array count]);
    self.test_attr= [data_array objectAtIndex:0];
}
- (NSDictionary*)makeDataIntoArray
{
    NSMutableDictionary* data_list=[[[NSMutableDictionary alloc] init]autorelease];
    [self addobject:self.test_attr IntoDic:data_list forKey:@"test_attr"];
    return data_list;
}

- (void)dealloc
{
    [test_attr release];
    [super dealloc];
}
@end
