//
//  JYContentTable.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue , FMDatabase;

@interface JYContentTable : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSString *tableName;  //数据库表名
@property (nonatomic, strong) Class contentClass;
@property (nonatomic, readonly) NSCache *cache;     //默认缓存20条数据


- (void)checkError:(FMDatabase *)aDb;

- (id)checkEmpty:(id)aObject;

// create (需先设置表名)JYContentTable
- (void)createTable:(FMDatabase *)aDB;

// Upgrade (需先设置表名)
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion;

// Operation (需先设置表名)
- (void)insertContent:(id)aContent;
- (void)insertContents:(NSArray *)aContents;
- (id)getContentByID:(NSString*)aID;
- (NSArray *)getAllContent;

- (void)deleteContent:(NSString *)aID;
- (void)deleteContents;

// 重写该方法 在建表时插入默认数据
- (void)insertDefaultData:(FMDatabase *)aDb;

@end
