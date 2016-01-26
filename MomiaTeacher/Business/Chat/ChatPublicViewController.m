//
//  ChatPublicViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/12/2.
//  Copyright © 2015年 Deng Jun. All rights reserved.
//

#import "ChatPublicViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface ChatPublicViewController ()

@end

@implementation ChatPublicViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super init]) {
        self.conversationType = [self convertType:[params objectForKey:@"type"]];
        self.targetId = [params objectForKey:@"targetid"];
        self.userName = [params objectForKey:@"username"];
        self.title = [params objectForKey:@"title"];
        
        self.hidesBottomBarWhenPushed = YES;
        self.displayUserNameInCell = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.chatSessionInputBarControl.hidden = YES;
    self.customFlowLayout.collectionView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self scrollToBottomAnimated:NO];
    
    if (self.conversationDataRepository.count == 0) {
        [self.view showEmptyView:@"还没有系统消息哦～"];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveServerNotification:) name:@"onReceiveServerNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"BgTitleShadow"];
    self.chatSessionInputBarControl.hidden = YES;
    self.customFlowLayout.collectionView.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onReceiveServerNotification" object:nil];
}

- (void)onReceiveServerNotification:(NSNotification*)notify {
    if (self.conversationDataRepository.count > 0) {
        [self.view removeEmptyView];
    }
}

- (RCConversationType)convertType:(NSNumber *)type {
    if (type) {
        int typeInt = [type intValue];
        if (typeInt == 6) {
            return ConversationType_SYSTEM;
        }
        if (typeInt == 8) {
            return ConversationType_PUBLICSERVICE;
        }
        if (typeInt == 9) {
            return ConversationType_PUSHSERVICE;
        }
    }
    return ConversationType_SYSTEM;
}

- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[RCTextMessage class]]) {
        NSString *pushData = ((RCTextMessage *)model.content).extra;
        if (pushData.length > 0 && [pushData containsString:MO_SCHEME]) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:pushData]];
        }
    }
}

@end
