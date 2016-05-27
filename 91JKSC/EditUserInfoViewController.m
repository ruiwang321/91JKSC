//
//  EditUserInfoViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EditUserInfoViewController.h"
#import "LiftSlideViewController.h"
#import "AddressManageViewController.h"
#import "SetInfoViewController.h"


@interface UserInfoModel ()

@end

@implementation UserInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end



@interface EditUserInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIView *_bgView;// 时间选择器背景view
}

/**从相册中获取图片的信息*/
@property (nonatomic, strong) NSDictionary *imageDictInfo;
/**上传图片返回的字典*/
@property (nonatomic, strong) NSDictionary *respondeDict;
/**用户头像*/
@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation EditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createTableView];
    [self loadUserInfo];
}

// 创建导航条
- (void)createNavBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"编辑个人资料";
    titleLabel.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
}
#pragma mark 创建表格
- (void)createTableView {
    _infoList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStyleGrouped];
    [self.view addSubview:_infoList];
    _infoList.dataSource = self;
    _infoList.delegate = self;
    
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SYS_HEIGHT-70, SYS_WIDTH, 45)];
    logoLabel.text = @"91jksc.com";
    logoLabel.textColor = BackGreenColor;
    logoLabel.font = [UIFont fontWithName:@"dauphin" size:45];
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:logoLabel];
}

#pragma mark - 表格数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0? 1: 4;
//    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0? 84: 42;
//    return indexPath.row == 0? 84: 42;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"我的头像";
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SYS_WIDTH-64-35, (84-64)/2, 64, 64)];
        _imageV.layer.cornerRadius = 32;
        _imageV.layer.masksToBounds = YES;
        [cell.contentView addSubview:_imageV];
        [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_userInfoModel.member_avatar]] placeholderImage:[UIImage imageNamed:@"profile"]];
    }else {
        cell.textLabel.text = @[@"昵称", @"性别", @"出生日期", @"我的收货地址"][indexPath.row];
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = _userInfoModel.member_nickname?_userInfoModel.member_nickname:@"还是空的，快来取个有逼格的...";
                self.nickNameLabel.text =  ![_userInfoModel.member_nickname isEqualToString:@""]?_userInfoModel.member_nickname:_userInfoModel.member_name;
                break;
            case 1: {
                cell.detailTextLabel.text = @[@"", @"男", @"女", @"保密"][_userInfoModel.member_sex.integerValue];
                break;
            }
            case 2: {

                cell.detailTextLabel.text = _userInfoModel.member_birthday;
                break;
            }
            default:
                break;
        }
    }
    cell.textLabel.font = SYS_FONT(15);
    cell.detailTextLabel.font = SYS_FONT(13);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self changeHeaderImage];
    }else {
        switch (indexPath.row) {
            // 昵称
            case 0: {
                SetInfoViewController *setInfoVC = [[SetInfoViewController alloc] init];
                setInfoVC.userInfoVC = self;
                [self.navigationController pushViewController:setInfoVC animated:YES];
                break;
            }
            // 性别
            case 1: {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女", @"保密", nil];
                sheet.tag = 256;
                [sheet showInView:self.view];
                break;
            }
            // 生日
            case 2: {
                _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
                _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
                [[[UIApplication sharedApplication].delegate window] addSubview:_bgView];
                
                UITableViewCell *cell = [_infoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                UIDatePicker *datePickView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, SYS_HEIGHT-150, SYS_WIDTH, 150)];
                datePickView.backgroundColor = [UIColor whiteColor];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                if (cell.detailTextLabel.text.length != 0) {
                    datePickView.date = [formatter dateFromString:cell.detailTextLabel.text];
                }
                datePickView.tag = 250;
                [_bgView addSubview:datePickView];
                datePickView.datePickerMode = UIDatePickerModeDate;
                [datePickView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
                datePickView.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0];
                
                
                UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SYS_HEIGHT-180, SYS_WIDTH, 30)];
                toolBar.backgroundColor = [UIColor whiteColor];
                [_bgView addSubview:toolBar];
                
                UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                doneBtn.frame = CGRectMake(SYS_WIDTH-70, 0, 50, 30);
                [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
                [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [toolBar addSubview:doneBtn];
                
                UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                cancelBtn.frame = CGRectMake(20, 0, 50, 30);
                [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
                [toolBar addSubview:cancelBtn];

                break;
            }
            // 我的收获地址
            case 3: {
                AddressManageViewController *addressVC = [[AddressManageViewController alloc] init];
                [self.navigationController pushViewController:addressVC animated:YES];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - 时间选择器值响应事件
- (void)dateChanged:(UIDatePicker *)datePicker {
    UITableViewCell *cell = [_infoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:datePicker.date];
}

- (void)doneBtnClicked {
    UIDatePicker *datePicker = [_bgView viewWithTag:250];
    NSString *birthday = [NSString stringWithFormat:@"%ld", (long)[datePicker.date timeIntervalSince1970]];
    NSDictionary *params = @{
                             @"key"             :[Function getKey],
                             @"member_birthday" :birthday
                             };
    [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_USER,@"update.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            UITableViewCell *cell = [_infoList cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
            _userInfoModel.member_birthday = cell.detailTextLabel.text;
        }
        [_bgView removeFromSuperview];
    }];
    
}

- (void)cancelBtnClicked {
    [_infoList reloadData];
    [_bgView removeFromSuperview];
}
#pragma mark ----  改变头像
-(void)changeHeaderImage{
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 2:
                    return;
                case 0: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }else {
        if (buttonIndex == 3) {
            return;
        }else {
            NSString *url = [NSString stringWithFormat:@"%@%@",API_USER,@"update.html"];
            NSDictionary *params = @{
                                     @"key"         :[Function getKey],
                                     @"member_sex"  :[NSString stringWithFormat:@"%ld", buttonIndex+1]
                                     };
            [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                if ([obj[@"code"] isEqualToNumber:@200]) {
                    _userInfoModel.member_sex = [NSNumber numberWithInteger:buttonIndex+1];
                    [_infoList reloadData];
                }
            }];
        }
    }
}

