//
//  KHAdView.m
//  KHAdView
//
//  Created by qianfeng on 16/9/25.
//  Copyright © 2016年 Aaron_zkh. All rights reserved.
//

#import "KHAdView.h"

typedef NS_ENUM(NSInteger, KHSourceType){
    KHSourceOnlineType = 0,
    KHSourceLocalType = 1
};

@interface KHAdView ()<UICollectionViewDelegate, UICollectionViewDataSource>


@property (nonatomic, weak)  UICollectionView *collectionView;
/** 控制图片轮播的计时器 */
@property (nonatomic, strong)  NSTimer *timer;
/** 分页提示栏 */
@property (nonatomic, weak)  UIPageControl *pageControl;
/** 底部的pageControl的背景View */
@property (nonatomic, weak)  UIView *bottomView;

/** 图片的来源(可以是URL或者本地文件名) */
@property (nonatomic, strong)  NSArray<NSString *> *dataSource;
/** 要展示的图片 */
@property(nonatomic, strong) NSMutableArray<UIImage *> *images;
/** 占位图片 */
@property(nonatomic, strong) UIImage *placeHolderImg;

/** 子线程缓存 */
@property(nonatomic, strong) NSMutableDictionary *operationDictM;
/** 图片缓存 */
@property(nonatomic, strong) NSMutableDictionary *imageDictM;
/** 子线程 */
@property(nonatomic, strong) NSOperationQueue *queue;

/** 波浪view */
@property(nonatomic, weak) UIView *waveView;
/** 计时器 */
@property (nonatomic, strong)  CADisplayLink *displayLink;
/** 波浪Layer */
@property (nonatomic, strong)  CAShapeLayer *shapeLayer;

/** 波浪高度 */
@property (nonatomic, assign)  CGFloat waveHeight;
/** 波浪偏移量 */
@property (nonatomic, assign)  CGFloat waveOffset;
/** 波动出现时间(waveTime = 0时波浪不消失) */
@property (nonatomic, assign)  NSTimeInterval waveTime;
/** 波浪移动速度 */
@property (nonatomic, assign)  CGFloat waveSpeed;
/** 波浪颜色 */
@property (nonatomic, weak)  UIColor *waveColor;


@end

@implementation KHAdView


#pragma mark - Lazy load
- (UIView *)bottomView{
    if (!_bottomView ) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = self.bottomViewColor;
        view.alpha = self.alpha;
        [self addSubview:view];
        _bottomView = view;
        [self bringSubviewToFront:self.pageControl];
    }
    return _bottomView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        UIPageControl *pageC = [[UIPageControl alloc]init];
        pageC.currentPage = 0;
        
        [self addSubview:pageC];
        _pageControl = pageC;
    }
    _pageControl.numberOfPages = self.dataSource.count;
    return _pageControl;
}

- (NSMutableDictionary *)operationDictM{
    if (!_operationDictM) {
        _operationDictM = [NSMutableDictionary dictionary];
    }
    return _operationDictM;
}

- (NSMutableDictionary *)imageDictM{
    if (!_imageDictM) {
        _imageDictM = [NSMutableDictionary dictionary];
    }
    return _imageDictM;
}

