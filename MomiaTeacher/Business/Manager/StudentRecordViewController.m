//
//  StudentRecordViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 16/1/5.
//  Copyright © 2016年 YouXing. All rights reserved.
//

#import "StudentRecordViewController.h"
#import "StudentRecordModel.h"

#import "StudentListItemCell.h"
#import "CharacterTagsCell.h"
#import "ContentInputCell.h"

static NSString * identifierStudentListItemCell = @"StudentListItemCell";
static NSString * identifierCharacterTagsCell = @"CharacterTagsCell";
static NSString * identifierContentInputCell = @"ContentInputCell";

@interface StudentRecordViewController ()<CharacterTagsCellDelegate, UITextViewDelegate>
@property (nonatomic, strong) NSString *coid;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) StudentRecordModel *model;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation StudentRecordViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.coid = [params objectForKey:@"coid"];
        self.sid = [params objectForKey:@"sid"];
        self.cid = [params objectForKey:@"cid"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"学生记录";
    
    [StudentListItemCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierStudentListItemCell];
    [CharacterTagsCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierCharacterTagsCell];
    [ContentInputCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierContentInputCell];
    
    [self requestData];
}

- (void)requestData {
    [self.view showLoadingBee];
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/teacher/student/record")
                                              parameters:@{@"coid":self.coid, @"sid":self.sid, @"cid":self.cid} cacheType:CacheTypeDisable JSONModelClass:[StudentRecordModel class]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                     self.model = responseObject;
                                                     [self.tableView reloadData];
                                                     [self.view removeLoadingBee];
                                                 }
                         
                                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                     [self showDialogWithTitle:nil message:error.message];
                                                     [self.view removeLoadingBee];
                                                 }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTagSelectChanged {
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

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        StudentListItemCell *studentCell = [StudentListItemCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierStudentListItemCell];
        studentCell.data = self.model.data.child;
        cell = studentCell;
        
    } else if (indexPath.section == 1) {
        CharacterTagsCell *tagsCell = [CharacterTagsCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierCharacterTagsCell];
        tagsCell.delegate = self;
        tagsCell.data = self.model;
        cell = tagsCell;
        
    } else {
        ContentInputCell *contentCell = [ContentInputCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierContentInputCell];
        contentCell.data = self.model.data.content;
        contentCell.contentTv.delegate = self;
        self.countLabel = contentCell.countLabel;
        cell = contentCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 70;
    } else if (indexPath.section == 1) {
        return [CharacterTagsCell heightWithTableView:tableView withIdentifier:identifierCharacterTagsCell forIndexPath:indexPath data:self.model];
        
    } else {
        return [ContentInputCell heightWithTableView:tableView withIdentifier:identifierContentInputCell forIndexPath:indexPath data:nil];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onDoneClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0.1;
}

- (void)onDoneClicked {
    [self.view showLoadingBee];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:self.model.data.content forKey:@"content"];
    NSMutableArray *tags = [NSMutableArray new];
    for (StudentRecordTag *tag in self.model.data.tags) {
        if ([tag.selected boolValue]) {
            [tags addObject:tag.ids];
        }
    }
    [dic setObject:tags forKey:@"tags"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/teacher/student/record")
                           parameters:@{@"coid":self.coid, @"sid":self.sid, @"cid":self.cid, @"record":jsonString}
                       JSONModelClass:[BaseModel class]
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  [self.view removeLoadingBee];
                                  [self.navigationController popViewControllerAnimated:YES];
                              }
     
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self showDialogWithTitle:nil message:error.message];
                                 [self.view removeLoadingBee];
                             }];
}

#pragma mark - textView delegate

- (void)textViewDidEndEditing:(UITextView *)textView {
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 300 - comcatstr.length;
    if (caninputlen >= 0) {
        return YES;
    }
    else {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 300)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:300];
        
        [textView setText:s];
    }
    self.model.data.content = textView.text;
    //不让显示负数
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0, 300 - existTextNum), 300];
}

@end
