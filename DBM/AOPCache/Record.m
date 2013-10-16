//
//  Record.m
//  DBM
//
//  Created by Baitian on 13-5-17.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "Record.h"
@interface Record()
@property(nonatomic, retain) id<RecordObjDelegate> record_obj_data;
@end

@implementation Record
@synthesize key_str;
@synthesize record_obj_data=_record_obj_data;
- (id)initWithKeyString:(NSString *)__key_str
{
    if (self=[super init]) {
        self.key_str=__key_str;
    }
    return self;
}

- (id)initWithRecordObj:(RecordObject *)aRecordObj
{
    if (self=[super init]) {
        if ([aRecordObj hasCompleteSave]) {
            [self setRecord_obj_data:[aRecordObj m_data]];
        }else
        {
            
        }
    }
    return self;
}
- (void)saveStatusMakedata:(id<RecordObjDelegate>)obj_data
{
    //TODO:从当前状态中生成record objcet
    _record_obj_data=obj_data;
}
- (RecordObject *)getRecordObjWithComplete:(bool)hasRecordSave
{
    id<RecordObjDelegate> data=_record_obj_data;
    RecordObject* complete_obj=[[[RecordObject alloc]initWithSomeData:data]autorelease];
    
    return complete_obj;
}
- (RecordObject *)getRecordObj
{
    return [self getRecordObjWithComplete:YES];
}
+ (Record *)recordWithRecordObj:(RecordObject *)aRecord
{
    Record* record=[[[Record alloc]initWithRecordObj:aRecord]autorelease];
    return record;
}
@end
