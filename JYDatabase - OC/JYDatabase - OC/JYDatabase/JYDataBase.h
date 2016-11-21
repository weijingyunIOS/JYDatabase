//
//  JYDataBase.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYContentTable.h"
#import "JYQueryConditions.h"

@class FMDatabase;
@class FMDatabaseQueue;

typedef NS_ENUM(NSInteger, ArtDatabaseMode)
{
    ArtDatabaseModeRead = 0,
    ArtDatabaseModeWrite = 1 << 0,
};

@interface JYDataBase : NSObject

@property (nonatomic, copy, readonly) NSString* path;
@property (nonatomic, strong, readonly) FMDatabaseQueue *dbQueue;
@property (nonatomic, assign, readonly) ArtDatabaseMode mode;

- (void)buildWithPath:(NSString *)aPath mode:(ArtDatabaseMode)aMode;
- (void)buildWithPath:(NSString *)aPath mode:(ArtDatabaseMode)aMode registTable:(void(^)())aRegist;

- (void)checkError:(FMDatabase *)aDb;
- (id)checkEmpty:(id)aObject;
- (void)addUpdateValue:(id)aValue key:(NSString *)aKey inParams:(NSMutableDictionary *)aParams;

// 获取DB版本号, 默认返回 1
- (NSInteger)getCurrentDBVersion;

// 创建数据库
- (void)createAllTable:(FMDatabase *)aDB;
// 数据库升级 1-2 2-3 3-4 4-5 的升级
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion;

// 一次性升级
- (void)updateDB:(FMDatabase *)aDB;

#pragma mark - 简化创建的方法
/*
    - (void)buildWithPath:(NSString *)aPath mode:(ArtDatabaseMode)aMode registTable:(void(^)())aRegist;
    使用该方法创建，写在aRegist 回调内
 */
- (JYContentTable *)registTableClass:(Class)aClass;

@end
