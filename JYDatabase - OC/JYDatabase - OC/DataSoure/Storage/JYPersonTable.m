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
    return @"personnumber";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"mutableString1",@"integer1",@"uInteger1",@"int1",@"bool1",@"double1"];
}

- (BOOL)enableCache{
    return NO;
}

@end
