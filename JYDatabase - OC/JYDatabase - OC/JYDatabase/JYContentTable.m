//
//  JYContentTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYContentTable.h"
#import "JYDataBaseConfig.h"
#import <UIKit/UIKit.h>
#import "FMDB.h"
#import <objc/runtime.h>

#if DEBUG

#else

#define NSLog(...)

#endif

static const NSInteger JYDeleteMaxCount = 500;

@interface JYContentTable()

@property (nonatomic, strong) NSCache *cache;
@property (nonatomic, strong) NSDictionary *attributeTypeDic;
@property (nonatomic, strong, readonly) NSString *insertTimeField;

@end

@implementation JYContentTable{
    NSArray<NSString *> *_independentContentField; // 独立的字段表
}

#pragma mark - 创建 JYContentTable 的是一个单例
- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
    });
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

- (void)addOtherOperationForTable:(FMDatabase *)aDB{
    
}

- (BOOL)enableCache{
    return YES;
}

- (NSDictionary*)fieldLenght{
    return nil;
}

- (NSString *)contentId{
    return nil;
}

- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField{
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

#pragma mark - 字段的获取
// 需要存表的独立字段
- (NSArray<NSString *> *)getIndependentContentField{
    if (!_independentContentField) {
        NSMutableArray<NSString *> *arrayM = [[NSMutableArray alloc] init];
        // 保证 contentId 在第一个位置
        [arrayM addObject:[self contentId]];
        [arrayM addObjectsFromArray:[self getContentField]];
        [arrayM addObject:self.insertTimeField];
        _independentContentField = [arrayM copy];
    }
    return _independentContentField;
}

// 特殊字段 与其它表有关联的
- (NSArray<NSString *> *)getSpecialContentField{
    return self.associativeTableField.allKeys;
}

#pragma mark - 查询的处理函数
- (void)checkError:(FMDatabase *)aDb
{
#if DEBUG
    
    if ([aDb hadError]) {
        NSLog(@"DB Err %d: %@", [aDb lastErrorCode], [aDb lastErrorMessage]);
    }
    
#else
    
#endif
}

// 数据预处理
- (id)checkEmpty:(id)aObject
{
    return aObject == nil ? [NSNull null] : aObject;
}

// 插入时数据处理
- (id)checkContent:(id)aContent forKey:(NSString *)akey{
    
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

- (BOOL)jSONSerializationForType:(NSString *)type{
    NSArray *array = @[@"T@\"NSDictionary\"",@"T@\"NSMutableDictionary\"",@"T@\"NSMutableArray\"",@"T@\"NSArray\""];
    __block BOOL abool= NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        abool =abool || [obj isEqualToString:type];
    }];
    return abool;
}

- (BOOL)isArrayForAttributeName:(NSString *)aKey{
    NSString *type = [self attributeTypeDic][aKey];
    NSArray *array = @[@"T@\"NSMutableArray\"",@"T@\"NSArray\""];
    __block BOOL abool= NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        abool =abool || [obj isEqualToString:type];
    }];
    return abool;
}

// 特殊字段需要插入其它表
- (void)insertSpecialFieldDB:(FMDatabase *)aDB content:(id)aContent forKey:(NSString *)akey{
    
    @autoreleasepool {
        // 需要存入表的对象以及关系描述
        NSArray *fieldObject = [aContent valueForKey:akey];
        if (fieldObject == nil) {
            return;
        }
        if (![fieldObject isKindOfClass:[NSArray class]]) {
            fieldObject = @[fieldObject];
        }
        NSDictionary *dic = self.associativeTableField[akey];
        JYContentTable *table = dic[tableContentObject];
        NSAssert([table isKindOfClass:[JYContentTable class]], @"tableContentObject 对应的必须是继承 JYContentTable类的对象");
        NSString *viceKey = dic[tableViceKey];
        
        id contentIdValue = [aContent valueForKey:self.contentId];
        [table deleteContentDB:aDB byconditions:^(JYQueryConditions *make) {
            make.field(viceKey).equalTo(contentIdValue);
        }];
        [fieldObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj setValue:contentIdValue forKey:viceKey];
        }];
        [table insertDB:aDB contents:fieldObject];
    }
}

