//
//  ChangePasswordViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/6.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () {
    UITextField *securityQ;
    UITextField *password;
    UITextField *passwordConfirm;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:@"忘记密码" andSEL:@selector(leftbtnWith:)];
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createSubView];
}

- (void)createSubView {
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
    securityQ.placeholder = _securty;
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
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, CGRectGetMaxY(bgView.frame)+50, SYS_WIDTH-20, 40);
    nextBtn.layer.cornerRadius = 5;
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    nextBtn.backgroundColor = BackGreenColor;
    [nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)nextBtnClicked {
    
}

- (void)leftbtnWith:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [securityQ resignFirstResponder];
    [password resignFirstResponder];
    [passwordConfirm resignFirstResponder];
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
