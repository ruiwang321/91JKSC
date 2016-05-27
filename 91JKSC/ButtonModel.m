//
//  ButtonModel.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ButtonModel.h"

@implementation ButtonModel
#pragma mark ---- 创建Btn
+(void)createLittleBtn:(CGRect)frame andImageName:(NSString *)imageName andTarget:(SEL)selector andClassObject:(id)classObj andTag:(int)tag andColor:(UIColor *)color andBaseView:(UIView *)baseView andTitleName:(NSString *)titleName andFont:(CGFloat)font{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;

    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    btn.tag = tag;
    btn.layer.shadowOffset = CGSizeMake(1, 1);
    btn.layer.shadowColor = [UIColor blackColor].CGColor;
    btn.layer.shadowOpacity = 0.3;//阴影透明度，默认0
    btn.layer.shadowRadius = 4;//阴影半径，默认3
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitle:titleName forState:UIControlStateNormal];
    btn.backgroundColor = color;
    [btn addTarget:classObj action:selector forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];
}

@end
