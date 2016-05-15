//
//  ViewController.m
//  JYGenerationCode
//
//  Created by weijingyun on 16/5/15.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
@property (weak) IBOutlet NSTextField *dbName;
@property (weak) IBOutlet NSTextField *tableName;
@property (weak) IBOutlet NSButton *outButton;
@property (weak) IBOutlet NSTextField *tableClass;
@property (weak) IBOutlet NSTextField *dbClass;
@property (weak) IBOutlet NSTextField *hhContent;

@property (unsafe_unretained) IBOutlet NSTextView *outPutView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)tapBut:(id)sender {
    
    NSString *fileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/code.bundle/code1.text"];
    NSString *contentCode1String = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    contentCode1String = [contentCode1String stringByReplacingOccurrencesOfString:@"HHContent" withString:self.hhContent.stringValue];
    contentCode1String = [contentCode1String stringByReplacingOccurrencesOfString:@"HHClass" withString:self.tableClass.stringValue];
    contentCode1String = [contentCode1String stringByReplacingOccurrencesOfString:@"HHTableName" withString:self.tableName.stringValue];
    contentCode1String = [contentCode1String stringByReplacingOccurrencesOfString:@"HHDBName" withString:self.dbName.stringValue];
    self.outPutView.string = contentCode1String;
}


@end
