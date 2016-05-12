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
//@property (nonatomic, readonly) NSCache *cache;     //默认缓存20条数据


- (void)checkError:(FMDatabase *)aDb;

- (id)checkEmpty:(id)aObject;

// create (需先设置表名)JYContentTable
- (void)createTable:(FMDatabase *)aDB;

// Upgrade (需先设置表名)
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion;

#pragma mark - insert 插入
- (void)insertDB:(FMDatabase *)aDB contents:(NSArray *)aContents;
- (void)insertContent:(id)aContent;
- (void)insertContents:(NSArray *)aContents;
#pragma mark - get 查询
- (id)getDB:(FMDatabase *)aDB contentByID:(NSString*)aID;
- (NSArray *)getAllContent:(FMDatabase *)aDB;
- (id)getContentByID:(NSString*)aID;
- (NSArray *)getAllContent;
#pragma mark - delete 删除
- (void)deleteContent:(NSString *)aID;
- (void)deleteContents;

// 重写该方法 在建表时插入默认数据
- (void)insertDefaultData:(FMDatabase *)aDb;

@end
