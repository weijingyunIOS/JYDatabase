//
//  JYDataBaseConfig.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/10/17.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDataBaseConfig.h"

@implementation JYDataBaseConfig

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static JYDataBaseConfig* shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - 静态方法
NSDictionary * jy_correspondingDic(){
    return @{@"Tb":@"BOOL",
             @"TB":@"BOOL",
             @"Tc":@"BOOL",
             @"TC":@"BOOL",
             @"Td":@"DOUBLE",
             @"TD":@"DOUBLE",
             @"Tf":@"FLOAT",
             @"TF":@"INTEGER",
             @"Ti":@"INTEGER",
             @"TI":@"INTEGER",
             @"Tq":@"INTEGER",
             @"TQ":@"INTEGER",
             @"T@\"NSMutableString\"":@"VARCHAR",
             @"T@\"NSString\"":@"VARCHAR",
             @"T@\"NSData\"":@"BLOB",
             @"T@\"UIImage\"":@"BLOB",
             @"T@\"NSValue\"":@"BLOB",
             @"T@\"NSNumber\"":@"BLOB",
             @"T@\"NSDictionary\"":@"BLOB",
             @"T@\"NSMutableDictionary\"":@"BLOB",
             @"T@\"NSMutableArray\"":@"BLOB",
             @"T@\"NSArray\"":@"BLOB",};
}

NSDictionary * jy_defaultDic(){
    return @{@"BOOL":@"1",
             @"DOUBLE":@"20",
             @"FLOAT":@"10",
             @"INTEGER":@"10",
             @"VARCHAR":@"128",
             @"BLOB":@"512",};
}

@end



