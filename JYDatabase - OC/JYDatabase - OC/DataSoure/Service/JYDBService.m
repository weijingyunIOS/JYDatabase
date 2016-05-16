//
//  JYDBService.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDBService.h"

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

# pragma mark JYPersonInfo operation
- (void)insertPersonInfo:(JYPersonInfo *)aPersonInfo{
    [self.personDB.personTable insertContent:aPersonInfo];
}

- (void)insertPersonInfos:(NSArray<JYPersonInfo *> *)aPersonInfos{
    [self.personDB.personTable insertContents:aPersonInfos];
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


# pragma mark JYTest1Content operation
- (void)insertTest1Content:(JYTest1Content *)aTest1Content{
    [self.personDB.test1Table insertContent:aTest1Content];
}

- (void)insertTest1Contents:(NSArray<JYTest1Content *> *)aTest1Contents{
    [self.personDB.test1Table insertContents:aTest1Contents];
}

- (NSArray<JYTest1Content *> *)getTest1ContentByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.test1Table getContentByConditions:block];
}

- (JYTest1Content *)getTest1Content:(NSString*)aTest1ContentID{
    return [self.personDB.test1Table getContentByID:aTest1ContentID];
}

- (NSArray<JYTest1Content *> *)getTest1Contents:(NSArray<NSString *> *)aTest1ContentIDs{
    return [self.personDB.test1Table getContentByIDs:aTest1ContentIDs];
}

- (NSArray<JYTest1Content *> *)getAllTest1Content{
    return [self.personDB.test1Table getAllContent];
}

- (void)deleteTest1ContentByConditions:(void (^)(JYQueryConditions *make))block{
    return [self.personDB.test1Table deleteContentByConditions:block];
}

- (void)deleteTest1Contents:(NSArray<NSString *>*)aTest1ContentIDs{
    [self.personDB.test1Table deleteContentByIDs:aTest1ContentIDs];
}

- (void)deleteTest1Content:(NSString *)aTest1ContentID{
    [self.personDB.test1Table deleteContentByID:aTest1ContentID];
}

- (void)deleteAllTest1Content{
    [self.personDB.test1Table deleteAllContent];
}

- (void)cleanTest1ContentBefore:(NSDate*)date{
    [self.personDB.test1Table cleanContentBefore:date];
}



@end
