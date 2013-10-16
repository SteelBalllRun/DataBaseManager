//
//  TestPO.h
//  DBM
//
//  Created by Baitian on 13-5-20.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePO.h"
@interface TestPO : BasePO<BasePODelegate>
{
    NSString* test_attr;
}
@property(nonatomic, retain)NSString* test_attr;
@end
