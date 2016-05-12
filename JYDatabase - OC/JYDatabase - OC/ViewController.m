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
        info.float1 = 10.10111;
        info.int1 = i;
        info.bool1 = i % 2 == 0;
        [arrayM addObject:info];
    }
    [[JYDBService shared] insertPersonInfos:arrayM];
    
    UIButton *button1 = [self addButtonTitle:@"查询单条" action:@selector(getConttent:)];
    button1.frame = CGRectMake(0, 64, 80, 50);
    
    UIButton *button2 = [self addButtonTitle:@"查询所有" action:@selector(getAllConttent:)];
    button2.frame = CGRectMake(100, 64, 80, 50);
    
    UIButton *button3 = [self addButtonTitle:@"查询多条" action:@selector(getConttents:)];
    button3.frame = CGRectMake(200, 64, 80, 50);
    
    UIButton *button4 = [self addButtonTitle:@"删除单条" action:@selector(deleteConttent:)];
    button4.frame = CGRectMake(0, 164, 80, 50);
    
    UIButton *button5 = [self addButtonTitle:@"删除所有" action:@selector(deleteAllConttent:)];
    button5.frame = CGRectMake(100, 164, 80, 50);
    
    UIButton *button6 = [self addButtonTitle:@"删除多条" action:@selector(deleteConttents:)];
    button6.frame = CGRectMake(200, 164, 80, 50);
}

- (void)deleteConttent:(UIButton*)but{
    [[JYDBService shared] deletePersonInfo:@"1234560"];
}

- (void)deleteConttents:(UIButton*)but{
    [[JYDBService shared] deletePersonInfos:@[@"1234560",@"12345610",@"12345611",@"1234562"]];
}

- (void)deleteAllConttent:(UIButton*)but{
    [[JYDBService shared] deleteAllPersonInfo];
}

- (void)getConttent:(UIButton*)but{
   JYPersonInfo* info = [[JYDBService shared] getPersonInfo:@"1234560"];
   NSLog(@"%@",info);
}

- (void)getConttents:(UIButton*)but{
    NSArray* infos = [[JYDBService shared] getPersonInfos:@[@"1234560",@"12345610",@"12345611",@"1234562"]];
    NSLog(@"%@",infos);
}

- (void)getAllConttent:(UIButton*)but{
    NSArray* infos = [[JYDBService shared] getAllPersonInfo];
    NSLog(@"%@",infos);
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
