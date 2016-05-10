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
        
    });
    return globalService;
}

# pragma mark JYPersonInfo operation

- (void)updatePersonInfo:(JYPersonInfo *)aPersonInfo{
    [self.personDB.personTable insertContent:aPersonInfo];
}

- (JYPersonInfo *)getPersonInfo:(NSString*)aPersonInfo{
    return [self.personDB.personTable getContentByID:aPersonInfo];
}
- (NSArray<JYPersonInfo *> *)getAllPersonInfo{
    return [self.personDB.personTable getAllContent];
}

- (void)deletePersonInfo:(NSString *)aPersonInfoid{
    [self.personDB.personTable deleteContent:aPersonInfoid];
}

#pragma mark - 懒加载
- (JYPersonDB *)personDB{
    if (!_personDB) {
        _personDB = [JYPersonDB storage];
    }
    return _personDB;
}

@end
