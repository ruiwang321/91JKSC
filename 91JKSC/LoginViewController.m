//
//  LoginViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "LoginViewController.h"
#import "Common.h"
#import "MainViewController.h"
#import "ButtonModel.h"
#import "LoadDate.h"
#import "LoginModel.h"
#import "SHCZMainView.h"
#import "MeViewController.h"
#import "MyMessageViewController.h"
#import "CartBadgeSingleton.h"
#import "LiftSlideViewController.h"
#import "SHCZMainView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "LostPassWordViewController.h"
#import "SocketManager.h"

@interface LoginViewController ()<UITextFieldDelegate, TencentSessionDelegate> {
    int time;
    UIButton *_getCode;
    TencentOAuth *_tencentOAuth;
}
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UITextField *userTextField;
@property (nonatomic,strong)UITextField *phoneCodeTF;
@property (nonatomic,strong)UITextField *registerpassword;
@property (nonatomic ,strong)UITextField *userNameTextField;
@property (nonatomic,strong)UITextField *passWordTextField;
@property (nonatomic,strong)UITextField *againTextField;
@property (nonatomic,strong) UIView * registerView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = BackGreenColor;
    time = 60;
    [UIApplication sharedApplication].statusBarStyle =UIStatusBarStyleLightContent;
    [self createBaseView];
}
-(void)createBaseView{
    _imageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
    _imageView.userInteractionEnabled = YES;
    _imageView.image=[UIImage imageNamed:@"background"];
    [self.view addSubview:_imageView];

    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(SYS_WIDTH*0.055, SYS_WIDTH*0.055+20, 40, 40);
    [deleteBtn setImage:[UIImage imageNamed:@"login_delete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    UIImageView *imageLogo = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_WIDTH*0.333, SYS_HEIGHT*0.15, SYS_WIDTH*0.334, SYS_HEIGHT*0.135)];
    imageLogo.image = [UIImage imageNamed:@"logo"];
    
    [_imageView addSubview:imageLogo];
    [self createButton];
    [self createLoginView];
}

-(void)createLoginView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(SYS_WIDTH *0.1, SYS_HEIGHT*0.397, SYS_WIDTH*0.8, SYS_HEIGHT*0.15)];
    backView.layer.cornerRadius = 5;
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor whiteColor];
    backView.alpha = 0.5;
    [_imageView addSubview:backView];
    _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH*0.8, SYS_HEIGHT*0.075)];
    _userNameTextField.placeholder = @"请输入会员卡号/手机号码";
    _userNameTextField.delegate = self;
    _userNameTextField.tag = 100;
    _userNameTextField.userInteractionEnabled = YES;
    _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backView addSubview:_userNameTextField];
    
    _passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, SYS_HEIGHT*0.075, SYS_WIDTH*0.8, SYS_HEIGHT*0.075)];
    _passWordTextField.placeholder = @"请输入密码";
    _passWordTextField.delegate = self;
    _passWordTextField.secureTextEntry = YES;
    _passWordTextField.tag = 200;
    _passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passWordTextField.borderStyle = UITextBorderStyleRoundedRect;
    [backView addSubview:_passWordTextField];
}
-(void)createButton{
    
    
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.1, SYS_HEIGHT*0.565, SYS_WIDTH*0.8, SYS_HEIGHT*0.067) andImageName:@"login" andTarget:@selector(btnTarget:) andClassObject:self andTag:1005 andColor:[UIColor clearColor] andBaseView:self.view andTitleName:nil andFont:0];
    
    
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH*0.09, SYS_HEIGHT*0.712, SYS_WIDTH*0.82, SYS_HEIGHT*0.07) andImageName:@"qq-login" andTarget:@selector(btnTarget:) andClassObject:self andTag:1000 andColor:[UIColor clearColor] andBaseView:self.view andTitleName:nil andFont:12];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH*0.09, SYS_HEIGHT*0.797, SYS_WIDTH*0.82, SYS_HEIGHT*0.07) andImageName:@"wechat-login-new" andTarget:@selector(btnTarget:) andClassObject:self andTag:1001 andColor:[UIColor clearColor] andBaseView:self.view andTitleName:nil andFont:12];
//    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH*0.513, SYS_HEIGHT*0.797, SYS_WIDTH*0.399, SYS_HEIGHT*0.066) andImageName:@"weibo-login" andTarget:@selector(btnTarget:) andClassObject:self andTag:1002 andColor:[UIColor clearColor] andBaseView:self.view andTitleName:nil andFont:11];
    
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH*0.216, SYS_HEIGHT*0.894, SYS_WIDTH*0.155, SYS_HEIGHT*0.020) andImageName:nil andTarget:@selector(btnTarget:) andClassObject:self andTag:1003 andColor:[UIColor clearColor] andBaseView:self.view andTitleName:@"忘记密码？" andFont:SYS_WIDTH *0.0293];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH*0.673, SYS_HEIGHT*0.894, SYS_WIDTH*0.067, SYS_HEIGHT*0.020) andImageName:nil andTarget:@selector(btnTarget:) andClassObject:self andTag:1004 andColor:[UIColor clearColor] andBaseView:self.view andTitleName:@"注册" andFont:SYS_WIDTH *0.0293];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(wxresp) name:@"wxloginresp" object:nil];
    
    
}

