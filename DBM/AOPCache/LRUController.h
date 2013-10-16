//
//  LRUController.h
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordObject.h"
@class Record;
/*
 "caretaker"
 */
@interface LRUController : NSObject
{
    //一个哈希表
    NSMutableDictionary* record_dic;
    //一个记录权值表
    NSMutableArray* value_stack;
    //保存记录最大条数
    int m_capacity;
}
/*
 设置储存的记录条数
 */
-(void)setStackCapacity:(int)record_amt;

-(void)pushRecordWithVersionID:(NSString*)record_key;
/*
 得到当前缓存中应该保存的记录id
 */
-(NSArray*)getCurrentVersionIDs;



/*
 记录当前操作记录数(LRU策略对record_stack进行操作
 当传入时，放在栈首，记录号不在stack中时，栈变长，超出部分截断
 当记录号在stack中时，移动栈内成员
 */
-(BOOL)saveRecord:(Record*)aRecord;

/*
 操作记录对象的保存和提取
 key值是供业务逻辑设置的前段缓存字段名
 */
- (Record*)recordForKey:(NSString*)target_key;

@end
