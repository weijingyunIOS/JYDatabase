//
//  JYContentTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYContentTable.h"
#import "FMDB.h"
#import <objc/runtime.h>

@interface JYContentTable()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation JYContentTable

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
        [self configTableName];
    }
    return self;
}

- (void)configTableName{
    
}

- (void)insertDefaultData:(FMDatabase *)aDb{
    
}

- (NSString *)contentId{
    return nil;
}

- (NSArray<NSString *> *)getContentField{
    
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    unsigned int outCount;
    NSLog(@"%@",NSStringFromClass(self.contentClass));
    objc_property_t *properties = class_copyPropertyList(self.contentClass, &outCount);
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
    
    NSAssert([self contentId].length > 0, @"主键不能为空");
    NSLog(@"contentID : %@",[self contentId]);
    [arrayM removeObject:[self contentId]];
    return [arrayM copy];
}

- (void)checkError:(FMDatabase *)aDb
{
    if ([aDb hadError]) {
        NSLog(@"DB Err %d: %@", [aDb lastErrorCode], [aDb lastErrorMessage]);
    }
}

- (id)checkEmpty:(id)aObject
{
    return aObject == nil ? [NSNull null] : aObject;
}

#pragma mark - Create Table
- (void)createTable:(FMDatabase *)aDB{
    [self configTableName];
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendFormat:@"CREATE TABLE if not exists %@ (%@ varchar(64) NOT NULL, ",self.tableName,[self contentId]];
    [[self getContentField] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@ varchar(256), ",obj];
    }];
    [strM appendFormat:@"PRIMARY KEY (%@) ON CONFLICT REPLACE)",[self contentId]];
    NSLog(@"----------%@",strM);
    [aDB executeUpdate:[strM copy]];
    [self checkError:aDB];
    
    // 插入默认数据
    [self insertDefaultData:aDB];
}

#pragma mark - Upgrade
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion {
    
    NSArray<NSString *> *tablefields = [self getCurrentFields:aDB];
    NSArray<NSString *> *contentfields = [self getContentField];
    __block NSMutableArray *fields = [contentfields mutableCopy];
    [tablefields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fields removeObject:obj];
    }];
    
    [self updateDB:aDB addFieldS:fields];
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
    [aFields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ varchar(128)", self.tableName,obj];
        [aDB executeUpdate:sql];
        [self checkError:aDB];
    }];
}

#pragma mark - Operation
//- (void)insertContents:(NSArray *)aContents{
//    [self configTableName];
//    
//    id aContent = aContents.firstObject;
//    NSLog(@"insert %@",[aContent class]);
//    NSString * ts = [NSString stringWithFormat:@"%@不能为空",[self contentId]];
//    NSAssert([aContent valueForKey:[self contentId]], ts);
//    
//    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
//    [arrayM addObject:[aContent valueForKey:[self contentId]]];
//    [[self getContentField] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [arrayM addObject:[self checkEmpty:[aContent valueForKey:obj]]];
//    }];
//    
//    __weak JYContentTable *weakSelf = self;
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        [aContents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//        }];
//    }];
//    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
//        
//    
//        NSMutableString *strM = [[NSMutableString alloc] init];
//        NSMutableString *strM1 = [[NSMutableString alloc] initWithString:@"?"];
//        [strM appendFormat:@"INSERT OR REPLACE INTO %@(%@",weakSelf.tableName,[weakSelf contentId]];
//        [[weakSelf getContentField] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [strM appendFormat:@", %@",obj];
//            [strM1 appendFormat:@",?"];
//        }];
//        [strM appendFormat:@") VALUES (%@)",strM1];
//        
//        NSLog(@"-----%@",strM);
//        [aDB executeUpdate:[strM copy] withArgumentsInArray:[arrayM copy]];
//        [weakSelf checkError:aDB];
//    }];
//}

- (void)insertContent:(id)aContent{
    [self configTableName];
    
    NSLog(@"insert %@",[aContent class]);
    NSString * ts = [NSString stringWithFormat:@"%@不能为空",[self contentId]];
    NSAssert([aContent valueForKey:[self contentId]], ts);
    [self saveCacheContent:aContent];
    
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    [arrayM addObject:[aContent valueForKey:[self contentId]]];
    [[self getContentField] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arrayM addObject:[self checkEmpty:[aContent valueForKey:obj]]];
    }];
    
    __weak JYContentTable *weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        NSMutableString *strM = [[NSMutableString alloc] init];
        NSMutableString *strM1 = [[NSMutableString alloc] initWithString:@"?"];
        [strM appendFormat:@"INSERT OR REPLACE INTO %@(%@",weakSelf.tableName,[weakSelf contentId]];
        [[weakSelf getContentField] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [strM appendFormat:@", %@",obj];
            [strM1 appendFormat:@",?"];
        }];
        [strM appendFormat:@") VALUES (%@)",strM1];
        
        NSLog(@"-----%@",strM);
        [aDB executeUpdate:[strM copy] withArgumentsInArray:[arrayM copy]];
        [weakSelf checkError:aDB];
    }];
}