// 特殊字段要从其它表拿数据
- (void)getSpecialFieldDB:(FMDatabase *)aDB content:(id)aContent forKey:(NSString *)akey{
    
    @autoreleasepool {
        
        NSDictionary *dic = self.associativeTableField[akey];
        JYContentTable *table = dic[tableContentObject];
        NSAssert([table isKindOfClass:[JYContentTable class]], @"tableContentObject 对应的必须是继承 JYContentTable类的对象");
        NSString *viceKey = dic[tableViceKey];
        id contentIdValue = [aContent valueForKey:self.contentId];
        NSArray *specialFieldValue = [table getContentDB:aDB byconditions:^(JYQueryConditions *make) {
            make.field(viceKey).equalTo(contentIdValue);
        }];
        if ([self isArrayForAttributeName:akey]) {
            [aContent setValue:specialFieldValue forKey:akey];
        }else{
    #if DEBUG
            NSString *assertStr = [NSString stringWithFormat:@"%@ 所包含的 %@ 字段对应表%@ 数据异常，该字段查询出来应该只有一个值现在出现了多个值,代码删除，插入可能有问题",self,akey,table];
            NSAssert(specialFieldValue.count < 2, assertStr);
    #endif
            [aContent setValue:specialFieldValue.firstObject forKey:akey];
        }
    }
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
- (NSArray *)conversionAttributeName:(NSString *)aField{
    NSString *aType = self.attributeTypeDic[aField];
#if DEBUG
    NSString *assertStr = [NSString stringWithFormat:@"该属性找不到对应类型 %@",aField];
    NSAssert(aType != nil,assertStr);
#endif
    
    NSString *str = jy_correspondingDic()[aType];
    if (str == nil) {
        if ([JYDataBaseConfig shared].corresponding) {
            str = [JYDataBaseConfig shared].corresponding[aType];
        }
    }
#if DEBUG
    NSString *assertStr1 = [NSString stringWithFormat:@"%@属性的对应类型%@ 找不到，请设置JYDataBaseConfig中的 corresponding 属性添加，并到gitHub留言告知我，谢谢",aField,aType];
    NSAssert(str != nil,assertStr1);
#endif
    NSString *length = jy_defaultDic()[str];
    return @[str,length];
}

#pragma mark - Create Table
- (void)createTable:(FMDatabase *)aDB{
   
    NSMutableString *strM = [[NSMutableString alloc] init];
    [strM appendFormat:@"CREATE TABLE if not exists %@ ( ",self.tableName];
    [self.getIndependentContentField enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *array = [self conversionAttributeName:obj];
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
    
    // 添加额外的操作
    [self addOtherOperationForTable:aDB];
    
    // 插入默认数据
    [self insertDefaultData:aDB];
}

#pragma mark - Upgrade
- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion {
    NSAssert(NO, @"需要在子类重写该方法，建议使用 - (void)updateDB:(FMDatabase *)aDB 升级");
}

- (void)updateDB:(FMDatabase *)aDB{
 
    NSArray<NSString *> *tablefields = [self getCurrentFields:aDB];
    if (tablefields.count <= 0) { // 表示该表未创建
        [self createTable:aDB];
        return;
    }
    NSArray<NSString *> *allFields = self.getIndependentContentField;
    __block NSMutableArray *addfields = [allFields mutableCopy];
    __block NSMutableArray *minusfields = [tablefields mutableCopy];
    [tablefields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [addfields removeObject:obj];
    }];
    
    [allFields enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [minusfields removeObject:obj];
    }];
    [self updateDB:aDB addFieldS:addfields];
    [self updateDB:aDB minusFieldS:minusfields];

    // 5.添加额外的操作 如索引
    [self addOtherOperationForTable:aDB];
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
        NSArray *array = [self conversionAttributeName:obj];
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
    
    [self.getIndependentContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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

#pragma mark - 索引添加
// 默认添加 非聚集索引
- (void)addUniques:(NSArray<NSString *>*)indexs{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
       [self addDB:db uniques:indexs];
    }];
}

// 默认添加 非聚集索引
- (void)addDB:(FMDatabase *)aDB uniques:(NSArray<NSString *>*)indexs{
    [self addDB:aDB type:EJYDataBaseIndexNonclustered uniques:indexs];
}

- (void)addDB:(FMDatabase *)aDB type:(EJYDataBaseIndex)aType uniques:(NSArray<NSString *>*)indexs{
    NSString *str = @"create unique index";
    switch (aType) {
            
        case EJYDataBaseIndexCompositeIndex:
        case EJYDataBaseIndexNonclustered:
            str = @"CREATE INDEX";
            break;
            
        case EJYDataBaseIndexOnlyIndex:
            str = @"create unique index";
            break;
            
        default:
            break;
    }
    str = [NSString stringWithFormat:@"%@ if not exists",str];
    
    if (aType != EJYDataBaseIndexCompositeIndex) {
        [indexs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *sql = [NSString stringWithFormat:@"%@ '%@%@_key' on  %@(%@)",str,self.tableName,obj,self.tableName,obj];
            [aDB executeUpdate:sql];
            [self checkError:aDB];
        }];
        return;
    }
    
    NSMutableString *strM = [[NSMutableString alloc] init];
    [indexs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [strM appendString:@","];
        }
        [strM appendString:obj];
    }];
    
    NSString *sql = [NSString stringWithFormat:@"%@ '%@CompositeIndex_key' on  %@(%@)",str,self.tableName,self.tableName,strM];
    [aDB executeUpdate:sql];
    [self checkError:aDB];
}

