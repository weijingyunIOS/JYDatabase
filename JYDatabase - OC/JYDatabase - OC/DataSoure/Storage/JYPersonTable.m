//
//  JYPersonTable.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYPersonTable.h"
#import "JYTest1Table.h"

@implementation JYPersonTable

- (void)configTableName{

    self.contentClass = [JYPersonInfo class];
    self.tableName = @"JYPersonTable";
}

- (NSString *)contentId{
    return @"personnumber";
}

- (NSArray<NSString *> *)getContentField{
    return @[@"mutableString1",@"integer1",@"uInteger1",@"int1",@"bool1",@"double1",@"data",@"image",@"name",@"desc"];
}

- (NSDictionary<NSString *, NSDictionary *> *)associativeTableField{
    
    JYTest1Table *table = [[JYTest1Table alloc] init];
    table.dbQueue = self.dbQueue;
    return @{
             @"test1Contents":@{
                     tableContentObject: table,
                     tablePrimaryKey   : @"testID",
                     tableViceKey      : @"personID"
                     
                              },
             @"test1":@{
                     tableContentObject: table,
                     tablePrimaryKey   : @"testID",
                     tableViceKey      : @"testPersonID"
                     
                     }
             };
}

//- (BOOL)enableCache{
//    return NO;
//}

@end
