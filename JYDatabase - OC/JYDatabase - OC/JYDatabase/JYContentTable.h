//
//  JYContentTable.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYDataBaseConfig.h"
#import "JYQueryConditions.h"
#import "NSObject+JYContentTableClass.h"

static const NSString *tableContentObject = @"tableContentObject";// 对应的字段 模型的 JYContentTable 对象
static const NSString *tableViceKey = @"tableViceKey";            // 属于本表的 副key
static const NSString *tableSortKey = @"tableSortKey";            // 用于排序字段(映射到数组的顺序) NSString or NSInteger

@class FMDatabaseQueue , FMDatabase;

@interface JYContentTable : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
//数据库表名
@property (nonatomic, copy) NSString *tableName;
//该表对应的模型类
@property (nonatomic, strong) Class contentClass;

- (void)checkError:(FMDatabase *)aDb;
- (id)checkEmpty:(id)aObject;
- (id)checkVaule:(id)aVaule forKey:(NSString*)aKey; // 查询出来的数据进行处理

#pragma mark - 创建表
- (void)configTableName;                    // 进行一些初始化设置
- (NSString *)contentId;                    // 表的主键
- (NSArray<NSString *> *)getContentField;   // 表除主键外其它的列 默认取 @“DB” 结尾的属性
- (NSDictionary*)fieldLenght;               // 创建表 对应列默认长度  默认取默认值
/*
 * 用于关联其它表的属性联系必须是 NSArray<ContentClass>* NSMutableArray<ContentClass>或者  ContentClass
 * JYTest1Table *table = [[JYTest1Table alloc] init];
 * table.dbQueue = self.dbQueue;
 * @{
 *   @"field1":@{
 *               tableContentClass : table,
 *               tablePrimaryKey   : @"primaryKey",
 *               tableViceKey      : @"viceKey"
 *             },
 * }
*/
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField;


// 不重写 该方法会 通过 contentId getContentField fieldLenght associativeTableField 进行表的创建
- (void)createTable:(FMDatabase *)aDB;

// 重写该方法  在创建和更新表时添加额外的数据 比如为某些字段添加索引
- (void)addOtherOperationForTable:(FMDatabase *)aDB;

// 重写该方法 在建表时插入默认数据
- (void)insertDefaultData:(FMDatabase *)aDb;

#pragma mark - 更新表
// 1-2 2-3 3-4 一步步升级 不建议使用  // - (void)updateDB:(FMDatabase *)aDB 已经实现一步到位
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion;
// 默认通过 getContentField 来进行对比 从而新增 删除对应列
- (void)updateDB:(FMDatabase *)aDB;

#pragma mark - 索引添加
- (void)addUniques:(NSArray<NSString *>*)indexs; // 默认添加 非唯一索引
- (void)addDB:(FMDatabase *)aDB uniques:(NSArray<NSString *>*)indexs;
- (void)addDB:(FMDatabase *)aDB type:(EJYDataBaseIndex)aType uniques:(NSArray<NSString *>*)indexs;

#pragma mark - insert 插入
// 以下插入会更新该模型所有相关表
- (void)insertDB:(FMDatabase *)aDB contents:(NSArray *)aContents;
- (void)insertContent:(id)aContent;
- (void)insertContents:(NSArray *)aContents;

// 以下插入只会更新本表相关数据，不会更新关联表，请根据情况尽量调用以下方法
- (void)insertIndependentDB:(FMDatabase *)aDB contents:(NSArray *)aContents;
- (void)insertIndependentContent:(id)aContent;
- (void)insertIndependentContents:(NSArray *)aContents;

#pragma mark - get 查询
- (NSArray *)getContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block;
- (NSArray *)getDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs;
- (NSArray *)getContentByConditions:(void (^)(JYQueryConditions *make))block;
- (NSArray *)getContentByIDs:(NSArray<NSString*>*)aIDs;
- (id)getContentByID:(NSString*)aID;
- (NSArray *)getAllContent;

#pragma mark - delete 删除
- (void)deleteContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs;
- (void)deleteContentByConditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteContentByID:(NSString *)aID;
- (void)deleteContentByIDs:(NSArray<NSString *>*)aIDs;
- (void)deleteAllContent;
- (void)cleanContentBefore:(NSDate*)date;

#pragma mark - getCount
- (NSInteger)getCountContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block;
- (NSInteger)getCountByConditions:(void (^)(JYQueryConditions *make))block;
- (NSInteger)getAllCount;

@end