#pragma mark - insert 插入
- (void)insertDB:(FMDatabase *)aDB contents:(NSArray *)aContents{
    
    if (aContents.count <= 0) {
        return;
    }
    
    // 1.插入语句拼接
    NSMutableString *strM = [[NSMutableString alloc] init];
    NSMutableString *strM1 = [[NSMutableString alloc] init];
    [strM appendFormat:@"INSERT OR REPLACE INTO %@(",self.tableName];
    [self.getIndependentContentField enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        
#if DEBUG
        NSString * ts = [NSString stringWithFormat:@"%@不能为空",[self contentId]];
        NSAssert([aContent valueForKey:[self contentId]], ts );
#endif
        // 特殊字段的参数处理
        [self.getSpecialContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self insertSpecialFieldDB:aDB content:aContent forKey:obj];
        }];
        
        // 2.1 获取参数
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        // 基本字段的参数处理
        [self.getIndependentContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arrayM addObject:[self checkContent:aContent forKey:obj]];
        }];
        
        // 2.2 执行插入
        [aDB executeUpdate:[strM copy] withArgumentsInArray:[arrayM copy]];
        if (![aDB hadError]) {
           [self saveCacheContent:aContent];
        }
    }];
    
    [self checkError:aDB];
}

- (void)insertContent:(id)aContent{
    if (aContent == nil) {
        return;
    }
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [self insertDB:db contents:@[aContent]];
    }];
}

- (void)insertContents:(NSArray *)aContents{
    if (aContents.count <= 0) {
        return;
    }
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [self insertDB:db contents:aContents];
    }];
}

#pragma mark - get 查询
- (NSArray *)getContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{
 
    JYQueryConditions *conditions = [[JYQueryConditions alloc] init];
    if (block) {
        block(conditions);
    }
    
#if DEBUG
    [conditions.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(([self.getIndependentContentField containsObject:obj[kField]]),@"该表不存在这个字段 -- %@",obj);
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
        [self.getIndependentContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id value = [rs objectForKeyedSubscript:obj];
            value = [self checkVaule:value forKey:obj];
            if (value != [NSNull null]) {
                [content setValue:value forKey:obj];
            }
        }];
        if (arrayM == nil) {
            arrayM = [[NSMutableArray alloc] init];
        }
        
        [self.getSpecialContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self getSpecialFieldDB:aDB content:content forKey:obj];
        }];
        if (![aDB hadError]) {
            [self saveCacheContent:content];
        }
        [arrayM addObject:content];
    }
    [rs close];
    [self checkError:aDB];
    return [arrayM copy];
}

- (NSArray *)getDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs{
    if (aIDs.count <= 0) {
        return nil;
    }
    return [self togetherArray:aIDs maxCount:JYDeleteMaxCount traverse:^(JYQueryConditions *make, NSString *obj) {
        make.field(self.contentId).equalTo(obj).OR();
    } complete:^NSArray *(id block) {
        return [self getContentDB:aDB byconditions:block];
    }];
}

- (NSArray *)getContentByConditions:(void (^)(JYQueryConditions *make))block{
    __block id contents = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        contents = [self getContentDB:db byconditions:block];
    }];
    return contents;
}

- (NSArray *)getContentByIDs:(NSArray<NSString*>*)aIDs{
    if (aIDs.count <= 0) {
        return nil;
    }
    __block id contents = nil;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        contents = [self getDB:db contentByIDs:aIDs];
    }];
    return contents;
}

