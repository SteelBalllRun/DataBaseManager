//
//  RecordObject.m
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "RecordObject.h"
#import "RecordObject+Friend.h"
@implementation RecordObject
@synthesize m_data=_m_data;
@synthesize hasCompleteSave=_hasCompleteSave;
- (NSData *)data
{
    NSData* data=[NSKeyedArchiver archivedDataWithRootObject:m_data];
    return data;
}

+(RecordObject *)memontoWithData:(NSData *)data
{
    id<RecordObjDelegate> restored_record=(id<RecordObjDelegate>)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    RecordObject* memento=[[[RecordObject alloc]initWithSomeData:restored_record] autorelease];
    return memento;
}

- (void)dealloc
{
    [m_data release];
    [super dealloc];
}

#pragma mark -----
#pragma mark private methods

- (id)initWithSomeData:(id<RecordObjDelegate>)data
{
    if(self=[super init])
    {
        [self setM_data:data];
    }
    return self;
}
@end
