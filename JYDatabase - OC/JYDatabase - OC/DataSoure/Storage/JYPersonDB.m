//
//  JYPersonDB.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYPersonDB.h"
#import "JYGradeTable.h"
#import "JYClassTable.h"
#import "JYPersonTable.h"

#define dataBaseName @"usersDataSource.db"

@interface JYPersonDB()

@property (nonatomic, strong) NSString * documentDirectory ;
@property (nonatomic, strong) JYGradeTable  *gradeTable;
@property (nonatomic, strong) JYClassTable  *classTable;
@property (nonatomic, strong) JYPersonTable *personTable;

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
        self.gradeTable = (JYGradeTable *)[self registTableClass:[JYGradeTable class]];
        self.classTable = (JYClassTable *)[self registTableClass:[JYClassTable class]];
        self.personTable = (JYPersonTable *)[self registTableClass:[JYPersonTable class]];
    }];
    
}

#pragma mark - 数据库版本
- (NSInteger)getCurrentDBVersion
{
    return 8;
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
