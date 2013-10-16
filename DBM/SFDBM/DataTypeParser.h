//
//  DataTypeParser.h
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    STRINGTYPE=1,
    INTEGERTYPE=2,
    DOUBLETYPE=3,
    DATETYPE=4,
    RAWDATATYPE=5,
    NILTYPE=-1
}DATA_TYPE;

@interface DataTypeParser : NSObject
{
    NSDictionary* data_map;
    NSDictionary* class_map;
}
@property (retain, nonatomic) NSDictionary* data_map;
@property (retain, nonatomic) NSDictionary* class_map;
//解析一份xml文件来得到一个nsdictionary
//key是表名，value是对应数据类型字典（一个表名对一个数据类型字典
//数据类型字典的key-value是：
//key是对应系统数据类型 ， value是表中数据的名字（表中字段数有多少就有多少对键值对）
-(id)initWithListFileName:(NSString*)plist_name andClassMapName:(NSString*)class_list_name;

/*
 * 每一个键值对key是string，表中字段名 value是值
 */
-(NSDictionary*)getDataTypeListFrom:(NSString*)table_name;
/*
 * 得到持久类class名对应的dao子类名
 */

-(NSString*)getPOClassNameByDAOName:(NSString*)dao_name;

/*
 * 得到表的主键名
 */
- (NSString*)getPrimaryKeyNameByTableName:(NSString*)table_name;

@end
