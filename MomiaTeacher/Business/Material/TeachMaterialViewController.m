//
//  TeachMaterialViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/24.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "TeachMaterialViewController.h"
#import "MaterialListItemCell.h"
#import "MaterialListModel.h"
#import "MJRefreshHelper.h"
#import "NSString+MOURLEncode.h"

static NSString * identifierMaterialListItemCell = @"MaterialListItemCell";

@interface TeachMaterialViewController ()
@property (nonatomic, strong) NSMutableArray *materialList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation TeachMaterialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"教材教具";
    
    [MaterialListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierMaterialListItemCell];
    
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    self.materialList = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData];
}


- (void)refreshData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/teacher/material/list")
                                              parameters:@{@"start":@"0"} cacheType:CacheTypeDisable JSONModelClass:[MaterialListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [self.tableView.mj_header endRefreshing];
                                                     MaterialListModel *model = (MaterialListModel *)responseObject;
                                                     self.totalCount = model.data.totalCount;
                                                     self.nextIndex = model.data.nextIndex;
                                                     if ([self.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"还没有教材哦~"];
                                                         return;
                                                     }
                                                     
                                                     [self.materialList removeAllObjects];
                                                     
                                                     for (Material *order in model.data.list) {
                                                         [self.materialList addObject:order];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                 }];
}



- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.materialList count] == 0) {
        [self.view showLoadingBee];
    }
    
    int start = self.nextIndex ? [self.nextIndex intValue] : 0;
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(@"/teacher/material/list")
                                              parameters:@{@"start":[NSString stringWithFormat:@"%d", start]} cacheType:CacheTypeDisable JSONModelClass:[MaterialListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.materialList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     MaterialListModel *model = (MaterialListModel *)responseObject;
                                                     self.totalCount = model.data.totalCount;
                                                     self.nextIndex = model.data.nextIndex;
                                                     if ([self.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"还没有教材哦~"];
                                                         return;
                                                     }
                                                     
                                                     [self.materialList removeAllObjects];
                                                     
                                                     for (Material *order in model.data.list) {
                                                         [self.materialList addObject:order];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.materialList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                 }];
}

- (UITableViewCellSeparatorStyle)tableViewCellSeparatorStyle {
    return UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - tableview delegate & datasource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < self.materialList.count) {
        Material * model = self.materialList[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"http://%@/course/material?id=%@", MO_DEBUG ? @"m.momia.cn" : @"m.sogokids.com", model.ids];
        [self openURL:[NSString stringWithFormat:@"web?url=%@", [url URLEncodedString]]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nextIndex && self.nextIndex > 0) {
        return self.materialList.count + 1;
    }
    return self.materialList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.materialList.count) {
        static NSString * loadIdentifier = @"CellLoading";
        UITableViewCell * load = [tableView dequeueReusableCellWithIdentifier:loadIdentifier];
        if(load == nil) {
            load = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadIdentifier];
        }
        [load showLoadingBee];
        cell = load;
        if(!self.isLoading) {
            [self requestData];
            self.isLoading = YES;
        }
        
    } else {
        MaterialListItemCell *itemCell = [MaterialListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierMaterialListItemCell];
        itemCell.data = self.materialList[row];
        cell = itemCell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}


@end