- (NSOperationQueue *)queue{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.pagingEnabled = YES;
        
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = NO;
        [collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        [self addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (UIView *)waveView{
    if (!_waveView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - _waveHeight / 2, CGRectGetWidth(self.frame), _waveHeight)];
        [self addSubview:view];
        _waveView = view;
    }
    return _waveView;
}

- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = _waveColor.CGColor;
        [self.waveView.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}

- (CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleWave)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.image = self.images[indexPath.row];
    [cell.contentView addSubview:imageView];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickImageHandler) {
        NSInteger index = 0;
        if (indexPath.item == 0) {
            index = 1;
            self.clickImageHandler(index, [self.dataSource lastObject], self.images[indexPath.item]);
        }else if (indexPath.item == self.images.count - 1){
            index = self.dataSource.count;
            self.clickImageHandler(index, [self.dataSource firstObject], self.images[indexPath.item]);
        }else{
            index = indexPath.item;
            self.clickImageHandler(index, self.dataSource[indexPath.item - 1], self.images[indexPath.item]);
        }
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage = (scrollView.contentOffset.x / CGRectGetWidth(self.frame)) - 1;
    self.pageControl.currentPage = currentPage;
    
    if (currentPage < 0)
    {
        self.pageControl.currentPage = self.dataSource.count - 1;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataSource.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
    else if (currentPage == self.dataSource.count)
    {
        self.pageControl.currentPage = 0;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}


#pragma mark - SetUp Images

- (void)setUpOnlineImagesWithSource:(NSArray<NSString *> *)dataSource
                        PlaceHolder:(UIImage *)image
                       ClickHandler:(ClickImageHandler)handler{
    
    [self setDataSource:dataSource WithSourceType:KHSourceOnlineType PlaceHolder:image];
    self.clickImageHandler = handler;
}

- (void)setUpLocalImagesWithSource:(NSArray<NSString *> *)dataSource
                      ClickHandler:(ClickImageHandler)handler{
    
    [self setDataSource:dataSource WithSourceType:KHSourceLocalType PlaceHolder:nil];
    self.clickImageHandler = handler;
}

- (void)setDataSource:(NSArray *)dataSource
       WithSourceType:(KHSourceType)sourceType
          PlaceHolder:(UIImage *)image{
    
    _dataSource = dataSource;
    self.placeHolderImg = image;
    self.images = [NSMutableArray array];
    NSInteger count = dataSource.count + 2;
    
    switch (sourceType) {
        case KHSourceOnlineType:
        {
            if (self.imageDictM.count != dataSource.count) {
                [self downloadImages:dataSource];
            }
            self.images = [self getDisplayImgs:self.imageDictM DataSource:dataSource];
            break;
        }
            
        default:
            for (NSInteger i = 0; i < count; i++) {
                if (i == 0) {
                    image = [UIImage imageNamed:[dataSource lastObject]];
                }else if(i == count - 1){
                    image = [UIImage imageNamed:[dataSource firstObject]];
                }else{
                    image = [UIImage imageNamed:dataSource[i - 1]];
                }
                [self.images addObject:image];
            }
            break;
    }
  
    [self.collectionView reloadData];
}

- (NSMutableArray *)getDisplayImgs:(NSDictionary *)imageDict DataSource:(NSArray *)dataSource{
    
    NSMutableArray *imgArrM = [NSMutableArray array];
    NSInteger count = dataSource.count + 2;
    UIImage *img = nil;
    
    for (NSInteger i = 0; i < count; i++) {
        NSString *imgUrl = nil;
        if (i == 0) {
            imgUrl = [dataSource lastObject];
        }else if(i == count - 1){
            imgUrl = [dataSource firstObject];
        }else{
            imgUrl = dataSource[i - 1];
        }
        img = [self.imageDictM objectForKey:imgUrl];
        [imgArrM addObject:img];
    }
    return imgArrM;
}

- (void)downloadImages:(NSArray *)urlArr{
    
    for (NSInteger i = 0; i < urlArr.count; i++) {
        NSString *imageUrl = urlArr[i];
        UIImage *image = [self.imageDictM objectForKey:imageUrl];
        //如果没有内存缓存
        if (!image) {
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *filePath = [cachePath stringByAppendingString:[imageUrl lastPathComponent]];
            BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
            //如果没有沙盒缓存
            if (!exist) {
                [self.imageDictM setObject:self.placeHolderImg forKey:imageUrl];
                NSOperation *downloadOP = [self.operationDictM objectForKey:imageUrl];
                //如果没有子线程缓存
                if (!downloadOP) {
                    NSBlockOperation *download = [NSBlockOperation blockOperationWithBlock:^{
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                        UIImage *image = [UIImage imageWithData:imageData];
                        NSLog(@"下载图片----%ld", i);
                        //容错处理
                        if (!image) {
                            [self.operationDictM removeObjectForKey:imageUrl];
                            return;
                        }
                        
                        [self.imageDictM setObject:image forKey:imageUrl];
                        [imageData writeToFile:filePath atomically:YES];
                        [self.operationDictM removeObjectForKey:imageUrl];
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //如果线程缓存数==0, 所有图片已经下载完毕, 刷新视图
                            NSInteger operationCount = self.operationDictM.count;
                            if (operationCount == 0) {
                                self.images = [self getDisplayImgs:self.imageDictM DataSource:urlArr];
                                [self.collectionView reloadData];
                            }
                        }];
                    }];
                    
                    [self.operationDictM setObject:download forKey:imageUrl];
                    [self.queue addOperation:download];
                }
            }else{
                image = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
                [self.imageDictM setObject:image forKey:imageUrl];
                NSLog(@"从沙盒中获取图片");
            }
        }else{
            [self.imageDictM setObject:image forKey:imageUrl];
            NSLog(@"从内存中获取图片");
        }
    }
}


