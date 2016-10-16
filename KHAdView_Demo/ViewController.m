//
//  ViewController.m
//  waveView
//
//  Created by qianfeng on 16/9/24.
//  Copyright © 2016年 Arron_zkh. All rights reserved.
//

#import "ViewController.h"
#import "KHAdView.h"
#import "Interfaces.h"
#import "TestViewController.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define KHAdView_Height 300


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/** tableView */
@property (nonatomic, weak)  UITableView *tableView;
/** AdView */
@property (nonatomic, weak)  KHAdView *khAdView;
/** Internet_interfaces */
@property (nonatomic, strong)  NSArray *urlArr;
/** local file */
@property (nonatomic, strong)  NSArray<NSString *> *localArr;

@end

@implementation ViewController

#pragma mark - lazy load
- (KHAdView *)khAdView{
    if (!_khAdView) {
        KHAdView *view = [[KHAdView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, KHAdView_Height)];
        self.tableView.tableHeaderView = view;
        _khAdView = view;
    }
    return _khAdView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView = tableView;
        [self.view addSubview:tableView];
    }
    return _tableView;
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Click to start timer";
    }else if(indexPath.section == 1){
        cell.textLabel.text = @"Click to stop timer";
    }else{
        cell.textLabel.text = @"present TestViewController";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
         [self.khAdView startTimer];
    }else if(indexPath.section == 1){
         [self.khAdView stopTimer];
    }else{
        [self presentTestController];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlArr = @[kInterfaceOne, kInterfaceTwo, kInterfaceThree, kInterfaceFour, kInterfaceFive];
    
//When images' source is from Internet
    [self.khAdView setDataSource:_urlArr WithSourceType:KHSourceInternetType];
  
    
    
//When images' source is from local File
    /*
     self.localArr = @[@"1.jpg", @"2.jpg",@"3.jpg"];
     [self.khAdView setDataSource:self.localArr WithSourceType:KHSourceLocalType];
    */
    
    
//options for setting the scrollView:
    /*
    self.khAdView.bottomViewColor = [UIColor redColor];
    self.khAdView.currentPageIndicatorTintColor = [UIColor blackColor];
    self.khAdView.pageIndicatorTintColor = [UIColor yellowColor];
     
    self.khAdView.direction = KHScrollDirectionFromLeft;
    self.khAdView.bottomViewHeight = 50;
    self.khAdView.timeInterval = 1.f;
    self.khAdView.alpha = 1.0;
     
    self.khAdView.hideBottomView = YES;
    self.khAdView.hidePageControl = YES;
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //in case of memory leaks because of NSTimer
    [self.khAdView invalidateTimer];
}

- (void)presentTestController{
    TestViewController *testCtrler = [[TestViewController alloc] init];
    [self presentViewController:testCtrler animated:YES completion:nil];
}



@end
