//
//  ApplyTeacherViewController.m
//  MomiaTeacher
//
//  Created by Deng Jun on 15/12/28.
//  Copyright © 2015年 YouXing. All rights reserved.
//

#import "ApplyTeacherViewController.h"
#import "DatePickerSheet.h"
#import "ApplyTeacherModel.h"
#import "UploadImageModel.h"

#import "ApplyTeacherInputCell.h"
#import "ApplyTeacherAddCell.h"

#import "EditExpViewController.h"
#import "EditEduViewController.h"

static NSString *identifierApplyTeacherInputCell = @"ApplyTeacherInputCell";
static NSString *identifierApplyTeacherAddCell = @"ApplyTeacherAddCell";

@interface ApplyTeacherViewController ()<UIAlertViewDelegate, DatePickerSheetDelegate, EditExpDelegate, EditEduDelegate>
@property (nonatomic, strong) ApplyTeacherModel *model;
@property (nonatomic, assign) BOOL fromLogin;
@property (nonatomic, strong) UIImage *picThumb;
@end

@implementation ApplyTeacherViewController

- (instancetype)initWithParams:(NSDictionary *)params {
    if (self = [super initWithParams:params]) {
        self.fromLogin = [[params objectForKey:@"fromLogin"] boolValue];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"成为助教";
    if (self.fromLogin) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"跳过" style:UIBarButtonItemStyleDone target:self action:@selector(onTitleBtnClicked)];
    }
    
    [ApplyTeacherInputCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierApplyTeacherInputCell];
    [ApplyTeacherAddCell registerCellFromNibWithTableView:self.tableView withIdentifier:identifierApplyTeacherAddCell];
    
    [self requestData];
}

- (void)onTitleBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestData {
    [self.view showLoadingBee];
    [[HttpService defaultService]GET:URL_APPEND_PATH(@"/teacher/status") parameters:nil cacheType:CacheTypeDisable JSONModelClass:[ApplyTeacherModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.view removeLoadingBee];
        
        self.model = responseObject;
        int status = [self.model.data.status intValue];
        if (status == 1) {
            [self.view showEmptyView:@"恭喜您！通过助教资格审核，您可以在课程管理中查看课程安排啦~"];
        } else if (status == 3) {
            [self.view showEmptyView:@"您的申请已经提交，正在审核中，请耐心等待1~2个工作日哦~"];
        } else {
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view removeLoadingBee];
        [self showDialogWithTitle:nil message:error.message];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photo picker
-(void)takePictureClick
{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机", @"本地相簿",nil];
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //scale
    self.picThumb = [self thumbnailWithImageWithoutScale:[self croppImage:image] size:CGSizeMake(100, 100)];
    NSString *uploadImagePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    UIImage *uploadImage=[self scaleFromImage:image];
    [UIImageJPEGRepresentation(uploadImage, 1.0f) writeToFile:uploadImagePath atomically:YES];//写入文件
    
    //上传
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HttpService defaultService] uploadImageWithFilePath:uploadImagePath fileName:@"selfPhoto.jpg" handler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self showDialogWithTitle:nil message:@""];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UploadImageData *data = ((UploadImageModel *)responseObject).data;
            self.model.data.pic = data.path;
            [self.tableView reloadData];
        }
    }];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *)scaleFromImage: (UIImage *) image
{
    CGSize size = CGSizeMake(800, 800);
    int scaleWidth = 800;
    if (image.size.width < size.width) {
        return image;
    }
    size.height = scaleWidth * image.size.height / image.size.width;
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)croppImage:(UIImage *)imageToCrop
{
    UIImage *sourceImage = imageToCrop;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    //crop
    CGRect cropRect;
    if (width > height) {
        cropRect = CGRectMake((width-height)/2, 0, height, height);
    } else {
        cropRect = CGRectMake(0, (height-width)/2, width, width);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], cropRect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)targetSize
{
    if (nil == image) {
        return nil;
    }
    
    CGSize newSize = CGSizeMake(targetSize.width, targetSize.height);
    CGFloat widthRatio = newSize.width/image.size.width;
    CGFloat heightRatio = newSize.height/image.size.height;
    
    if(widthRatio > heightRatio)
    {
        newSize=CGSizeMake(image.size.width*heightRatio,image.size.height*heightRatio);
    }
    else
    {
        newSize=CGSizeMake(image.size.width*widthRatio,image.size.height*widthRatio);
    }
    
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - sex picker
-(void)showSexPicker:(NSInteger)tag {
    UIActionSheet *sexSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",nil];
    sexSheet.tag = tag;
    [sexSheet showInView:[[UIApplication sharedApplication].delegate window]];
}

#pragma mark - date picker
- (void)showDatePicker {
    NSDate *date;
    if (self.model.data.birthday) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:self.model.data.birthday];
    }
    DatePickerSheet * datePickerSheet = [DatePickerSheet getInstance];
    [datePickerSheet initializationWithMaxDate:nil
                                   withMinDate:nil
                                   withCurDate:nil
                            withDatePickerMode:UIDatePickerModeDate
                                  withDelegate:self];
    [datePickerSheet showDatePickerSheet];
}

