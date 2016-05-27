//
//  ShippmentOneTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShippmentOneTableViewCell.h"

@implementation ShippmentOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
        
        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}
-(void)setShippModel:(ShippmentModel *)shippModel{
    _stateL.text = shippModel.shipping_status;
    _busissL.text = shippModel.shipping_name;
    _numL.text = shippModel.shipping_code;
    _shippModel = shippModel;
}
-(void)createSubView{
    
    UILabel *stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 20)];
    stateLabel.text = @"物流状态:";
    stateLabel.textColor = [UIColor grayColor];
    stateLabel.font = SYS_FONT(17);
    [self.contentView addSubview:stateLabel];
    
    UILabel *busissLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 100, 20)];
    busissLabel.text = @"承运公司:";
    busissLabel.textColor = [UIColor grayColor];
    busissLabel.font = SYS_FONT(17);
    [self.contentView addSubview:busissLabel];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 80, 100, 20)];
    numLabel.text = @"快递单号:";
    numLabel.textColor = [UIColor grayColor];
    numLabel.font = SYS_FONT(17);
    [self.contentView addSubview:numLabel];
    
     _stateL= [[UILabel alloc]initWithFrame:CGRectMake(120, 20, SYS_WIDTH-120, 20)];
    _stateL.textColor = [UIColor grayColor];
    _stateL.font = SYS_FONT(17);
    [self.contentView addSubview:_stateL];
    
     _busissL= [[UILabel alloc]initWithFrame:CGRectMake(120, 50, SYS_WIDTH-120, 20)];
    _busissL.textColor = [UIColor grayColor];
    _busissL.font = SYS_FONT(17);
    [self.contentView addSubview:_busissL];
    
    
    _numL = [[UILabel alloc]initWithFrame:CGRectMake(120, 80, SYS_WIDTH-120, 20)];
    _numL.textColor = [UIColor grayColor];
    _numL.font = SYS_FONT(17);
    [self.contentView addSubview:_numL];
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
