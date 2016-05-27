//
//  MyNavigationBar.m
//  91jksc
//
//  Created by 商城 阜新 on 16/1/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MyNavigationBar.h"
#import "MyNavigationItem.h"
#import "Common.h"
#import "CartBadgeSingleton.h"
@implementation MyNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)createMyNavigationBarWithImageName:(NSString *)imageName andTitle:(NSString *)title andLeftItems:(NSArray *)leftItemArr andRightItems:(NSArray *)rightItemArr andTitleView:(UIView *)titleView andClass:(id)classObject andSEL:(SEL)sel andColor:(UIColor *)bgColor{
    
//    [self createMyNavigationBarWithImageName:imageName];
    
    [self createMyNavigationBarWithBackImageColor:bgColor];
    
    if (title.length >0) {
        [self createMyNavigationBarWithTitle:title];
    }
    if (titleView) {
        [self createMyNavigationBarWithTitleView:titleView];
    }
    
    if (leftItemArr.count >0) {
        int index = 0;
        
        CGFloat x = 0.f;
        
        for (MyNavigationItem *item  in leftItemArr) {
            
            x = [self createMyVavigationBarWitnItem:item andIsLeft:YES andIndex:index andX:x andClass:classObject andSEL:sel];
            index ++;
            
        }
        
    }
    if (rightItemArr.count > 0) {
        int index = 0;
        
        CGFloat x = self.frame.size.width;

        for (MyNavigationItem *item  in rightItemArr) {
            
            x = [self createMyVavigationBarWitnItem:item andIsLeft:NO andIndex:index andX:x andClass:classObject andSEL:sel];
            index ++;

        }
    }
    
    
    
}
#pragma mark --- 创建NAV的背景图片
//-(void)createMyNavigationBarWithImageName:(NSString *)imageName{
-(void)createMyNavigationBarWithBackImageColor:(UIColor *)bgColor{
//    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
//    imageV.frame = self.bounds;
//    [self addSubview:imageV];
    UILabel *label = [[UILabel alloc]init];
    label.frame = self.bounds;
    label.backgroundColor = bgColor;
    [self addSubview:label];
    
    
    
    
}
#pragma mark --- 创建NAV的标题
-(void)createMyNavigationBarWithTitle:(NSString *)titleName {
    
    UILabel *titleLable = [[UILabel alloc]init];
    
    titleLable.frame = CGRectMake(self.frame.size.width/3,27,SYS_WIDTH/3,30);
    
    titleLable.text = titleName;
    
    titleLable.textAlignment = NSTextAlignmentCenter;
    
    titleLable.font = [UIFont systemFontOfSize:18];
    
    titleLable.textColor = [UIColor whiteColor];
    
    [self addSubview:titleLable];
}

#pragma mark --- 创建NAV的view
-(void)createMyNavigationBarWithTitleView:(UIView * )titleView{
    
    titleView.frame = CGRectMake(60, (self.frame.size.height - titleView.frame.size.height+20)/2, titleView.frame.size.width, titleView.frame.size.height);
    [self addSubview:titleView];
}
#pragma mark --- 创建NAV Item
-(CGFloat)createMyVavigationBarWitnItem:(MyNavigationItem *)item andIsLeft:(BOOL)isLeft andIndex:(int)index andX:(CGFloat)x andClass:(id)classObject andSEL:(SEL)sel{
    
    UIImage *bgImage = [UIImage imageNamed:item.imageName];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    btn.frame = isLeft?CGRectMake(x+10, (self.frame.size.height+26-32)/2-6, 44, 44):CGRectMake(x-15-32, (self.frame.size.height-32+20)/2-6, 44, 44);
    [btn setImage:bgImage forState:UIControlStateNormal];
    
    [btn addTarget:classObject action:sel forControlEvents:UIControlEventTouchUpInside];
    
    btn.tag = isLeft?1000+index:2000+index;
    
    [self addSubview:btn];
    
    return isLeft?x+10+btn.frame.size.width:btn.frame.origin.x;
}

@end
