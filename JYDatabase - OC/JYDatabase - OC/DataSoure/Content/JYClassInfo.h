//
//  JYClassInfo.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYPersonInfo.h"

@interface JYClassInfo : NSObject

// 年级ID
@property (nonatomic, copy) NSString *classID;

// 班级所属的年级表
@property (nonatomic, copy) NSString *gradeID;

// 班级名
@property (nonatomic, copy) NSString *className;

// 一个老师
@property (nonatomic, strong) JYPersonInfo *teacher;

// 一群学生
@property (nonatomic, strong) NSArray<JYPersonInfo *> *students;

@end
