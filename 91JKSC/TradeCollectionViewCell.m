//
//  TradeCollectionViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "TradeCollectionViewCell.h"
#import "TradeModel.h"
#import "UIImageView+WebCache.h"
@implementation TradeCollectionViewCell



-(void)createCellWithModel:(TradeModel *)model andIndex:(int)index{
    
    if (_titleLabel == nil) {
        [self createSubView];
    }
    
   
    ImageWithUrl(_imageV, model.goods_image);
    _titleLabel.text = model.goods_name;
    _moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"RMB:%@",model.goods_price]];
    
    [_moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12/375.0f*SYS_WIDTH] range:NSMakeRange(0, 4)];
    _moneyLabel.attributedText = _moneyStr;
}

- (void)createSubView {
    
    
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
