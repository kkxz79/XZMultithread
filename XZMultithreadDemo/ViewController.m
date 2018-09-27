//
//  ViewController.m
//  XZMultithreadDemo
//
//  Created by kkxz on 2018/9/25.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import "ViewController.h"
#import "XZQueueViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSThread * thread;
@property(nonatomic,strong)UIButton * buttonOne;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithTitle:@"queue" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction)];
    self.navigationItem.rightBarButtonItem = barButton;
    [self.view addSubview:self.buttonOne];
    self.buttonOne.frame = CGRectMake(10.0f, 80.0f, 300,25.0f);
    
    //进程是资源分配的最小单位，线程是CPU调度的最小单位。
    //多线程：是指从软件或者硬件上实现多个线程的并发技术。
    
    // 1.创建线程--->新建状态
    self.thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadAction) object:nil];
    // 设置线程名称
    self.thread.name = @"线程A";
    
}

-(void)rightButtonAction
{
    XZQueueViewController * queue = [[XZQueueViewController alloc] init];
    [self.navigationController pushViewController:queue animated:YES];
}

-(void)threadAction
{
    NSThread * current = [NSThread currentThread];
    NSLog(@"therad---打印线程---%@",self.thread.name);
    NSLog(@"therad---线程开始---%@",current.name);
    
    //3.第一种设置线程阻塞，阻塞2秒 --->阻塞状态
    NSLog(@"接下来，线程阻塞2秒");
    [NSThread sleepForTimeInterval:2.0];
    
    //第二种设置线程阻塞，以当前时间为基准阻塞4秒
    NSLog(@"接下来，线程阻塞4秒");
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:4.0];
    [NSThread sleepUntilDate:date];
    
    // 4. 任务结束 --- >死亡状态
    NSLog(@"test---线程结束---%@",current.name);
}

-(void)oneClick
{
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 2.开启线程---->就绪和运行状态
    [self.thread start];
}


@synthesize thread = _thread;
@synthesize buttonOne = _buttonOne;
-(UIButton *)buttonOne
{
    if(_buttonOne == nil){
        _buttonOne = [UIButton buttonWithType:UIButtonTypeSystem];
        [_buttonOne setTitle:@"oneclick" forState:UIControlStateNormal];
        [_buttonOne.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_buttonOne.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_buttonOne setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_buttonOne addTarget:self action:@selector(oneClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonOne;
}

@end
