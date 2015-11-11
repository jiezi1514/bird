//
//  PlayViewController.m
//  FlappyBird
//
//  Created by Qianfeng on 15/10/7.
//  Copyright (c) 2015年 1000phone. All rights reserved.
//

#import "PlayViewController.h"
#import "LastViewController.h"
#import "AppDelegate.h"

@interface PlayViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
@property (weak, nonatomic) IBOutlet UILabel *myScore;//显示分数
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property(strong,nonatomic)UIImageView *imageView;
@end

@implementation PlayViewController
{
    NSTimer *_timer;//定时器
    NSInteger score;
    NSInteger num;
    UIImageView *_pipe1;
    UIImageView *_pipe2;
    CGRect frame1;
    BOOL isUping;//是否上升
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAnimation];
    [self createTimer];
}

-(void)createAnimation
{
    NSMutableArray *images=[[NSMutableArray alloc]init];
    for (NSInteger i=1; i<=3; i++) {
        NSString *name=[NSString stringWithFormat:@"bird%ld",i];
        UIImage *image=[UIImage imageNamed:name];
        [images addObject:image];
    }
    //小鸟视图
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 250, 40, 31)];
    self.imageView.animationDuration=1;
    self.imageView.animationImages=images;
    self.imageView.animationRepeatCount=0;//动画次数
    [self.imageView startAnimating];
    [self.view addSubview:self.imageView];
    
    [self createPipe];//创建上下的管子
    isUping =NO;//状态初始化定义
    //创建一个和self一样大小的视图  给整个视图添加手势
    UIImageView *imageView1=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView1.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    [imageView1 addGestureRecognizer:tap];
    [self.view addSubview:imageView1];
    
    score=0;
    self.myScore.text=[NSString stringWithFormat:@"%ld",score];
    
    [self.view insertSubview:self.myScore atIndex:2];
    
}
-(void)onTap:(UITapGestureRecognizer *)tap
{
    isUping=NO;
    
    
}
//创建上下管子
-(void)createPipe
{
    NSInteger height=arc4random()%300+30;
    _pipe1=[[UIImageView alloc]initWithFrame:CGRectMake(375, -30, 70, height)];
     _pipe2=[[UIImageView alloc]initWithFrame:CGRectMake(375, height+100, 70, 580)];
    _pipe1.image=[UIImage imageNamed:@"pipe"];
    _pipe2.image=[UIImage imageNamed:@"pipe"];
    [self.view addSubview:_pipe1];
    [self.view addSubview:_pipe2];
    [self.view insertSubview:self.downImageView aboveSubview:_pipe2];
}
//定时器
-(void)createTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}
-(void)onTimer
{
    //改变最先面视图的frame
    CGRect frame=self.downImageView.frame;
    if (frame.origin.x == -24) {
        frame.origin.x=0;
    }
    frame.origin.x--;
    self.downImageView.frame=frame;
    
    //点击就进入到这里开始上升
    if (isUping ==NO) {
        CGRect frame =self.imageView.frame;//只改变小鸟的 y 值
        frame.origin.y -=2;
        num +=2;
        self.imageView.frame=frame;
        if (num >=60) {
            isUping=YES;//
        }
    }
    //不点击时会自动下落的
    if (isUping==YES&&self.imageView.frame.origin.y<500) {
        CGRect frame=self.imageView.frame;
        frame.origin.y++;
        num -=2;
        self.imageView.frame=frame;
        num=0;
    }
   
    //管子移动到一定的值  重新创建
    frame1 = _pipe1.frame;
    CGRect frame2 = _pipe2.frame;
    frame1.origin.x--;
    frame2.origin.x--;
    _pipe1.frame= frame1;
    _pipe2.frame= frame2;
    if (frame1.origin.x<-70) {
        [self createPipe];

    }
    //发生碰撞就会弹出警示框
    //http://blog.sina.com.cn/s/blog_87a824440101a0p5.html
    
    bool ret1=CGRectIntersectsRect(self.imageView.frame, _pipe1.frame);
    bool ret2=CGRectIntersectsRect(self.imageView.frame,  _pipe2.frame);
    if (ret1==YES||ret2==YES) {
        [self onStop];
    }
    
    if (frame1.origin.x==100+40-70) {
        [self myScoreClick];//管子过了鸟就分数加一
    }

}
-(void)myScoreClick
{
    if (frame1.origin.x==100+40-70) {
        score ++;
    self.myScore.text=[NSString stringWithFormat:@"%ld",score];
        
    }
    
}
-(void)onStop
{
    [_timer setFireDate:[NSDate distantFuture]];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"再来一局" delegate:self cancelButtonTitle:@"退出应用" otherButtonTitles:@"确定",@"难度",@"取消",nil];                            //0                          //1    2     3
    
    
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"警告框点击按钮位置%ld",buttonIndex);
    if (buttonIndex ==3||buttonIndex ==1) {
        
         [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (buttonIndex==2){
        
        LastViewController *vc=[[LastViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
    } else {
        
        [self exitApplication ];

    }

    
}
- (void)exitApplication {
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UIWindow *window = app.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}



















@end
