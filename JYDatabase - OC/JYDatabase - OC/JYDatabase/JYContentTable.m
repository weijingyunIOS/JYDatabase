//
//  JYContentTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYContentTable.h"
#import <UIKit/UIKit.h>
#import "FMDB.h"
#import <objc/runtime.h>
#import "JYDataBaseConfig.h"

#if DEBUG

#else

#define NSLog(...)

#endif

@interface JYContentTable()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSDictionary *attributeTypeDic;

@end

@implementation JYContentTable

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configTableName];
        if ([self enableCache]) {
            self.cache = [[NSCache alloc] init];
            self.cache.countLimit = 20;
        }
    }
    return self;
}

- (void)configTableName{
    
}

- (void)insertDefaultData:(FMDatabase *)aDb{
    
}

- (BOOL)enableCache{
    return YES;
}

- (NSDictionary *)correspondingDic{
    return nil;
}

- (NSDictionary*)fieldLenght{
    return nil;
}

- (NSString *)contentId{
    return nil;
}

- (NSString *)insertTimeField{
    return @"lastInsertTime";
}

- (NSArray<NSString *> *)getContentField{
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    unsigned int outCount;
    Class aClass = self.contentClass;
    while (class_getSuperclass(aClass) != nil) {
        objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
        for (NSInteger index = 0; index < outCount; index++) {
            NSString *tmpName = [NSString stringWithFormat:@"%s",property_getName(properties[index])];
            NSString* prefix = @"DB";
            if ([tmpName hasSuffix:prefix]) {
                [arrayM addObject:tmpName];
            }
        }
        
        if (properties) {
            free(properties);
        }
        aClass = class_getSuperclass(aClass);
    }
    NSAssert([self contentId].length > 0, @"主键不能为空");
    [arrayM removeObject:[self contentId]];
    return [arrayM copy];
}

- (NSArray<NSString *> *)getAllContentField{
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    // 保证 contentId 在第一个位置
    [arrayM addObject:[self contentId]];
    [arrayM addObjectsFromArray:[self getContentField]];
    [arrayM addObject:self.insertTimeField];
    return [arrayM copy];
}

#pragma mark - 查询的处理函数
- (void)checkError:(FMDatabase *)aDb
{
    if ([aDb hadError]) {
        NSLog(@"DB Err %d: %@", [aDb lastErrorCode], [aDb lastErrorMessage]);
    }
}

// 数据预处理
- (id)checkEmpty:(id)aObject
{
    return aObject == nil ? [NSNull null] : aObject;
}

// 插入时数据处理
- (id)checkContent:(NSString *)aContent forKey:(NSString *)akey{
    if ([akey isEqualToString:[self insertTimeField]]) {
        return @([NSDate date].timeIntervalSince1970);
    }
    
    id vaule = [aContent valueForKey:akey];
    @autoreleasepool {
        if ([vaule isKindOfClass:[UIImage class]]) {
            vaule = UIImageJPEGRepresentation(vaule,1.0);
        }
    }
    
    NSString *type = [self attributeTypeDic][akey];
    
    if ([self jSONSerializationForType:type] && vaule != nil) {
        vaule = [NSJSONSerialization dataWithJSONObject:vaule options:NSJSONWritingPrettyPrinted error:nil];
    }
    return [self checkEmpty:vaule];
}

// 查询出来的数据处理
- (id)checkVaule:(id)aVaule forKey:(NSString*)aKey{
    @autoreleasepool {
        NSString *type = [self attributeTypeDic][aKey];
        if ([type  isEqual: @"T@\"UIImage\""] && aVaule != [NSNull null]) {
            aVaule = [UIImage imageWithData:aVaule];
        }
    
        if ([self jSONSerializationForType:type] && aVaule != [NSNull null]) {
            aVaule =  [NSJSONSerialization JSONObjectWithData:aVaule options:NSJSONReadingMutableContainers error:nil];
        }
        return aVaule;
    }
}

