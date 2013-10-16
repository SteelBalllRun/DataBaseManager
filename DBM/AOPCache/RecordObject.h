//
//  RecordObject.h
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 记录对象“memento”
 */
typedef enum {
    STRING_TYPE,
    IMG_TYPE,
    OTHER_FILE_TYPE
}DataType;

@protocol RecordObjDelegate <NSObject>
/*
 为了可以使对象能够被存入备忘录而必须实现的一些方法？
 */
//+(id<RecordObjDelegate>)getRecorcObjDataWith:(NSDictionary*)data_dic;
////得到文件类型
//-(DataType)getRecordDataType;
////得到文件的key
//-(NSString*)getRecordDataKey;
////得到nsdata数据
//-(NSData*) getDataForObj;

@end

@interface RecordObject : NSObject
{
    @private
    id<RecordObjDelegate> m_data;
    BOOL hasCompleteSave;
    
}
+ (RecordObject*)memontoWithData:(NSData* )data;
- (NSData*) data;
@end
