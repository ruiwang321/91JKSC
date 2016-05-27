//
//  MeCollectionViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MeCollectionViewCell.h"

@implementation MeCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}

-(void)createCell{
    self.backgroundColor =[UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
    _imageV= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width,self.contentView.frame.size.height-50)];
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageV];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,_imageV.frame.size.height, self.contentView.frame.size.height, 0.5)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [self.contentView addSubview:lineView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, _imageV.frame.size.height+4, self.contentView.frame.size.width-2, 20)];
    _titleLabel.text = nil;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = SYS_FONT(16);
    [self.contentView addSubview:_titleLabel];
    
    
    
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageV.frame.size.height+4+_titleLabel.frame.size.height+2, self.contentView.frame.size.width-4, 20)];
    
    _moneyLabel.font = SYS_FONT(16);
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    _moneyLabel.textColor = [UIColor colorWithRed:0.32f green:0.33f blue:0.34f alpha:1.00f];
    [self.contentView addSubview:_moneyLabel];
}
@end
