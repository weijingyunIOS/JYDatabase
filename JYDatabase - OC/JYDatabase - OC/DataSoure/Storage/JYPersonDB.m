//
//  JYPersonDB.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYPersonDB.h"
#define dataBaseName @"usersDataSource.db"

@interface JYPersonDB()

@property (nonatomic, strong) NSString * documentDirectory ;
@property (nonatomic, strong) JYPersonTable * personTable;
@property (nonatomic, strong) JYTest1Table * test1Table;

@end


@implementation JYPersonDB
+ (instancetype)storage{
    JYPersonDB *userStorage = [[JYPersonDB alloc] init];
    [userStorage construct];
    return userStorage;
}

- (void)construct{
    NSLog(@"%@",self.documentDirectory);
    [self buildWithPath:self.documentDirectory mode:ArtDatabaseModeWrite];
}

#pragma mark - 创建更新表
- (NSInteger)getCurrentDBVersion
{
    return 4;
}

- (void)createAllTable:(FMDatabase *)aDB{
    [self.personTable createTable:aDB];
    [self.test1Table createTable:aDB];
}

- (void)updateDB:(FMDatabase *)aDB{
    [self.personTable updateDB:aDB];
    [self.test1Table updateDB:aDB];
}

#pragma make - 懒加载
- (NSString *)documentDirectory{
    if (!_documentDirectory) {
        NSString *path = [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject] stringByAppendingPathComponent:@"usersDataSource"];
        
        NSFileManager* fm = [NSFileManager defaultManager];
        BOOL isDirectory = NO;
        if (![fm fileExistsAtPath:path isDirectory:&isDirectory] || !isDirectory) {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        _documentDirectory = [path stringByAppendingPathComponent:dataBaseName];
        
    }
    return _documentDirectory;
}

- (JYPersonTable *)personTable{
    if (!_personTable) {
        _personTable = [[JYPersonTable alloc] init];
        _personTable.dbQueue = self.dbQueue;
    }
    return _personTable;
}

- (JYTest1Table *)test1Table{
    if (!_test1Table) {
        _test1Table = [[JYTest1Table alloc] init];
        _test1Table.dbQueue = self.dbQueue;
    }
    return _test1Table;
}

@end
