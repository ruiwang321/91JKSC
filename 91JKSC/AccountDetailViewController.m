//
//  AccountDetailViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/2/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AccountDetailViewController.h"
#import "MainViewController.h"
#import "SHCZMainView.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "CartBadgeSingleton.h"
#import "LoginViewController.h"
#import "LiftSlideViewController.h"
#import "AddressManageViewController.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "HelpViewController.h"
#import "ChangePhoneViewController.h"
#import "SocketManager.h"
#import "ExplainViewController.h"
#import "VersionViewController.h"
@interface AccountDetailViewController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate> {
    UITableView *_tableView;
    int time;
    UIButton *_getCode;
}

@end
void (^printBlock)(NSString *x);
@implementation AccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.text = @"账户设置";
    titleView.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"item" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(leftBtn)];
    
    time = 60;
    [self createTableView];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(centerNoti:) name:@"100" object:nil];

}
-(void)centerNoti:(NSNotification *)notification{

    _numlabel.text = [[notification userInfo] objectForKey:@"num"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
    if ([Function isLogin]) {
         [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];
    }
     _dict = [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] dataDict];
    [_tableView reloadData];
}

// 创建表格
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
// 创建退出登录按钮
//- (void)createExitBut {
//    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    exitButton.frame = CGRectMake(10, 470, SYS_WIDTH - 20, 44);
//    [exitButton setTitle:@"安全退出" forState:UIControlStateNormal];
//    exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
//    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    exitButton.backgroundColor = BackGreenColor;
//    [exitButton addTarget:self action:@selector(exitView) forControlEvents:UIControlEventTouchUpInside];
//    exitButton.layer.cornerRadius = 8.0f;
//    [_tableView addSubview:exitButton];
//}
-(void)exitView{


    [self loginOut];
    SHCZMainView *mainV = [(LiftSlideViewController *)[[self mm_drawerController] leftDrawerViewController] mainview];
    [mainV.userNameBtn setTitle:@"请登录" forState:UIControlStateNormal];
     mainV.headImage.image = [UIImage imageNamed:@"profile"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"login_key"];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[CartBadgeSingleton sharedManager] getCartBadgeNumBynet];
    [_tableView reloadData];
    [[SocketManager shareManager].socket disconnect];
    [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
    

}
#pragma mark - tableView数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
-(void)loginOut{
    NSString *pathStr = [NSString stringWithFormat:@"%@loginOut.html",API_USER];
    NSDictionary *paramDic = @{
                               @"key":[Function getKey]
                               };
    [LoadDate httpPost:pathStr param:paramDic finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        
        if (error == nil) {
            if ([obj[@"code"] longLongValue] == 200) {
                [MBProgressHUD showSuccess:@"退出成功"];
            }else{
                [MBProgressHUD showError:@"退出失败"];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [Function isLogin] ? 3 : 0;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 2;
    }
    if (section == 3) {
        return [Function isLogin] ? 1 : 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    if (indexPath.section == 0) {
        if (![_dict[@"member_mobile"] isEqualToString:@""]) {
            if (indexPath.row == 1) {
                 _numlabel= [[UILabel alloc]initWithFrame:CGRectMake(SYS_WIDTH -150, 15, 140, 10)];
                NSString *originTel = _dict[@"member_mobile"];
                NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
                _numlabel.text = [NSString stringWithFormat:@"已绑定%@",tel];
                _numlabel.font = SYS_FONT(13);
                
                [cell.contentView addSubview:_numlabel];
            }
        }
        NSArray *cellTitles = @[@"密码管理", @"手机验证", @"收货地址"];
        cell.textLabel.text = cellTitles[indexPath.row];
        
    }else {
        // 其他组添加分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SYS_WIDTH, 1)];
        line.backgroundColor = [UIColor colorWithRed:207/255.0f green:207/255.0f blue:207/255.0f alpha:1];
        [cell.contentView addSubview:line];
    }
    if (indexPath.section == 1) {
        NSArray *cellTitles = @[@"关于 91jksc.com",@"特别说明", @"帮助"];
        cell.textLabel.text = cellTitles[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"App Version";
            UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 60, 15, 40, 14)];
            version.font = [UIFont systemFontOfSize:14];
            version.text = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            [cell.contentView addSubview:version];
        }else {
            cell.textLabel.text = @"反馈";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0.07 green:0.4 blue:0.15 alpha:1];
        }
    }
    if (indexPath.section == 3) {
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(10, 470, SYS_WIDTH - 20, 44);
        exitButton.center = CGPointMake(SYS_WIDTH/2, cell.contentView.bounds.size.height / 2);
        [exitButton setTitle:@"安全退出" forState:UIControlStateNormal];
        exitButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        exitButton.backgroundColor = BackGreenColor;
        [exitButton addTarget:self action:@selector(exitView) forControlEvents:UIControlEventTouchUpInside];
        exitButton.layer.cornerRadius = 8.0f;
        [cell.contentView addSubview:exitButton];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
// cell点击回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
           
            _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissregisView:)];
            [_backView addGestureRecognizer:tap];
            [self.view addSubview:_backView];
            [self createRegisterViewWithPass:YES andIsSolve:NO];
            self.backView.backgroundColor = [UIColor blackColor];
            self.backView.alpha = 0.8;
            
        
        }else if (indexPath.row ==  2) {
            AddressManageViewController *addressManageVC = [[AddressManageViewController alloc] init];
            [self.navigationController pushViewController:addressManageVC animated:YES];
        }else{

            if ([_dict[@"member_mobile"] isEqualToString:@""]) {
                _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissregisView:)];
                [_backView addGestureRecognizer:tap];
                [self.view addSubview:_backView];
                [self createRegisterViewWithPass:NO andIsSolve:NO];
                self.backView.backgroundColor = [UIColor blackColor];
                self.backView.alpha = 0.8;
            }else{
    
                ChangePhoneViewController *changePVC = [[ChangePhoneViewController alloc]init];
                changePVC.presentPhone =_dict[@"member_mobile"];
                [self.navigationController pushViewController:changePVC animated:YES];
                
            }
        }
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
        }else if (indexPath.row == 2){
            HelpViewController *helpVC =[[HelpViewController alloc]init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }else{
            ExplainViewController *explainVC = [[ExplainViewController alloc]init];
            explainVC.version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            [self.navigationController pushViewController:explainVC animated:YES];
        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
        }else{
            VersionViewController *versionVC = [[VersionViewController alloc]init];
            versionVC.version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            [self.navigationController pushViewController:versionVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41;
}

// tableView头视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBtn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
 #pragma mark ---- 显示注册框
-(void)createRegisterViewWithPass:(BOOL)isTrue andIsSolve:(BOOL)isright{
    
    //白框
    self.alterView = [[UIView alloc]initWithFrame:CGRectMake(5, SYS_HEIGHT *0.305, SYS_WIDTH -10,isTrue?SYS_HEIGHT *0.49:SYS_HEIGHT *0.33)];
    self.alterView.layer.cornerRadius = 5;
    
    self.alterView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.alterView];
    
    CGFloat alterWidth = self.alterView.frame.size.width;
    CGFloat alterHeight =  self.alterView.frame.size.height;
    
    //修改登录密码
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, alterWidth -20, 20)];
    registerLabel.text = isTrue?@"修改登录密码":@"手机验证";
    registerLabel.textColor =[UIColor blackColor];
    registerLabel.font = SYS_FONT(20);
    [ self.alterView addSubview:registerLabel];
    
    //输入框
    NSArray *placeHolderArr =isTrue?@[@" 请输入当前密码",@"  请输入新密码",@"  请确认密码"]:@[@" 请输入手机号码",@" 请输入手机验证码"];
    for (int i=0; i<placeHolderArr.count; i++) {
        
        UITextField * elTextField= [[UITextField alloc]initWithFrame:CGRectMake(alterWidth *0.06,(i*(isTrue?0.21:0.27) +i*0.001 +(isTrue?0.214:0.232))*alterHeight, alterWidth *0.88, alterHeight*(isTrue?0.153:0.20))];
        elTextField.placeholder=placeHolderArr[i];
        elTextField.borderStyle = UITextBorderStyleNone;
        elTextField.tag = 20+i;
        elTextField.delegate = self;
        elTextField.font = SYS_FONT(15);
        elTextField.layer.cornerRadius = 5;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(7, elTextField.frame.size.height-1, elTextField.frame.size.width-14, 1)];
        lineView.backgroundColor = BACKGROUND_COLOR;
        [elTextField addSubview:lineView];
     
        if (isTrue) {
            _isChangePass = YES;
            if (i==0) {
                elTextField.secureTextEntry = NO;
                _presentTextField= elTextField;
                [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                
            }else if (i ==1){
                elTextField.secureTextEntry = NO;
                _alterpassword=elTextField;
                [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }else if (i ==2){
                
                elTextField.secureTextEntry = NO;
                _againTextField= elTextField ;
                [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }
        }else{
            _isChangePass = NO;
            if (i==0) {
                elTextField.secureTextEntry = NO;
                _presentTextField= elTextField;
                _presentTextField.keyboardType =UIKeyboardTypeNumberPad;
                [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            }else {
                elTextField.frame = CGRectMake(alterWidth *0.06,(i*(isTrue?0.21:0.27) +i*0.001 +(isTrue?0.214:0.232))*alterHeight, alterWidth *0.6432, alterHeight*(isTrue?0.153:0.20));
                elTextField.secureTextEntry = NO;
                _alterpassword=elTextField;
                elTextField.keyboardType = UIKeyboardTypeNumberPad;
                
                
            }
            
        }
        
        [self.alterView addSubview:elTextField];
        
    }
    [self createBtnView:self.alterView andIsPass:isTrue andIsSolve:isright];
    
   
    
}
#pragma mark ---- 发送验证码
- (void)getCodeClicked:(UIButton *)btn {
    
    NSString *url;
    NSDictionary *params;
    if (btn.tag == 100) {
        url = [NSString stringWithFormat:@"%@%@",API_USER,@"bindSms.html"];
       params = @{
                                 @"mobile"      :_presentTextField.text,
                                 @"key"      :[Function getKey]
                                 };
    }
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            btn.enabled = NO;
           
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(shushu:) userInfo:nil repeats:YES];
            [MBProgressHUD showSuccess:obj[@"msg"]];
        }else {
            [MBProgressHUD showError:obj[@"msg"]];
        }
    }];

}

