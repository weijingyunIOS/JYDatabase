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
    [self buildWithPath:self.documentDirectory mode:ArtDatabaseModeWrite registTable:^{
        //注册数据表 建议外引出来，用于其它位置调用封装
        self.personTable = (JYPersonTable *)[self registTableClass:[JYPersonTable class]];
        self.test1Table = (JYTest1Table *)[self registTableClass:[JYTest1Table class]];
    }];
    
}

#pragma mark - 数据库版本
- (NSInteger)getCurrentDBVersion
{
    return 15;
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

@end
