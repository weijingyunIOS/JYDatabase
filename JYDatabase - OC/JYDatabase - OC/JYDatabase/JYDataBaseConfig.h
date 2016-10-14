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
 ：聚集索引和非聚集索引。其中聚集索引表示表中存储的数据按照索引的顺序存储，检索效率比非聚集索引高，但对数据更新影响较大。非聚集索引表示数据存储在一个地方，索引存储在另一个地方，索引带有指针指向数据的存储位置，非聚集索引检索效率比聚集索引低，但对数据更新影响较小。
 
 create unique index 索引名 on 表名(列名1,列名2……)
 唯一索引
 create unique index IX_GoodsMade_Labour on GoodsMade_Labour(SID)
 非聚集索引
 create unique nonclustered index IX_GoodsMade_Labour on GoodsMade_Labour(SID)
 聚集索引 不适用于更新多的场景  会更新 列 顺序
 create unique clustered index IX_GoodsMade_Labour on GoodsMade_Labour(SID)
 
 */
typedef NS_ENUM(NSInteger, EJYDataBaseIndex) { //索引类型
    EJYDataBaseIndexNonclustered,  // 非聚集索引
    EJYDataBaseIndexClustered,	   // 聚集索引
    EJYDataBaseIndexOnlyIndex,     // 唯一索引
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
