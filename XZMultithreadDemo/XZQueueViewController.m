//
//  XZQueueViewController.m
//  XZMultithreadDemo
//
//  Created by kkxz on 2018/9/26.
//  Copyright © 2018年 kkxz. All rights reserved.
//

#import "XZQueueViewController.h"
#import "CustomOperation.h"

@interface XZQueueViewController ()
@property(nonatomic,strong)UIButton * buttonOne;
@property(nonatomic,assign)NSInteger queueType;
@property(nonatomic,strong)UIImageView * imageView1;
@property(nonatomic,strong)UIImageView * imageView2;
@property(nonatomic,strong)UIImageView * imageView3;
@property (copy, nonatomic) NSString *imageString1;
@property (copy, nonatomic) NSString *imageString2;

/** 售票员01 */
@property (nonatomic, strong) NSThread *thread01;
/** 售票员02 */
@property (nonatomic, strong) NSThread *thread02;
/** 售票员03 */
@property (nonatomic, strong) NSThread *thread03;
/** 票的总数 */
@property (nonatomic, assign) NSInteger ticketCount;

@end

@implementation XZQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Queue";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.buttonOne];
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.imageView3];
    
    self.buttonOne.frame = CGRectMake(10.0f, 80.0f, 300.0f,25.0f);
    self.imageView1.frame = CGRectMake(10.0f, 120.0f, 120.0f, 120.0f);
    self.imageView2.frame = CGRectMake(150.0f, 120.0f, 120.0f, 120.0f);
    self.imageView3.frame = CGRectMake(10.0f, 300.0f, 200.0f, 100.0f);
    self.queueType = 18;
    
    self.ticketCount = 100;
    self.thread01 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread01.name = @"售票员01";
    
    self.thread02 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread02.name = @"售票员02";
    
    self.thread03 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread03.name = @"售票员03";
    
}

-(void)oneClick
{
    if(1==self.queueType){
        [self concurrentQueueInAsyn];//并发队列+异步函数
    }
    else if(2==self.queueType){
        [self serialQueueInAsyn];//串行队列+异步函数
    }
    else if(3==self.queueType){
        [self concurrentQueueInSyn];//并发队列+同步函数
    }
    else if(4==self.queueType){
        [self serialQueueInSyn];//串行队列+同步函数
    }
    else if(5==self.queueType){
        [self queueGroup];//队列组
    }
    else if(6==self.queueType){
        [self commonIteration];//普通迭代
    }
    else if(7==self.queueType){
        [self quickIteration];//多线程快速迭代
    }
    else if(8==self.queueType){
        [self concurrentQueueInAsync];
    }
    else if(9==self.queueType){
        [self dispatch_barrier_async];//实现高效率的数据库访问和文件访问
    }
    else if(10==self.queueType){
        [self blockMiddle];//死锁
    }
    else if(11==self.queueType){
        [self noBlockMiddle];//解除死锁
    }
    else if(12==self.queueType){
        [self invocationOperation];
    }
    else if(13==self.queueType){
        [self blockOperation];
    }
    else if(14==self.queueType){
        [self customOperation];
    }
    else if(15==self.queueType){
        [self dependency];
    }
    else if(16==self.queueType){
        [self queueAddOperation];
    }
    else if(17==self.queueType){
        [self connectionBetweenThreadWithGCD];
    }
    else if(18==self.queueType){
        [self connectionBetweenThreadWithOperationQueue];
    }
}

//并发队列+异步函数
-(void)concurrentQueueInAsyn
{
    //获取全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //添加任务到队列中，就可以执行任务
    //异步函数：具备开启新线程的能力
    //同时开启三个子线程
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
}

//串行队列+异步函数
- (void)serialQueueInAsyn
{
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
    //创建串行队列
    //第一个参数为串行队列的名称，是c语言的字符串
    //第二个参数为队列的属性，一般来说串行队列不需要赋值任何属性，所以通常传空值（NULL）
    dispatch_queue_t queue = dispatch_queue_create("11", NULL);
    
    //添加任务到队列中执行
    //会打开线程，但是只开启一个线程
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
         NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    
}

//异步队列+同步函数
- (void)concurrentQueueInSyn
{
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
    
    //1.创建并行队列
    dispatch_queue_t  queue= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.添加任务到队列中执行
    //不会开启新的线程，并发队列失去了并发的功能
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
    
}

