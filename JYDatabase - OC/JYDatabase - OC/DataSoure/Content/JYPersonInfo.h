//
//  JYPersonInfo.h
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JYPersonInfo : NSObject

//存数据库属性
@property (nonatomic, copy) NSString * personnumber;   // 人员编号
@property (nonatomic, copy) NSString * iconDB;         // 照片地址
@property (nonatomic, copy) NSString * addressDB;      // 地址
//@property (nonatomic, copy) NSString * nameDB;         // 姓名
//@property (nonatomic, assign) NSInteger genderDB;      // 性别 0男 1女
//@property (nonatomic, copy) NSString * birthdateDB;    // 出生年月
@property (nonatomic, copy) NSString * phonenumberDB;  // 联系方式
@property (nonatomic, assign) double resultsDB;        // 成绩
@property (nonatomic, assign) int intDB;
@property (nonatomic, assign) CGFloat floatDB;
@property (nonatomic, copy) NSString * qqphonenumberDB;
@property (nonatomic, copy) NSString * add1DB;
@property (nonatomic, copy) NSString * add2DB;
@property (nonatomic, copy) NSString * add3DB;
@property (nonatomic, copy) NSString * add4DB;

@end
