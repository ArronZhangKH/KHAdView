#KHAdView  
###[中文版本](https://github.com/ArronZhangKH/KHAdView/blob/master/README-CN.md#khadview)
###Add an advertisement View with high perfromance for you app
- Using UICollectionView's reuse mechanism, effectively reduce memory consumption
- Capable of scrolling in two directions circularly
- Abundant interfaces to DIY your own ad view
- Image resource can be from Internet or local file 
- No limit in adding images, can be one or MAXFLOAT :P

####KHAdView can be added to any views 

e.g.  
A KHAdView in tableView:  
  
![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/KHAdView_Demo01.gif?raw=true)

##How to use
1. Download and copy the **KHAdView** folder with the source code in it to your project.
2. Initialize KHAdView, and give it a frame

        KHAdView *view = [[KHAdView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, KHAdView_Height)];
        self.tableView.tableHeaderView = view;
        _khAdView = view;
        
 	 Of course, you can just give CGRectZero to the method above and use __Auto Layout__ to define its frame.

3. Use "**setDataSource: WithSourceType:**" method to add dataSource for **KHAdView**, indicating the source by using KHSourceInternetType or KHSourceLocalType

		[self.khAdView setDataSource:_urlArr 	WithSourceType:KHSourceInternetType];
		
4. Perform the method "**startTimer**" when you want it to scroll automatically.
		
		[self.khAdView startTimer];
		
####So far, you already got yourself an ad View with high performance.

###Wait a minute, you can also DIY it !
###A new effect after DIY  
![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/KHAdView_Demo02.gif?raw=true)  
 
##How to DIY
1. Change the color of subViews
	- Change the background color of the bottomView, which is black in default. 
  	
 			 self.khAdView.bottomViewColor = [UIColor redColor];
  	  
  	- Change the indicating color of the pageControl, which is white in default. 
  	  	
   		    self.khAdView.pageIndicatorTintColor = [UIColor yellowColor];
   		    
  	- Change the current page indicatiing color of the pageControl, which is red in default. 
  	
    	    self.khAdView.currentPageIndicatorTintColor = [UIColor blackColor];
    	    


2. Change the height of the bottomView, which is 30 in default.

		self.khAdView.bottomViewHeight = 50;
	
3. Change the alpha of the bottomView, which is 0.3 in default.

		self.khAdView.alpha = 1.0;

4. Change the time interval of the timer, which is 2 in default.

		self.khAdView.timeInterval = 1.f;
	
5. Change the scroll direction, which is from right to left in default.

		self.khAdView.direction = KHScrollDirectionFromLeft;
6. Hide the bottomView and the pageControl. Default is not hidden.

		self.khAdView.hideBottomView = YES;
    	self.khAdView.hidePageControl = YES;

  	

###An effect by using local file and hidding the bottomView 
![()](https://github.com/ArronZhangKH/KH_Resources/blob/master/KhAdView_Demo03.gif?raw=true)

####TO DO
- Add core animation, making the transition cooler
- Add vertical directions 


