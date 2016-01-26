//
//  MineViewController.m
//  MomiaIOS
//
//  Created by Deng Jun on 15/4/23.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "MineViewController.h"
#import "FeedbackViewController.h"
#import "Child.h"
#import "CommonTableViewCell.h"
#import "ChatListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "NSString+MOURLEncode.h"

@interface MineViewController ()

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"我的";
    
    [[AccountService defaultService] addListener:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[AccountService defaultService]removeListener:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onMineDotChanged" object:nil];
}

- (void)onAccountChange {
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// 单击设置
- (void)onSettingClicked {
    NSURL *url = [NSURL URLWithString:@"setting"];
    [[UIApplication sharedApplication ] openURL:url];
}

- (void)onLoginClicked {
    [[AccountService defaultService] login:self success:nil];
}

#pragma mark - tableview delegate & datasource

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section == 0) {
//        return 59;
//    }
//    return 44;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:
        {
            if ([[AccountService defaultService] isLogin]) {
                [[UIApplication sharedApplication ] openURL:MOURL(@"personinfo")];
                
                [MobClick event:@"Mine_PersonInfo"];
            }
        }
            break;
        case 1:
            if(row == 0) {
                [self openURL:@"applyteacher"];
                
                [MobClick event:@"Mine_Apply"];
                
            }
            break;
        case 2:
            if(row == 0) {
                NSString *title = @"系统消息";
                NSString *url = [NSString stringWithFormat:@"chatpublic?type=6&targetid=10000&username=%@&title=%@", [title URLEncodedString], [title URLEncodedString]];
                [self openURL:url];
                
                [MobClick event:@"Mine_Message"];
                
            } else {
                [self openURL:@"setting"];
                
                [MobClick event:@"Mine_Setting"];
            }
            break;
            
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellUser = @"CellUser";
    static NSString *CellLogin = @"CellLogin";
    static NSString *CellCommon = @"CommonTableViewCell";
    UITableViewCell *cell;
    if (section == 0) {
        if ([[AccountService defaultService] isLogin]) {
            cell = [tableView dequeueReusableCellWithIdentifier:CellUser];
            if (cell == nil) {
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
                cell = [arr objectAtIndex:0];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            Account *account = [AccountService defaultService].account;
            
            UIImageView *userPic = (UIImageView *)[cell viewWithTag:1];
            if (account.avatar) {
                [userPic sd_setImageWithURL:[NSURL URLWithString:account.avatar]];
            }
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
            titleLabel.text = account.nickName;
            
            UILabel *subTitleLabel = (UILabel *)[cell viewWithTag:3];
            subTitleLabel.text = account.mobile;
            
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:CellLogin];
            if (cell == nil) {
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"MineInfoCell" owner:self options:nil];
                cell = [arr objectAtIndex:1];
            }
            UIButton *loginBtn = (UIButton *)[cell viewWithTag:1001];
            [loginBtn addTarget:self action:@selector(onLoginClicked) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellCommon];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"CommonTableViewCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        CommonTableViewCell *commonCell = (CommonTableViewCell *)cell;
        commonCell.dotIv.hidden = YES;
        
        switch (section) {
            case 1:
                if (row == 0) {
                    commonCell.titleLabel.text = @"成为助教";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconBooking"];
                }
                break;
            case 2:
                if (row == 0) {
                    commonCell.titleLabel.text = @"系统消息";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconFeedback"];
                    if ([[RCIMClient sharedRCIMClient] getUnreadCount:ConversationType_PRIVATE targetId:@"10000"] > 0) {
                        commonCell.dotIv.hidden = NO;
                    } else {
                        commonCell.dotIv.hidden = YES;
                    }
                    
                } else {
                    commonCell.titleLabel.text = @"设置";
                    commonCell.iconIv.image = [UIImage imageNamed:@"IconSetting"];
                }
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)shareToFriend {
    
}


@end
