#KHAdView  
###[English Doc](https://github.com/ArronZhangKH/KHAdView/blob/master/README.md#khadview)
###为你的App添加一个高性能的广告视图
- 使用**UICollectionView**的复用机制，有效减少内存占用
- 支持双向循环滚动
- 可自定义广告视图
- 既可以加载URL也可以加载本地文件  
- 支持 **“1-MAXFLOAT”** 张的视图播放

####KHAdView可以添加任何视图上  

例如，添加到**UITableView上**:  

![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/KHAdView_Demo01.gif?raw=true)

##使用方法
1. 下载并复制**KHAdView**文件夹下的源代码到你的工程目录。
2. 初始化**KHAdView**，并为其赋值一个**Frame**。

        KHAdView *view = [[KHAdView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, KHAdView_Height)];
        self.tableView.tableHeaderView = view;
        _khAdView = view;
  当然，你也可以通过Auto Layout来设置它的大小和位置
3. 使用“**setDataSource: WithSourceType:**”方法给**KHAdView**添加数据源，通过SourceType来指定加载的数据源是URL还是本地文件。

		[self.khAdView setDataSource:_urlArr 	WithSourceType:KHSourceInternetType];
4. 开启定时器，让广告视图循环滚动。
		
		[self.khAdView startTimer];
		
####到此你就成功添加了一个高性能的广告视图！
  
  
###等等，你还可以进行自定义!
###自定义后可以得到全新的效果
![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/KHAdView_Demo02.gif?raw=true)  

##如何自定义：
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

		self.khAdView.alpha = 1.0;

4. 改变定时器的时间间隔，默认是2

		self.khAdView.timeInterval = 1.f;
	
5. 改变广告视图的滚动方向，默认是从右向左滚动

		self.khAdView.direction = KHScrollDirectionFromLeft;
6. 隐藏底部背景栏和页码指示器，默认不隐藏

		self.khAdView.hideBottomView = YES;
    	self.khAdView.hidePageControl = YES;
   	

###隐藏底部背景栏，并使用本地文件的效果
![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/KhAdView_Demo03.gif?raw=true)

####后续工作
- 添加核心动画，让视图的转场动画效果更酷炫
- 丰富广告栏的滚动方向，让它还能上下滚动。

