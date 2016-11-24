//
//  JYClassTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYClassTable.h"
#import "JYClassInfo.h"
#import "JYPersonTable.h"
#import "JYDBService.h"
#import "JYPersonDB.h"

@implementation JYClassTable

- (void)configTableName{
    
    self.contentClass = [JYClassInfo class];
    self.tableName = @"JYClassTable";
}

- (NSString *)contentId{
    return @"classID";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"className",@"gradeID"];
}

// 设置关联的表
- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField{
    
    JYPersonTable *table = [JYDBService shared].personDB.personTable;
    // tableSortKey 不设置查询时会以主key做升序放入数组
    return @{
             @"teacher" : @{
                             tableContentObject : table,
                             tableViceKey       : @"teacherClassID"
                           },
             @"students" : @{
                             tableContentObject : table,
                             tableViceKey       : @"studentClassID",
                             tableSortKey       : @"studentIdx"
                           }
             };
}

// 为 gradeID 加上索引
- (void)addOtherOperationForTable:(FMDatabase *)aDB{
    [self addDB:aDB uniques:@[@"gradeID"]];
}

@end
