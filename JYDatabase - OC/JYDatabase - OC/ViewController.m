//
//  ViewController.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/5/9.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "ViewController.h"
#import "JYDBService.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    for (int i = 0; i < 200; i++) {
        JYPersonInfo *info = [[JYPersonInfo alloc] init];
        info.personnumber = [NSString stringWithFormat:@"123456%tu",i];
        info.floatDB = 10.10111;
        info.intDB = i;
        info.boolDB = i % 2 == 0;
        [arrayM addObject:info];
    }
    [[JYDBService shared] insertPersonInfos:arrayM];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
