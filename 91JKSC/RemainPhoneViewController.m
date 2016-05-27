//
//  RemainPhoneViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "RemainPhoneViewController.h"
#import "LiftSlideViewController.h"
@interface RemainPhoneViewController ()<UITextFieldDelegate>
{
    int time;
    UIButton *_getCode;
}
@end

@implementation RemainPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    time = 60;
    [self createNavBar];
    [self createBaseView];
    
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"手机验证";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createBaseView{
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 71, SYS_WIDTH, 100)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    _phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 50)];
    _phoneTextField.tag =10;
    _phoneTextField.text = @"  当前绑定的手机号码";
    _phoneTextField.font = SYS_FONT(16);
    _phoneTextField.borderStyle =UITextBorderStyleNone;
    _phoneTextField.userInteractionEnabled = NO;
    [baseView addSubview:_phoneTextField];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 49,SYS_WIDTH -20 , 1)];
    lineLabel.backgroundColor = BACKGROUND_COLOR;
    lineLabel.text = @"";
    [_phoneTextField addSubview:lineLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(SYS_WIDTH-120, 0, 110, 49)];
    NSString *originTel = self.PresentPhone;
    NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    phoneLabel.text = tel;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.font = SYS_FONT(16);
    [_phoneTextField addSubview:phoneLabel];
    
    
    
   _codeTextPhone= [[UITextField alloc]initWithFrame:CGRectMake(10,50,SYS_WIDTH-20,50)];
    _codeTextPhone.placeholder=@"请输入手机验证码";
    _codeTextPhone.borderStyle = UITextBorderStyleNone;
    _codeTextPhone.tag = 20;
    _codeTextPhone.delegate = self;
    _codeTextPhone.font = SYS_FONT(15);
    _codeTextPhone.layer.cornerRadius = 5;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 49, SYS_WIDTH-20, 1)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [_codeTextPhone addSubview:lineView];
    
    
    
    
    // 获取验证码按钮
    _getCode = [[UIButton alloc] initWithFrame:CGRectMake(_codeTextPhone.frame.size.width - 80, 7, 70, _codeTextPhone.frame.size.height - 14)];
    _getCode.layer.cornerRadius = 5;
    _getCode.layer.borderColor = [UIColor grayColor].CGColor;
    _getCode.layer.borderWidth = 0.5;
    [_getCode.layer masksToBounds];
    [_getCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _getCode.tag = 30;
    _getCode.titleLabel.font = SYS_FONT(13);
    [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getCode addTarget:self action:@selector(getCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_codeTextPhone addSubview:_getCode];
    _codeTextPhone.secureTextEntry = NO;
    [baseView addSubview:_codeTextPhone];
    
    
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(10, 225, SYS_WIDTH -20, 50);
    changeBtn.layer.cornerRadius = 5;
    changeBtn.backgroundColor = BackGreenColor;
    [changeBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [changeBtn addTarget:self action:@selector(solvePhontNum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 290, SYS_WIDTH - 20, 30)];
    label.text = @"为确保账户安全，更换手机号前，需验证原手机号";
    label.textColor = [UIColor grayColor];
    label.font = SYS_FONT(14);
    [self.view addSubview:label];
    
}

#pragma mark ---- 发送验证码
- (void)getCodeClicked:(UIButton *)btn {
    NSString *url;
    NSDictionary *params;
    
    
    url = [NSString stringWithFormat:@"%@%@",API_USER,@"unBindSms.html"];
    
    params = @{
                   @"key"      :[Function getKey]
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


#pragma mark ---- 解绑手机号
-(void)solvePhontNum{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_USER,@"unBindMobile.html"];
    if (![Function isLogin]||_codeTextPhone.text.length<=0) {
        
        if ([Function isLogin]) {
            [MBProgressHUD showError:@"请输入验证码"];
        }else{
            [MBProgressHUD showError:@"请登录"];
        }
    }else{
        NSDictionary *params = @{
                                 @"key":[Function getKey],
                                 @"code":_codeTextPhone.text
                                 };
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] longLongValue] == 200) {
                [MBProgressHUD showSuccess:obj[@"msg"]];

                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"100" object:nil userInfo:@{
                                                      @"num":@" "
                                                                                                           }];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
                
                [self textFieldShouldReturn:_codeTextPhone];
                [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:NO];
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
