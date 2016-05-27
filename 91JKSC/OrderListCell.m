//
//  OrderListCell.m
//  91健康商城
//
//  Created by HerangTang on 16/2/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib {
    // Initialization code
}

// 重写cellframe的setter
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
