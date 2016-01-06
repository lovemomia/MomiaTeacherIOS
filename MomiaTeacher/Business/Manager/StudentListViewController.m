//
//  StudentListViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/4.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "StudentListViewController.h"
#import "StudentListItemCell.h"
#import "StudentListModel.h"
#import "MJRefreshHelper.h"

static NSString * identifierStudentListItemCell = @"StudentListItemCell";

@interface StudentListViewController ()

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *coid;
@property (nonatomic, strong) NSString *sid;

@property (nonatomic, strong) NSArray *studentList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@end

@implementation StudentListViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.status = [[params valueForKey:@"status"] integerValue];
        self.coid = [params valueForKey:@"coid"];
        self.sid = [params valueForKey:@"sid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"学生列表";
    
    [StudentListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierStudentListItemCell];
    
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData];
}

- (void)requestData {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    if ([self.studentList count] == 0) {
        [self.view showLoadingBee];
    }
    
    NSString *path = self.status == 0 ? @"/teacher/course/notfinished/student" : @"/teacher/course/finished/student";
    self.curOperation = [[HttpService defaultService]GET:URL_APPEND_PATH(path)
                                              parameters:@{@"coid":self.coid, @"sid":self.sid} cacheType:CacheTypeDisable JSONModelClass:[StudentListModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     if ([self.studentList count] == 0) {
                                                         [self.view removeLoadingBee];
                                                     }
                                                     
                                                     StudentListModel *model = (StudentListModel *)responseObject;
                                                     if (model.data.count == 0) {
                                                         [self.view showEmptyView:@"学生列表为空~"];
                                                         return;
                                                     }
                                                     
                                                     self.studentList = model.data;
                                                     
                                                     [self.tableView reloadData];
                                                     self.isLoading = NO;
                                                     [self.tableView.mj_header endRefreshing];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     if ([self.studentList count] == 0) {
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
    if(indexPath.row < self.studentList.count) {
        Student * model = self.studentList[indexPath.row];
        if (self.status != 0 && ![model.commented boolValue]) {
            [self openURL:[NSString stringWithFormat:@"studentaddcomment?coid=%@&sid=%@&cid=%@", self.coid, self.sid, model.ids]];
            
        } else {
            [self openURL:[NSString stringWithFormat:@"studentdetail?id=%@", model.ids]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.studentList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    UITableViewCell * cell;
    
    StudentListItemCell *itemCell = [StudentListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierStudentListItemCell];
    if (self.status != 0) {
        itemCell.showStatus = YES;
    }
    itemCell.data = self.studentList[row];
    cell = itemCell;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView]) {
        return SCREEN_HEIGHT;
    }
    return 0.1;
}

@end
