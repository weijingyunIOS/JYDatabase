//
//  JYDataBaseConfig.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/10/13.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#ifndef JYDataBaseConfig_h
#define JYDataBaseConfig_h
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EJYDataBaseIndex) { //索引类型
    EJYDataBaseIndexNonclustered,  // 非唯一索引
    EJYDataBaseIndexOnlyIndex,     // 唯一索引
    EJYDataBaseIndexCompositeIndex // 组合索引
};


static inline NSDictionary * jy_correspondingDic(){
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
             @"T@\"NSNumber\"":@"BLOB",
             @"T@\"NSDictionary\"":@"BLOB",
             @"T@\"NSMutableDictionary\"":@"BLOB",
             @"T@\"NSMutableArray\"":@"BLOB",
             @"T@\"NSArray\"":@"BLOB",};
}

static inline NSDictionary * jy_defaultDic(){
    return @{@"BOOL":@"1",
             @"DOUBLE":@"20",
             @"FLOAT":@"10",
             @"INTEGER":@"10",
             @"VARCHAR":@"128",
             @"BLOB":@"512",};
}

#endif /* JYDataBaseConfig_h */
