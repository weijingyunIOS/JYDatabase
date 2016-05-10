//
//  JYPersonInfo.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYPersonInfo : NSObject

//存数据库属性
@property (nonatomic, copy) NSString * personnumber;   // 人员编号
@property (nonatomic, copy) NSString * iconDB;         // 照片地址
@property (nonatomic, copy) NSString * addressDB;      // 地址
@property (nonatomic, copy) NSString * nameDB;         // 姓名
@property (nonatomic, copy) NSString * genderDB;       // 性别 男 女
@property (nonatomic, copy) NSString * birthdateDB;    // 出生年月
@property (nonatomic, copy) NSString * phonenumberDB;  // 联系方式

@end
