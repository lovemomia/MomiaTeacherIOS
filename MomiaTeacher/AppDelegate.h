//
//  AppDelegate.h
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/23.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MORootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setTitleShadow:(UIImage *)image aboveSubview:(UIView *)view;

@property (strong, nonatomic) MORootViewController *root;

@property (retain, nonatomic) NSString *appKey;
@property (retain, nonatomic) NSString *appSecret;
@property (retain, nonatomic) NSString *appID;
@property (retain, nonatomic) NSString *clientId;

@property (nonatomic, strong) NSMutableDictionary *imUserDic;
@property (nonatomic, strong) NSMutableDictionary *imGroupDic;

@end
