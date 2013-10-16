//
//  BaseVisitor.h
//  DBM
//
//  Created by Baitian on 13-5-16.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseVisitor : NSObject
{
    
}
/*
 *访问类的基类 (带锁
 */
-(void)onLock;
-(id)getResourceBykey:(NSString*)key_str;
-(void)unLocked;
@end
