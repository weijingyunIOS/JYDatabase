//
//  JYPersonTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYPersonTable.h"

@implementation JYPersonTable

- (void)configTableName{

    self.contentClass = [JYPersonInfo class];
    self.tableName = @"JYPersonTable";
}

- (NSString *)contentId{
    return @"PersonID";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"mutableString1",@"array",@"arrayM",@"dic",@"dicM",@"integer1",
             @"uInteger1",@"int1",@"bool1",@"double1",@"float1",@"cgfloat1",
             @"data",@"number",@"image",@"value",
             @"teacherClassID",@"studentClassID"];
}

// 为 studentClassID teacherClassID 加上索引
- (void)addOtherOperationForTable:(FMDatabase *)aDB{
    [self addDB:aDB uniques:@[@"teacherClassID",@"studentClassID"]];
}

// 不使用缓存，开发中建议打开
- (BOOL)enableCache{
    return NO;
}

@end