#pragma mark - DatePickerSheetDelegate method
- (void)datePickerSheet:(DatePickerSheet*)datePickerSheet chosenDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    
    self.model.data.birthday = dateString;
    [self.tableView reloadData];
}

#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        switch (buttonIndex) {
            case 0://照相机
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                //            [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            case 1://本地相簿
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = YES;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //            [self presentModalViewController:imagePicker animated:YES];
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    } else if (actionSheet.tag == 1) {
        if(buttonIndex > 1) {
            return;
        }
        
        NSString * sex = buttonIndex == 0 ? @"男" : @"女";
        self.model.data.sex = sex;
        [self.tableView reloadData];
    }
}

#pragma mark - Edit exp & edu delegate

- (void)onExpAdded:(Experience *)exp {
    if ([exp.ids intValue] == 0) {
        NSMutableArray *array;
        if (self.model.data.experiences) {
            array = [[NSMutableArray alloc]initWithArray:self.model.data.experiences];
        } else {
            array = [[NSMutableArray alloc]init];
        }
        [array addObject:exp];
        self.model.data.experiences = (NSMutableArray<Experience> *)array;
        
    } else {
        if (self.model.data.experiences.count > 0) {
            for (Experience *experience in self.model.data.experiences) {
                if ([exp.ids intValue] == [experience.ids intValue]) {
                    experience.school = exp.school;
                    experience.post = exp.post;
                    experience.time = exp.time;
                    experience.content = exp.content;
                    break;
                }
            }
            
        } else {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:exp];
            self.model.data.experiences = (NSMutableArray<Experience> *)array;
        }
    }
    [self.tableView reloadData];
}

- (void)onExpDeleted:(Experience *)exp {
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.model.data.experiences];
    [array removeObject:exp];
    self.model.data.experiences = (NSMutableArray<Experience> *)array;
    [self.tableView reloadData];
}

- (void)onEduAdded:(Education *)edu {
    if ([edu.ids intValue] == 0) {
        NSMutableArray *array;
        if (self.model.data.educations) {
            array = [[NSMutableArray alloc]initWithArray:self.model.data.educations];
        } else {
            array = [[NSMutableArray alloc]init];
        }
        [array addObject:edu];
        self.model.data.educations = (NSMutableArray<Education> *)array;
        
    } else {
        if (self.model.data.educations.count > 0) {
            for (Education *education in self.model.data.educations) {
                if ([edu.ids intValue] == [education.ids intValue]) {
                    education.school = edu.school;
                    education.major = edu.major;
                    education.time = edu.time;
                    education.level = edu.level;
                    break;
                }
            }
            
        } else {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:edu];
            self.model.data.educations = (NSMutableArray<Education> *)array;
        }
    }
    [self.tableView reloadData];
}