#pragma mark - Hanlde Timer
- (void)timerHandle{
    
    NSInteger curPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    NSInteger nextPage = 0;
    
    if (self.direction == KHScrollDirectionFromRight) {
        nextPage = curPage + 1;
        if (nextPage == self.images.count) {
            nextPage = 2;
        }
    }else{
        nextPage = curPage - 1;
        if (nextPage < 0) {
            nextPage = self.images.count - 2;
        }
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (void)startTimer{
    [self timer];
}

- (void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Other methods
- (void)setHideBottomView:(BOOL)hideBottomView{
    _hideBottomView = hideBottomView;
    self.bottomView.hidden = hideBottomView;
}

- (void)setHidePageControl:(BOOL)hidePageControl{
    _hidePageControl = hidePageControl;
    self.pageControl.hidden = hidePageControl;
}

- (void)setAlpha:(CGFloat)alpha{
    _alpha = alpha;
    self.bottomView.alpha = alpha;
}

- (void)invalidateTimer{
    [self stopTimer];
}

- (void)setClickImageHandler:(ClickImageHandler)handler{
    _clickImageHandler = handler;
}

#pragma mark - Init methods
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    _timeInterval = 2.f;
    _bottomViewColor = [UIColor blackColor];
    _pageIndicatorTintColor = [UIColor whiteColor];
    _currentPageIndicatorTintColor = [UIColor redColor];
    _bottomViewHeight = 30;
    _direction = KHScrollDirectionFromRight;
    _alpha = 0.3;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.bottomViewHeight;
    CGFloat y = CGRectGetHeight(self.frame) - height;
    
    self.bottomView.frame = CGRectMake(0, y, width, height);
    self.pageControl.frame = CGRectMake(0, y, width, height);
    
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
}


#pragma mark - Handle Waving
- (void)enableWavingWithDuration:(NSTimeInterval)duration
                       WaveSpeed:(CGFloat)speed
                       WaveHeight:(CGFloat)height
                       WaveColor:(UIColor *)color{
    
    _waveTime = duration;
    _waveColor = color;
    _waveSpeed = speed;
    _waveHeight = height;
    _waveOffset = 0.f;
    
    [self shapeLayer];
}

- (void)handleWave{
    
    self.waveOffset += self.waveSpeed;
    
    CGFloat width = CGRectGetWidth(self.waveView.frame);
    CGFloat height = CGRectGetHeight(self.waveView.frame);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height / 2);
    
    CGFloat y = 0.f;
    for (CGFloat x = 0; x <= width; x++) {
        y = height * sin(0.01 * (x + self.waveOffset));
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    
    CGPathAddLineToPoint(path, NULL, width, height);
    CGPathAddLineToPoint(path, NULL, 0, height);
    CGPathCloseSubpath(path);
    self.shapeLayer.path = path;
    
    CGPathRelease(path);
}

- (void)startWaving{
    
    [self displayLink];
    
    if (self.waveTime) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.waveTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopWaving];
        });
    }
}

- (void)stopWaving{
    [UIView animateWithDuration:1.5f animations:^{
        self.waveView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        self.shapeLayer.path = nil;
        self.waveView.alpha = 1.f;
    }];
}



@end
