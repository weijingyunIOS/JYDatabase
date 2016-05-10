//
//  JYContentDB.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabaseQueue , FMDatabase;

@interface JYContentDB : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSString *tableName;  //数据库表名
@property (nonatomic, strong) Class contentClass;

- (void)checkError:(FMDatabase *)aDb;

- (id)checkEmpty:(id)aObject;

// create (需先设置表名)
- (void)createTable;

// Upgrade (需先设置表名)
- (void)updateDBFromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion;

// Operation (需先设置表名)
- (void)insertContent:(id)aContent;
- (id)getContentByID:(NSString*)aID;
- (NSArray *)getAllContent;
//- (NSArray *)getContentsBy:(id)aContent; // 查找符合 模型中 有数据的字段的

- (void)deleteContent:(NSString *)aID;
- (void)deleteContents;

// 重写该方法 在建表时插入默认数据
- (void)insertDefaultData;

@end
