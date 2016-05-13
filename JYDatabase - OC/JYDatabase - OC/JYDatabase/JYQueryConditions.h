//
//  JYQueryConditions.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/13.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kField      @"kField"
#define kEqual      @"kequal"
#define kCompare    @"kcompare"

@interface JYQueryConditions : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<NSMutableDictionary*> *conditions;
@property (nonatomic, copy, readonly) NSMutableString *orderStr;

- (JYQueryConditions * (^)(NSString *compare))equalTo;
- (JYQueryConditions * (^)(NSString *compare))greaterThanOrEqualTo;
- (JYQueryConditions * (^)(NSString *compare))lessThanOrEqualTo;
- (JYQueryConditions * (^)(NSString *compare))greaterTo;
- (JYQueryConditions * (^)(NSString *compare))lessTo;

- (JYQueryConditions * (^)(NSString *field))field;
- (JYQueryConditions * (^)(NSString *field))asc;
- (JYQueryConditions * (^)(NSString *field))desc;

@end
