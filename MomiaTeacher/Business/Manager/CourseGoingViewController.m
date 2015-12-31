//
//  CourseGoingViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/25.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "CourseGoingViewController.h"
#import "MJRefreshHelper.h"
#import "CourseGoingModel.h"

#import "CourseListItemCell.h"
#import "ChildListItemCell.h"

static NSString * identifierCourseListItemCell = @"CourseListItemCell";
static NSString * identifierChildListItemCell = @"ChildListItemCell";

@interface CourseGoingViewController ()

@property (nonatomic, strong) CourseGoingModel *model;

@end

@implementation CourseGoingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [CourseListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCourseListItemCell];
    [ChildListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierChildListItemCell];
    
    self.tableView.mj_header = [MJRefreshHelper createGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    [self requestData];
}

- (void)requestData {
    if (self.model == nil) {
        [self.view showLoadingBee];
    }
    
    [[HttpService defaultService] GET:URL_APPEND_PATH(@"/teacher/course/ongoing") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[CourseGoingModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        
        self.model = responseObject;
        if (self.model.data.course == nil) {
            [self.view showEmptyView:@"课程还没有开始哦～"];
            
        } else {
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.model == nil) {
            [self.view removeLoadingBee];
        }
        [self showDialogWithTitle:nil message:error.message];
        [self.tableView.mj_header endRefreshing];
    }];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.model.data.students.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [CourseListItemCell heightWithTableView:tableView withIdentifier:identifierChildListItemCell forIndexPath:indexPath data:self.model.data.course];
    }
    return [ChildListItemCell heightWithTableView:tableView withIdentifier:identifierChildListItemCell forIndexPath:indexPath data:self.model.data.students[indexPath.row - 1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        CourseListItemCell *courseCell = [CourseListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCourseListItemCell];
        courseCell.data = self.model.data.course;
        cell = courseCell;
        
    } else {
        ChildListItemCell *childCell = [ChildListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierChildListItemCell];
        childCell.data = self.model.data.students[indexPath.row - 1];
        cell = childCell;
    }
    return cell;
}

@end
