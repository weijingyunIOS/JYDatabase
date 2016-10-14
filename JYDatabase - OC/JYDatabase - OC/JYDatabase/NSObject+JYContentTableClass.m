//
//  NSObject+JYContentTableClass.m
//  JYDatabase - OC
//
//  Created by weijingyun on 16/10/14.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

#import "NSObject+JYContentTableClass.h"
#import <objc/runtime.h>

static char kJy_LastInsertTime;

@implementation NSObject (JYContentTableClass)

- (NSTimeInterval)lastInsertTime{
    NSNumber* number = objc_getAssociatedObject(self, &kJy_LastInsertTime);
    return [number longLongValue];
}

- (void)setLastInsertTime:(NSTimeInterval)lastInsertTime{
    objc_setAssociatedObject(self,&kJy_LastInsertTime,[NSNumber numberWithUnsignedLong:lastInsertTime],OBJC_ASSOCIATION_RETAIN);
}



@end
