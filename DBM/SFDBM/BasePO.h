//
//  BasePO.h
//  DBM
//
//  Created by 舒 方昊 on 13-9-28.
//  Copyright (c) 2013年 舒 方昊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataTypeParser.h"

/*
 写持久类的时候继承这个类。
 然后就可以用基类方法来从线索化的数据中给用户自定义的持久类对象赋值
 
 在子类实现的过程中来调用？
 */

@protocol BasePODelegate <NSObject>
@required

/*
 * 需要提供的两个处理线索化数据的方法
 */
- (void)setValueWithDataArray:(NSArray*)data_array;     //用线索化数据初始化子类
- (NSDictionary*)makeDataIntoArray;                     //将子类数据线索化,autorelease
@end
@interface BasePO : NSObject
{
    NSString* childrenClassKey;
}
@property (nonatomic, retain)NSString* childrenClassKey;
- (void)addobject:(NSObject*)target_obj IntoDic:(NSMutableDictionary*)data_list forKey:(NSString*)key;
@end
