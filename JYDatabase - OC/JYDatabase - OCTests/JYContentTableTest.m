//
//  JYContentTableTest.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/11/21.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JYDBService.h"
#import "JYGradeInfo.h"
#import "JYClassInfo.h"
#import "JYPersonInfo.h"

@interface JYContentTableTest : XCTestCase

@end

@implementation JYContentTableTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    JYGradeInfo *gradeInfo = [self getGradeInfo];
    // 插入数据
    [[JYDBService shared] insertGradeInfo:gradeInfo];
    // 查询数据
    JYGradeInfo *queryGradeInfo = [[JYDBService shared] getGradeInfo:gradeInfo.gradeID];
    BOOL isEqual = [self gradeInfo:gradeInfo equalTo:queryGradeInfo];
    XCTAssert(isEqual);
    //修改数据再插入
    gradeInfo.gradeName = @"修改后的 gradeName";
    [[JYDBService shared] insertGradeInfo:gradeInfo];
    
    // 查询出全部的
    NSArray<JYGradeInfo*>*queryGradeInfos = [[JYDBService shared] getAllGradeInfo];
    [queryGradeInfos enumerateObjectsUsingBlock:^(JYGradeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.gradeID isEqualToString:gradeInfo.gradeID]) {
            XCTAssert([obj.gradeName isEqualToString:@"修改后的 gradeName"]);
            *stop = YES;
        }
    }];
    
    //删除该条数据
    [[JYDBService shared] deleteGradeInfo:gradeInfo.gradeID];
    
    //最后获取为空
    queryGradeInfo = [[JYDBService shared] getGradeInfo:gradeInfo.gradeID];
    XCTAssert(queryGradeInfo == nil);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (JYGradeInfo *)getGradeInfo{
    
    JYGradeInfo *gradeInfo = [[JYGradeInfo alloc] init];
    gradeInfo.gradeID = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    gradeInfo.gradeName = @"gradeName";
    gradeInfo.allClass = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < 10; i ++) {
        JYClassInfo *classInfo = [self getClassInfoForGradeID:gradeInfo.gradeID];
        [gradeInfo.allClass addObject:classInfo];
    }
    return gradeInfo;
}

- (JYClassInfo *)getClassInfoForGradeID:(NSString *)gradeID{
    
    JYClassInfo *classInfo = [[JYClassInfo alloc] init];
    classInfo.classID = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    classInfo.gradeID = gradeID;
    classInfo.className = @"className";
    classInfo.teacher = [self getPersonInfoForTeacherClassID:classInfo.classID studentClassID:nil];
    classInfo.students = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i ++) {
        JYPersonInfo *student = [self getPersonInfoForTeacherClassID:nil studentClassID:classInfo.classID];
        [classInfo.students addObject:student];
    }
    return classInfo;
}

- (JYPersonInfo *)getPersonInfoForTeacherClassID:(NSString *)teacherClassID studentClassID:(NSString *)studentClassID{
    
    JYPersonInfo *personInfo = [[JYPersonInfo alloc] init];
    personInfo.PersonID = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    personInfo.teacherClassID = teacherClassID;
    personInfo.studentClassID = studentClassID;
    personInfo.mutableString1 = [@"mutableString1" mutableCopy];
    personInfo.array = @[@"array1",@"array2"];
    personInfo.arrayM = [@[@"arrayM1",@"arrayM2"] mutableCopy];
    personInfo.dic = @{@"dic11":@"dic12",
                       @"dic21":@"dic22"
                       };
    personInfo.dicM = [@{@"dicM11":@"dicM12",
                         @"dicM21":@"dicM22"
                         } mutableCopy];
    personInfo.integer1 = -100;
    personInfo.uInteger1 = 100;
    personInfo.int1 = 10;
    personInfo.bool1 = YES;
    personInfo.double1 = 2.5;
    personInfo.float1 = 0.33;
    personInfo.cgfloat1 = 3.333;
    personInfo.number = [NSNumber numberWithDouble:0.55];
    return personInfo;
}

- (BOOL)gradeInfo:(JYGradeInfo *)gradeInfo1 equalTo:(JYGradeInfo *)gradeInfo2{
    
    __block BOOL isEqual = YES;
    NSArray<NSString *>*keys = @[@"gradeID",@"gradeName"];
    isEqual &= [self mode:gradeInfo1 equalTo:gradeInfo2 forKeys:keys];
    [gradeInfo1.allClass enumerateObjectsUsingBlock:^(JYClassInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        isEqual &= [self classInfo:obj equalTo:gradeInfo2.allClass[idx]];
    }];
    return isEqual;

}


- (BOOL)classInfo:(JYClassInfo *)classInfo1 equalTo:(JYClassInfo *)classInfo2{
    
    __block BOOL isEqual = YES;
    NSArray<NSString *>*keys = @[@"classID",@"gradeID",@"className"];
    isEqual &= [self mode:classInfo1 equalTo:classInfo2 forKeys:keys];
    isEqual &= [self personInfo:classInfo1.teacher equalTo:classInfo2.teacher];
    [classInfo1.students enumerateObjectsUsingBlock:^(JYPersonInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        isEqual &= [self personInfo:obj equalTo:classInfo2.students[idx]];
    }];
    return isEqual;
}

- (BOOL)personInfo:(JYPersonInfo *)personInfo1 equalTo:(JYPersonInfo *)personInfo2{
    
    __block BOOL isEqual = YES;
    NSArray<NSString *>*keys = @[@"PersonID",@"teacherClassID",@"studentClassID"];
    isEqual &= [self mode:personInfo1 equalTo:personInfo2 forKeys:keys];
    [personInfo1.array.firstObject isEqualToString:personInfo2.array.firstObject];
    [personInfo1.arrayM.firstObject isEqualToString:personInfo2.arrayM.firstObject];
    [personInfo1.dic[@"dic11"] isEqualToString:personInfo2.dic[@"dic11"]];
    [personInfo1.dicM[@"dic12"] isEqualToString:personInfo2.dicM[@"dic12"]];
    // 浮点数会有些许偏差
    isEqual &= personInfo1.integer1 == personInfo2.integer1;
    isEqual &= personInfo1.uInteger1 == personInfo2.uInteger1;
    isEqual &= labs(personInfo1.int1 - personInfo2.int1) < 0.00001;
    isEqual &= personInfo1.bool1 == personInfo2.bool1;
    isEqual &= fabs(personInfo1.double1 - personInfo2.double1) < 0.00001;
    isEqual &= fabsf(personInfo1.float1 - personInfo2.float1) < 0.00001;
    isEqual &= fabs(personInfo1.cgfloat1 - personInfo2.cgfloat1) < 0.00001;
    return isEqual;
}

// 只支持简单的 NSString 检测
- (BOOL)mode:(id)model1 equalTo:(id)model2 forKeys:(NSArray<NSString *> *)keys{
    __block BOOL isEqual = YES;
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id v1 = [model1 valueForKey:obj];
        id v2 = [model2 valueForKey:obj];
        if (v1 == nil && v2 == nil) {
            
        }else if ([v1 isKindOfClass:[NSString class]]) {
            isEqual &= [[v1 copy] isEqual:[v2 copy]];
            if (!isEqual) {
                NSLog(@"%@--%@",v1,v2);
            }
        }else{
            isEqual = NO;
            NSLog(@"%@--%@不支持该类型检测",v1,v2);
        }
    }];
    return isEqual;
}

@end
