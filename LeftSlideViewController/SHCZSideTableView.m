//
//  SHCZSideTableView.m
//  test1
//
//  Created by Devil on 16/1/11.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import "SHCZSideTableView.h"
#import "MainViewController.h"
#import "UIView+SHCZExt.h"
#import "AccountDetailViewController.h"
#import "ShoppingCartViewController.h"
#import "AppDelegate.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "UIView+ViewController.h"
#import "LoginViewController.h"
#import "ShareViewController.h"
#import "UIView+ViewController.h"
#import "LiftSlideViewController.h"
@interface SHCZSideTableView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *arrayM;


@end

@implementation SHCZSideTableView
//    实例化
-(NSMutableArray *)arrayM{
    if (_arrayM==nil) {
        _arrayM=[NSMutableArray array];
    }
    return _arrayM;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
//    设置代理和数据源
    self.delegate=self;
    self.dataSource=self;
    self.rowHeight=50;
    self.separatorStyle=NO;
    return  self;
}


//实现数据源方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (indexPath.row==0) {
           
            cell.imageView.image=[UIImage imageNamed:@"首页黑"];
            cell.selected = YES;

            cell.textLabel.text=@"首页";
            
            cell.imageView.highlightedImage = [UIImage imageNamed:@"首页绿"];
        
//        }else if (indexPath.row== 1) {
//            cell.imageView.image=[UIImage imageNamed:@"会员黑"];
//            cell.textLabel.text=@"会员服务";
//           cell.imageView.highlightedImage = [UIImage imageNamed:@"会员绿"];
//
        }else if (indexPath.row== 1) {
            cell.imageView.image=[UIImage imageNamed:@"购物车黑"];
            cell.textLabel.text=@"购物车";
            cell.imageView.highlightedImage = [UIImage imageNamed:@"购物车绿"];

        }else if (indexPath.row == 2) {
    
            cell.imageView.image=[UIImage imageNamed:@"消息黑"];
            cell.textLabel.text=@"消息";
            cell.imageView.highlightedImage = [UIImage imageNamed:@"消息绿"];

        }else if (indexPath.row == 3) {
            cell.imageView.image=[UIImage imageNamed:@"收藏黑"];
            cell.textLabel.text=@"我的收藏";
            cell.imageView.highlightedImage = [UIImage imageNamed:@"收藏率"];
        }else {

//            cell.imageView.image=[UIImage imageNamed:@"收藏黑"];
            cell.textLabel.text=@"账户设置";
//            cell.imageView.highlightedImage = [UIImage imageNamed:@"收藏率"];
            
        }
//        }else{
//            
//            cell.textLabel.text=@"分享";
//            
//        }
    
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.highlightedTextColor = BackGreenColor;
//    点击cell时没有点击效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)indexPath.row);
//    if (indexPath.row == 6) {
//        ShareViewController *shareVC = [[ShareViewController alloc]init];
//        [self.viewController presentViewController:shareVC animated:YES completion:nil];
//    }else
    if(indexPath.row == 1||indexPath.row == 3 || indexPath.row == 2){
    
        if (![Function isLogin]) {
            [[[[[UIApplication  sharedApplication] delegate] window] rootViewController] presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil] ;
        }else{
            UITabBarController *mainTabBar  = [(AppDelegate *)[UIApplication sharedApplication].delegate mainTabBar];
            mainTabBar.selectedIndex = indexPath.row/(indexPath.row>1?2:3);
            //indexPath.row/3
            [(UITabBarController *)mainTabBar.selectedViewController setSelectedIndex:indexPath.row%(indexPath.row>1?2:3)];
            //indexPath.row%3
            [mainTabBar.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
            
        }
    }else if (indexPath.row ==4){
        UITabBarController *mainTabBar  = [(AppDelegate *)[UIApplication sharedApplication].delegate mainTabBar];
        mainTabBar.selectedIndex =1;
        [(UITabBarController *)mainTabBar.selectedViewController setSelectedIndex:2];
        [mainTabBar.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    }else{
        UITabBarController *mainTabBar  = [(AppDelegate *)[UIApplication sharedApplication].delegate mainTabBar];
        mainTabBar.selectedIndex = indexPath.row/(indexPath.row>1?2:3);
        [(UITabBarController *)mainTabBar.selectedViewController setSelectedIndex:indexPath.row%(indexPath.row>1?2:3)];
        [mainTabBar.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    
}

@end

