//
//  Record.h
//  DBM
//
//  Created by Baitian on 13-5-17.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "RecordObject.h"
#import "RecordObject+Friend.h"

@interface Record : NSObject
{
@private
    NSString* key_str;
}
@property(nonatomic, retain)NSString* key_str;
- (id)initWithKeyString:(NSString*)__key_str;

- (id)initWithRecordObj:(RecordObject*)aRecordObj;
/*
 *从record object 得到record方法
 */
+(Record*)recordWithRecordObj:(RecordObject*)aRecord;
/*
 *默认取得recordObject方法。。。
 */
-(RecordObject*) getRecordObj;
/*
 *从当前状态弄成recordObject对象
 */
-(void)saveStatusMakedata:(id<RecordObjDelegate>)obj_data;
-(RecordObject*) getRecordObjWithComplete:(bool)hasRecordSave;

@end
