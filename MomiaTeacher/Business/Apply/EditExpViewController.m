//
//  AddEduViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "EditExpViewController.h"

#import "EditExpLineInputCell.h"
#import "EditExpContentInputCell.h"
#import "ExperienceModel.h"
#import "ActionSheetPickView.h"

#define MAX_LIMIT_NUMS     500 //最大输入只能100个字符

static NSString *identifierEditExpLineInputCell = @"EditExpLineInputCell";
static NSString *identifierEditExpContentInputCell = @"EditExpContentInputCell";

@interface EditExpViewController ()<UITextViewDelegate, ActionSheetPickViewDelegate>
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *post;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation EditExpViewController

- (void)setModel:(Experience *)model {
    _model = model;
    self.school = model.school;
    self.post = model.post;
    self.time = model.time;
    self.content = model.content;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        NSDictionary *exp = [params objectForKey:@"exp"];
        if (exp) {
            self.model = [[Experience alloc]initWithDictionary:exp error:nil];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"工作经历";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onTitleBtnClicked)];
    
    [EditExpLineInputCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierEditExpLineInputCell];
    [EditExpContentInputCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierEditExpContentInputCell];
}

- (void)onTitleBtnClicked {
    if (self.model) {
        self.model.school = self.school;
        self.model.post = self.post;
        self.model.time = self.time;
        self.model.content = self.content;
        if ([self checkContent:self.model]) {
            [self requestSaveContent:self.model];
        }
        
    } else {
        Experience *exp = [[Experience alloc]init];
        exp.ids = [NSNumber numberWithInt:0];
        exp.school = self.school;
        exp.post = self.post;
        exp.time = self.time;
        exp.content = self.content;
        if ([self checkContent:exp]) {
            [self requestSaveContent:exp];
        }
    }
}

- (BOOL)checkContent:(Experience *)exp {
    if (exp.school.length == 0) {
        [self showDialogWithTitle:nil message:@"学校不能为空"];
        return NO;
    }
    if (exp.post.length == 0) {
        [self showDialogWithTitle:nil message:@"岗位不能为空"];
        return NO;
    }
    if (exp.time.length == 0) {
        [self showDialogWithTitle:nil message:@"在职时间不能为空"];
        return NO;
    }
    if (exp.content.length == 0) {
        [self showDialogWithTitle:nil message:@"工作内容不能为空"];
        return NO;
    }
    return YES;
}

- (void)requestSaveContent:(Experience *)exp {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.curOperation = [[HttpService defaultService]POST:URL_APPEND_PATH(@"/teacher/experience") parameters:@{@"experience":[exp toJSONString]}  JSONModelClass:[ExperienceModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        ExperienceModel *model = responseObject;
        
        if (self.delegate) {
            [self.delegate onExpAdded:model.data];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showDialogWithTitle:nil message:error.message];
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

#pragma mark ZhpickVIewDelegate

-(void)toolbarDonBtnHaveClick:(ActionSheetPickView *)pickView resultString:(NSString *)resultString{
    self.time = resultString;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        ActionSheetPickView *pickview=[[ActionSheetPickView alloc] initPickviewWithPlistName:@"date" isHaveNavControler:NO];
        pickview.title = @"时间段";
        pickview.delegate = self;
        
        [pickview show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            EditExpLineInputCell *lineCell = [EditExpLineInputCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierEditExpLineInputCell];
            UITextField *inputField = lineCell.inputTextFiled;
            if (indexPath.row == 0) {
                inputField.tag = 1001;
                inputField.placeholder = @"学校名称";
                inputField.text = self.school;
                
            } else if (indexPath.row == 1) {
                inputField.tag = 1002;
                inputField.placeholder = @"岗位";
                inputField.text = self.post;
            }
            [inputField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
            cell = lineCell;
            
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"CellDefault"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if (self.time || self.model) {
                cell.textLabel.textColor = UIColorFromRGB(0x333333);
                cell.textLabel.text = self.time;
            } else {
                cell.textLabel.textColor = UIColorFromRGB(0x999999);
                cell.textLabel.text = @"在职时间";
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize: 14.0];
        }
        
        
    } else {
        EditExpContentInputCell *contentCell = [EditExpContentInputCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierEditExpContentInputCell];
        contentCell.contentTv.text = self.content;
        contentCell.contentTv.delegate = self;
        self.countLabel = contentCell.countLabel;
        cell = contentCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    return [EditExpContentInputCell heightWithTableView:tableView withIdentifier:identifierEditExpContentInputCell forIndexPath:indexPath data:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (self.model && section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"删除此工作经历" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onRemoveClicked) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"BgLargeButtonDisable"] forState:UIControlStateDisabled];
        
        [view addSubview:button];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.model && section == [self numberOfSectionsInTableView:tableView] - 1) {
        return 80;
    }
    return 0.1;
}

- (void)textFieldWithText:(UITextField *)textField
{
    if (textField.tag == 1001) {
        self.school = textField.text;
    } else if (textField.tag == 1002) {
        self.post = textField.text;
    }
}

- (void)onRemoveClicked {
    if ([self.model.ids intValue] == 0) {
        if (self.delegate) {
            [self.delegate onExpDeleted:self.model];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/teacher/experience/delete") parameters:@{@"id":[self.model.ids stringValue]}  JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (self.delegate) {
                [self.delegate onExpDeleted:self.model];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDialogWithTitle:nil message:error.message];
        }];
    }
}

#pragma mark - moTextView delegate

- (void)textViewDidEndEditing:(UITextView *)textView {
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
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
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    self.content = textView.text;
    //不让显示负数
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

@end
