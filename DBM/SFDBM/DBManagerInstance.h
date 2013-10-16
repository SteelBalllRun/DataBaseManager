//
//  DBManagerInstance.h
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#import "AppDelegate.h"
typedef enum
{
    SQLITE3_TYPE,
    CORE_DATA_TYPE
}DBType;

@interface DBManagerInstance : NSObject
{
    FMDatabase* m_db;
    FMResultSet* m_result_set;
    
    NSManagedObjectContext* m_context;
    NSFetchRequest* m_request;
    DBType m_type;
}

//最底层数据库封装，用来管理数据库连接

@property(nonatomic, retain)FMDatabase* m_db;
@property(nonatomic, retain)FMResultSet* m_result_set;

@property(nonatomic, retain)NSManagedObjectContext *m_context;
@property(nonatomic, retain)NSFetchRequest *m_request;
@property(nonatomic, assign)DBType db_type;
//1.sqlite3的数据库连接初始化
-(id)initWithDataBaseName:(NSString*)db_name;
//2.core data 数据库连接初始化
-(id)initWithCoreDataName:(NSString*)entity_name;
//3.sqllite methods
-(BOOL) getNext;
-(void) commitDB;
-(BOOL) closeDB;
@end
