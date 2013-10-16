//
//  TestResObj.h
//  DBM
//
//  Created by Baitian on 13-5-23.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordObject.h"
@interface TestResObj : NSObject<RecordObjDelegate>
{
    NSString* data_str;
}
@property (nonatomic, retain)NSString *data_str;
@end
