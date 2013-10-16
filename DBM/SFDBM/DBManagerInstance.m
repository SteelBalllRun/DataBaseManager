//
//  DBManagerInstance.m
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import "DBManagerInstance.h"
@implementation DBManagerInstance
@synthesize m_db;
@synthesize m_result_set;
@synthesize m_request,m_context;
@synthesize db_type;
- (NSString *)dataFilePath:(NSString*)data_base_name
{
    //set database path
    NSString* path= [[NSBundle mainBundle]pathForResource:data_base_name ofType:@"db"];
    NSArray* paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",data_base_name]];
    
    NSFileManager* fm=[NSFileManager defaultManager];
    if ([fm fileExistsAtPath:documentsDirectory]==NO) {
        [fm copyItemAtPath:path toPath:documentsDirectory error:nil];
    }
    NSLog(@"%@",documentsDirectory);
    return documentsDirectory;
}
- (id)initWithDataBaseName:(NSString *)db_name
{
    if (self=[super init]) {
        m_db= [FMDatabase databaseWithPath:[self dataFilePath:db_name]];
        return self;
    }else
    {
        return nil;
    }
}
- (id)initWithCoreDataName:(NSString *)entity_name
{
    if (self=[super init]) {
        AppDelegate* _app_delegate=[[UIApplication sharedApplication] delegate];
        self.m_context =[_app_delegate managedObjectContext];
        self.m_request= [[NSFetchRequest alloc]init];
        return self;
    }
    return nil;
}
- (BOOL)getNext
{
    //when using sqlite3 data base
    if (m_type==SQLITE3_TYPE) {
        if(self.m_result_set)
        {
            return [self.m_result_set next];
        }
        NSLog(@"result set not created!");
        return false;
    }else
    {
        NSLog(@"wrong database type selected");
        return false;
    }
}
- (void)commitDB
{
    //when using sqlite3 data base
    if (m_type==SQLITE3_TYPE) {
       [self.m_db commit];
    }else
    {
        NSLog(@"wrong database type selected");
    }
}
- (BOOL)closeDB
{
    //when using sqlite3 data base
    if (m_type==SQLITE3_TYPE) {
        if(self.m_result_set)
        {
            [self.m_db commit];
            [self.m_db close];
            return true;
        }
        NSLog(@"result set not created!");
        return false;
    }else
    {
        NSLog(@"wrong database type selected");
        return false;
    }
}
- (void)dealloc
{
    if ([m_db hasOpenResultSets]) {
        [m_db closeOpenResultSets];
        [m_db close];
    }
    [super dealloc];
}

@end
