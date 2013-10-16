//
//  usr_UnitPO.h
//  DBM
//
//  Created by Baitian on 13-5-14.
//  Copyright (c) 2013年 Baitian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasePO.h"
@interface usr_UnitPO : BasePO<BasePODelegate>
{
    NSNumber* m_UnitID;
    NSNumber* m_UnitStatus;
    NSNumber* m_UnitGrade;
    NSNumber* m_CurrentUnitIndex;
    NSNumber* m_PassedCount;
    NSDate * m_PassedTime;
}

@property(nonatomic, retain) NSNumber* m_UnitID;
@property(nonatomic, retain) NSNumber* m_UnitStatus;
@property(nonatomic, retain) NSNumber* m_CurrentUnitIndex;
@property(nonatomic, retain) NSNumber* m_UnitGrade;
@property(nonatomic, retain) NSNumber* m_PassedCount;
@property(nonatomic, retain) NSDate* m_PassedTime;
@end
