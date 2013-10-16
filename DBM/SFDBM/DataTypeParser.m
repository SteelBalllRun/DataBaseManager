//
//  DataTypeParser.m
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import "DataTypeParser.h"

@implementation DataTypeParser
@synthesize data_map;
@synthesize class_map;
- (id)initWithListFileName:(NSString *)plist_name andClassMapName:(NSString*)class_list_name
{
    if (self = [super init]) {
        NSArray* paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString * path=[paths objectAtIndex:0];
        
        NSString* file_path= [path stringByAppendingPathComponent:plist_name];
        
        self.data_map = [[NSDictionary alloc]initWithContentsOfFile:file_path];
        
        self.class_map = [[NSDictionary alloc]initWithContentsOfFile:class_list_name];
        return self;
    }else
    {
        return nil;
    }
}

- (NSDictionary *)getDataTypeListFrom:(NSString *)table_name
{
    NSString* listTablePOName=[table_name stringByAppendingString:@"PO"];
    [table_name release];
    NSMutableDictionary* data_typeList=[[NSMutableDictionary alloc]initWithDictionary:[self.data_map objectForKey:listTablePOName]];
    
    [data_typeList removeObjectForKey:@"PrimaryKey"];
    return data_typeList;
}
-(NSString*)getPOClassNameByDAOName:(NSString*)dao_name
{
    NSString* class_name= [self.class_map objectForKey:dao_name];
    return class_name;
}
- (NSString *)getPrimaryKeyNameByTableName:(NSString *)table_name
{
    NSString* listTablePOName=[table_name stringByAppendingString:@"PO"];
    [table_name release];
    NSMutableDictionary* data_typeList= [self.data_map objectForKey:listTablePOName];
    NSString* primary_key=[data_typeList objectForKey:@"PrimaryKey"];
    NSLog(@"%@",primary_key);
    return primary_key;
}
- (void)dealloc  
{
    if (data_map) {
        [data_map release];
    }
    if (class_map) {
        [class_map release];
    }
    [super dealloc];
}
@end
