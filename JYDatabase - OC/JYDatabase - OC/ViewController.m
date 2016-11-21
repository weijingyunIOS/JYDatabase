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

- (void)viewDidLoad{
    [super viewDidLoad];
    [[JYDBService shared] getAllClassInfo];
}

@end
