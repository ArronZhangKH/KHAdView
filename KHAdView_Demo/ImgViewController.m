//
//  ImgViewController.m
//  KHAdView_Demo
//
//  Created by Aaron_Zhang on 17/1/8.
//  Copyright © 2017年 Arron_zkh. All rights reserved.
//

#import "ImgViewController.h"

@interface ImgViewController ()

@end

@implementation ImgViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 200 - 64)];
    [self.view addSubview:imgV];
    imgV.image = self.image;
    
    UILabel *indexL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 200, CGRectGetWidth(self.view.frame), 40)];
    [self.view addSubview:indexL];
    indexL.textAlignment = NSTextAlignmentCenter;
    indexL.text = [NSString stringWithFormat:@"第%zd张图片",self.index];
    
    UILabel *srcL = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetHeight(self.view.frame) - 160, CGRectGetWidth(self.view.frame) - 60, 160)];
    [self.view addSubview:srcL];
    srcL.numberOfLines = 0;
    srcL.text = [NSString stringWithFormat:@"图片URL或名字: %@",self.srcStr];
}


@end
