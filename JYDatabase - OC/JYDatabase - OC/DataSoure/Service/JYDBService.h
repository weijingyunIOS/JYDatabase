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
- (JYPersonInfo *)getPersonInfo:(NSString*)aPersonInfo;
- (NSArray<JYPersonInfo *> *)getAllPersonInfo;
- (void)deletePersonInfo:(NSString *)aPersonInfoid;

@end
