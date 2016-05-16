//
//  JYPersonDB.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDataBase.h"
#import "JYPersonTable.h"
#import "JYTest1Table.h"
@interface JYPersonDB : JYDataBase

@property (nonatomic, strong, readonly) NSString * documentDirectory ;
@property (nonatomic, strong, readonly) JYPersonTable * personTable;
@property (nonatomic, strong, readonly) JYTest1Table * test1Table;

+ (instancetype)storage;

@end