-(void)dismiss:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
   
}

#pragma mark ----- 注册
-(void) testHttpMsPostRegister{
   
    NSString *urlPath = [NSString stringWithFormat:@"%@smsRegister.html",API_Login];
    NSDictionary *paramsDic = @{
                                @"mobile"           :_userTextField.text,
                                @"smsCode"          :_phoneCodeTF.text,
                                @"password"         :_registerpassword.text,
                                @"password_confirm" :_againTextField.text,
                                @"client"           :@"ios",
                                @"ip2long"          :[LoadDate getIPDress],
                                @"deviceName"       :DEVICE,
                                @"macAddress"       :MAC_ADDRESS
                                };

    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.

            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                NSDictionary *dict = [obj objectForKey:@"data"];
                LoginModel *model=[[LoginModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                
#warning key本地持久化
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"key"] forKey:@"login_key"];
                [[NSUserDefaults standardUserDefaults] setObject:(NSString *)dict[@"userid"] forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([Function isLogin]) {
                    [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];
                    [[SocketManager shareManager].socket connect];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"%@",[obj objectForKey:@"msg"]);
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];

            }else{
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
            }
            
        }else{
            [MBProgressHUD showError:@"亲 网络不给力啊"];
        }


    }];
    
}
#pragma mark ---- 登陆
-(void) testHttpMsPost{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@login.html",API_Login];
    if (_userNameTextField.text.length != 0 &&_passWordTextField.text.length != 0) {
        NSDictionary *paramsDic = @{@"username":_userNameTextField.text,
                                    @"password":_passWordTextField.text,
                                    @"client":@"ios",
                                    @"ip2long":[LoadDate getIPDress],
                                    @"deviceName":DEVICE,
                                    @"macAddress":MAC_ADDRESS};

        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.

                
                NSString *str= [obj objectForKey:@"code"];
                if (str.longLongValue == 200) {
                    NSDictionary *dict = [obj objectForKey:@"data"];

#warning key本地持久化
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"key"] forKey:@"login_key"];
                    [[NSUserDefaults standardUserDefaults] setObject:dict[@"username"] forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setObject:(NSString *)dict[@"userid"] forKey:@"userid"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    if ([Function isLogin]) {
                        [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];
                        [[SocketManager shareManager].socket connect];
                    }
                    
                    [[CartBadgeSingleton sharedManager] getCartBadgeNumBynet];
                    [[[(LiftSlideViewController *)[[self mm_drawerController] leftDrawerViewController] mainview] userNameBtn] setTitle:dict[@"username"] forState:UIControlStateNormal];
                    //发送消息
                    [MBProgressHUD showSuccess:@"登录成功"];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [MBProgressHUD showError:[obj objectForKey:@"msg"]];
                }
                
            }else{
                [MBProgressHUD showError:@"亲 网络不给力啊"];
            }
          
            
        }];

    } else {
        [MBProgressHUD showError:@"请输入完整信息"];
    }
   }

