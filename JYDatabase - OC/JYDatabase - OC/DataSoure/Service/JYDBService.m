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

- (void)deletePersonInfos:(NSArray<NSString *>*)aPersonInfoids{
    [self.personDB.personTable deleteContentByIDs:aPersonInfoids];
}

- (void)deletePersonInfo:(NSString *)aPersonInfoid{
    [self.personDB.personTable deleteContentByID:aPersonInfoid];
}

- (void)deleteAllPersonInfo{
    [self.personDB.personTable deleteAllContent];
}

- (void)cleanPersonBefore:(NSDate*)date{
    [self.personDB.personTable cleanContentBefore:date];
}

@end
