//
//  EditEduViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/30.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "EditEduViewController.h"

#import "EditExpLineInputCell.h"

#import "ActionSheetPickView.h"


static NSString *identifierEditExpLineInputCell = @"EditExpLineInputCell";


@interface EditEduViewController () <UITextViewDelegate, ActionSheetPickViewDelegate>
@property (nonatomic, strong) AFHTTPRequestOperation * curOperation;

@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) NSString *major;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *time;

@end

@implementation EditEduViewController

- (void)setModel:(Education *)model {
    _model = model;
    self.school = model.school;
    self.major = model.major;
    self.time = model.time;
    self.level = model.level;
}

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        NSDictionary *edu = [params objectForKey:@"edu"];
        if (edu) {
            self.model = [[Education alloc]initWithDictionary:edu error:nil];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"教育经历";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onTitleBtnClicked)];
    
    [EditExpLineInputCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierEditExpLineInputCell];
}

- (void)onTitleBtnClicked {
    if (self.model) {
        self.model.school = self.school;
        self.model.major = self.major;
        self.model.time = self.time;
        self.model.level = self.level;
        if ([self checkContent:self.model]) {
            [self requestSaveContent:self.model];
        }
        
    } else {
        Education *edu = [[Education alloc]init];
        edu.ids = [NSNumber numberWithInt:0];
        edu.school = self.school;
        edu.major = self.major;
        edu.time = self.time;
        edu.level = self.level;
        if ([self checkContent:edu]) {
            [self requestSaveContent:edu];
        }
    }
}

- (BOOL)checkContent:(Education *)edu {
    if (edu.school.length == 0) {
        [self showDialogWithTitle:nil message:@"学校不能为空"];
        return NO;
    }
    if (edu.major.length == 0) {
        [self showDialogWithTitle:nil message:@"专业不能为空"];
        return NO;
    }
    if (edu.level.length == 0) {
        [self showDialogWithTitle:nil message:@"学历不能为空"];
        return NO;
    }
    if (edu.time.length == 0) {
        [self showDialogWithTitle:nil message:@"在校时间不能为空"];
        return NO;
    }
    
    return YES;
}

- (void)requestSaveContent:(Education *)edu {
    if(self.curOperation) {
        [self.curOperation pause];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.curOperation = [[HttpService defaultService]POST:URL_APPEND_PATH(@"/teacher/education") parameters:@{@"education":[edu toJSONString]}  JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.delegate) {
            [self.delegate onEduAdded:edu];
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
    if (indexPath.row == 3) {
        ActionSheetPickView *pickview=[[ActionSheetPickView alloc] initPickviewWithPlistName:@"date" isHaveNavControler:NO];
        pickview.delegate = self;
        
        [pickview show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row < 3) {
        EditExpLineInputCell *lineCell = [EditExpLineInputCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierEditExpLineInputCell];
        UITextField *inputField = lineCell.inputTextFiled;
        if (indexPath.row == 0) {
            inputField.tag = 1001;
            inputField.placeholder = @"学校";
            inputField.text = self.school;
            
        } else if (indexPath.row == 1) {
            inputField.tag = 1002;
            inputField.placeholder = @"专业";
            inputField.text = self.major;
            
        } else if (indexPath.row == 2) {
            inputField.tag = 1003;
            inputField.placeholder = @"学历";
            inputField.text = self.level;
        }
        [inputField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        cell = lineCell;
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CellDefault"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellDefault"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (self.time) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.text = self.time;
        } else {
            cell.textLabel.textColor = UIColorFromRGB(0x999999);
            cell.textLabel.text = @"在校时间";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize: 14.0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (self.model && section == [self numberOfSectionsInTableView:tableView] - 1) {
        UIButton *button = [[UIButton alloc]init];
        button.height = 40;
        button.width = 280;
        button.left = (SCREEN_WIDTH - button.width) / 2;
        button.top = 30;
        [button setTitle:@"删除此教育经历" forState:UIControlStateNormal];
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
        self.major = textField.text;
    } else if (textField.tag == 1003) {
        self.level = textField.text;
    }
}

- (void)onRemoveClicked {
    if ([self.model.ids intValue] == 0) {
        if (self.delegate) {
            [self.delegate onEduDeleted:self.model];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[HttpService defaultService]POST:URL_APPEND_PATH(@"/teacher/education/delete") parameters:@{@"id":[self.model.ids stringValue]}  JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (self.delegate) {
                [self.delegate onEduDeleted:self.model];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDialogWithTitle:nil message:error.message];
        }];
    }
}

@end