//当用户取消时调用
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        _imageDictInfo = info;
        [self loadImageData];
        
        
    }];
   	
}
#pragma mark ----- 上传图片网络加载
-(void)loadImageData{
    NSString *urlPath = [NSString stringWithFormat:@"http://img.91jksc.com/upload-images-upload-upload"];
    NSDictionary * paramsDic = @{@"file":[_imageDictInfo objectForKey:@"UIImagePickerControllerOriginalImage"]};
    NSData *imageData =  UIImageJPEGRepresentation([_imageDictInfo objectForKey:@"UIImagePickerControllerOriginalImage"], 0.1);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlPath parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ImageWithUrl(_imageV, responseObject[@"name"]);
        UIImageView * imageV =[(LiftSlideViewController *)self.mm_drawerController.leftDrawerViewController mainview].headImage;
        ImageWithUrl(imageV, responseObject[@"name"]);
        [(LiftSlideViewController *)self.mm_drawerController.leftDrawerViewController mainview].imageName = responseObject[@"name"];
        ImageWithUrl(self.headerView, responseObject[@"name"]);
        _respondeDict = responseObject;
        
        [self chengeUserInfo];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"--------------%@",error);
    }];
    
    
    
}
#pragma mark ---- 修改用户信息网络请求
-(void)chengeUserInfo{
    
    NSString *changeurlPath = [NSString stringWithFormat:@"%@update.html",API_USER];
    NSDictionary * changeparamsDic = @{
                                       @"key"           :[Function getKey],
                                       @"member_avatar" :[_respondeDict objectForKey:@"name"]
                                       };
    
    [LoadDate httpPost:changeurlPath param:changeparamsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                [MBProgressHUD showSuccess:@"头像上传成功"];
            }else{
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
            }
            
        }else{
            [MBProgressHUD showError:@"网络不给力"];
        }
        
    }];
    
}

#pragma mark - 加载个人信息
- (void)loadUserInfo {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_USER,@"info.html"];
    NSDictionary *params = @{
                             @"key":[Function getKey]
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            [self.userInfoModel setValuesForKeysWithDictionary:obj[@"data"]];
            [_infoList reloadData];
            
        }
    }];
}
#pragma mark - 按钮点击事件
- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter
- (UserInfoModel *)userInfoModel {
    if (_userInfoModel == nil) {
        _userInfoModel = [[UserInfoModel alloc] init];
    }
    return _userInfoModel;
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

@end
