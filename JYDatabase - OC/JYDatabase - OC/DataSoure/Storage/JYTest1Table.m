//
//  JYTest1Table.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/16.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYTest1Table.h"

@implementation JYTest1Table

- (void)configTableName{
    
    self.contentClass = [JYTest1Content class];
    self.tableName = @"JYTest1Table";
    self.isDistinguish = YES;
}

- (NSString *)contentId{
    return @"testID";
}

- (BOOL)enableCache{
    return NO;
}

@end
