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

// 类型测试
@property (nonatomic, copy)   NSMutableString                           *mutableString1;
@property (nonatomic, strong) NSArray<NSString *>                       *array;
@property (nonatomic, strong) NSMutableArray<NSString *>                *arrayM;
@property (nonatomic, strong) NSDictionary<NSString *, NSString*>       *dic;
@property (nonatomic, strong) NSMutableDictionary<NSString *,NSString*> *dicM;
@property (nonatomic, assign) NSInteger                                 integer1;
@property (nonatomic, assign) NSUInteger                                uInteger1;
@property (nonatomic, assign) int                                       int1;
@property (nonatomic, assign) BOOL                                      bool1;
@property (nonatomic, assign) double                                    double1;
@property (nonatomic, assign) float                                     float1;
@property (nonatomic, assign) CGFloat                                   cgfloat1;
@property (nonatomic, strong) NSData                                    *data;
@property (nonatomic, strong) NSNumber                                  *number;
@property (nonatomic, strong) UIImage                                   *image;   // 不建议图片直接存数据库

@end
