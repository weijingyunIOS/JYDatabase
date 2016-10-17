//
//  JYQueryConditions.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/13.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kField      @"kField"

@interface JYQueryConditions : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NSMutableDictionary*> *conditions;
@property (nonatomic, copy, readonly) NSMutableString *orderStr;
@property (nonatomic, strong) NSMutableString *conditionStr;

//以该字段结尾，表示 条件是 或 如 userId = 1 或 userId = 2, 否则就是 AND
- (JYQueryConditions * (^)())OR;

- (JYQueryConditions * (^)(NSString *compare))notEqualTo;
- (JYQueryConditions * (^)(NSString *compare))equalTo;
- (JYQueryConditions * (^)(NSString *compare))greaterThanOrEqualTo;
- (JYQueryConditions * (^)(NSString *compare))lessThanOrEqualTo;
- (JYQueryConditions * (^)(NSString *compare))greaterTo;
- (JYQueryConditions * (^)(NSString *compare))lessTo;

- (JYQueryConditions * (^)(NSString *field))field;
- (JYQueryConditions * (^)(NSString *field))asc;
- (JYQueryConditions * (^)(NSString *field))desc;

//以该字段结尾，表示 条件是 或 如 userId = 1 或 userId = 2, 否则就是 AND 与sqlStr 配对
- (JYQueryConditions * (^)())sqlOR;
- (JYQueryConditions * (^)(NSString *str))sqlStr;

@end
