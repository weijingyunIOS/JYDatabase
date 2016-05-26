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
@property (nonatomic, copy) NSMutableString *orderStr;
@property (nonatomic, strong) NSMutableArray<NSString *> *sqlStrings;

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

- (JYQueryConditions * (^)(NSString *field))asc{
    return ^id(NSString *field) {
        [self orderAppendType:@"asc" field:field];
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *field))desc{
    return ^id(NSString *field) {
        [self orderAppendType:@"desc" field:field];
        return self;
    };
}

- (void)orderAppendType:(NSString *)aType field:(NSString *)aField{
    if (self.orderStr.length <= 0) {
        [self.orderStr appendString:@" order by "];
    }else{
        [self.orderStr appendString:@","];
    }
    [self.orderStr appendFormat:@" %@ %@ ",aField,aType];
}



- (JYQueryConditions * (^)(NSString *compare))equalTo{
    return ^id(NSString *compare) {
         NSMutableDictionary *dicM = self.conditions.lastObject;
         dicM[kEqual] = @"=";
         dicM[kCompare] = compare;
        return self;
    };
}

- (JYQueryConditions * (^)(NSString *compare))notEqualTo{
    return ^id(NSString *compare) {
        NSMutableDictionary *dicM = self.conditions.lastObject;
        dicM[kEqual] = @"!=";
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

- (JYQueryConditions * (^)(NSString *str))sqlStr{
    return ^id(NSString *str) {
        [self.sqlStrings addObject:str];
        return self;
    };
}

- (NSMutableString *)conditionStr{
    __block NSMutableString *strM = [[NSMutableString alloc] init];
    [self.conditions enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [strM appendFormat:@"%@ %@ \"%@\"",obj[kField],obj[kEqual],obj[kCompare]];
        if (idx < self.conditions.count - 1) {
            [strM appendFormat:@" AND "];
        }
    }];
    
    if (self.sqlStrings.count > 0) {
        
        [self.sqlStrings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!(idx == 0 && self.conditions.count <= 0)) {
                [strM appendFormat:@" AND "];
            }
            [strM appendString:obj];
        }];
    }
    return strM;
}

#pragma mark - 懒加载
- (NSMutableArray<NSMutableDictionary *> *)conditions{
    if (!_conditions) {
        _conditions = [[NSMutableArray alloc] init];
    }
    return _conditions;
}

- (NSMutableString *)orderStr{
    if (!_orderStr) {
        _orderStr = [[NSMutableString alloc] init];
    }
    return _orderStr;
}

- (NSMutableArray<NSString *> *)sqlStrings{
    if (!_sqlStrings) {
        _sqlStrings = [[NSMutableArray alloc] init];
    }
    return _sqlStrings;
}

@end
