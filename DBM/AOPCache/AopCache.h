//
//  AopCache.h
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"
#import "LRUController.h"
/*
 *顶层调用接口
 */
@interface AopCache : NSObject
{
    @private
    bool is_using_cache;
}
@property (assign, nonatomic)bool is_using_cache;
+(AopCache*)getInstance;
/*
 设置记录条数
 */
-(BOOL)setWithCapacity:(int)record_amt;
/*
 启用缓存
 */
-(void)startCache;
/*
 record 存 data数据
 */
-(void)record:(Record*)_record saveRecordIntoCache:(id<RecordObjDelegate>)_record_data;
/*
 取数据项 传出到record
 */
-(void)record:(Record*)_record getDataWithKeyString:(NSString*)res_key;
/*
 关闭缓存
 */
-(void)stopCache;
@end
