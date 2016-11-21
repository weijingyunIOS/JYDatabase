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
    
    //修改数据再插入
    gradeInfo.gradeName = @"修改后的 gradeName";
    [[JYDBService shared] insertGradeInfo:gradeInfo];
    
    // 查询出全部的 queryGradeInfos 只有一条
    NSArray<JYGradeInfo*>*queryGradeInfos = [[JYDBService shared] getAllGradeInfo];
    
    //删除该条数据
    [[JYDBService shared] deleteGradeInfo:gradeInfo.gradeID];
    
    //最后获取所有为空
    queryGradeInfos = [[JYDBService shared] getAllGradeInfo];
    XCTAssert(queryGradeInfos.count == 0);
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
    personInfo.value = [NSValue valueWithCGPoint:CGPointMake(10, 22)];
    return personInfo;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
