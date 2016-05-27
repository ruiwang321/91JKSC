//
//  LeftSortsViewController.m
//  91JKSC
//
//  Created by 商城 阜新 on 16/2/17.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "Common.h"
@interface LeftSortsViewController ()

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    [self createView];
}
-(void)createView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 230)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
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
