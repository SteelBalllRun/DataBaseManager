//
//  LRUController.m
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import "LRUController.h"
#import "Record.h"

#define kScribbleDataPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cachedata"]

@interface LRUController()
-(NSString*)recordCacheFilePath;
- (NSArray *) recordsDataPaths;
-(void)addFileWithKeynameString:(NSString*)file_name withData:(NSData*)file_data;
-(void)removeFileWithKeynameString:(NSString*)file_name;
-(void)hashMap:(NSMutableDictionary*)dic  WithValueList:(NSMutableArray*)value_arr WithRecord:(Record*)_record;
@end

@implementation LRUController
-(id)init
{
    if (self=[super init]) {
        record_dic = [[NSMutableDictionary alloc]init];
        value_stack= [[NSMutableArray alloc]init];
        NSArray* record_paths=[self recordsDataPaths];
        int i=0;
        for (NSString* record_path in record_paths) {
            //TODO:init record_dic with substring of record-path
            NSString* key=[NSString stringWithFormat:@"%d",i];          //暂定使用的key值
            NSString* file_name;
            NSArray* tmp_arr=[record_path componentsSeparatedByString:@"/"];
            int amt=[tmp_arr count];
            file_name=[tmp_arr objectAtIndex:amt-1];
            [record_dic setObject:file_name forKey:key];
            ++i;
        }
        [value_stack setArray:[record_dic allKeys]];
        return self;
    }
    return nil;
}
- (void)setStackCapacity:(int)record_amt
{
    m_capacity=record_amt;
}
- (void)pushRecordWithVersionID:(NSString*)record_key
{
    //TODO:从记录的record_key值转为Record对象
    Record* data_to_save=[[Record alloc]init];
    
    [self saveRecord:data_to_save];
}
- (NSArray *)getCurrentVersionIDs
{
    return value_stack;
}
- (BOOL)saveRecord:(Record *)aRecord
{
    [self hashMap:record_dic WithValueList:value_stack WithRecord:aRecord];
    
    return true;
}
- (Record *)recordAtIndex:(int)_index
{
    NSString* file_path=[[self recordsDataPaths] objectAtIndex:_index];
    NSData* data=[NSData dataWithContentsOfFile:file_path];
    RecordObject * recordObj=[RecordObject memontoWithData:data];
    Record* _result_record=[[Record alloc]initWithRecordObj:recordObj];
    return _result_record;
}

- (Record*)recordForKey:(NSString*)target_key
{
    //TODO:根据target_key的内容从文件中取得data写入内存
    NSString* file_name=[record_dic objectForKey:target_key];
    NSString* file_path=[[self recordCacheFilePath] stringByAppendingPathComponent:file_name];
    
    NSData* _data= [ NSData dataWithContentsOfFile:file_path];
    RecordObject * recordObj=[RecordObject memontoWithData:_data];
    Record* _result_record=[[Record alloc]initWithRecordObj:recordObj];
    return _result_record;
}

#pragma mark ------------------------
#pragma mark private methods for lru
#pragma mark ------------------------

/*
 * 插入一个键值对到dictionary中，同时更新用来模仿lru效果的value_arr(key:键值)
 * key:键值
 * obj:文件名
 */
-(void)hashMap:(NSMutableDictionary*)dic WithValueList:(NSMutableArray*)value_arr WithRecord:(Record*)_record
{
    bool flag=false;
    NSString* _key=_record.key_str;
    //本来是要用record来取个file名字的
    NSObject* _obj=@"test_file_name";
    
    for (int i=0; i<[value_arr count]; ++i) {
        NSString* key=[value_arr objectAtIndex:i];
        if ([key isEqualToString:_key]) {
            //TODO:move all key-value objects which same with _obj-_key to first position
            [value_arr exchangeObjectAtIndex:i withObjectAtIndex:0];
            flag=true;
        }
    }
    if (!flag)
    {
        //TODO:insert objcet into hash map and value array
        int map_capacity=[[dic allKeys]count];
        if (map_capacity>=[value_arr count]&&[value_arr count]>0) {
            NSString* last_key=[value_arr objectAtIndex:(map_capacity-1)];
            [dic removeObjectForKey:last_key];
            [value_arr removeObject:last_key];
            
            NSString* obj=[dic objectForKey:last_key];
            [self removeFileWithKeynameString:obj];
        }
        
        [value_arr insertObject:_key atIndex:0];
        
        //_obj is name for file
        if (!_obj) {
            NSLog(@"no object to be stored");
            return;
        }
        [dic setObject:_obj forKey:_key];
        [self addFileWithKeynameString:(NSString*)_obj withData:[[_record getRecordObj]data]];
    }
}

#pragma mark -----------------------------------
#pragma mark private methods for file management
#pragma mark -----------------------------------
-(NSString*)recordCacheFilePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:kScribbleDataPath])
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:kScribbleDataPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:NULL];
    }
    
    return kScribbleDataPath;
}
- (NSArray *) recordsDataPaths
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *recordDataPathsArray = [fileManager contentsOfDirectoryAtPath:[self recordCacheFilePath] error:&error];
    
    return recordDataPathsArray;
}
-(void)addFileWithKeynameString:(NSString*)file_name withData:(NSData*)file_data
{
    //1.get nsdata
    //2.get filePath
    NSString* file_path=[[self recordCacheFilePath] stringByAppendingPathComponent:file_name];
    //3.write data in file
    [file_data writeToFile:file_path atomically:true];
}
-(void)removeFileWithKeynameString:(NSString*)file_name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError* error;
    NSString* file_path=[[self recordCacheFilePath] stringByAppendingString:file_name];
    
    if ([fileManager fileExistsAtPath:file_path]) {
        [fileManager removeItemAtPath:file_path error:&error];
    }else
    {
        NSLog(@"文件不存在");
    }
}

@end