- (BOOL)jSONSerializationForType:(NSString*)type{
    NSArray *array = @[@"T@\"NSDictionary\"",@"T@\"NSMutableDictionary\"",@"T@\"NSMutableArray\"",@"T@\"NSArray\""];
    __block BOOL abool= NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        abool =abool || [obj isEqualToString:type];
    }];
    return abool;
}

#pragma mark - field Attributes 获取准备处理 如 personid varchar(64)
- (NSDictionary*)attributeTypeDic{
    if (!_attributeTypeDic) {
        NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
        Class aClass = self.contentClass;
        while (class_getSuperclass(aClass) != nil) {
            unsigned int outCount;
            objc_property_t *properties = class_copyPropertyList(aClass, &outCount);
            for (NSInteger index = 0; index < outCount; index++) {
                NSString *tmpName = [NSString stringWithFormat:@"%s",property_getName(properties[index])];
                NSString *tmpAttributes = [NSString stringWithFormat:@"%s",property_getAttributes(properties[index])];
                NSArray<NSString*> *attributes = [tmpAttributes componentsSeparatedByString:@","];
                dicM[tmpName] = attributes.firstObject;
            }
            
            if (properties) {
                free(properties);
            }
            aClass = class_getSuperclass(aClass);
        }
        dicM[[self insertTimeField]] = @"Td";
        _attributeTypeDic = [dicM copy];
    }
    return _attributeTypeDic;
}

// 类型的映射
- (NSArray *)conversionAttributeType:(NSString *)aType{
    NSString *str = jy_correspondingDic()[aType];
    if (str == nil) {
        if (self.correspondingDic) {
            str = self.correspondingDic[aType];
        }
    }
    NSAssert(str != nil, @"当前类型不支持");
    
    NSString *length = jy_defaultDic()[str];
    return @[str,length];
}


#pragma mark - Create Table
- (void)createTable:(FMDatabase *)aDB{
    [self configTableName];
    NSDictionary * typeDict = [self attributeTypeDic];
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendFormat:@"CREATE TABLE if not exists %@ ( ",self.tableName];
    [[self getAllContentField] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self conversionAttributeType:typeDict[obj]];
        NSString *lenght = [self fieldLenght][obj] == nil ? array.lastObject : [self fieldLenght][obj];
        [strM appendFormat:@"%@ %@(%@) ",obj,array.firstObject,lenght];
        if ([obj isEqualToString:[self contentId]]) {
            [strM appendString:@" NOT NULL"];
        }
        [strM appendString:@" , "];
    }];
    [strM appendFormat:@"PRIMARY KEY (%@) ON CONFLICT REPLACE)",[self contentId]];
//    //    NSLog(@"----------%@",strM);
    [aDB executeUpdate:[strM copy]];
    [self checkError:aDB];
    
    // 插入默认数据
    [self insertDefaultData:aDB];
}

#pragma mark - Upgrade
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion {
    NSAssert(NO, @"需要在子类重写该方法，建议使用 - (void)updateDB:(FMDatabase *)aDB 升级");
}

- (void)updateDB:(FMDatabase *)aDB{
    [self configTableName];
    NSArray<NSString *> *tablefields = [self getCurrentFields:aDB];
    if (tablefields.count <= 0) { // 表示该表未创建
        [self createTable:aDB];
        return;
    }
    NSArray<NSString *> *contentfields = [self getAllContentField];
    __block NSMutableArray *addfields = [contentfields mutableCopy];
    __block NSMutableArray *minusfields = [tablefields mutableCopy];
    [tablefields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [addfields removeObject:obj];
    }];
    
    [contentfields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [minusfields removeObject:obj];
    }];
    [self updateDB:aDB addFieldS:addfields];
    [self updateDB:aDB minusFieldS:minusfields];
}

- (NSArray<NSString*> *)getCurrentFields:(FMDatabase *)aDB{
    __block NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"PRAGMA table_info([%@])", self.tableName];
    FMResultSet *rs = [aDB executeQuery:sql];
    while([rs next]) {
        [arrayM addObject:[rs stringForColumn:@"name"]];
    }
    [rs close];
    [self checkError:aDB];
    return arrayM;
}

