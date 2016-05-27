//
//  ShareViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavBar];
    UIImageView *developing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"developing"]];
    developing.frame = CGRectMake(0, 0, 250, 250);
    developing.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT / 2);
    [self.view addSubview:developing];
}
// 创建导航条
- (void)createNavBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"分享";
    titleLabel.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
}
-(void)leftBtn:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
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
