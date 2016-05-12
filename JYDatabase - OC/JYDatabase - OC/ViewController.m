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
    
    UIButton *button1 = [self addButtonTitle:@"查询单条" action:@selector(getConttent:)];
    button1.frame = CGRectMake(0, 64, 100, 50);
    
    UIButton *button2 = [self addButtonTitle:@"查询所有" action:@selector(getAllConttent:)];
    button2.frame = CGRectMake(120, 64, 100, 50);
}

- (void)getConttent:(UIButton*)but{
   JYPersonInfo* info = [[JYDBService shared] getPersonInfo:@"1234560"];
   NSLog(@"%@",info);
}

- (void)getAllConttent:(UIButton*)but{
    NSArray* infos = [[JYDBService shared] getAllPersonInfo];
//    NSLog(@"%@",infos);
}

- (UIButton *)addButtonTitle:(NSString*)aTitle action:(SEL)aSel{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button addTarget:self action:aSel forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
