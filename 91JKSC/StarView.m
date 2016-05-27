//
//  StarView.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "StarView.h"
#import "UIImageView+WebCache.h"
@implementation StarView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.view = [[UIView alloc]initWithFrame:frame];
        _numberOfStar = 0;
    }
    return self;
}

-(void)createStarView{
   
    
    UIImageView *imageV= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star-5-default"]];
    imageV.contentMode=UIViewContentModeTopLeft;
    imageV.clipsToBounds=YES;
    imageV.frame = CGRectMake(0, 0, 30*5, 25);
    [self addSubview:imageV];
    
    UIImageView *imagelight= [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star-5"]];
    imagelight.contentMode=UIViewContentModeTopLeft;
    imagelight.clipsToBounds=YES;
    imagelight.frame = CGRectMake(0, 0, 30*(CGFloat)_numberOfStar, 25);
    [self addSubview:imagelight];
    
    
}




@end