// 新增字段数组
- (void)updateDB:(FMDatabase *)aDB addFieldS:(NSArray<NSString*>*)aFields{
    NSDictionary * typeDict = [self attributeTypeDic];
    [aFields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self conversionAttributeType:typeDict[obj]];
        NSString *lenght = [self fieldLenght][obj] == nil ? array.lastObject : [self fieldLenght][obj];
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@(%@)", self.tableName,obj,array.firstObject,lenght];
        [aDB executeUpdate:sql];
        [self checkError:aDB];
    }];
}

// 删除字段 因为sqlLite没有提供类似ADD的方法，我们需要新建一个表然后删除原表
- (void)updateDB:(FMDatabase *)aDB minusFieldS:(NSArray<NSString*>*)aFields{
    if (aFields.count <= 0) {
        return;
    }
//    //    NSLog(@"多余字段%@",aFields);
    // 1.根据原表新建一个表
    NSString *tempTableName = [NSString stringWithFormat:@"temp_%@",self.tableName];
    __block NSMutableString *tableField = [[NSMutableString alloc] init];
    
    [[self getAllContentField] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:[self contentId]]) {
            [tableField appendString:@","];
        }
        [tableField appendFormat:@"%@",obj];
    }];
    NSString *sql = [NSString stringWithFormat:@"create table %@ as select %@ from %@", tempTableName,tableField,self.tableName];
    [aDB executeUpdate:sql];
    [self checkError:aDB];
    // 2.删除原表
    sql = [NSString stringWithFormat:@"drop table if exists %@", self.tableName];
    [aDB executeUpdate:sql];
    [self checkError:aDB];
    
    // 3.将tempTableName 该名为 table
    sql = [NSString stringWithFormat:@"alter table %@ rename to %@",tempTableName ,self.tableName];
    [aDB executeUpdate:sql];
    [self checkError:aDB];
    
    // 4.为新表添加唯一索引
    sql = [NSString stringWithFormat:@"create unique index '%@_key' on  %@(%@)", self.tableName,self.tableName,[self contentId]];
    [aDB executeUpdate:sql];
    [self checkError:aDB];
}

#pragma mark - insert 插入
- (void)insertDB:(FMDatabase *)aDB contents:(NSArray *)aContents{
    [self configTableName];
//    //    NSLog(@"insert %@",[aContents.firstObject class]);
    NSArray<NSString *> *fields = [self getAllContentField];
    // 1.插入语句拼接
    NSMutableString *strM = [[NSMutableString alloc] init];
    NSMutableString *strM1 = [[NSMutableString alloc] init];
    [strM appendFormat:@"INSERT OR REPLACE INTO %@(",self.tableName];
    [fields enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqualToString:[self contentId]]) {
            [strM appendString:@","];
            [strM1 appendString:@","];
        }
        [strM appendFormat:@" %@",obj];
        [strM1 appendFormat:@" ?"];
    }];
    [strM appendFormat:@") VALUES (%@)",strM1];
//    //    NSLog(@"-----%@",strM);
    
    // 2.一条条插入
    [aContents enumerateObjectsUsingBlock:^(id  _Nonnull aContent, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 断言消息 主key 不能为空
        NSString * ts = [NSString stringWithFormat:@"%@不能为空",[self contentId]];
        NSAssert([aContent valueForKey:[self contentId]], ts );

        // 2.1 获取参数
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        [fields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayM addObject:[self checkContent:aContent forKey:obj]];
        }];
        
        // 2.2 执行插入
        [aDB executeUpdate:[strM copy] withArgumentsInArray:[arrayM copy]];
        [self saveCacheContent:aContent];
    }];
    
    [self checkError:aDB];
}

- (void)insertContent:(id)aContent{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [self insertDB:db contents:@[aContent]];
    }];
}

