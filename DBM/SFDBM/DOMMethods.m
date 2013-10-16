//
//  DOMMethods.m
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import "DOMMethods.h"

@implementation DOMMethods

-(NSObject*)setValueFromResultSet:(FMResultSet*)result WithDataType:(DATA_TYPE)data_type andName:(NSString*)data_name
{
    NSObject* object= [[NSObject alloc]init];
    switch (data_type) {
        case STRINGTYPE:
        {
            object = [result stringForColumn:data_name];
        }
            break;
        case INTEGERTYPE:
        {
            object =[NSNumber numberWithInt:[result intForColumn:data_name]];
        }
            break;
        case DOUBLETYPE:
        {
            object = [NSNumber numberWithFloat:[result doubleForColumn:data_name]];
        }
            break;
            
        case DATETYPE:
        {
            object = [result dateForColumn:data_name];
        }
            break;
        case RAWDATATYPE:
        {
            object = [result dataForColumn:data_name];
        }
            break;
        default:
            break;
    }
    [object retain];
    return object;
}

- (id)initWithDataMapName:(NSString *)data_map_name andClassMapName:(NSString*)class_map_name type:(DBType)db_type
{
    
    if (self=[super init]) {
        data_map =[[DataTypeParser alloc]initWithListFileName:data_map_name andClassMapName:class_map_name];
        if (db_type==SQLITE3_TYPE) {
            data_base_manager= [[DBManagerInstance alloc]initWithDataBaseName:@"usr"];
        }else if (db_type==CORE_DATA_TYPE)
        {
            data_base_manager=[[DBManagerInstance alloc]initWithCoreDataName:@""];
        }
        [data_base_manager setDb_type:db_type];
        return self;
    }else
    {
        return nil;
    }
}

/*
 * 插入数据
 */
- (BOOL)insertObject:(id<BasePODelegate>)example_data intoTable:(NSString *)table_name
{
    return [self insertObject:example_data intoTable:table_name withDBType:data_base_manager.db_type];
}

/*
 * 删除数据项
 */
- (BOOL)deleteObject:(id<BasePODelegate>)example_data fromTable:(NSString *)table_name
{
    return [self deleteObject:example_data fromTable:table_name withDBType:data_base_manager.db_type];
}


/*
 * 根据数据项来查找数据
 */
- (NSArray *)getObjectByExample:(id<BasePODelegate>)example_data fromTable:(NSString *)table_name
{
    return [self getObjectByExample:example_data fromTable:table_name withDBType:data_base_manager.db_type];
}

#pragma makr------------------
#pragma mark sqlite3 methods
#pragma makr------------------