- (void)shushu:(NSTimer *)timer {
    
    
    if (time == 0) {
        [timer invalidate];
        
        _getCode.enabled = YES;
        time = 60;
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }else{
        [_getCode setTitle:[NSString stringWithFormat:@"%d",time--] forState:UIControlStateNormal];
    }

}
-(void)createBtnView:(UIView *)btnView andIsPass:(BOOL)istrue andIsSolve:(BOOL)isright{
    // 注册
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    nextBtn.frame = CGRectMake(SYS_WIDTH-10-150, btnView.frame.size.height-20-20,50, 20);
    nextBtn.backgroundColor =[UIColor clearColor];
    nextBtn.layer.cornerRadius =5;
    nextBtn.tag = istrue?40:isright?401:400;
    [nextBtn setTitle:@"取消" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(leftBtnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [ btnView addSubview:nextBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelBtn.frame = CGRectMake(SYS_WIDTH-10-80, btnView.frame.size.height-20-20,50, 20);
    cancelBtn.backgroundColor =[UIColor clearColor];
    cancelBtn.layer.cornerRadius =5;
    cancelBtn.tag =istrue?50:isright?501:500;
    [cancelBtn setTitle:@"保存" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(leftBtnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [ btnView addSubview:cancelBtn];
    
    
    if (!_isChangePass) {
        // 获取验证码按钮
        _getCode = [[UIButton alloc] initWithFrame:CGRectMake(btnView.frame.size.height+45 , btnView.frame.size.height-100, 70, 30)];
        _getCode.layer.cornerRadius = 5;
        _getCode.layer.borderColor = BackGreenColor.CGColor;
        _getCode.layer.borderWidth = 0.5;
        [_getCode.layer masksToBounds];
        [_getCode setTitleColor:BackGreenColor forState:UIControlStateNormal];
        _getCode.tag = 100;
        _getCode.titleLabel.font = SYS_FONT(12);
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCode addTarget:self action:@selector(getCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:_getCode];
    }
    
    
}
#pragma mark ---- 点击空白部分弹框消失
-(void)dismissregisView:(UIGestureRecognizer *)recognizer{
    [self.alterView removeFromSuperview];
    
    [recognizer.view removeFromSuperview];
    [self textFieldShouldReturn:_presentTextField];
    [self textFieldShouldReturn:_alterpassword];
    [self textFieldShouldReturn:_againTextField];
}
#pragma mark --- 取消
-(void)leftBtnTarget:(UIButton *)btn{
    
    if (btn.tag == 50) {
        [self confirmAlertPassWord];
    }else if (btn.tag == 40 || btn.tag == 400 || btn.tag == 401){
        [self.alterView removeFromSuperview];
        [_backView removeFromSuperview];
        [_getCode removeFromSuperview];
    }else if(btn.tag == 500){
        [self testPhoneCode];
    }
    
    
}
#pragma mark --- 修改密码
- (void)confirmAlertPassWord {
   
    if (_againTextField.text.length >0&&![_againTextField.text isEqualToString:_alterpassword.text]) {
        [MBProgressHUD show:@"两次密码输入的不同" icon:nil view:self.view];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",API_USER,@"setPass.html"];
    if (![Function isLogin]|| _presentTextField.text.length<=0||_alterpassword.text.length<=0 || _againTextField.text.length<=0) {
    
        [MBProgressHUD showError:@"请填入完整信息"];
    }else{
        NSDictionary *params = @{
                                 @"key":[Function getKey],
                                 @"pass"      :_presentTextField.text,
                                 @"newpass"     :_alterpassword.text,
                                 @"repass"  :_againTextField.text
                                 };
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] longLongValue] == 200) {
                
                [MBProgressHUD showSuccess:obj[@"msg"]];
                [self.alterView removeFromSuperview];
                [_backView removeFromSuperview];
                
                [self textFieldShouldReturn:_presentTextField];
                [self textFieldShouldReturn:_alterpassword];
                [self textFieldShouldReturn:_againTextField];
                
                
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }];
    }
}
#pragma mark ---- 绑定手机号
-(void)testPhoneCode{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_USER,@"bindMobile.html"];
    if (![Function isLogin]|| _presentTextField.text.length<=0||_alterpassword.text.length<=0) {
        
        [MBProgressHUD showError:@"请填入完整信息"];
    }else{
        NSDictionary *params = @{
                                 @"key":[Function getKey],
                                 @"mobile"      :_presentTextField.text,
                                 @"code":_alterpassword.text
                                 };
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] longLongValue] == 200) {
               
                [MBProgressHUD showSuccess:obj[@"msg"]];
                [self.alterView removeFromSuperview];
                [_backView removeFromSuperview];
                [self textFieldShouldReturn:_presentTextField];
                [self textFieldShouldReturn:_alterpassword];
                [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"100" object:nil userInfo:@{
                                @"num":_dict[@"member_mobile"]
                              }];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                [_tableView reloadData];
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }];
    }

}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    CGRect frame = textField.frame;
   
    int offset = self.view.frame.size.height- SYS_SCALE(216)- SYS_SCALE(300);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.alterView.frame.size.width;
    float height = self.alterView.frame.size.height;

    if(offset > 0)
    {
        CGRect rect = CGRectMake(5.0f, SYS_HEIGHT *0.305-offset,width,height);

        self.alterView.frame = rect;
    }
    [UIView commitAnimations];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(5.0f, SYS_HEIGHT*0.305, self.alterView.frame.size.width, self.alterView.frame.size.height);
    self.alterView.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (_isChangePass) {
        if (textField == _alterpassword || textField == _againTextField ) {
            if (textField.text.length > 20) {
                textField.text = [textField.text substringToIndex:20];
            }
        }
    }else{
        if (textField == _presentTextField) {
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
            }
        }
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (_isChangePass) {
        if (textField == _againTextField||textField == _alterpassword) {
            if (textField.text.length < 6 && textField.text.length >0) {
                [MBProgressHUD show:@"字符不能小于6位" icon:nil view:self.view];
                return NO;
            }
            
            
        }else{
            if (textField.text.length < 6 && textField.text.length >0) {
                [MBProgressHUD show:@"字符不能小于6位" icon:nil view:self.view];
                return NO;
            }
        }

    }
    return YES;
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