-(void)btnTarget:(UIButton *)btn{
    
    if (btn.tag == 1004) {

        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissregisView:)];
        [backView addGestureRecognizer:tap];
        [self.view addSubview:backView];
        
        [self createRegisterView];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.8;
        
    }else if (btn.tag == 1005){
        [self testHttpMsPost];
    }else if (btn.tag == 1001){
        [self wxlogin];
    }else if (btn.tag == 1000){
        // qq登录
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104986692" andDelegate:self];
        NSArray *permissions = @[@"get_userinfo",
                                 @"get_simple_userinfo",
                                 @"add_t"];
        

        [_tencentOAuth authorize:permissions];

        
    }else if (btn.tag == 1003) {
        [self presentViewController:[[LostPassWordViewController alloc] init] animated:YES completion:nil];
    }
    
}
//显示注册框
-(void)createRegisterView{
   
       //白框
   self.registerView = [[UIView alloc]initWithFrame:CGRectMake(SYS_WIDTH *0.0225, SYS_HEIGHT *0.205, SYS_WIDTH *0.955, SYS_HEIGHT *0.59)];
   self.registerView.layer.cornerRadius = 10;
    
    self.registerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.registerView];
    
    CGFloat registerWidth = self.registerView.frame.size.width;
    CGFloat registerHeight =  self.registerView.frame.size.height;
    
    //注册账户
    UILabel *registerLabel = [[UILabel alloc]initWithFrame:CGRectMake(registerWidth*0.06, registerHeight*0.067, registerWidth *0.88, registerHeight*0.04)];
    registerLabel.text = @"注册账户";
    registerLabel.textColor =[UIColor colorWithRed:0.45f green:0.46f blue:0.46f alpha:1.00f];
    registerLabel.font = [UIFont systemFontOfSize:20];
    [ self.registerView addSubview:registerLabel];
    
    //输入框
    NSArray *placeHolderArr = @[@"  请输入手机号",@"  请输入验证码",@"  请输入密码",@"  请确认密码"];
    for (int i=0; i<4; i++) {
        
        UITextField * elTextField= [[UITextField alloc]initWithFrame:CGRectMake(registerWidth *0.06,(i*0.15 +i*0.001 + 0.154)*registerHeight, registerWidth *0.88, registerHeight*0.113)];
        elTextField.placeholder=placeHolderArr[i];
        
        elTextField.tag = 20+i;
        elTextField.delegate = self;
        elTextField.font = [UIFont systemFontOfSize:15];
        elTextField.layer.cornerRadius = 5;
        
        elTextField.backgroundColor = [UIColor colorWithRed:0.92f green:0.93f blue:0.94f alpha:1.00f];
        if (i==0) {
            elTextField.keyboardType = UIKeyboardTypeNumberPad;
            _userTextField= elTextField;
            [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

        }else if (i ==2){
       
            
            elTextField.secureTextEntry = YES;
            _registerpassword=elTextField;
            [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  
        }else if (i ==3){
       
             elTextField.secureTextEntry = YES;
            _againTextField= elTextField ;
            [elTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
   
        }else {
            elTextField.keyboardType = UIKeyboardTypeNumberPad;
            _phoneCodeTF = elTextField;
        }
        [self.registerView addSubview:elTextField];

    }
    // 注册
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    nextBtn.frame = CGRectMake(registerWidth*0.06, (1-0.205)*registerHeight,registerWidth *0.88, registerHeight*0.113);
    nextBtn.backgroundColor =BackGreenColor;
    nextBtn.layer.cornerRadius =5;
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(leftBtnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [ self.registerView addSubview:nextBtn];
  
    
    // 获取验证码按钮
    _getCode = [[UIButton alloc] initWithFrame:CGRectMake(_phoneCodeTF.frame.size.width - 80, 7, 70, _phoneCodeTF.frame.size.height - 14)];
    _getCode.layer.cornerRadius = 5;
    _getCode.layer.borderColor = BackGreenColor.CGColor;
    _getCode.layer.borderWidth = 0.5;
    [_getCode.layer masksToBounds];
    [_getCode setTitleColor:BackGreenColor forState:UIControlStateNormal];
    _getCode.titleLabel.font = [UIFont systemFontOfSize:12];
    [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCode addTarget:self action:@selector(getCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_phoneCodeTF addSubview:_getCode];
    
}

- (void)getCodeClicked:(UIButton *)btn {
    if (_userTextField.text.length < 11) {
        
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",API_Login,@"spendSms.html"];
    NSDictionary *params = @{
                             @"mobile"      :_userTextField.text,
                             @"client"      :@"ios",
                             @"ip2long"     :[LoadDate getIPDress],
                             @"deviceName"  :DEVICE,
                             @"macAddress"  :MAC_ADDRESS
                             };
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
    [_getCode setTitle:[NSString stringWithFormat:@"%d",time--] forState:UIControlStateNormal];
    if (time == 0) {
        [timer invalidate];
        _getCode.enabled = YES;
        time = 60;
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

-(void)dismissregisView:(UIGestureRecognizer *)recognizer{
    [self.registerView removeFromSuperview];
    [recognizer.view removeFromSuperview];
}
-(void)leftBtnTarget:(UIButton *)btn{

        [self testHttpMsPostRegister];


}
#pragma mark ----- 微信登陆
-(void)wxlogin
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
-(void)wxresp{

    NSString *urlPath = [NSString stringWithFormat:@"%@wechat.html",API_Login];
    NSDictionary *dic = @{
                          @"code":[(AppDelegate *)[[UIApplication sharedApplication] delegate] WXCODE],
                          @"client":@"ios",
                          @"ip2long"          :[LoadDate getIPDress],
                          @"deviceName"       :DEVICE,
                          @"macAddress":MAC_ADDRESS
                          };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"" toView:self.view];
    [LoadDate httpPost:urlPath param:dic finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.

            
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                NSDictionary *dict = [obj objectForKey:@"data"];

#warning key本地持久化
                
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"key"] forKey:@"login_key"];
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"username"] forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:(NSString *)dict[@"userid"] forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([Function isLogin]) {
                    [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];

                    [[SocketManager shareManager].socket connect];

                }
                
                [[CartBadgeSingleton sharedManager] getCartBadgeNumBynet];
                
                [hud hide:YES];
                //发送消息
                [MBProgressHUD showSuccess:@"登录成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [hud hide:YES];
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
                
                
            }
            
        }else{
            [hud hide:YES];
            NSLog(@"%@",error.description);
            [MBProgressHUD showError:@"亲 网络不给力啊"];
        }
    }];
    
    
    
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == _againTextField||textField == _registerpassword) {
        if (textField.text.length < 6 && textField.text.length >0) {
           [MBProgressHUD show:@"字符不能小于6位" icon:nil view:self.view];
            return NO;
        }
        if (textField == _againTextField && textField.text.length > 0) {
            if (![_againTextField.text isEqualToString:_registerpassword.text]) {
                [MBProgressHUD show:@"两次密码输入的不同" icon:nil view:self.view];
                return NO;
            }
        }
        
    }
     return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _registerpassword || textField == _againTextField ) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
        
    }else if(textField == _userTextField){
        if (textField.text.length >11) {
           textField.text = [textField.text substringToIndex:11];
        }
    }
}


