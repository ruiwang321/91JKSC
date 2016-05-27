//
//  LostPassWordViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/6.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "LostPassWordViewController.h"
#import "ChangePasswordViewController.h"

@interface LostPassWordViewController () {
    UITextField *phoneNum;
    UITextField *smsCode;
    UIButton *getSmsCode;
    NSTimer *timer;
    int time;
    
    UITextField *securityQ;
    UITextField *password;
    UITextField *passwordConfirm;
    NSString *tempKey;
    NSString *security;
}

@end

@implementation LostPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:@"忘记密码" andSEL:@selector(leftbtnWith:)];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createFirstSubView];
    time = 60;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self dismissViewControllerAnimated:NO completion:nil];
}
// 创建第一步视图
- (void)createFirstSubView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SYS_WIDTH, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 50, SYS_WIDTH - 20, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [bgView addSubview:line];
    
    phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(13, 13, SYS_WIDTH - 26, 25)];
    phoneNum.placeholder = @"请输入手机号码";
    phoneNum.font = [UIFont systemFontOfSize:15];
    phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:phoneNum];
    
    smsCode = [[UITextField alloc] initWithFrame:CGRectMake(13, 63, SYS_WIDTH - 26, 25)];
    smsCode.placeholder = @"请输入手机验证码";
    smsCode.font = [UIFont systemFontOfSize:15];
    smsCode.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:smsCode];
    
    getSmsCode = [UIButton buttonWithType:UIButtonTypeCustom];
    getSmsCode.frame = CGRectMake(SYS_WIDTH - 80, 60, 70, 30);
    [getSmsCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    getSmsCode.titleLabel.font = [UIFont systemFontOfSize:12];
    [getSmsCode setTitleColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1] forState:UIControlStateNormal];
    getSmsCode.layer.borderWidth = 1;
    getSmsCode.layer.borderColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1].CGColor;
    getSmsCode.layer.cornerRadius = 4;
    [getSmsCode addTarget:self action:@selector(getSmsCode:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:getSmsCode];
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, CGRectGetMaxY(bgView.frame)+50, SYS_WIDTH-20, 40);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.backgroundColor = BackGreenColor;
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.tag = 151;
    [self.view addSubview:nextBtn];
}
- (void)removeFirstSubview {
    [[self.view viewWithTag:151] removeFromSuperview];
}

- (void)createSecondSubView {
    [self removeFirstSubview];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SYS_WIDTH, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 50, SYS_WIDTH - 20, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [bgView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, 100, SYS_WIDTH - 20, 0.5)];
    line2.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [bgView addSubview:line2];
    
    securityQ = [[UITextField alloc] initWithFrame:CGRectMake(13, 13, SYS_WIDTH - 26, 25)];
    securityQ.placeholder = security;
    securityQ.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:securityQ];
    
    password = [[UITextField alloc] initWithFrame:CGRectMake(13, 63, SYS_WIDTH - 26, 25)];
    password.placeholder = @"请设置新的登录密码";
    password.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:password];
    
    passwordConfirm = [[UITextField alloc] initWithFrame:CGRectMake(13, 113, SYS_WIDTH - 26, 25)];
    passwordConfirm.placeholder = @"请确认新的登录密码";
    passwordConfirm.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:passwordConfirm];
    
    
    UIButton *doBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doBtn.frame = CGRectMake(10, CGRectGetMaxY(bgView.frame)+50, SYS_WIDTH-20, 40);
    doBtn.layer.cornerRadius = 5;
    doBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [doBtn setTitle:@"完成" forState:UIControlStateNormal];
    doBtn.backgroundColor = BackGreenColor;
    [doBtn addTarget:self action:@selector(doBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doBtn];
}

#pragma mark - 按钮点击事件
- (void)getSmsCode:(UIButton *)btn {
    if (phoneNum.text.length >= 11) {
        btn.enabled = NO;
        NSDictionary *params = @{
                                 @"mobile"      :phoneNum.text,
                                 @"client"      :@"ios",
                                 @"ip2long"     :[LoadDate getIPDress],
                                 @"deviceName"  :DEVICE,
                                 @"macAddress"  :MAC_ADDRESS
                                 };

        [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_Login,@"resetPassword1.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeOn) userInfo:nil repeats:YES];
                phoneNum.userInteractionEnabled = NO;
                [MBProgressHUD showSuccess:@"获取验证码成功"];
            }else {
                [MBProgressHUD showError:@"获取验证码失败，请您重试"];
                btn.enabled = YES;
            }
        }];
    }else {
        [MBProgressHUD showError:@"手机号格式不正确"];
    }
}

- (void)nextBtnClicked {
    if (phoneNum.text.length >= 11 && smsCode.text.length > 0) {
        NSDictionary *params = @{
                                 @"mobile"      :phoneNum.text,
                                 @"client"      :@"ios",
                                 @"ip2long"     :[LoadDate getIPDress],
                                 @"deviceName"  :DEVICE,
                                 @"smsCode"     :smsCode.text,
                                 @"macAddress"  :MAC_ADDRESS
                                 };
        
        [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_Login,@"resetPassword2.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                tempKey = obj[@"data"][@"tempKey"];
                security = obj[@"data"][@"Security"];
                [timer invalidate];
                timer = nil;
                
                [self createSecondSubView];
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }];

    }else {
        [MBProgressHUD showError:@"请输入验证码"];
    }
}

- (void)doBtnClicked {
    if ([passwordConfirm.text isEqualToString:password.text] && securityQ.text.length!=0 && password.text.length!=0 && passwordConfirm.text.length!=0) {
        NSDictionary *params = @{
                                 @"mobile"              :phoneNum.text,
                                 @"password"            :password.text,
                                 @"password_confirm"    :passwordConfirm.text,
                                 @"client"              :@"ios",
                                 @"ip2long"             :[LoadDate getIPDress],
                                 @"deviceName"          :DEVICE,
                                 @"tempKey"             :tempKey,
                                 @"Security"            :securityQ.text,
                                 @"macAddress"          :MAC_ADDRESS
                                 };
        [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_Login,@"resetPassword3.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                [MBProgressHUD showSuccess:obj[@"msg"]];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }];
    }else if (password.text.length==0 || passwordConfirm.text.length==0 || securityQ.text.length==0) {
        [MBProgressHUD showError:@"信息填写不完整"];
    }else {
        [MBProgressHUD showError:@"两次密码不一致"];
    }
}

- (void)leftbtnWith:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)timeOn {
    [getSmsCode setTitle:[NSString stringWithFormat:@"%d",--time] forState:UIControlStateNormal];
    if (time == 0) {
        [timer invalidate];
        timer = nil;
        getSmsCode.enabled = YES;
        [getSmsCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [smsCode resignFirstResponder];
    [phoneNum resignFirstResponder];
    [securityQ resignFirstResponder];
    [password resignFirstResponder];
    [passwordConfirm resignFirstResponder];
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
