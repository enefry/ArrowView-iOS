//
//  ViewController.m
//  ArrowView
//
//  Created by renwei.chen on 2017/7/5.
//  Copyright © 2017年 renwei.chen. All rights reserved.
//

#import "ViewController.h"
#import "ArrowView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    label.text = @"内容有代码设置";
    label.layer.cornerRadius = 3.0f;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [UIColor yellowColor];
    
    ArrowView *arrow = [[ArrowView alloc]initWithFrame:CGRectMake(10, 80, 120, 80)];
    arrow.usingLayer = YES;
    arrow.arrowDirection = ArrowDirectionUp;
    arrow.arrowSize = 10;
    arrow.arrowOffsetXorY = 30;
    arrow.fillColor = [UIColor greenColor];
    arrow.strokeColor = [UIColor redColor];
    arrow.strokWidth = 1.0/[UIScreen mainScreen].scale;
    [arrow setContentView:label];
    [self.view addSubview:arrow];
    
    //这个很重要.需要设置!!
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:arrow attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1 constant:30]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:arrow attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:20]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