- (void)insertContents:(NSArray *)aContents{
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [self insertDB:db contents:aContents];
    }];
}

#pragma mark - get 查询
- (NSArray *)getContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{
    [self configTableName];
    JYQueryConditions *conditions = [[JYQueryConditions alloc] init];
    if (block) {
        block(conditions);
    }
    NSArray<NSString *> *fields = [self getAllContentField];
    
#if DEBUG
    [conditions.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(([fields containsObject:obj[kField]]),@"该表不存在这个字段 -- %@",obj);
    }];
#endif
    
    NSMutableString *strM = conditions.conditionStr;
    
    NSString *sql;
    if (strM.length > 0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ %@", self.tableName, strM,conditions.orderStr];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@", self.tableName,conditions.orderStr];
    }

    //    NSLog(@"conditions -- %@",sql);
    FMResultSet *rs = [aDB executeQuery:sql];
    id content = nil;
    NSMutableArray *arrayM = nil;
    while([rs next]) {
        content = [[self.contentClass alloc] init];
        id value = [rs stringForColumn:[self contentId]];
        [content setValue:value forKey:[self contentId]];
        [fields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [rs objectForKeyedSubscript:obj];
            value = [self checkVaule:value forKey:obj];
            if (value != [NSNull null]) {
                [content setValue:value forKey:obj];
            }
        }];
        if (arrayM == nil) {
            arrayM = [[NSMutableArray alloc] init];
        }
        [self saveCacheContent:content];
        [arrayM addObject:content];
    }
    [rs close];
    [self checkError:aDB];
    return [arrayM copy];
}

- (NSArray *)getDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs{
    [self configTableName];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", self.tableName, [self contentId]];
    //    NSLog(@"contentByID--%@",sql);
     NSArray<NSString *> *fields = [self getAllContentField];
     __block NSMutableArray *arrayM = nil;
    [aIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull aID, NSUInteger idx, BOOL * _Nonnull stop) {
        
        id content = [self getCacheContentID:aID];
        if (content != nil) {
            if (arrayM == nil) {
                arrayM = [[NSMutableArray alloc] init];
            }
            [arrayM addObject:content];
        }else{
            
            FMResultSet *rs = [aDB executeQuery:sql,
                               [self checkEmpty:aID]];
            if ([rs next]) {
                id content = [[self.contentClass alloc] init];
                [fields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    id value = [rs objectForKeyedSubscript:obj];
                    value = [self checkVaule:value forKey:obj];
                    if (value != [NSNull null]) {
                        [content setValue:value forKey:obj];
                    }
                }];
                if (arrayM == nil) {
                    arrayM = [[NSMutableArray alloc] init];
                }
                [self saveCacheContent:content];
                [arrayM addObject:content];
            }
            [rs close];
        }
        
    }];
    
    [self checkError:aDB];
    return [arrayM copy];
}

- (NSArray *)getContentByConditions:(void (^)(JYQueryConditions *make))block{
    __block id contents = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        contents = [self getContentDB:db byconditions:block];
    }];
    return contents;
}

- (NSArray *)getContentByIDs:(NSArray<NSString*>*)aIDs{
    __block id contents = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        contents = [self getDB:db contentByIDs:aIDs];
    }];
    return contents;
}

- (id)getContentByID:(NSString*)aID{
    __block id content = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        content = [self getDB:db contentByIDs:@[aID]].firstObject;
    }];
    return content;
}

- (NSArray *)getAllContent{
    __block NSArray *array = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        array = [self getContentDB:db byconditions:nil];
    }];
    return array;
}
    
#pragma mark - delete 删除
- (void)deleteContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{
    [self configTableName];
    JYQueryConditions *conditions = [[JYQueryConditions alloc] init];
    if (block) {
        block(conditions);
    }
    
    NSArray<NSString *> *fields = [self getAllContentField];
    
#if DEBUG
    [conditions.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(([fields containsObject:obj[kField]]),@"该表不存在这个字段 -- %@",obj);
    }];
