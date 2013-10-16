//
//  usr_UnitPO.m
//  DBM
//
//  Created by Baitian on 13-5-14.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "usr_UnitPO.h"

@implementation usr_UnitPO
@synthesize m_CurrentUnitIndex,m_PassedTime,m_UnitGrade,m_UnitID,m_PassedCount,m_UnitStatus;

- (void)setValueWithDataArray:(NSArray *)data_array
{
    NSLog(@"data arr is %d length",[data_array count]);
    self.m_UnitID= [data_array objectAtIndex:0];
    self.m_UnitStatus= [data_array objectAtIndex:1];
    self.m_UnitGrade= [data_array objectAtIndex:2];
    self.m_CurrentUnitIndex= [data_array objectAtIndex:3];
    self.m_PassedCount= [data_array objectAtIndex:4];
    self.m_PassedTime= [data_array objectAtIndex:5];
}


-(NSDictionary *)makeDataIntoArray
{
    //make data into map
    NSMutableDictionary* data_list=[[[NSMutableDictionary alloc] init]autorelease];

    [self addobject:self.m_UnitID IntoDic:data_list forKey:@"UnitID"];
    [self addobject:self.m_UnitGrade IntoDic:data_list forKey:@"UnitGrade"];
    [self addobject:self.m_UnitStatus IntoDic:data_list forKey:@"UnitStatus"];
    [self addobject:self.m_CurrentUnitIndex IntoDic:data_list forKey:@"CurrentUnitIndex"];
    [self addobject:self.m_PassedTime IntoDic:data_list forKey:@"PassedTime"];
    [self addobject:self.m_PassedCount IntoDic:data_list forKey:@"PassedCount"];
   
    return data_list;
}
- (void)dealloc
{
    [m_UnitID release];
    [m_UnitStatus release];
    [m_UnitGrade release];
    [m_CurrentUnitIndex release];
    [m_PassedCount release];
    [m_PassedTime release];
    [super dealloc];
}
@end
