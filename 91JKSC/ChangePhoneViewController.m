//
//  ChangePhoneViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "RemainPhoneViewController.h"
@interface ChangePhoneViewController ()

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createNavBar];
    [self createBaseView];
    [self createBtnAndLabel];
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
    _baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 75, SYS_WIDTH, 240)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SYS_WIDTH -60)/2, 30, 60,100)];
    imageV.image = [UIImage imageNamed:@"phone"];
    [_baseView  addSubview:imageV];
    
    
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 145, SYS_WIDTH-20, 30)];
    titleLabel.text = @"当前绑定的手机号码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = SYS_FONT(16);
    
    titleLabel.textColor = [UIColor grayColor];
    [_baseView addSubview:titleLabel ];
   
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 185, SYS_WIDTH-20, 30)];
    NSString *originTel = self.presentPhone;
    NSString *tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    phoneLabel.text = tel;
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.font = SYS_FONT(16);
    phoneLabel.textAlignment =NSTextAlignmentCenter;
    [_baseView addSubview:phoneLabel];
    
    
}
-(void)createBtnAndLabel{
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(10, 325, SYS_WIDTH -20, 40);
    changeBtn.layer.cornerRadius = 5;
    changeBtn.backgroundColor = BackGreenColor;
    [changeBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [changeBtn addTarget:self action:@selector(changePhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, SYS_WIDTH - 20, 30)];
    label.text = @"为确保账户安全，更换手机号前，需验证原手机号";
    label.textColor = [UIColor grayColor];
    label.font = SYS_FONT(14);
    [self.view addSubview:label];
    
    
}
-(void)changePhone:(UIButton *)btn{
    RemainPhoneViewController *remainVC = [[RemainPhoneViewController alloc]init];

    remainVC.PresentPhone = self.presentPhone;
    
    [self.navigationController pushViewController:remainVC animated:YES];
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
