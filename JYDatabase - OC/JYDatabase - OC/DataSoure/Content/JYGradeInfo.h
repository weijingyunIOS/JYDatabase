//
//  JYGradeInfo.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYClassInfo.h"

@interface JYGradeInfo : NSObject

// 年级编号
@property (nonatomic, copy) NSString *gradeID;

// 年级名称
@property (nonatomic, copy) NSString *gradeName;

// 年级下的所有班级
@property (nonatomic, strong) NSMutableArray<JYClassInfo *> *allClass;

@end
