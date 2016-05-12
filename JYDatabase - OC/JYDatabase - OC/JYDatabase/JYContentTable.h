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

#pragma mark - 创建表
- (NSString *)contentId;                    // 表的主键
- (NSArray<NSString *> *)getContentField;   // 表除主键外其它的列 默认取 @“DB” 结尾的属性
- (NSDictionary*)fieldLenght;               // 创建表 对应列默认长度  默认取默认值

// 不重写 该方法会 通过 contentId getContentField fieldLenght 进行表的创建
- (void)createTable:(FMDatabase *)aDB;

#pragma mark - 更新表 默认通过 getContentField 来进行对比 从而新增 删除对应列
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion;

#pragma mark - insert 插入
- (void)insertDB:(FMDatabase *)aDB contents:(NSArray *)aContents;
- (void)insertContent:(id)aContent;
- (void)insertContents:(NSArray *)aContents;

#pragma mark - get 查询
- (NSArray *)getDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs;
- (NSArray *)getAllContent:(FMDatabase *)aDB;
- (NSArray *)getContentByIDs:(NSArray<NSString*>*)aIDs;
- (id)getContentByID:(NSString*)aID;
- (NSArray *)getAllContent;

#pragma mark - delete 删除
- (void)deleteDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs;
- (void)deleteAllContent:(FMDatabase *)aDB;
- (void)deleteContentByID:(NSString *)aID;
- (void)deleteContentByIDs:(NSArray<NSString *>*)aIDs;
- (void)deleteAllContent;

// 重写该方法 在建表时插入默认数据
- (void)insertDefaultData:(FMDatabase *)aDb;

@end
