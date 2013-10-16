//
//  UnitDAO.m
//  DBM
//
//  Created by Baitian on 13-5-14.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "UnitDAO.h"

@implementation UnitDAO
- (NSArray *)test
{
//    return [self getResultBySql:@"SELECT * FROM usr_Unit WHERE UnitID in (1,2)" fromTable:@"usr_Unit"];
    usr_UnitPO* test_obj=[[usr_UnitPO alloc]init];
    [test_obj setM_CurrentUnitIndex:[NSNumber numberWithInt:13]];
    [test_obj setM_UnitID:[NSNumber numberWithInt:1]];
    [test_obj setM_UnitStatus:[NSNumber numberWithInt:1]];
    [test_obj setM_UnitGrade:[NSNumber numberWithInt:1]];
    [test_obj setM_PassedCount:[NSNumber numberWithInt:1]];
//    [self updateObject:test_obj forTable:@"usr_Unit"];
//    [self deleteObject:test_obj fromTable:@"usr_Unit"];
    [self insertObject:test_obj intoTable:@"usr_Unit"];
    return nil;
    
}
- (NSArray *)test2
{
    TestPO* test=[[TestPO alloc]init];
    [test setTest_attr:@"test_test_test"];
    return [self getObjectByExample:test fromTable:@"Test"];
}
- (void)dealloc
{
    [super dealloc];
}
@end
