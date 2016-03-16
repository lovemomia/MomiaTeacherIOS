//
//  SettingViewController.m
//  MomiaIOS
//
//  Created by Owen on 15/5/12.
//  Copyright (c) 2015年 Deng Jun. All rights reserved.
//

#import "SettingViewController.h"
#import "SGActionView.h"
#import "AppDelegate.h"


@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"设置";
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)switchAction:(id)sender
{
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [MBProgressHUD hideHUDForView:self.view animated:NO];
                [self.tableView reloadData];
            }];
        }
        
    } else if (indexPath.section == 1) {
        [self openURL:@"about"];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    static NSString *CellDefault = @"DefaultCell";
    
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
    if(cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
    
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.detailTextLabel.font = [UIFont systemFontOfSize: 12.0];
    
    switch (section) {
        case 0:
            if (row == 0) {
                cell.textLabel.text = @"清除缓存";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM", (float)[[SDImageCache sharedImageCache] getSize] / (1024 * 1024)];
            }
            break;
        case 1:
            cell.textLabel.text = @"关于我们";
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


@end
