//
//  TradeSysWidthCollectionViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/4.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "TradeSysWidthCollectionViewCell.h"
#import "TradeModel.h"
#import "UIImageView+WebCache.h"
@implementation TradeSysWidthCollectionViewCell



-(void)createCellWithModel:(TradeModel *)model andIndex:(int)index{
    if (_titleLabel == nil) {
        [self createSubView];
    }
     ImageWithUrl(_imageV, model.goods_image);
    
       _titleLabel.text = model.goods_name;
    
        _moneyLabel.text = model.goods_price;
}
-(void)createSubView{
    self.backgroundColor = [UIColor whiteColor];
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, SYS_WIDTH-4,self.frame.size.height-50                                                       )];
   
    [self addSubview:_imageV];
    
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, _imageV.frame.size.height+4, self.frame.size.width, 20)];
    
    _titleLabel.text = nil;
 
    
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_titleLabel];
    
    
    
    _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/5, _imageV.frame.size.height+4+_titleLabel.frame.size.height+4, self.frame.size.width, 20)];
    _valueLabel.text = @"RMB:";
    _valueLabel.font = [UIFont systemFontOfSize:10];
    _valueLabel.textColor = [UIColor colorWithRed:0.32f green:0.33f blue:0.34f alpha:1.00f];
    [self addSubview:_valueLabel];
    
    
    
    _moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/5+26, _imageV.frame.size.height+4+_titleLabel.frame.size.height+2, 60, 20)];

    _moneyLabel.font = [UIFont systemFontOfSize:15];
    _moneyLabel.textColor = [UIColor colorWithRed:0.32f green:0.33f blue:0.34f alpha:1.00f];
    [self addSubview:_moneyLabel];
    

}
@end