- (void)onEduDeleted:(Education *)edu {
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:self.model.data.educations];
    [array removeObject:edu];
    self.model.data.educations = (NSMutableArray<Education> *)array;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self takePictureClick];
        } else if (indexPath.row == 3) {
            [self showSexPicker:1];
        } else if (indexPath.row == 4) {
            [self showDatePicker];
        }
    } else if (indexPath.section == 1) {
        EditExpViewController *controller = [[EditExpViewController alloc]initWithParams:nil];
        if (indexPath.row < self.model.data.experiences.count) {
            Experience *exp = self.model.data.experiences[indexPath.row];
            controller.model = exp;
        }
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else if (indexPath.section == 2) {
        EditEduViewController *controller = [[EditEduViewController alloc]initWithParams:nil];
        if (indexPath.row < self.model.data.educations.count) {
            Education *edu = self.model.data.educations[indexPath.row];
            controller.model = edu;
        }
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model) {
        int status = [self.model.data.status intValue];
        if (status == 0 || status == 2 || status == 4) {
            return 3;
        }
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    } else if (section == 1) {
        return 1 + self.model.data.experiences.count;
    }
    return 1 + self.model.data.educations.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        return 70;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellDefault = @"DefaultCell";
    static NSString *CellLogo = @"LogoCell";
    UITableViewCell *cell;
    if ((section == 0) && row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellLogo];
        if (cell == nil) {
            NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"ApplyTeacherPicCell" owner:self options:nil];
            cell = [arr objectAtIndex:0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        UIImageView *avatarIv = (UIImageView *)[cell viewWithTag:1];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:2];
        titleLabel.text = @"生活照";
        if ([self.model.data.pic containsString:@"http"]) {
            [avatarIv sd_setImageWithURL:[NSURL URLWithString:self.model.data.pic]];
        } else if (self.picThumb) {
            avatarIv.image = self.picThumb;
        }
        
    } else if (section == 0 && (row == 1 || row == 2 || row == 5)) {
        ApplyTeacherInputCell *inputCell = [ApplyTeacherInputCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierApplyTeacherInputCell];
        UITextField *textField = inputCell.inputTextField;
        if (row == 1) {
            textField.tag = 1001;
            textField.placeholder = @"请输入您的真实姓名";
            textField.text = self.model.data.name;
            inputCell.titleLabel.text = @"真实姓名";
            
        } else if (row == 2) {
            textField.tag = 1002;
            textField.placeholder = @"请输入您的身份证号";
            textField.text = self.model.data.idNo;
            inputCell.titleLabel.text = @"身份证号";
            
        } else if (row == 5) {
            textField.tag = 1003;
            textField.placeholder = @"请输入您的现居地址";
            textField.text = self.model.data.address;
            inputCell.titleLabel.text = @"住址";
        }
        [textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
        cell = inputCell;
        
    } else if ((section == 0 && (row == 3 || row == 4)) || (section == 1 && row < self.model.data.experiences.count) || (section == 2 && row < self.model.data.educations.count)) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellDefault];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellDefault];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize: 15.0];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x333333);
        cell.detailTextLabel.font = [UIFont systemFontOfSize: 14.0];
        
        if (section == 0) {
            if (row == 3) {
                cell.textLabel.text = @"性别";
                cell.detailTextLabel.text = self.model.data.sex;
            } else if (row == 4) {
                cell.textLabel.text = @"生日";
                cell.detailTextLabel.text = self.model.data.birthday;
            }
            
        } else if (section == 1) {
            Experience *experience = self.model.data.experiences[row];
            cell.textLabel.text = experience.school;
            cell.detailTextLabel.text = experience.time;
            
        } else {
            Education *education = self.model.data.educations[row];
            cell.textLabel.text = education.school;
            cell.detailTextLabel.text = education.time;
        }
        
    } else {
        ApplyTeacherAddCell *addCell = [ApplyTeacherAddCell cellWithTableView:tableView forIndexPath:indexPath withIdentifier:identifierApplyTeacherAddCell];
        if (section == 1) {
            addCell.data = @"+添加工作经历";
        } else {
            addCell.data = @"+添加教育经历";
        }
        cell = addCell;
    }
    return cell;
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

- (void)textFieldWithText:(UITextField *)textField
{
    if (textField.tag == 1001) {
        self.model.data.name = textField.text;
    } else if (textField.tag == 1002) {
        self.model.data.idNo = textField.text;
    } else if (textField.tag == 1003) {
        self.model.data.address = textField.text;
    }
}

- (void)onDoneClicked {
    BOOL isContentFull = [self checkContent];
    if (!self.fromLogin && !isContentFull) {
        [self showDialogWithTitle:nil message:@"个人资料填写不完整，请完善后重新提交！"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[HttpService defaultService]POST:URL_APPEND_PATH(@"/teacher/signup") parameters:@{@"teacher":[self.model.data toJSONString]}  JSONModelClass:[BaseModel class] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (isContentFull) {
            [self showDialogWithTitle:nil message:@"申请助教成功，请耐心等待审核哦~" tag:1001];
            
        } else {
            NSString *message = @"个人资料填写不完整，可以在“我的-申请助教”中完善后重新提交";
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"继续填写" otherButtonTitles:@"跳过", nil];
            alter.tag = 1002;
            [alter show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showDialogWithTitle:nil message:error.message];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            //继续填写
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (BOOL)checkContent {
    if (self.model.data.pic.length == 0) {
        return NO;
        
    } else if (self.model.data.name.length == 0) {
        return NO;
        
    } else if (self.model.data.idNo.length == 0) {
        return NO;
        
    } else if (self.model.data.sex.length == 0) {
        return NO;
        
    } else if (self.model.data.birthday.length == 0) {
        return NO;
        
    } else if (self.model.data.address.length == 0) {
        return NO;
        
    } else if (self.model.data.experiences.count == 0) {
        return NO;
        
    } else if (self.model.data.educations.count == 0) {
        return NO;
    }
    return YES;
}

@end
