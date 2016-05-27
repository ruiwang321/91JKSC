//
//  WebViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/9.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:nil andSEL:@selector(dismissWeb)];
    [self createWebView];
}
-(void)dismissWeb{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createWebView{
   self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64)];
    
    self.webView.scalesPageToFit = true;
    self.webView.delegate = self;
    NSLog(@"%@",self.urlStr);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    NSLog(@"%@",self.webView.request.URL);
    [self.view addSubview:self.webView];
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
