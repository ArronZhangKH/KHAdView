//
//  ImgViewController.h
//  KHAdView_Demo
//
//  Created by Aaron_Zhang on 17/1/8.
//  Copyright © 2017年 Arron_zkh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgViewController : UIViewController

/** index */
@property(nonatomic, assign) NSInteger index;
/** source */
@property(nonatomic, copy) NSString *srcStr;
/** img */
@property(nonatomic, strong) UIImage *image;



@end
