//
//  AdversionCollectionViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/18.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AdversionCollectionViewCell.h"
#import "AdversionNews.h"

@interface AdversionCollectionViewCell()
@property (weak , nonatomic)  UILabel *label;
@property (weak , nonatomic)  UIImageView *imageView;
@end
@implementation AdversionCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc] init];
        [self.contentView addSubview:img];
        self.imageView = img;
        
        UILabel *lab = [[UILabel alloc] init];
        [self.contentView addSubview:lab];
        self.label = lab;
    }
    
    return self;
}


-(void)setNews:(AdversionNews *)news
{
    _news=news;
    
    [self settingData];
    [self settingFrame];
}

#pragma mark 给子控件赋值
-(void) settingData{
//    self.imageView.image = [UIImage imageNamed:_news.icon];
    self.label.text = _news.title;
    
}

#pragma mark 设置子控件的frame
-(void) settingFrame{
    CGFloat screenWidth = self.contentView.frame.size.width;
    self.imageView.frame = CGRectMake(0, 0, screenWidth, 200);
    self.label.frame = CGRectMake(0, 0, screenWidth, 200);
    self.label.font = [UIFont systemFontOfSize:30];
    self.label.textAlignment = NSTextAlignmentCenter;
}

@end
