//
//  JYDataBaseConfig.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/10/17.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
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


@interface JYDataBaseConfig : NSObject

+ (instancetype)shared;

// 额外的影射字段 jy_correspondingDic 可能无法全面覆盖，当遇到崩溃时可设置该属性添加映射
@property (nonatomic, strong) NSDictionary<NSString*,NSString*> *corresponding;


#pragma mark - 静态方法
extern NSDictionary * jy_correspondingDic();
extern NSDictionary * jy_defaultDic();

@end