- (id)getContentByID:(NSString*)aID{
    if (aID == nil) {
        return nil;
    }
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
// 只删除本表内容不删除关联表内容
- (void)deleteIndependentContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{

    JYQueryConditions *conditions = [[JYQueryConditions alloc] init];
    if (block) {
        block(conditions);
    }
    
#if DEBUG
    [conditions.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(([self.getIndependentContentField containsObject:obj[kField]]),@"该表不存在这个字段 -- %@",obj);
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

// 删除关联表的数据
- (void)deleteSpecialContentDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs{
    if (aIDs.count <= 0) {
        return;
    }
    [self.getSpecialContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull field, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary*dic = self.associativeTableField[field];
        JYContentTable *table = dic[tableContentObject];
        NSString *viceKey = dic[tableViceKey];
        [self togetherArray:aIDs maxCount:JYDeleteMaxCount traverse:^(JYQueryConditions *make, NSString *contentID) {
            make.field(viceKey).equalTo(contentID).OR();
        } complete:^NSArray *(id block) {
            [table deleteContentDB:aDB byconditions:block];
            return nil;
        }];
    }];
}

- (NSArray *)togetherArray:(NSArray<NSString *> *)aArray maxCount:(NSInteger)aMaxCount traverse:(void(^)(JYQueryConditions*,NSString *))aTraverse complete:(NSArray*(^)(id))aComplete{
    
    NSInteger traverseCount = 0;
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    while ((NSInteger)aArray.count != traverseCount) {
        NSInteger count = traverseCount + aMaxCount;
        count = count > aArray.count ? aArray.count : count;
        id block = ^(JYQueryConditions*make){
            for (NSInteger i = traverseCount; i < count; i ++) {
                aTraverse(make,aArray[i]);
            }
        };
        NSArray* array = aComplete(block);
        if (array != nil) {
            [arrayM addObjectsFromArray:array];
        }
        traverseCount = count;
    }
    return [arrayM copy];
}

// 删除本表以及关联表内容
- (void)deleteContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{
    NSArray * deleteContents = [self getContentDB:aDB byconditions:block];
    if (deleteContents.count <= 0) {
        return; // 没数据不删除
    }
    NSArray<NSString *> *deleteIDs = [deleteContents valueForKeyPath:self.contentId];
    // 删除本表
    [self deleteIndependentContentDB:aDB byconditions:block];
    // 删除关联表
    [self deleteSpecialContentDB:aDB contentByIDs:deleteIDs];
 
}

- (void)deleteDB:(FMDatabase *)aDB contentByIDs:(NSArray<NSString*>*)aIDs{
    if (aIDs.count <= 0) {
        return;
    }
    // 删除本表aIDs
    [self togetherArray:aIDs maxCount:JYDeleteMaxCount traverse:^(JYQueryConditions *make, NSString *obj) {
        make.field(self.contentId).equalTo(obj).OR();
    } complete:^NSArray *(id block) {
        [self deleteIndependentContentDB:aDB byconditions:block];
        return nil;
    }];
    [self deleteSpecialContentDB:aDB contentByIDs:aIDs];
}

- (void)deleteContentByConditions:(void (^)(JYQueryConditions *make))block{
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        [self deleteContentDB:aDB byconditions:block];
    }];
}

- (void)deleteContentByID:(NSString *)aID{
    if (aID == nil) {
        return;
    }
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        [self deleteDB:aDB contentByIDs:@[aID]];
    }];
}

- (void)deleteContentByIDs:(NSArray<NSString *>*)aIDs{
    if (aIDs.count <= 0) {
        return;
    }
    [self.dbQueue inDatabase:^(FMDatabase *aDB) {
        [self deleteDB:aDB contentByIDs:aIDs];
    }];
}

- (void)deleteAllContent{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [self deleteIndependentContentDB:db byconditions:nil];
        [self.getSpecialContentField enumerateObjectsUsingBlock:^(NSString * _Nonnull field, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary*dic = self.associativeTableField[field];
            JYContentTable *table = dic[tableContentObject];
            NSString *viceKey = dic[tableViceKey];
            [table deleteContentDB:db byconditions:^(JYQueryConditions *make) {
                make.field(viceKey).notEqualTo(@"");
            }];
        }];
    }];
}

- (void)cleanContentBefore:(NSDate*)date{
    NSTimeInterval time = date.timeIntervalSince1970;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [self deleteContentDB:db byconditions:^(JYQueryConditions *make) {
            make.field([self insertTimeField]).lessTo([NSString stringWithFormat:@"%f",time]);
        }];
    }];
}

#pragma mark - getCount
- (NSInteger)getCountContentDB:(FMDatabase *)aDB byconditions:(void (^)(JYQueryConditions *make))block{
    
    JYQueryConditions *conditions = [[JYQueryConditions alloc] init];
    if (block) {
        block(conditions);
    }
    
#if DEBUG
    [conditions.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSAssert(([self.getIndependentContentField containsObject:obj[kField]]),@"该表不存在这个字段 -- %@",obj);
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

@end
