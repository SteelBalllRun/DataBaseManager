//
//  AopCache.m
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "AopCache.h"

@interface AopCache()
{
    LRUController* save_controller;
}
@property (nonatomic, retain) LRUController* save_controller;
@end

@implementation AopCache
@synthesize save_controller,is_using_cache;
static AopCache* instance=nil;
+ (AopCache *)getInstance
{
    if (!instance) {
        instance= [[super allocWithZone:NULL]init];
        instance.save_controller =[[LRUController alloc]init];
        instance.is_using_cache= false;
    }
    return instance;
}
- (BOOL)setWithCapacity:(int)record_amt
{
   [save_controller setStackCapacity:record_amt];
    return true;
}
- (void)startCache
{
    is_using_cache=true;
}
-(void)record:(Record*)_record saveRecordIntoCache:(id<RecordObjDelegate>)_record_data
{
    if (!is_using_cache) {
        return;
    }
    [_record saveStatusMakedata:_record_data];
    [NSThread detachNewThreadSelector:@selector(saveCacheWithRecord:) toTarget:self withObject:_record];
}

-(void)record:(Record*)_record  getDataWithKeyString:(NSString*)res_key
{
    _record=[save_controller recordForKey:res_key];
}

- (void)stopCache
{
    is_using_cache=false;
}

#pragma mark =======================
#pragma mark thread methods
#pragma mark =======================
-(void)saveCacheWithRecord:(Record*)_record
{
    if ([save_controller saveRecord:_record]) {
        return;
    }else
    {
        NSLog(@"error with save data");
    }
}

@end
