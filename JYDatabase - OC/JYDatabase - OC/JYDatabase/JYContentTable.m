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
    [arrayM removeObject:[self contentId]];
    return [arrayM copy];
}

#pragma mark - field Attributes 获取准备处理 如 personid varchar(64)
- (NSDictionary*)attributeTypeDic{
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    unsigned int outCount;
    NSLog(@"%@",NSStringFromClass(self.contentClass));
    objc_property_t *properties = class_copyPropertyList(self.contentClass, &outCount);
    for (NSInteger index = 0; index < outCount; index++) {
        NSString *tmpName = [NSString stringWithFormat:@"%s",property_getName(properties[index])];
        NSString *tmpAttributes = [NSString stringWithFormat:@"%s",property_getAttributes(properties[index])];
        NSArray<NSString*> *attributes = [tmpAttributes componentsSeparatedByString:@","];
        dicM[tmpName] = attributes.firstObject;
    }
    
    if (properties) {
        free(properties);
    }
    return [dicM copy];
}

- (NSDictionary*)fieldLenght{
    return nil;
}

// 类型的映射
- (NSArray *)conversionAttributeType:(NSString *)aType{
    NSArray<NSString *> *array = @[@"TB",@"Td",@"Tf",@"Ti",@"Tq",@"TQ",@"T@\"NSMutableString\"",@"T@\"NSString\""];
    NSString *str = nil;
    NSString *length = nil;
    switch ([array indexOfObject:aType]) {
        case 0:
            str = @"BOOL";
            length = @"1";
            break;
            
        case 1:
            str = @"DOUBLE";
            length = @"10";
            break;
            
        case 2:
            str = @"FLOAT";
            length = @"10";
            break;
            
        case 3:
            str = @"INTEGER";
            length = @"10";
            break;
            
        case 4:
            str = @"INTEGER";
            length = @"10";
            break;
            
        case 5:
            str = @"INTEGER";
            length = @"10";
            break;
            
        case 6:
            str = @"VARCHAR";
            length = @"1";
            break;
            
        case 7:
            str = @"VARCHAR";
            length = @"1";
            break;
            
        default:
            NSAssert(YES, @"当前类型不支持");
            break;
    }
    return @[str,length];
}

#pragma mark - 查询的处理函数
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
    NSDictionary * typeDict = [self attributeTypeDic];
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendFormat:@"CREATE TABLE if not exists %@ (%@ varchar(64) NOT NULL, ",self.tableName,[self contentId]];
    [[self getContentField] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self conversionAttributeType:typeDict[obj]];
        NSString *lenght = [self fieldLenght][obj] == nil ? array.lastObject : [self fieldLenght][obj];
        [strM appendFormat:@"%@ %@(%@), ",obj,array.firstObject,lenght];
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
    __block NSMutableArray *addfields = [contentfields mutableCopy];
    __block NSMutableArray *minusfields = [tablefields mutableCopy];
    [tablefields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [addfields removeObject:obj];
    }];
    
    [minusfields removeObject:[self contentId]];
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
    NSLog(@"多余字段%@",aFields);
    // 1.根据原表新建一个表
    NSString *tempTableName = [NSString stringWithFormat:@"temp_%@",self.tableName];
    __block NSMutableString *tableField = [[NSMutableString alloc] init];
    [[self getContentField] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tableField appendFormat:@",%@",obj];
    }];
    NSString *sql = [NSString stringWithFormat:@"create table %@ as select %@%@ from %@", tempTableName,[self contentId],tableField,self.tableName];
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