#endif
    
    NSMutableString *strM = conditions.conditionStr;
    NSString *sql;
    if (strM.length > 0) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", self.tableName, strM];
    }else{
        sql = [NSString stringWithFormat:@"DELETE FROM %@", self.tableName];
    }
    
    //    NSLog(@"delete conditions -- %@",sql);
    [aDB executeUpdate:sql];
    [self checkError:aDB];
    [self removeAllCache];
}

- (void)deleteDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs{
    [self configTableName];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", self.tableName, [self contentId]];
    //    NSLog(@"delete--%@",sql);
    [aIDs enumerateObjectsUsingBlock:^(NSString * _Nonnull aID, NSUInteger idx, BOOL * _Nonnull stop) {
        [aDB executeUpdate:sql,
        [self checkEmpty:aID]];
        [self removeCacheContentID:aID];
    }];
    [self checkError:aDB];
}

- (void)deleteContentByConditions:(void (^)(JYQueryConditions *make))block{
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        [self deleteContentDB:aDB byconditions:block];
    }];
}

- (void)deleteContentByID:(NSString *)aID{
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        [self deleteDB:aDB contentByIDs:@[aID]];
    }];
}

- (void)deleteContentByIDs:(NSArray<NSString *>*)aIDs{
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        [self deleteDB:aDB contentByIDs:aIDs];
    }];
}

- (void)deleteAllContent{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [self deleteContentDB:db byconditions:nil];
    }];
}

- (void)cleanContentBefore:(NSDate*)date{
    NSTimeInterval time = [NSDate date].timeIntervalSince1970;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [self deleteContentDB:db byconditions:^(JYQueryConditions *make) {
            make.field([self insertTimeField]).lessTo([NSString stringWithFormat:@"%f",time]);
        }];
    }];
}

#pragma mark - getCount
- (NSInteger)getCountContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{
    
    [self configTableName];
    JYQueryConditions *conditions = [[JYQueryConditions alloc] init];
    if (block) {
        block(conditions);
    }
    NSArray<NSString *> *fields = [self getAllContentField];
    
#if DEBUG
    [conditions.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(([fields containsObject:obj[kField]]),@"该表不存在这个字段 -- %@",obj);
    }];
#endif
    
    NSMutableString *strM = conditions.conditionStr;
    
    NSString *sql;
    if (strM.length > 0) {
        sql = [NSString stringWithFormat:@"select count(1) from %@ WHERE %@ ", self.tableName, strM];
    }else{
        sql = [NSString stringWithFormat:@"select count(1) from %@ ", self.tableName];
    }
    
    //    NSLog(@"conditions -- %@",sql);
    NSInteger count = 0;
    FMResultSet *rs = [aDB executeQuery:sql];
    while([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    [self checkError:aDB];
    return count;
}

- (NSInteger)getCountByConditions:(void (^)(JYQueryConditions *make))block{
    __block NSInteger count = 0;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        count = [self getCountContentDB:db byconditions:block];
    }];
    return count;
}

- (NSInteger)getAllCount{
    __block NSInteger count = 0;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        count = [self getCountContentDB:db byconditions:nil];
    }];
    return count;
}

#pragma mark - 缓存存取删
- (id)getCacheContentID:(NSString *)aID{
    if (aID.length <= 0 || ![self enableCache]) {
        return nil;
    }
    return [self.cache objectForKey:aID];
}

- (void)saveCacheContent:(id)aContent{
    if (aContent == nil || ![self enableCache]) {
        return;
    }
    [self.cache setObject:aContent forKey:[aContent valueForKey:[self contentId]]];
}

- (void)removeCacheContentID:(NSString *)aID{
    if (aID.length <= 0 || ![self enableCache]) {
        return;
    }
    [self.cache removeObjectForKey:aID];
}

- (void)removeAllCache{
    if (![self enableCache]) {
        return;
    }
    [self.cache removeAllObjects];
}

- (void)dealloc{
    //    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
