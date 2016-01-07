//
//  CourseListViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "CourseListViewController.h"
#import "CourseListItemCell.h"
#import "CourseListModel.h"
#import "MJRefreshHelper.h"

static NSString * identifierMaterialListItemCell = @"CourseListItemCell";

@interface CourseListViewController ()
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber *nextIndex;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation CourseListViewController

- (BOOL)isNavDarkStyle {
    return true;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.status = [[params valueForKey:@"status"] integerValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierMaterialListItemCell];
    
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    self.orderList = [NSMutableArray new];
    self.nextIndex = 0;
    [self requestData];
}


- (void)refreshData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    NSString *path = self.status == 0 ? @"/teacher/course/notfinished" : @"/teacher/course/finished";
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(path)
                                              parameters:@{@"start":@"0"} cacheType:CacheTypeDisable JSONModelClass:[CourseListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     [self.tableView.mj_header endRefreshing];
                                                     CourseListModel *model = (CourseListModel *)responseObject;
                                                     self.totalCount = model.data.totalCount;
                                                     self.nextIndex = model.data.nextIndex;
                                                     if ([self.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"课程列表为空~"];
                                                         return;
                                                     }
                                                     
                                                     [self.orderList removeAllObjects];
                                                     
                                                     for (Course *order in model.data.list) {
                                                         [self.orderList addObject:order];
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
    
    if ([self.orderList count] == 0) {
        [self.view showLoadingBee];
    }
    
    int start = self.nextIndex ? [self.nextIndex intValue] : 0;
    NSString *path = self.status == 0 ? @"/teacher/course/notfinished" : @"/teacher/course/finished";
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(path)
                                              parameters:@{@"start":[NSString stringWithFormat:@"%d", start]} cacheType:CacheTypeDisable JSONModelClass:[CourseListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.orderList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     CourseListModel *model = (CourseListModel *)responseObject;
                                                     self.totalCount = model.data.totalCount;
                                                     self.nextIndex = model.data.nextIndex;
                                                     if ([self.totalCount intValue] == 0) {
                                                         [self.view showEmptyView:@"课程列表为空~"];
                                                         return;
                                                     }
                                                     
                                                     [self.orderList removeAllObjects];
                                                     
                                                     for (Course *order in model.data.list) {
                                                         [self.orderList addObject:order];
                                                     }
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.orderList count] == 0) {
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
    if(indexPath.row < self.orderList.count) {
        Course * model = self.orderList[indexPath.row];
        [self openURL:[NSString stringWithFormat:@"studentlist?coid=%@&sid=%@&status=%d", model.courseId, model.courseSkuId, self.status]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.nextIndex && self.nextIndex > 0) {
        return self.orderList.count + 1;
    }
    return self.orderList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    if(row == self.orderList.count) {
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
        CourseListItemCell *itemCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierMaterialListItemCell];
        if (self.status != 0) {
            itemCell.showStatus = YES;
        }
        itemCell.data = self.orderList[row];
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
