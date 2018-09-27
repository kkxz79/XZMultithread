//
//  CustomOperation.m
//  XZMultithreadDemo
//
//  Created by kkxz on 2018/9/27.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import "CustomOperation.h"

@implementation CustomOperation
//重写main方法，在这里执行任务
-(void)main
{
    for (NSInteger i = 0; i<10; i++) {
        NSLog(@"download1 -%zd-- %@", i, [NSThread currentThread]);
    }
    if (self.isCancelled) return;
    
    for (NSInteger i = 0; i<10; i++) {
        NSLog(@"download2 -%zd-- %@", i, [NSThread currentThread]);
    }
    if (self.isCancelled) return;
    
    for (NSInteger i = 0; i<10; i++) {
        NSLog(@"download3 -%zd-- %@", i, [NSThread currentThread]);
    }
    if (self.isCancelled) return;

}
@end
