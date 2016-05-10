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
    JYPersonInfo *info = [[JYPersonInfo alloc] init];
    info.personnumber = @"123456";
    info.nameDB = @"nameDB";
    [JYDBService shared];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[JYDBService shared] updatePersonInfo:info];
        NSArray *array = [[JYDBService shared] getAllPersonInfo];
        
        NSLog(@"%@",array);
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