//串行队列+同步函数
- (void)serialQueueInSyn
{
    NSLog(@"用同步函数往串行队列中添加任务");
    //打印主线程
    NSLog(@"主线程----%@",[NSThread mainThread]);
    
    //创建串行队列
    dispatch_queue_t  queue= dispatch_queue_create("11", NULL);
    
    //2.添加任务到队列中执行
    //不会开启新线程
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@",[NSThread currentThread]);
    });
}

-(void)queueGroup
{
    NSDate *startDate = [NSDate date];
    NSTimeInterval startTime = startDate.timeIntervalSince1970;
    
    //创建一个对列组
    dispatch_group_t group = dispatch_group_create();
    
    //开启一个任务下载图片1
    __block UIImage * image1 = nil;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image1= [self imageWithUrl:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=2b9a12172df5e0fefa1581533d095fcd/cefc1e178a82b9019115de3d738da9773912ef00.jpg"];
        NSLog(@"图片1下载完成---%@",[NSThread currentThread]);

    });
    
    //开启一个任务下载图片2
    __block UIImage *image2=nil;
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        image2= [self imageWithUrl:@"http://h.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=f47fd63ca41ea8d39e2f7c56f6635b2b/1e30e924b899a9018b8d3ab11f950a7b0308f5f9.jpg"];
        NSLog(@"图片2下载完成---%@",[NSThread currentThread]);
    });
    
    //同时执行下载图片1、图片2的操作
    
    //等group中的所有任务都执行完毕, 再回到主线程执行其他操作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"显示图片---%@",[NSThread currentThread]);
        self.imageView1.image=image1;
        self.imageView2.image=image2;
        
        //合并两张图片
        //注意最后一个参数是浮点数（0.0），不要写成0。
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(200, 100), NO, 0.0);
        [image1 drawInRect:CGRectMake(0, 0, 100, 100)];
        [image2 drawInRect:CGRectMake(100, 0, 100, 100)];
        self.imageView3.image = UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        NSLog(@"图片合并完成---%@",[NSThread currentThread]);
        
        NSDate *endDate = [NSDate date];
        NSTimeInterval endTime = endDate.timeIntervalSince1970;
        NSLog(@"endTime - startTime = %f",endTime - startTime);
        
    });
    //同时开启了2个子线程，分别下载图片。
}


//封装一个方法，传入一个url参数，返回一张网络上下载的图片
- (UIImage *)imageWithUrl:(NSString *)urlStr
{
    NSURL *url=[NSURL URLWithString:urlStr];
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *image=[UIImage imageWithData:data];
    return image;
}

//快速迭代dispatch_apply函数
 //普通迭代
- (void)commonIteration
{
    for (int i = 0; i < 9; i++) {
        NSLog(@"%d----%@", i, [NSThread currentThread]);
    }
}

//快速迭代（如：拷贝文件）,创建多条线程，进行迭代，速度快
-(void)quickIteration
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(9, queue, ^(size_t index) {
        NSLog(@"%zd----%@",index,[NSThread currentThread]);
    });
}

//并发队列+异步函数  读1和读2之间写入数据
//在写入处理之前，读取处理不可执行
- (void)concurrentQueueInAsync {
    dispatch_queue_t queue = dispatch_queue_create("JJ", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"block for reading 0");
    });
    dispatch_async(queue, ^{
        NSLog(@"block for reading 1");
    });
    // 在1和2之间执行写入处理,那么根据Concurrent Dispatch Queue的性质，就有可能在追加到写入处理前面的处理中读取到与期待不符的数据。
    dispatch_async(queue, ^{
        NSLog(@"block for writing");
    });
    dispatch_async(queue, ^{
        NSLog(@"block for reading 2");
    });
    dispatch_async(queue, ^{
        NSLog(@"block for reading 3");
    });
}

//dispatch_barrier_async函数控制读写操作 读1和读2之间写入数据
-(void)dispatch_barrier_async
{
    dispatch_queue_t queue = dispatch_queue_create("GG", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"block for reading 0");
    });
    dispatch_async(queue, ^{
        NSLog(@"block for reading 1");
    });
    //将这个block之前的任务拦着，等执行完后，执行这个block,然后再并行执行其他任务。
    dispatch_barrier_async(queue, ^{
        NSLog(@"block for writing");
    });
    dispatch_async(queue, ^{
        NSLog(@"block for reading 2");
    });
    dispatch_async(queue, ^{
        NSLog(@"block for reading 3");
    });
}

-(void)blockMiddle
{
    //产生死锁
    dispatch_queue_t queue = dispatch_get_main_queue();//主队列，是串行队列
    dispatch_sync(queue, ^{
        NSLog(@"block middle");
    });
}

-(void)noBlockMiddle
{
    //解除死锁
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//global队列，是并行队列
    dispatch_sync(queue, ^{
        NSLog(@"no block middle");
    });
}

