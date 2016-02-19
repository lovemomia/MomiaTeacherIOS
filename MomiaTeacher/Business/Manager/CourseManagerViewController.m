//
//  CourseManagerViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/24.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "CourseManagerViewController.h"
#import "CourseGoingViewController.h"
#import "CourseListViewController.h"
#import "LJViewPager.h"
#import "LJTabBar.h"

@interface CourseManagerViewController ()<LJViewPagerDataSource, LJViewPagerDelegate, LJTabBarDelegate>

@property (strong, nonatomic) LJViewPager *viewPager;
@property (strong, nonatomic) LJTabBar *tabBar;

@property (strong, nonatomic) CourseGoingViewController *courseGoingVC;
@property (strong, nonatomic) CourseListViewController *courseUnstartVC;
@property (strong, nonatomic) CourseListViewController *courseFinishVC;

@end

@implementation CourseManagerViewController

- (BOOL)isNavDarkStyle {
    return true;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"课程管理";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.viewPager];
    [self.view addSubview:self.tabBar];
    self.viewPager.viewPagerDateSource = self;
    self.viewPager.viewPagerDelegate = self;
    self.tabBar.titles = @[@"上课中", @"待上课", @"已上课"];
    self.viewPager.tabBar = self.tabBar;
    
    self.tabBar.itemsPerPage = 3;
    self.tabBar.showShadow = NO;
    self.tabBar.textColor = UIColorFromRGB(0x333333);
    self.tabBar.textFont = [UIFont systemFontOfSize:16];
    self.tabBar.selectedTextColor = MO_APP_ThemeColor;
    self.tabBar.indicatorColor = MO_APP_ThemeColor;
    self.tabBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - pager view data source
- (UIViewController *)viewPagerInViewController {
    return self;
}

- (NSInteger)numbersOfPage {
    return 3;
}

- (UIViewController *)viewPager:(LJViewPager *)viewPager controllerAtPage:(NSInteger)page {
    if (page == 0) {
        self.courseGoingVC = [[CourseGoingViewController alloc]initWithParams:nil];
        return self.courseGoingVC;
        
    } else if (page == 1) {
        self.courseUnstartVC = [[CourseListViewController alloc]initWithParams:@{@"status":@"0"}];
        return self.courseUnstartVC;
        
    } else {
        self.courseFinishVC = [[CourseListViewController alloc]initWithParams:@{@"status":@"1"}];
        return self.courseFinishVC;
    }
}

#pragma mark - pager view delegate
- (void)viewPager:(LJViewPager *)viewPager didScrollToPage:(NSInteger)page {
    if (page == 0) {
        [self.courseGoingVC refresh];
    } else if (page == 1) {
        [self.courseUnstartVC refresh];
    } else {
        [self.courseFinishVC refresh];
    }
}

- (void)viewPager:(LJViewPager *)viewPager didScrollToOffset:(CGPoint)offset {
    
}

#pragma mark - tabbar delegate
- (void)tabBar:(LJTabBar *)tabBar didSelectedItemAtIndex:(NSUInteger)index {
    if (index == 0) {
        [self.courseGoingVC refresh];
    } else if (index == 1) {
        [self.courseUnstartVC refresh];
    } else {
        [self.courseFinishVC refresh];
    }
}

- (UIView *)tabBar {
    if (_tabBar == nil) {
        int tabHeight = 44;
        _tabBar = [[LJTabBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tabHeight)];
        _tabBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _tabBar;
}

- (LJViewPager *)viewPager {
    if (_viewPager == nil) {
        _viewPager = [[LJViewPager alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.tabBar.frame),
                                                                   self.view.frame.size.width,
                                                                   self.view.frame.size.height - CGRectGetMaxY(self.tabBar.frame))];
        _viewPager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _viewPager;
}

@end
