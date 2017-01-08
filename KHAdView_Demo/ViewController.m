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
#import "ImgViewController.h"


#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kAdView_Height 300


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

/** tableView */
@property (nonatomic, weak)  UITableView *tableView;
/** KHAdView */
@property (nonatomic, weak)  KHAdView *khAdView;
/** 网络图片 */
@property (nonatomic, strong)  NSArray *urlArr;
/** 本地图片 */
@property (nonatomic, strong)  NSArray *localArr;

@end

@implementation ViewController

#pragma mark - Lazy load
- (KHAdView *)khAdView{
    if (!_khAdView) {
        KHAdView *view = [[KHAdView alloc] initWithFrame:CGRectMake(0, -kAdView_Height, kScreen_Width, kAdView_Height)];
        [self.tableView addSubview:view];
        _khAdView = view;
    }
    return _khAdView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:tableView];
        tableView.contentInset = UIEdgeInsetsMake(kAdView_Height, 0, 0, 0);
        _tableView = tableView;
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    }
    return cell;
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


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        [self.khAdView startTimer];
    }else if(indexPath.section == 1){
        [self.khAdView stopTimer];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KHAdView";
    [self setUpImages];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //销毁定时器以避免内存泄露
    [self.khAdView invalidateTimer];
}


- (void)setUpImages{
    
    __weak typeof(self) weakSelf = self;
    //网络图片
#if 1
    self.urlArr = @[kInterfaceOne, kInterfaceTwo, kInterfaceThree, kInterfaceFour, kInterfaceFive];
    [self.khAdView setUpOnlineImagesWithSource:self.urlArr
                                   PlaceHolder:[UIImage imageNamed:@"001"]
                                  ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
        [weakSelf pushToImgViewControllerWithIndex:index Image:img ImageSource:imgSrc];
    }];
#endif
    
    //本地图片
#if 0
    self.localArr = @[@"1.jpg", @"2.jpg",@"3.jpg"];
    [self.khAdView setUpLocalImagesWithSource:self.localArr
                                 ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
        [weakSelf pushToImgViewControllerWithIndex:index Image:img ImageSource:imgSrc];
    }];
#endif
    
    
    //自定义轮播器
#if 0
    self.khAdView.bottomViewColor = [UIColor redColor];
    self.khAdView.currentPageIndicatorTintColor = [UIColor blackColor];
    self.khAdView.pageIndicatorTintColor = [UIColor yellowColor];
    
    self.khAdView.direction = KHScrollDirectionFromLeft;
    self.khAdView.bottomViewHeight = 50;
    self.khAdView.timeInterval = 1.f;
    self.khAdView.alpha = 0.5;
    
#endif
    
    //启动波浪效果
#if 1
    self.khAdView.hideBottomView = YES;
    self.khAdView.hidePageControl = YES;
    [self.khAdView enableWavingWithDuration:0.f
                                  WaveSpeed:12.f
                                 WaveHeight:12.f
                                  WaveColor:[UIColor whiteColor]];
#endif
    
}

- (void)pushToImgViewControllerWithIndex:(NSInteger)index
                                   Image:(UIImage *)img
                             ImageSource:(NSString *)imgSrc{
    
    ImgViewController *imgCtrler = [[ImgViewController alloc] init];
    imgCtrler.index = index;
    imgCtrler.srcStr = imgSrc;
    imgCtrler.image = img;
    [self.navigationController pushViewController:imgCtrler animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.khAdView startWaving];
}






@end
