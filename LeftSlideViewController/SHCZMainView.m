//
//  SHCZMainView.m
//  test1
//
//  Created by Devil on 16/1/5.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import "SHCZMainView.h"
#import "LoginViewController.h"
#import "MeViewController.h"
#import "LoginModel.h"
#import "UIView+ViewController.h"
#import "AppDelegate.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "MyMessageViewController.h"
@interface SHCZMainView()

@end
@implementation SHCZMainView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
    //    按钮的frame
    CGFloat bX=37.5;
    CGFloat bY=59;
    CGFloat bW=70;
    CGFloat bH=70;
    //    在背景图上添加按钮
    UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake(bX,bY,bW,bH)];
   
    [headBtn addTarget:self action:@selector(didPanEvent:) forControlEvents:UIControlEventTouchUpInside];
    [headBtn setBackgroundImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    //    头像的frame
    CGFloat iX=0;
    CGFloat iY=0;
    CGFloat iW=headBtn.bounds.size.height;
    CGFloat iH=headBtn.bounds.size.height;
    //    在按钮上添加头像
    _headImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"profile"]];
    _headImage.frame=CGRectMake(iX,iY,iW,iH);
    _headImage.layer.cornerRadius =headBtn.bounds.size.height * 0.5;
    _headImage.layer.masksToBounds = YES;

    //    名称的frame
    
        CGFloat lX=bX;
    
        CGFloat lY=iH+bY+5;
    
        CGFloat lW=[UIScreen mainScreen].bounds.size.width;
    
        CGFloat lH=iW*0.3;
    //    在按钮上显示名称
       _userNameBtn
        =[UIButton buttonWithType:UIButtonTypeCustom];
        _userNameBtn.frame = CGRectMake(lX, lY, lW, lH);

        [_userNameBtn setTitle:@"请登录" forState:UIControlStateNormal];
//        _userNameBtn.titleLabel.font = [UIFont fontWithName:@"Dauphin" size:0.053*SYS_WIDTH];
        _userNameBtn.titleLabel.font = [UIFont systemFontOfSize:0.053*SYS_WIDTH];
        
       _userNameBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_userNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_userNameBtn addTarget:self action:@selector(didPanEvent:) forControlEvents:UIControlEventTouchUpInside];
        // 查看详细资料的frame
    
        CGFloat XX=bX;
        CGFloat XY=lH+lY;
        CGFloat XW=[UIScreen mainScreen].bounds.size.width;
        CGFloat XH=iW*0.3;
        //    在按钮上显示名称
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(XX, XY, XW, XH);
        [btn setTitle:@"[查看详细资料]" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:0.032*SYS_WIDTH]];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(didPanEvent:) forControlEvents:UIControlEventTouchUpInside];
               
//     二维码的frame
    
        CGFloat qW=headBtn.bounds.size.height;
    
        CGFloat qH=headBtn.bounds.size.height;
   
        CGFloat qX=headBtn.bounds.size.width-qW;
   
        CGFloat qY=0;
   
        UIButton *qrCode=[[UIButton alloc]initWithFrame:CGRectMake(qX,qY,qW,qH)];
   
        [qrCode setImage:[UIImage imageNamed:@"sidebar_ QRcode_normal"] forState:UIControlStateNormal];
        
//        创建透明view上的tableview
    
        _sideTableView=[[SHCZSideTableView alloc]initWithFrame:CGRectMake(0,207,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-206.5)];
        
    
        _sideTableView.backgroundColor=[UIColor clearColor];
        

//       创建底部view的按钮
    
        
   
        [headBtn addSubview:_headImage];
        
     

        UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 206.5)];
   
        headerView.backgroundColor=[UIColor colorWithRed:0.01f green:0.48f blue:0.22f alpha:1.00f];
        [headerView addSubview:_userNameBtn];
        [headerView addSubview:btn];
        [headerView addSubview:headBtn];
//    [self addGestureRecognizer:pan];

        [_sideTableView reloadData];
        [self addSubview:_sideTableView];
   
       
   
        [self addSubview:headerView];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2 -70 ,SYS_HEIGHT -40, 120, 30)];
        label.text = @"91jksc.com";
        label.textColor = BackGreenColor;
        label.font = [UIFont fontWithName:@"Dauphin" size:30];
        label.userInteractionEnabled = YES;
        [self addSubview:label];
    
    
    }

    return  self ;

}

-(void)didPanEvent:(UIButton *)btn{

    if (![Function isLogin]) {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:loginVC animated:YES completion:nil];
        
    }else{

//        MeViewController *meVC = [[MeViewController alloc]init];
//        meVC.userName = self.userName;
//        meVC.imageName = self.imageName;
//        meVC.nickName = self.nickName;
        MyMessageViewController *myMessage = [[MyMessageViewController alloc]init];
        myMessage.userName = self.userName;
        myMessage.imageName = self.imageName;
        myMessage.nickName = self.nickName;
        UITabBarController *mainTabBar = [(AppDelegate *)[UIApplication sharedApplication].delegate mainTabBar];
        [[mainTabBar.selectedViewController selectedViewController]pushViewController:myMessage animated:YES];
 
        [self.viewController.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
       
    }
}

@end