//NSInvocationOperation的使用
-(void)invocationOperation
{
    //创建操作
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    //启动操作
    [op start];
}
- (void)run
{
    NSLog(@"------%@", [NSThread currentThread]);
}

//NSBlockOperation的基本使用
//第一个任务在当前当前线程，后面添加的任务会放在新的线程里执行
-(void)blockOperation
{
    //创建操作
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
       //主线程
        NSLog(@"下载1------%@", [NSThread currentThread]);
    }];
    
    //添加额外的任务，在子线程执行
    [op addExecutionBlock:^{
        NSLog(@"下载2------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"下载3------%@", [NSThread currentThread]);
    }];
    [op addExecutionBlock:^{
        NSLog(@"下载4------%@", [NSThread currentThread]);
    }];
    
    //启动操作
    [op start];

}

//自定义NSOperation使用
-(void)customOperation
{
    CustomOperation * op = [[CustomOperation alloc] init];
    [op start];
}

//NSOperation可以轻松的设置依赖来保证执行顺序
-(void)dependency
{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download1----%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download2----%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download3----%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download4----%@", [NSThread  currentThread]);
    }];
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download5----%@", [NSThread  currentThread]);
    }];
    
    //设置依赖
    [op3 addDependency:op1];
    [op3 addDependency:op2];
    [op3 addDependency:op4];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
    //操作3一定是在操作1，2，4执行完成之后才执行。

}

//队列添加操作
- (void)queueAddOperation
{
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作（操作把任务封装起来）
    
    // 设置最大并发操作数
    //queue.maxConcurrentOperationCount = 2;
    //queue.maxConcurrentOperationCount = 1; // 就变成了串行队列
    
    // 2.1 创建NSInvocationOperation
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download2) object:nil];
    
    // 2.2 创建NSBlockOperation
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download3 --- %@", [NSThread currentThread]);
    }];
    
    [op3 addExecutionBlock:^{
        NSLog(@"download4 --- %@", [NSThread currentThread]);
    }];
    [op3 addExecutionBlock:^{
        NSLog(@"download5 --- %@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"download6 --- %@", [NSThread currentThread]);
    }];
    
    // 2.3 创建CustomOperation
    CustomOperation *op5 = [[CustomOperation alloc] init];
    
    // 3. 添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
}

- (void)download1 {
    NSLog(@"download1 --- %@", [NSThread currentThread]);
}

- (void)download2 {
    NSLog(@"download2 --- %@", [NSThread currentThread]);
}

//GCD 线程间通信
-(void)connectionBetweenThreadWithGCD
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 图片的网络路径
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        // 加载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 生成图片
        UIImage *image = [UIImage imageWithData:data];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView1.image = image;
        });

    });
}

//NSOperationQueue 线程间通信
-(void)connectionBetweenThreadWithOperationQueue
{
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        // 图片的网络路径
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        // 加载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        // 生成图片
        UIImage *image = [UIImage imageWithData:data];
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView1.image = image;
        }];
    }];
}

//多线程安全隐患示例
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.thread01 start];
    [self.thread02 start];
    [self.thread03 start];
}

- (void)saleTicket
{
    while (1) {
        //加锁
        @synchronized(self) {
            // 先取出总数
            NSInteger count = self.ticketCount;
            if (count > 0) {
                self.ticketCount = count - 1;
                NSLog(@"%@卖了一张票，还剩下%zd张", [NSThread currentThread].name, self.ticketCount);
            } else {
                NSLog(@"票已经卖完了");
                break;
            }
        }
    }
}

#pragma mark - lazy init
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
@synthesize queueType = _queueType;

@synthesize imageString1 = _imageString1;
@synthesize imageString2 = _imageString2;

@synthesize imageView1 = _imageView1;
-(UIImageView *)imageView1
{
    if(!_imageView1){
        _imageView1 = [[UIImageView alloc] init];
        _imageView1.backgroundColor = [UIColor clearColor];
    }
    return _imageView1;
}
@synthesize imageView2 = _imageView2;
-(UIImageView *)imageView2
{
    if(!_imageView2){
        _imageView2 = [[UIImageView alloc] init];
        _imageView2.backgroundColor = [UIColor clearColor];
    }
    return _imageView2;
}
@synthesize imageView3 = _imageView3;
-(UIImageView *)imageView3
{
    if(!_imageView3){
        _imageView3 = [[UIImageView alloc] init];
        _imageView3.backgroundColor = [UIColor clearColor];
    }
    return _imageView3;
}

@end
