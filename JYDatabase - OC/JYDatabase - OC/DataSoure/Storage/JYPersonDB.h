//
//  JYPersonDB.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDataBase.h"

@class JYGradeTable,JYPersonTable,JYClassTable;

@interface JYPersonDB : JYDataBase

@property (nonatomic, strong, readonly) NSString      *documentDirectory ;
@property (nonatomic, strong, readonly) JYGradeTable  *gradeTable;
@property (nonatomic, strong, readonly) JYClassTable  *classTable;
@property (nonatomic, strong, readonly) JYPersonTable *personTable;

+ (instancetype)storage;

@end
