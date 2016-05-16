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


- (void)insertTest1Content:(JYTest1Content *)aTest1Content;
- (void)insertTest1Contents:(NSArray<JYTest1Content *> *)aTest1Contents;

- (NSArray<JYTest1Content *> *)getTest1ContentByConditions:(void (^)(JYQueryConditions *make))block;
- (JYTest1Content *)getTest1Content:(NSString*)aTest1ContentID;
- (NSArray<JYTest1Content *> *)getTest1Contents:(NSArray<NSString *> *)aTest1ContentIDs;
- (NSArray<JYTest1Content *> *)getAllTest1Content;

- (void)deleteTest1ContentByConditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteTest1Contents:(NSArray<NSString *>*)aTest1ContentIDs;
- (void)deleteTest1Content:(NSString *)aTest1ContentID;
- (void)deleteAllTest1Content;
- (void)cleanTest1ContentBefore:(NSDate*)date;

@end
