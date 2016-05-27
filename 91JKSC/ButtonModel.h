//
//  ButtonModel.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonModel : UIView

+(void)createLittleBtn:(CGRect)frame andImageName:(NSString *)imageName andTarget:(SEL)selector andClassObject:(id)classObj andTag:(int)tag andColor:(UIColor *)color andBaseView:(UIView *)baseView andTitleName:(NSString *)titleName andFont:(CGFloat)font;
@end
