#KHAdView  
###特色一览
- 使用**UICollectionView**的复用机制
- 支持广告轮播图的自定义
- 网络图片异步下载和缓存机制
- 加载网络图片时可设置占位图片
- 一行代码实现点击图片的响应事件
- 波浪刷新效果  


###使用示例_01

![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/Demo03.gif?raw=true)

###使用方法
1. 下载并复制**KHAdView**文件夹下的源代码到你的工程目录;
2. 初始化**KHAdView**;
3. 一句代码实现加载网络图片, 设置占位图片和响应点击事件;
	- 说明 : ClickHandler这个block中返回的参数分别为图片的索引, 图片的来源(URL或本地图片名), 以及图片本身
	

			[self.khAdView setUpOnlineImagesWithSource:self.urlArr 
							PlaceHolder:[UIImage imageNamed:@"001"] 
							ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
			 //在这个block中设置点击图片后要进行的操作
       		 [weakSelf pushToImgViewControllerWithIndex:index Image:img ImageSource:imgSrc];
        
    		}];
4. 或者一句代码实现加载本地图片和设置响应点击事件;

		[self.khAdView setUpLocalImagesWithSource:self.localArr 
						ClickHandler:^(NSInteger index, NSString *imgSrc, UIImage *img) {
			 //在这个block中设置点击图片后要进行的操作
       		 [weakSelf pushToImgViewControllerWithIndex:index Image:img ImageSource:imgSrc];
        
   		 }];
5. 开启或关闭图片轮播的定时器

		[self.khAdView startTimer];
		[self.khAdView stopTimer];
		
###使用示例_02

![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/Demo04.gif?raw=true)

###使用方法
1. 隐藏底部的PageControl, 再使用一行代码初始化波浪View

		self.khAdView.hideBottomView = YES;
  	 	self.khAdView.hidePageControl = YES;
    	[self.khAdView enableWavingWithDuration:0.f
                                     WaveSpeed:12.f
                                     WaveHeight:12.f
                                     WaveColor:[UIColor whiteColor]];

2. 在**scrollViewDidEndDecelerating**代理方法中启动波动效果 

		- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   		
   			 [self.khAdView startWaving];
		}  
	
 
###如何自定义：
1. 改变控件的颜色
	- 改变底部背景栏的颜色，默认是黑色
  	
 			 self.khAdView.bottomViewColor = [UIColor redColor];
  	  
  	- 改变**PageControl**的指示颜色，默认是白色
  	
   		    self.khAdView.pageIndicatorTintColor = [UIColor yellowColor];
   		    
  	- 改变当前页**PageControl**的指示颜色，默认是红色
  	
    	    self.khAdView.currentPageIndicatorTintColor = [UIColor blackColor];
    	    

2. 改变底部背景栏的高度，默认是30

		self.khAdView.bottomViewHeight = 50;
	
3. 改变底部背景栏的透明度，默认是0.3

		self.khAdView.alpha = 0.5;

4. 改变定时器的时间间隔，默认是2

		self.khAdView.timeInterval = 1.f;
	
5. 改变广告视图的滚动方向，默认是从右向左滚动

		self.khAdView.direction = KHScrollDirectionFromLeft;


###后续工作
- 添加更多有趣的效果
- 添加核心动画，让图片的转换效果更丰富
- 丰富广告栏的滚动方向，让它还能上下滚动。

