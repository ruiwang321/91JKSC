//
//  MyNavigationBar.h
//  91jksc
//
//  Created by 商城 阜新 on 16/1/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyNavigationBar : UIView



-(void)createMyNavigationBarWithImageName:(NSString *)imageName andTitle:(NSString *)title andLeftItems:(NSArray *)leftItemArr andRightItems:(NSArray *)rightItemArr andTitleView:(UIView *)titleView andClass:(id)classObject andSEL:(SEL)sel andColor:(UIColor *)bgColor;



@end
