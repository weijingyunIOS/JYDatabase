//
//  JYPersonTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYPersonTable.h"

@implementation JYPersonTable

- (instancetype)init{
    
    if (self = [super init]) {
        [self configTableName];
    }
    
    return self;
}

- (void)configTableName{
    
    self.contentClass = [JYPersonInfo class];
    self.tableName = @"JYPersonTable";
}

- (NSString *)contentId{
    return @"personnumber";
}

- (BOOL)enableCache{
    return NO;
}

@end
