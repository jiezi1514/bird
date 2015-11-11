//
//  ViewController.m
//  FlappyBird
//
//  Created by Qianfeng on 15/10/7.
//  Copyright (c) 2015年 1000phone. All rights reserved.
//

#import "ViewController.h"
#import "PlayViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createAnimation];
}

-(void)createAnimation
{
    NSMutableArray *imagesArr=[[NSMutableArray alloc]init];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(160, 270, 40, 31)];
    NSArray *arr=@[@"bird1",@"bird2",@"bird3"];
    for (NSInteger i=0; i<arr.count; i++) {
        UIImage *image=[UIImage imageNamed:arr[i]];
        [imagesArr addObject:image];
    }
    imageView.animationImages=imagesArr;
    imageView.animationDuration=1;
    imageView.animationRepeatCount=0;
    [imageView startAnimating];
    [self.view addSubview:imageView];

}

//- (IBAction)startButton:(id)sender {
//    
//    PlayViewController *vc=[[PlayViewController alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
//    
//}
- (IBAction)startButton:(id)sender {
}
@end
