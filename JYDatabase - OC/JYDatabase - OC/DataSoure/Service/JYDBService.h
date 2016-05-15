//
//  JYDBService.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYPersonDB.h"

@interface JYDBService : NSObject

+ (instancetype)shared;
- (void)insertPersonInfo:(JYPersonInfo *)aPersonInfo;
- (void)insertPersonInfos:(NSArray<JYPersonInfo *> *)aPersonInfos;

- (NSArray<JYPersonInfo *> *)getPersonInfoByConditions:(void (^)(JYQueryConditions *make))block;
- (JYPersonInfo *)getPersonInfo:(NSString*)aPersonInfoID;
- (NSArray<JYPersonInfo *> *)getPersonInfos:(NSArray<NSString *> *)aPersonInfoIDs;
- (NSArray<JYPersonInfo *> *)getAllPersonInfo;

- (void)deletePersonInfoByConditions:(void (^)(JYQueryConditions *make))block;
- (void)deletePersonInfos:(NSArray<NSString *>*)aPersonInfoIDs;
- (void)deletePersonInfo:(NSString *)aPersonInfoID;
- (void)deleteAllPersonInfo;
- (void)cleanPersonInfoBefore:(NSDate*)date;

@end
