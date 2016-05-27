//
//  HeaderButton.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/9.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "HeaderButton.h"

@implementation HeaderButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, self.frame.size.height*0.5, self.frame.size.height*0.5)];
        imageV.image = [UIImage imageNamed:@"iconfont-xihuan"];
        UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(self.frame.size.height*0.5+2, 1, self.frame.size.width - self.frame.size.width, self.frame.size.height*0.5)];
        label.textColor = [UIColor grayColor];
        label.text =@"喜欢";
        [self addSubview:label];
        [self addSubview:imageV];
    }
    return self;
}

@end
