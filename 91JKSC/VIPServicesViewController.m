//
//  VIPServicesViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "VIPServicesViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import <MMDrawerController/UIViewController+MMDrawerController.h>
@interface VIPServicesViewController ()

@end

@implementation VIPServicesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNavBar];
    
    UIImageView *developing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"developing"]];
    developing.frame = CGRectMake(0, 0, 250, 250);
    developing.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT / 2);
    [self.view addSubview:developing];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 130, 50)];
    [button setImage:[UIImage imageNamed:@"developing-page-button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT / 2 + 160);
    [self.view addSubview:button];
}

// 创建导航条
- (void)createNavBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"会员服务";
    titleLabel.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"item" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
}
-(void)leftBtn:(UIButton *)btn{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)buttonClicked {
    
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
