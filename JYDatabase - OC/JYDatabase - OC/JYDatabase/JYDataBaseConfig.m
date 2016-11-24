//
//  JYDataBaseConfig.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/10/17.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "JYDataBaseConfig.h"

@implementation JYDataBaseConfig

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static JYDataBaseConfig* shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    
    return shared;
}

#pragma mark - 静态方法
NSDictionary * jy_correspondingDic(){
    return @{@"Tb":@"BOOL",
             @"TB":@"BOOL",
             @"Tc":@"BOOL",
             @"TC":@"BOOL",
             @"Td":@"DOUBLE",
             @"TD":@"DOUBLE",
             @"Tf":@"FLOAT",
             @"TF":@"INTEGER",
             @"Ti":@"INTEGER",
             @"TI":@"INTEGER",
             @"Tq":@"INTEGER",
             @"TQ":@"INTEGER",
             @"T@\"NSMutableString\"":@"NVARCHAR",
             @"T@\"NSString\"":@"NVARCHAR",
             @"T@\"NSData\"":@"BLOB",
             @"T@\"NSNumber\"":@"BLOB",
             @"T@\"NSDictionary\"":@"BLOB",
             @"T@\"NSMutableDictionary\"":@"BLOB",
             @"T@\"NSMutableArray\"":@"BLOB",
             @"T@\"NSArray\"":@"BLOB",};
}

NSDictionary * jy_defaultDic(){
    return @{@"BOOL":@"1",
             @"DOUBLE":@"20",
             @"FLOAT":@"10",
             @"INTEGER":@"10",
             @"VARCHAR":@"10",
             @"NVARCHAR":@"10",
             @"TEXT"    :@"512",
             @"BLOB":@"512",};
}

@end

/*
 
 1、CHAR。CHAR存储定长数据很方便，CHAR字段上的索引效率级高，比如定义char(10)，那么不论你存储的数据是否达到了10个字节，都要占去10个字节的空间,不足的自动用空格填充。
 2、VARCHAR。存储变长数据，但存储效率没有CHAR高。如果一个字段可能的值是不固定长度的，我们只知道它不可能超过10个字符，把它定义为 VARCHAR(10)是最合算的。VARCHAR类型的实际长度是它的值的实际长度+1。为什么“+1”呢？这一个字节用于保存实际使用了多大的长度。从空间上考虑，用varchar合适；从效率上考虑，用char合适，关键是根据实际情况找到权衡点。
 3、TEXT。text存储可变长度的非Unicode数据，最大长度为2^31-1(2,147,483,647)个字符。
 4、NCHAR、NVARCHAR、NTEXT。这三种从名字上看比前面三种多了个“N”。它表示存储的是Unicode数据类型的字符。我们知道字符中，英文字符只需要一个字节存储就足够了，但汉字众多，需要两个字节存储，英文与汉字同时存在时容易造成混乱，Unicode字符集就是为了解决字符集这种不兼容的问题而产生的，它所有的字符都用两个字节表示，即英文字符也是用两个字节表示。nchar、nvarchar的长度是在1到4000之间。和char、varchar比较起来，nchar、nvarchar则最多存储4000个字符，不论是英文还是汉字；而char、varchar最多能存储8000个英文，4000个汉字。可以看出使用nchar、nvarchar数据类型时不用担心输入的字符是英文还是汉字，较为方便，但在存储英文时数量上有些损失。
 所以一般来说，如果含有中文字符，用nchar/nvarchar，如果纯英文和数字，用char/varchar。
 SQLite最大的特点在于其数据类型为无数据类型(typelessness)。这意味着可以保存任何类型的数据到所想要保存的任何表的任何列中，无论这列声明的数据类型是什么。虽然在生成表结构的时候，要声明每个域的数据类型，但SQLite并不做任何检查。开发人员要靠自己的程序来控制输入与读出数据的类型。这里有一个例外，就是当主键为整型值时，如果要插入一个非整型值时会产生异常。
 
 虽然，SQLite允许忽略数据类型，但是，仍然建议在Create Table语句中指定数据类型，因为数据类型有利于增强程序的可读性。另外，虽然在插入或读出数据的时候是不区分类型的，但在比较的时候，不同数据类型是有区别的
 
 */



