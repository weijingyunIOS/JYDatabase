//
//  JYPersonDB.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDataBase.h"
#import "JYPersonTable.h"
@interface JYPersonDB : JYDataBase

@property (nonatomic, strong, readonly) NSString * documentDirectory ;
@property (nonatomic, strong, readonly) JYPersonTable * personTable;

+ (instancetype)storage;

@end
