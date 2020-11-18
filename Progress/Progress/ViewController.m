//
//  ViewController.m
//  Progress
//
//  Created by 1 on 2020/11/18.
//  Copyright © 2020 1. All rights reserved.
//

#import "ViewController.h"
#import "PHCycleView.h"

@interface ViewController ()
@property (nonatomic,strong) PHCycleView *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView =[[PHCycleView alloc]initWithFrame:CGRectMake(0, 0, 130, 130)];
    self.progressView.center = self.view.center;
    self.progressView.backgroundColor = [UIColor clearColor];
    [self.progressView setProgressColor:[UIColor blueColor]];
    self.progressView.progressFont = [UIFont systemFontOfSize:30];
    [self.view addSubview:self.progressView];
    [self.progressView updateProgress:50];
    [self.progressView setLinePreAngle:15 lineSize:CGSizeMake(3, 10) color:[UIColor redColor]];
    self.progressView.describeFont = [UIFont systemFontOfSize:12];
    self.progressView.describeStr = @"历史最高分";
    self.progressView.progressTextColor = [UIColor blackColor];
    self.progressView.describeTextColor = [UIColor blackColor];
    self.progressView.outLayerColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0.3];
}


@end
