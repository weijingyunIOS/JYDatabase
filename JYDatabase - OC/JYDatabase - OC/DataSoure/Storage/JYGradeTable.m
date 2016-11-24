//
//  JYGradeTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYGradeTable.h"
#import "JYGradeInfo.h"
#import "JYClassTable.h"
#import "JYDBService.h"
#import "JYPersonDB.h"

@implementation JYGradeTable

- (void)configTableName{
    
    self.contentClass = [JYGradeInfo class];
    self.tableName = @"JYGradeTable";
}

- (NSString *)contentId{
    return @"gradeID";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"gradeName"];
}

// 设置关联的表
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField{
    
    JYClassTable *table = [JYDBService shared].personDB.classTable;
    return @{
             @"allClass" : @{
                             tableContentObject : table,
                             tableViceKey       : @"gradeID"
                            }
             };
}

// 为 gradeID 加上索引
- (void)addOtherOperationForTable:(FMDatabase *)aDB{
    [self addDB:aDB uniques:@[@"gradeID"]];
}

@end
