//
//  MORootViewController.h
//  MomiaIOS
//
//  Created by Deng Jun on 15/6/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MORootViewController : UITabBarController

@property (nonatomic, assign) BOOL isFirstLogin;

- (void)makeTabBarHidden:(BOOL)hide;

@end