#pragma mark - qq登录回调
- (void)tencentDidLogin {
    
    NSString *url = @"http://api.91jksc.com/index/login/qq.html";
    NSDictionary *params = @{
                             @"client"          :@"ios",
                             @"ip2long"         :[LoadDate getIPDress],
                             @"deviceName"      :DEVICE,
                             @"access_token"    :_tencentOAuth.accessToken,
                             @"openid"          :_tencentOAuth.openId,
                             @"macAddress":MAC_ADDRESS
                             };
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"" toView:self.view];
    
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.

            
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                NSDictionary *dict = [obj objectForKey:@"data"];

#warning key本地持久化
                
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"key"] forKey:@"login_key"];
                [[NSUserDefaults standardUserDefaults] setObject:dict[@"username"] forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:(NSString *)dict[@"userid"] forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                if ([Function isLogin]) {
                    [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];

                    [[SocketManager shareManager].socket connect];

                }
                
                [[CartBadgeSingleton sharedManager] getCartBadgeNumBynet];
                [[[(LiftSlideViewController *)[[self mm_drawerController] leftDrawerViewController] mainview] userNameBtn] setTitle:dict[@"username"] forState:UIControlStateNormal];
                [hud hide:YES];
                //发送消息
                [MBProgressHUD showSuccess:@"登录成功"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [hud hide:YES];
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
                
                
            }
            
        }else{
            [hud hide:YES];

            [MBProgressHUD showError:@"亲 网络不给力啊"];
        }
    }];

}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
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
