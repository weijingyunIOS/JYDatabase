//
//  JYDBService.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDBService.h"
#import "JYPersonDB.h"
#import "JYGradeTable.h"
#import "JYGradeInfo.h"
#import "JYClassTable.h"
#import "JYClassInfo.h"
#import "JYPersonTable.h"
#import "JYPersonInfo.h"

@interface JYDBService ()

@property (nonatomic, strong) JYPersonDB *personDB;

@end

@implementation JYDBService

+ (instancetype)shared{
    static JYDBService *globalService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        globalService = [[JYDBService alloc] init];
        globalService.personDB = [JYPersonDB storage];
    });
    return globalService;
}

# pragma mark JYGradeInfo operation
- (void)insertGradeInfo:(JYGradeInfo *)aGradeInfo{
    [self.personDB.gradeTable insertContent:aGradeInfo];
}

- (void)insertGradeInfos:(NSArray<JYGradeInfo *> *)aGradeInfos{
    [self.personDB.gradeTable insertContents:aGradeInfos];
}

- (void)insertIndependentGradeInfo:(JYGradeInfo *)aGradeInfo{
    [self.personDB.gradeTable insertIndependentContent:aGradeInfo];
}

- (void)insertIndependentGradeInfos:(NSArray<JYGradeInfo *> *)aGradeInfos{
    [self.personDB.gradeTable insertIndependentContents:aGradeInfos];
}

- (NSArray<JYGradeInfo *> *)getGradeInfoByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.gradeTable getContentByConditions:block];
}

- (JYGradeInfo *)getGradeInfo:(NSString*)aGradeInfoID{
    return [self.personDB.gradeTable getContentByID:aGradeInfoID];
}

- (NSArray<JYGradeInfo *> *)getGradeInfos:(NSArray<NSString *> *)aGradeInfoIDs{
    return [self.personDB.gradeTable getContentByIDs:aGradeInfoIDs];
}

- (NSArray<JYGradeInfo *> *)getAllGradeInfo{
    return [self.personDB.gradeTable getAllContent];
}

- (void)deleteGradeInfoByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.gradeTable deleteContentByConditions:block];
}

- (void)deleteGradeInfos:(NSArray<NSString *>*)aGradeInfoIDs{
    [self.personDB.gradeTable deleteContentByIDs:aGradeInfoIDs];
}

- (void)deleteGradeInfo:(NSString *)aGradeInfoID{
    [self.personDB.gradeTable deleteContentByID:aGradeInfoID];
}

- (void)deleteAllGradeInfo{
    [self.personDB.gradeTable deleteAllContent];
}

- (void)cleanGradeInfoBefore:(NSDate*)date{
    [self.personDB.gradeTable cleanContentBefore:date];
}

- (NSInteger)getGradeInfoCountByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.gradeTable getCountByConditions:block];
}

- (NSInteger)getGradeInfoAllCount{
    return [self.personDB.gradeTable getAllCount];
}


# pragma mark JYClassInfo operation
- (void)insertClassInfo:(JYClassInfo *)aClassInfo{
    [self.personDB.classTable insertContent:aClassInfo];
}

- (void)insertClassInfos:(NSArray<JYClassInfo *> *)aClassInfos{
    [self.personDB.classTable insertContents:aClassInfos];
}

- (void)insertIndependentClassInfo:(JYClassInfo *)aClassInfo{
    [self.personDB.classTable insertIndependentContent:aClassInfo];
}

- (void)insertIndependentClassInfos:(NSArray<JYClassInfo *> *)aClassInfos{
    [self.personDB.classTable insertIndependentContents:aClassInfos];
}

- (NSArray<JYClassInfo *> *)getClassInfoByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.classTable getContentByConditions:block];
}

- (JYClassInfo *)getClassInfo:(NSString*)aClassInfoID{
    return [self.personDB.classTable getContentByID:aClassInfoID];
}

- (NSArray<JYClassInfo *> *)getClassInfos:(NSArray<NSString *> *)aClassInfoIDs{
    return [self.personDB.classTable getContentByIDs:aClassInfoIDs];
}

- (NSArray<JYClassInfo *> *)getAllClassInfo{
    return [self.personDB.classTable getAllContent];
}

- (void)deleteClassInfoByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.classTable deleteContentByConditions:block];
}

- (void)deleteClassInfos:(NSArray<NSString *>*)aClassInfoIDs{
    [self.personDB.classTable deleteContentByIDs:aClassInfoIDs];
}

- (void)deleteClassInfo:(NSString *)aClassInfoID{
    [self.personDB.classTable deleteContentByID:aClassInfoID];
}

- (void)deleteAllClassInfo{
    [self.personDB.classTable deleteAllContent];
}

- (void)cleanClassInfoBefore:(NSDate*)date{
    [self.personDB.classTable cleanContentBefore:date];
}

- (NSInteger)getClassInfoCountByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.classTable getCountByConditions:block];
}

- (NSInteger)getClassInfoAllCount{
    return [self.personDB.classTable getAllCount];
}

# pragma mark JYPersonInfo operation
- (void)insertPersonInfo:(JYPersonInfo *)aPersonInfo{
    [self.personDB.personTable insertContent:aPersonInfo];
}

- (void)insertPersonInfos:(NSArray<JYPersonInfo *> *)aPersonInfos{
    [self.personDB.personTable insertContents:aPersonInfos];
}

- (void)insertIndependentPersonInfo:(JYPersonInfo *)aPersonInfo{
    [self.personDB.personTable insertIndependentContent:aPersonInfo];
}

- (void)insertIndependentPersonInfos:(NSArray<JYPersonInfo *> *)aPersonInfos{
    [self.personDB.personTable insertIndependentContents:aPersonInfos];
}

- (NSArray<JYPersonInfo *> *)getPersonInfoByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.personTable getContentByConditions:block];
}

- (JYPersonInfo *)getPersonInfo:(NSString*)aPersonInfoID{
    return [self.personDB.personTable getContentByID:aPersonInfoID];
}

- (NSArray<JYPersonInfo *> *)getPersonInfos:(NSArray<NSString *> *)aPersonInfoIDs{
    return [self.personDB.personTable getContentByIDs:aPersonInfoIDs];
}

- (NSArray<JYPersonInfo *> *)getAllPersonInfo{
    return [self.personDB.personTable getAllContent];
}

- (void)deletePersonInfoByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.personTable deleteContentByConditions:block];
}

- (void)deletePersonInfos:(NSArray<NSString *>*)aPersonInfoIDs{
    [self.personDB.personTable deleteContentByIDs:aPersonInfoIDs];
}

- (void)deletePersonInfo:(NSString *)aPersonInfoID{
    [self.personDB.personTable deleteContentByID:aPersonInfoID];
}

- (void)deleteAllPersonInfo{
    [self.personDB.personTable deleteAllContent];
}

- (void)cleanPersonInfoBefore:(NSDate*)date{
    [self.personDB.personTable cleanContentBefore:date];
}

- (NSInteger)getPersonInfoCountByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.personTable getCountByConditions:block];
}

- (NSInteger)getPersonInfoAllCount{
    return [self.personDB.personTable getAllCount];
}

@end
