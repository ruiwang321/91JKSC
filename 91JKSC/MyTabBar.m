//
//  MyTabBar.m
//  91jksc
//
//  Created by 商城 阜新 on 16/1/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MyTabBar.h"
//#import "Header.h"
#import "Common.h"
@implementation MyTabBar
{
    UITabBarController *_tbc;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(MyTabBar *)shareTabBarController{
    
    static MyTabBar *tab = nil;
    if (!tab) {
        tab = [[MyTabBar alloc]initWithFrame:CGRectMake(0,0, 49, SYS_HEIGHT)];
    }
    return tab;
    
}

#pragma mark----创建TabBar的背景图片
-(void)createBgImageWithImageName:(NSString *)imageName{
    
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    
    imageV.frame = self.bounds;
    
    [self addSubview:imageV];
    
}

#pragma mark ---- 创建TabBar
-(void)createMyTabBarWithUITabBarController:(UITabBarController *)tabBarController{
    _tbc = tabBarController;
    NSDictionary *plistDict = [[NSDictionary alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@/MyTabBar.plist",[[NSBundle mainBundle] resourcePath]]];
    
    [self createBgImageWithImageName:[plistDict objectForKey:@"bgTabBarImageName"]];
    NSArray *itemArr = [plistDict objectForKey:@"items"];
    int index = 0;
    for (NSDictionary *itemDict in itemArr ) {
        [self createItemWithItemDict :itemDict andIndex:index andCount:(int     )itemArr.count];
        index++;
    }
    
}
#pragma mark----创建TabBar上的item
-(void)createItemWithItemDict:(NSDictionary *)itemDict andIndex:(int)index andCount:(int)count{
    
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, SYS_HEIGHT/count*index, 49, SYS_HEIGHT/count-10)];
    [self addSubview:baseView];
    
    
    /** tabBar 按钮**/
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, baseView.frame.size.width, baseView.frame.size.height-10);
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"bgImage"]] forState:UIControlStateNormal];
    [btn setTintColor:[UIColor cyanColor]];
    [btn setImage:[UIImage imageNamed:[itemDict objectForKey:@"selectImage"]] forState:UIControlStateSelected];
    
    btn.tag = index;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [baseView addSubview:btn];
    
    
    /**tabBar字体**/
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, btn.frame.size.height-3, baseView.frame.size.width, baseView.frame.size.height - btn.frame.size.height)];
    label.text = [itemDict objectForKey:@"title"];
//    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    [baseView addSubview:label];

}
-(void)btnClick:(UIButton *)btn{
    [self changeColorWithIndex:(int)btn.tag];
    _tbc.selectedIndex = btn.tag;
    _tbc.selectedViewController = [_tbc.viewControllers objectAtIndex:btn.tag];
}

-(void)changeColorWithIndex:(int)index{
    for (UIView *view in self.subviews) {
        if (![view isKindOfClass:[UIImageView class]]) {
            ((UIButton *)[view.subviews objectAtIndex:0]).selected = NO;
        }
    }
    UIView *baseView = [self.subviews objectAtIndex:index+1];
    ((UIButton *)[baseView.subviews objectAtIndex:0]).selected = YES;
}

@end