- (BOOL)updateObject:(id<BasePODelegate>)example_data forTable:(NSString *)table_name
{
    if (data_base_manager.db_type==CORE_DATA_TYPE) {
        NSLog(@"this method is only for sqlite3");
        return false;
    }
    //1.analyse data_obj
    NSDictionary* class_type_list=[data_map getDataTypeListFrom:table_name] ;
    NSString* primary_key_name= [data_map getPrimaryKeyNameByTableName:table_name];
    NSMutableDictionary* _data= (NSMutableDictionary*)[example_data makeDataIntoArray];
    
    for (int i=0; i<[[class_type_list allKeys] count]; ++i) {
        NSString * _type_name=[[class_type_list allKeys] objectAtIndex:i];
        NSNumber * _value=[_data objectForKey:_type_name];
        if ([_value intValue]==-1) {
            [_data removeObjectForKey:_type_name];
        }
    }
    //2.make sql
    NSString* predicate_str=[[NSString alloc]init];
    for (int i=0; i<[[_data allKeys] count]; ++i) {
        if ([[[_data allKeys]objectAtIndex:i] isEqualToString:primary_key_name]) {
            continue;
        }
        predicate_str=[predicate_str stringByAppendingFormat:@"%@=%@",[[_data allKeys] objectAtIndex:i],[_data objectForKey:[[_data allKeys] objectAtIndex:i]]];
        if (i<[[_data allKeys] count]-1) {
            predicate_str=[predicate_str stringByAppendingString:@","];
        }
    }
    
    NSString * sql=[NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ",table_name,predicate_str,primary_key_name];
    sql = [sql stringByAppendingFormat:@"%d",[[_data valueForKey:primary_key_name] intValue]];
    //3.call getResultBySql:
    [class_type_list release];
    [_data release];
    if ([self getResultBySql:sql fromTable:table_name]) {
        return true;
    }
    return false;
}

-(NSArray *)getObjectByID:(NSString *)primary_keys fromTable:(NSString *)table_name
{
    if (data_base_manager.db_type==CORE_DATA_TYPE) {
        NSLog(@"this method is only for sqlite3");
        return nil;
    }
    NSString* str=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE UnitID in (%@)",table_name,primary_keys];
    return [self getResultBySql:str fromTable:table_name];
}

-(NSArray *)getResultBySql:(NSString *)sql_string fromTable:(NSString *)table_name
{
    if (data_base_manager.db_type==CORE_DATA_TYPE) {
        NSLog(@"this method is only for sqlite3");
        return nil;
    }
    NSMutableArray* result_array=[[NSMutableArray alloc]init];
    NSDictionary* table_arr=(NSDictionary*)[data_map getDataTypeListFrom:table_name];
    NSArray* data_type_index= [table_arr allKeys];
    if (![data_base_manager.m_db open]) {
        NSLog(@"error with open data base table:%@",table_name);
        return nil;
    }
    //make sql by example data (通过处理解析example
    data_base_manager.m_result_set=[data_base_manager.m_db executeQuery:sql_string];
    //make object by data_type_index
    while([data_base_manager getNext])
    {
        NSMutableArray* ent=[[NSMutableArray alloc]init];
        //得到每条数据项
        for (int sub_index=0; sub_index<[data_type_index count]; sub_index++) {
            NSString* data_type_name=(NSString*)[data_type_index objectAtIndex:sub_index];
            NSNumber* data_type= (NSNumber*)[table_arr objectForKey:data_type_name];
            
            NSObject* obj=[self setValueFromResultSet:data_base_manager.m_result_set WithDataType:[data_type intValue] andName:data_type_name];
            if (!obj) {
                obj= [[NSNumber alloc]initWithInt:-1];
            }
            [ent addObject:obj];
            [obj release];
        }
        //将每条线索化后的PO数据项存入数组
        NSString * class_str=[table_name stringByAppendingString:@"PO"];
//        BasePO* po_obj=[[NSClassFromString(class_str) alloc]init];
        id<BasePODelegate> __obj=[[NSClassFromString(class_str) alloc]init];
        [__obj setValueWithDataArray:ent];
        [result_array addObject:__obj];
        
        [data_base_manager closeDB];
        
        [table_arr release];
        [table_name release];
        [__obj release];
        [ent release];
    }
    return result_array;
}

#pragma makr------------------
#pragma mark coredata methods
#pragma makr------------------

- (BOOL)insertObject:(id<BasePODelegate>)example_data intoTable:(NSString*)table_name withDBType:(DBType)data_base_type
{
    if (data_base_type==SQLITE3_TYPE) {
        //1.analyse data_obj
        NSDictionary* class_type_list=[data_map getDataTypeListFrom:table_name] ;
        //    NSString* primary_key_name= [data_map getPrimaryKeyNameByTableName:table_name];
        NSMutableDictionary* _data= (NSMutableDictionary*)[example_data makeDataIntoArray];
        
        for (int i=0; i<[[class_type_list allKeys] count]; ++i) {
            NSString * _type_name=[[class_type_list allKeys] objectAtIndex:i];
            NSNumber * _value=[_data objectForKey:_type_name];
            if ([_value intValue]==-1) {
                [_data removeObjectForKey:_type_name];
            }
        }
        //2.make sql
        NSString* key_str=[[[NSString alloc]init]autorelease];
        for (int i=0; i<[[_data allKeys] count]; ++i) {
            key_str=[key_str stringByAppendingFormat:@"%@",[[_data allKeys] objectAtIndex:i]];
            if (i<[[_data allKeys] count]-1) {
                key_str=[key_str stringByAppendingString:@","];
            }
        }
        
        NSString* value_str=[[[NSString alloc]init]autorelease];
        for (int i=0; i<[[_data allKeys] count]; ++i) {
            value_str=[value_str stringByAppendingFormat:@"%@",[_data objectForKey:[[_data allKeys] objectAtIndex:i]]];
            if (i<[[_data allKeys] count]-1) {
                value_str=[value_str stringByAppendingString:@","];
            }
        }
        
        
        
        NSString * sql=[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES(%@)  ",table_name,key_str,value_str];
        //3.call getResultBySql:
        [class_type_list release];
        [_data release];
        //    [value_str release];
        //    [key_str release];
        if ([self getResultBySql:sql fromTable:table_name]) {
            return true;
        }
        return false;
    }
    if (data_base_type==CORE_DATA_TYPE) {
        NSDictionary* table_arr=(NSDictionary*)[data_map getDataTypeListFrom:table_name];
        NSArray* data_type_index= [table_arr allKeys];
        
        NSError* error;
        NSEntityDescription* entityDescription=[NSEntityDescription entityForName:table_name inManagedObjectContext:data_base_manager.m_context];
        [data_base_manager.m_request setEntity:entityDescription];
        
        NSDictionary* insert_data=[example_data makeDataIntoArray];
        
        NSArray* result_arr=[data_base_manager.m_context executeFetchRequest:data_base_manager.m_request error:&error];
        NSManagedObject* theObj=nil;
        if (!result_arr) {
            NSLog(@"error");
            return false;
        }
        if ([result_arr count]>0) {
            theObj=[result_arr objectAtIndex:0];
        }else
        {
            theObj=[NSEntityDescription insertNewObjectForEntityForName:table_name inManagedObjectContext:data_base_manager.m_context];
        }
        for (int i=0;i<[data_type_index count];i++) {
            NSString* key_str=[data_type_index objectAtIndex:i];
            [theObj setValue:[insert_data objectForKey:key_str] forKey:key_str];
        }
        [data_base_manager.m_context save:&error];
        [table_arr release];
        return true;
    }
    return false;
}

- (BOOL)deleteObject:(id<BasePODelegate>)example_data fromTable:(NSString*)table_name withDBType:(DBType)data_base_type
{
    if (data_base_type==SQLITE3_TYPE) {
        //1.analyse data_obj
        NSDictionary* class_type_list=[data_map getDataTypeListFrom:table_name] ;
        //    NSString* primary_key_name= [data_map getPrimaryKeyNameByTableName:table_name];
        NSMutableDictionary* _data= (NSMutableDictionary*)[example_data makeDataIntoArray];
        
        for (int i=0; i<[[class_type_list allKeys] count]; ++i) {
            NSString * _type_name=[[class_type_list allKeys] objectAtIndex:i];
            NSNumber * _value=[_data objectForKey:_type_name];
            if ([_value intValue]==-1) {
                [_data removeObjectForKey:_type_name];
            }
        }
        //2.make sql
        NSString* predicate_str=[[NSString alloc]init];
        for (int i=0; i<[[_data allKeys] count]; ++i) {
            predicate_str=[predicate_str stringByAppendingFormat:@"%@=%@",[[_data allKeys] objectAtIndex:i],[_data objectForKey:[[_data allKeys] objectAtIndex:i]]];
            if (i<[[_data allKeys] count]-1) {
                predicate_str=[predicate_str stringByAppendingString:@","];
            }
        }
        
        NSString * sql=[NSString stringWithFormat:@"DELETE FROM %@ WHERE  ",table_name];
        sql=[sql stringByAppendingString:predicate_str];
        //3.call getResultBySql:
        [class_type_list release];
        [_data release];
        if ([self getResultBySql:sql fromTable:table_name]) {
            return true;
        }
        return false;
    }
    if (data_base_type==CORE_DATA_TYPE) {
        NSDictionary* table_arr=(NSDictionary*)[data_map getDataTypeListFrom:table_name];
        NSError* error;
        NSEntityDescription* entityDescription=[NSEntityDescription entityForName:table_name inManagedObjectContext:data_base_manager.m_context];
        [data_base_manager.m_request setEntity:entityDescription];
        
        NSDictionary* insert_data=[example_data makeDataIntoArray];
        NSString* pre_substr=[[NSString alloc]init];
        for (int i=0; i<[insert_data count]; i++) {
            NSString* key_str=[[insert_data allKeys] objectAtIndex:i];
            NSString* data_str=[insert_data objectForKey:key_str];
            if ([data_str isEqualToString:@"-1"]) {
                continue;
            }
            pre_substr=[pre_substr stringByAppendingFormat:@"%@=%@",key_str,data_str];
            if (i<[insert_data count]-1) {
                pre_substr =[pre_substr stringByAppendingFormat:@","];
            }
        }
        NSPredicate *pre=[NSPredicate predicateWithFormat:pre_substr];
        [data_base_manager.m_request setPredicate:pre];
        
        NSArray* result_arr=[data_base_manager.m_context executeFetchRequest:data_base_manager.m_request error:&error];
        for (NSManagedObject* theObject in result_arr) {
            [data_base_manager.m_context deleteObject:theObject];
        }
        [data_base_manager.m_context processPendingChanges];
        [data_base_manager.m_context save:&error];
        [table_arr release];
        return true;
    }
    return false;
}

- (NSArray*)getObjectByExample:(id<BasePODelegate>)example_data fromTable:(NSString*)table_name withDBType:(DBType)data_base_type
{
    if (data_base_type==SQLITE3_TYPE) {
        NSDictionary* class_type_list=[data_map getDataTypeListFrom:table_name] ;
        NSMutableDictionary* _data= (NSMutableDictionary*)[example_data makeDataIntoArray];
        
        for (int i=0; i<[[class_type_list allKeys] count]; ++i) {
            NSString * _type_name=[[class_type_list allKeys] objectAtIndex:i];
            NSNumber * _value=[_data objectForKey:_type_name];
            if ([_value intValue]==-1) {
                [_data removeObjectForKey:_type_name];
            }
        }
        //2.make sql
        NSString * sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE ",table_name];
        for (int i=0; i<[[_data allKeys] count]; ++i) {
            sql=[sql stringByAppendingFormat:@"%@=%@",[[_data allKeys] objectAtIndex:i],[_data objectForKey:[[_data allKeys] objectAtIndex:i]]];
            if (i<[[_data allKeys] count]-1) {
                sql=[sql stringByAppendingString:@","];
            }
        }
        [class_type_list release];
        [_data release];
        //3.call getResultBySql:
        return [self getResultBySql:sql fromTable:table_name];
    }
    if (data_base_type==CORE_DATA_TYPE) {
        NSError* error;
        NSEntityDescription* entityDescription=[NSEntityDescription entityForName:table_name inManagedObjectContext:data_base_manager.m_context];
        [data_base_manager.m_request setEntity:entityDescription];
        
        NSMutableArray* result_array=[[NSMutableArray alloc]init];
        NSDictionary* table_arr=(NSDictionary*)[data_map getDataTypeListFrom:table_name];
        NSArray* data_type_index= [table_arr allKeys];
        
        NSDictionary* insert_data=[example_data makeDataIntoArray];
        NSString* pre_substr=[[NSString alloc]init];
        for (int i=0; i<[insert_data count]; i++) {
            NSString* key_str=[[insert_data allKeys] objectAtIndex:i];
            NSString* data_str=[insert_data objectForKey:key_str];
            if ([data_str isEqualToString:@"-1"]) {
                continue;
            }
            pre_substr=[pre_substr stringByAppendingFormat:@"%@==\"%@\"",key_str,data_str];
            if (i<[insert_data count]-1) {
                pre_substr =[pre_substr stringByAppendingFormat:@"AND"];
            }
        }
        NSPredicate *pre=[NSPredicate predicateWithFormat:pre_substr];
        [data_base_manager.m_request setPredicate:pre];
        
        NSArray* result_arr=[data_base_manager.m_context executeFetchRequest:data_base_manager.m_request error:&error];
        for (NSManagedObject* object in result_arr)
        {
            //TODO:make raw object into po object
            NSMutableArray* ent=[[NSMutableArray alloc]init];
            for (NSString* data_key in data_type_index)
            {
                NSObject* raw_obj=[object valueForKey:data_key];
                [ent addObject:raw_obj];
                [raw_obj release];
            }
            NSString * class_str=[table_name stringByAppendingString:@"PO"];
            id<BasePODelegate> __obj=[[NSClassFromString(class_str) alloc]init];
            [__obj setValueWithDataArray:ent];
            [result_array addObject:__obj];
            
            [table_arr release];
            [table_name release];
            [__obj release];
            [ent release];
        }
        return result_array;
    }
    return nil;
}
- (void)dealloc
{
    [data_map release];
    [data_base_manager release];
    [super dealloc];
}
@end

