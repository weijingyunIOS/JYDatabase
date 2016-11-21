//
//  JYDBService.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYGradeInfo,JYClassInfo,JYPersonInfo,JYQueryConditions;

@interface JYDBService : NSObject

+ (instancetype)shared;

#pragma mark - 以下代码由 DEMO 中 JYGenerationCode 工具生成
# pragma mark JYGradeInfo operation
- (void)insertGradeInfo:(JYGradeInfo *)aGradeInfo;
- (void)insertGradeInfos:(NSArray<JYGradeInfo *> *)aGradeInfos;
- (void)insertIndependentGradeInfo:(JYGradeInfo *)aGradeInfo;
- (void)insertIndependentGradeInfos:(NSArray<JYGradeInfo *> *)aGradeInfos;

- (NSArray<JYGradeInfo *> *)getGradeInfoByConditions:(void (^)(JYQueryConditions *make))block;
- (JYGradeInfo *)getGradeInfo:(NSString*)aGradeInfoID;
- (NSArray<JYGradeInfo *> *)getGradeInfos:(NSArray<NSString *> *)aGradeInfoIDs;
- (NSArray<JYGradeInfo *> *)getAllGradeInfo;

- (void)deleteGradeInfoByConditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteGradeInfos:(NSArray<NSString *>*)aGradeInfoIDs;
- (void)deleteGradeInfo:(NSString *)aGradeInfoID;
- (void)deleteAllGradeInfo;
- (void)cleanGradeInfoBefore:(NSDate*)date;

# pragma mark JYClassInfo operation
- (void)insertClassInfo:(JYClassInfo *)aClassInfo;
- (void)insertClassInfos:(NSArray<JYClassInfo *> *)aClassInfos;
- (void)insertIndependentClassInfo:(JYClassInfo *)aClassInfo;
- (void)insertIndependentClassInfos:(NSArray<JYClassInfo *> *)aClassInfos;

- (NSArray<JYClassInfo *> *)getClassInfoByConditions:(void (^)(JYQueryConditions *make))block;
- (JYClassInfo *)getClassInfo:(NSString*)aClassInfoID;
- (NSArray<JYClassInfo *> *)getClassInfos:(NSArray<NSString *> *)aClassInfoIDs;
- (NSArray<JYClassInfo *> *)getAllClassInfo;

- (void)deleteClassInfoByConditions:(void (^)(JYQueryConditions *make))block;
- (void)deleteClassInfos:(NSArray<NSString *>*)aClassInfoIDs;
- (void)deleteClassInfo:(NSString *)aClassInfoID;
- (void)deleteAllClassInfo;
- (void)cleanClassInfoBefore:(NSDate*)date;

# pragma mark JYPersonInfo operation
- (void)insertPersonInfo:(JYPersonInfo *)aPersonInfo;
- (void)insertPersonInfos:(NSArray<JYPersonInfo *> *)aPersonInfos;
- (void)insertIndependentPersonInfo:(JYPersonInfo *)aPersonInfo;
- (void)insertIndependentPersonInfos:(NSArray<JYPersonInfo *> *)aPersonInfos;

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
