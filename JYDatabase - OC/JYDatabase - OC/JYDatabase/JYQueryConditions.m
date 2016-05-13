//
//  JYQueryConditions.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/13.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYQueryConditions.h"

@interface JYQueryConditions()

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary*> *conditions;

@end

@implementation JYQueryConditions

- (JYQueryConditions * (^)(NSString *field))field{
    return ^id(NSString *field) {
        NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
        dicM[kField] = field;
        [self.conditions addObject:dicM];
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *compare))equalTo{
    return ^id(NSString *compare) {
         NSMutableDictionary *dicM = self.conditions.lastObject;
         dicM[kEqual] = @"=";
         dicM[kCompare] = compare;
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *compare))greaterThanOrEqualTo{
    return ^id(NSString *compare) {
        NSMutableDictionary *dicM = self.conditions.lastObject;
        dicM[kEqual] = @">=";
        dicM[kCompare] = compare;
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *compare))lessThanOrEqualTo{
    return ^id(NSString *compare) {
        NSMutableDictionary *dicM = self.conditions.lastObject;
        dicM[kEqual] = @"<=";
        dicM[kCompare] = compare;
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *compare))greaterTo{
    return ^id(NSString *compare) {
        NSMutableDictionary *dicM = self.conditions.lastObject;
        dicM[kEqual] = @">";
        dicM[kCompare] = compare;
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *compare))lessTo{
    return ^id(NSString *compare) {
        NSMutableDictionary *dicM = self.conditions.lastObject;
        dicM[kEqual] = @"<";
        dicM[kCompare] = compare;
        return self;
    };
}

#pragma mark - 懒加载
- (NSMutableArray<NSMutableDictionary *> *)conditions{
    if (!_conditions) {
        _conditions = [[NSMutableArray alloc] init];
    }
    return _conditions;
}

@end
