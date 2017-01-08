//
//  KHAdView.h
//  KHAdView
//
//  Created by qianfeng on 16/9/25.
//  Copyright © 2016年 Arron_zkh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KHScrollDirection){
    KHScrollDirectionFromRight = 0,
    KHScrollDirectionFromLeft = 1
};

typedef void (^ClickImageHandler)(NSInteger index, NSString *imgSrc, UIImage *img);


@interface KHAdView : UIView

/** 广告轮播的时间间隔 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/** 底部分页栏的背景颜色 */
@property (nonatomic, weak)  UIColor *bottomViewColor;
/** 分页栏的指示颜色 */
@property (nonatomic, weak)  UIColor *pageIndicatorTintColor;
/** 分页栏当前分页的指示颜色 */
@property (nonatomic, weak)  UIColor *currentPageIndicatorTintColor;
/** 底部分页栏的高度 */
@property (nonatomic, assign)  CGFloat bottomViewHeight;
/** 底部分页栏的透明度 */
@property (nonatomic, assign)  CGFloat alpha;
/** 滚动的方向 */
@property (nonatomic, assign)  KHScrollDirection direction;
/** 隐藏底部分页栏的背景 */
@property (nonatomic, assign)  BOOL hideBottomView;
/** 隐藏底部分页栏 */
@property (nonatomic, assign)  BOOL hidePageControl;
/** 点击图片的回调 */
@property(nonatomic, copy) ClickImageHandler clickImageHandler;


/**
 设置网络图片

 @param dataSource 网络图片的URL
 @param image 占位图片
 @param handler 点击图片的回调
 */
- (void)setUpOnlineImagesWithSource:(NSArray<NSString *> *)dataSource
                        PlaceHolder:(UIImage *)image
                       ClickHandler:(ClickImageHandler)handler;

/**
 设置本地图片

 @param dataSource 本地图片的名称
 @param handler 点击图片的回调
 */
- (void)setUpLocalImagesWithSource:(NSArray<NSString *> *)dataSource
                      ClickHandler:(ClickImageHandler)handler;



/**
 初始化波浪View

 @param duration 持续时间(duration = 0默认波浪不消失)
 @param speed 波动速度
 @param height 波浪高度
 @param color 波浪颜色
 */
- (void)enableWavingWithDuration:(NSTimeInterval)duration
                       WaveSpeed:(CGFloat)speed
                       WaveHeight:(CGFloat)height
                       WaveColor:(UIColor *)color;

- (void)startWaving;

- (void)stopWaving;

- (void)startTimer;

- (void)stopTimer;

- (void)invalidateTimer;



@end
