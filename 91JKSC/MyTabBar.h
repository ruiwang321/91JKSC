//
//  MyTabBar.h
//  91jksc
//
//  Created by 商城 阜新 on 16/1/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBar : UIView



+(MyTabBar *)shareTabBarController;


-(void)createMyTabBarWithUITabBarController:(UITabBarController *)tabBarController;
@end