- (id)getContentByID:(NSString*)aID{
    [self configTableName];
    
    NSLog(@"getContentByID %@",aID);
    if ([self.cache objectForKey:aID]) {
        return [self.cache objectForKey:aID];
    }
    
    __weak JYContentTable *weakSelf = self;
    __block id content = nil;
    [self.dbQueue inTransaction:^(FMDatabase *aDB, BOOL *aRollback) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", weakSelf.tableName, [weakSelf contentId]];
        FMResultSet *rs = [aDB executeQuery:sql,
                           [weakSelf checkEmpty:aID]];
        
        if ([rs next]) {
            content = [[weakSelf.contentClass alloc] init];
            id value = [rs stringForColumn:[weakSelf contentId]];
            [content setValue:value forKey:[weakSelf contentId]];
            [[weakSelf getContentField] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = [rs stringForColumn:obj];
                [content setValue:value forKey:obj];
            }];
            [weakSelf saveCacheContent:content];
        }
        
        [rs close];
        [weakSelf checkError:aDB];
    }];
    return content;
}

- (NSArray *)getAllContent{
    [self configTableName];
    
    NSLog(@"getAllContent %@",[self class]);
    __weak JYContentTable *weakSelf = self;
    __block id content = nil;
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    [self.dbQueue inTransaction:^(FMDatabase *aDB, BOOL *aRollback) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", weakSelf.tableName];
        NSLog(@"%@",sql);
        FMResultSet *rs = [aDB executeQuery:sql];
        
        while([rs next]) {
            content = [[weakSelf.contentClass alloc] init];
            id value = [rs stringForColumn:[weakSelf contentId]];
            [content setValue:value forKey:[weakSelf contentId]];
            NSArray *contentFieldArray = [weakSelf getContentField];
            [contentFieldArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                id value = [rs stringForColumn:obj];
                [content setValue:value forKey:obj];
            }];
            [weakSelf saveCacheContent:content];
            [arrayM addObject:content];
        }
        
        [rs close];
        [weakSelf checkError:aDB];
    }];
    return [arrayM copy];
}

- (void)deleteContent:(NSString *)aID{
    [self configTableName];
    
    NSLog(@"deleteContent %@",aID);
    __weak JYContentTable *weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", weakSelf.tableName, [weakSelf contentId]];
        [aDB executeUpdate:sql,
         [weakSelf checkEmpty:aID]];
        [weakSelf checkError:aDB];
        [weakSelf removeCacheContentID:aID];
    }];
}

- (void)deleteContents{
    [self configTableName];
    __weak JYContentTable *weakSelf = self;
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", weakSelf.tableName];
        [aDB executeUpdate:sql];
        [weakSelf checkError:aDB];
        [weakSelf.cache removeAllObjects];
    }];
}

- (void)saveCacheContent:(id)aContent{
    [self.cache setObject:aContent forKey:[aContent valueForKey:[self contentId]]];
}

- (void)removeCacheContentID:(NSString *)aID{
    [self.cache removeObjectForKey:aID];
}

- (void)dealloc{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
