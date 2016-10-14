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

/*
 虽然索引的目的在于提高数据库的性能，但这里有几个情况需要避免使用索引。使用索引时，应重新考虑下列准则：
 索引不应该使用在较小的表上。
 索引不应该使用在有频繁的大批量的更新或插入操作的表上。
 索引不应该使用在含有大量的 NULL 值的列上。
 索引不应该使用在频繁操作的列上。
 */
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
