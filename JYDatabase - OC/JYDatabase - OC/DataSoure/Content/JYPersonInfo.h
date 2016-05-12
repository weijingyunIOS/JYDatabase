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
@property (nonatomic, copy) NSMutableString *mutableStringDB;
@property (nonatomic, assign) NSInteger integertDB;
@property (nonatomic, assign) NSUInteger uIntegerDB;
@property (nonatomic, assign) int intDB;
@property (nonatomic, assign) BOOL boolDB;
@property (nonatomic, assign) double doubleDB;
@property (nonatomic, assign) float floatDB;

//@property (nonatomic, copy) NSMutableString *mutableString1DB;
//@property (nonatomic, assign) NSInteger integert1DB;
//@property (nonatomic, assign) NSUInteger uInteger1DB;
//@property (nonatomic, assign) int int1DB;
//@property (nonatomic, assign) BOOL bool1DB;
@property (nonatomic, assign) double double3DB;
//@property (nonatomic, assign) float float1DB;


@end
