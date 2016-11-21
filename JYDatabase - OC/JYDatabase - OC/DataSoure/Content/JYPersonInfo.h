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

// 人员编号
@property (nonatomic, copy) NSString *PersonID;

/* 主要演示 class  包含老师和学生
*  这里要 两个副key区分，老师设置teacherClassID 学生 studentClassID
*  否则会有问题，开发过程中表的设计应该避免这样。老师和学生用两张表处理
*/
@property (nonatomic, copy) NSString *teacherClassID;
@property (nonatomic, copy) NSString *studentClassID;

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
@property (nonatomic, strong) NSValue                                   *value;

@end
