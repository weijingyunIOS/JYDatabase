//
//  GKDatabase.m
//
//
//  Created by weijingyun on 5/26/15.
//  Copyright (c) 2015 justone. All rights reserved.
//

#import "JYDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#if FMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif

@interface JYDataBase ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSString* path;
@property (nonatomic, assign) ArtDatabaseMode mode;

@end

@implementation JYDataBase

#pragma mark - Custom Methods

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

- (void)addUpdateValue:(id)aValue key:(NSString *)aKey inParams:(NSMutableDictionary *)aParams
{
    if (aValue) {
        [aParams setObject:aValue forKey:aKey];
    } else {
        [aParams setObject:[NSNull null] forKey:aKey];
    }
}

#pragma mark - init

- (void)buildWithPath:(NSString *)aPath mode:(ArtDatabaseMode)aMode
{
    self.path = aPath;
    self.mode = aMode;
    
    if (aMode == ArtDatabaseModeRead)
    {
        // 只读
        self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:aPath flags:SQLITE_OPEN_READONLY];
    }
    else
    {
        // 读写 或 创建
        self.dbQueue = [[FMDatabaseQueue alloc] initWithPath:aPath];
    }
    
    __weak JYDataBase *weakSelf = self;
    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *version = [weakSelf getVersion:db];
        if (version == nil) {
            [self createDBVersionTable:db];
            [self createAllTable:db];
            [self updateVersion:db];
        }else if([version integerValue] != [self getCurrentDBVersion]){
            [self updateDB:db fromVersion:[version integerValue]];
            [self updateVersion:db];
        }
    }];
}

- (void)dealloc
{
    [self.dbQueue close];
}

#pragma mark - version

- (NSInteger)getCurrentDBVersion
{
    return 1;
}

- (NSString *)getVersion:(FMDatabase *)aDB
{
    NSString* version = nil;
    FMResultSet *rs = [aDB executeQuery:@"SELECT Version FROM gkdb_version WHERE Name = 'version'"];
    while ([rs next]) {
        version = [rs stringForColumnIndex:0];
    }
    [rs close];
    return version;
}

- (void)updateVersion:(FMDatabase *)aDB
{
    NSString* version = [self getVersion:aDB];
    
    if (version)
    {
        [aDB executeUpdate:@"UPDATE gkdb_version SET Version=? WHERE Name = 'version'", @([self getCurrentDBVersion])];
        [self checkError:aDB];
    } else {
        [aDB executeUpdate:@"INSERT INTO gkdb_version (Name, Version) VALUES(?,?)" , @"version", @([self getCurrentDBVersion])];
        [self checkError:aDB];
    }
}


- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion
{
    NSInteger from = aFromVersion;
    NSInteger to = [self getCurrentDBVersion];
    while (from < to) {
        [self updateDB:aDB fromVersion:from toVersion:from + 1];
        ++from;
    }
}

- (void)updateDB:(FMDatabase *)aDB fromVersion:(NSInteger)aFromVersion toVersion:(NSInteger)aToVersion
{
    
}

#pragma mark - Create Table

- (void)createAllTable:(FMDatabase *)aDB
{
}

- (void)createDBVersionTable:(FMDatabase *)aDB
{
    [aDB executeUpdate:@"CREATE TABLE gkdb_version (Version varchar(20), Name varchar(10))"];
    [self checkError:aDB];
}

@end

