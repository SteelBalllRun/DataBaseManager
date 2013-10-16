//
//  DOMMethods.h
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataTypeParser.h"
#import "DBManagerInstance.h"
#import "BasePO.h"
//#import "usr_UnitPO.h"
@interface DOMMethods : NSObject
{
    DataTypeParser* data_map;
    DBManagerInstance* data_base_manager;
}
//可以写成基类，也可以做成单例？
-(id)initWithDataMapName:(NSString*)data_map_name andClassMapName:(NSString*)class_map_name type:(DBType)db_type;
//这东西要想能用起来，前提是

//1.增
- (BOOL)insertObject:(id<BasePODelegate>)example_data intoTable:(NSString*)table_name;
//2.删
- (BOOL)deleteObject:(id<BasePODelegate>)example_data fromTable:(NSString*)table_name;
//3.改
- (BOOL)updateObject:(id<BasePODelegate>)example_data forTable:(NSString *)table_name;
//4.查(传出的数组是可靠数据，在外部释放
- (NSArray*)getObjectByID:(NSString*)primary_keys fromTable:(NSString*)table_name;
- (NSArray*)getObjectByExample:(id<BasePODelegate>)example_data fromTable:(NSString*)table_name;
//5.by sql
//对sql语句的语义要作个处理诶。。。。
- (NSArray*)getResultBySql:(NSString*)sql_string fromTable:(NSString*)table_name;

@end
