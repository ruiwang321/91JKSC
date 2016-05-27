//
//  MoreOrderTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MoreOrderTableViewCell.h"
#import "OrderModel.h"
#import "OrderListView.h"

@implementation MoreOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}
// 重写cellframe的setter
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 5;
    frame.origin.x += 10;
    frame.size.width -= 20;
    frame.size.height -= 5;
    [super setFrame:frame];
}
-(void)createViewWithBaseView:(OrderModel*)model{
    if (_orderview == nil) {
        [self createOrderView];
    }
    [_orderview createView:model];
}
-(void)createOrderView{
    _orderview = [[OrderListView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH-20, SYS_SCALE(200))];
    
    [self.contentView addSubview:_orderview];
}
@end
