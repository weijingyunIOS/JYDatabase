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
@property (nonatomic, copy) NSString * name;   
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSMutableString *mutableString1;
@property (nonatomic, assign) NSInteger integer1;
@property (nonatomic, assign) NSUInteger uInteger1;
@property (nonatomic, assign) int int1;
@property (nonatomic, assign) BOOL bool1;
@property (nonatomic, assign) double double1;
@property (nonatomic, assign) float float1;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) UIImage *image;


@end
