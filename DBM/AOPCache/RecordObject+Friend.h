//
//  RecordObject+Friend.h
//  DBM
//
//  Created by Baitian on 13-5-17.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordObject.h"
@interface RecordObject()
- (id)initWithSomeData:(id<RecordObjDelegate>)data;
@property (nonatomic, retain)id<RecordObjDelegate> m_data;
@property (nonatomic, assign)BOOL hasCompleteSave;

@end
