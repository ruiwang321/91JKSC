//
//  ShippmentTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShippmentTableViewCell.h"

@implementation ShippmentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}
-(void)setShippModel:(ShippmentModel *)shippModel{
    
    _lineView.frame = CGRectMake(80, shippModel.rowHight-1, SYS_WIDTH -110, 1);
    _stateLabel.frame = CGRectMake(80, 15, SYS_WIDTH -90, shippModel.messageHight);
    _timeLabel.frame = CGRectMake(80, 15+shippModel.messageHight, SYS_WIDTH -190, 20);
    _linedownView.frame = CGRectMake(40, 35,1 , shippModel.rowHight-35);
    _lineupView.frame = CGRectMake(40, 0, 1, 15);
    _timeLabel.text = shippModel.shipping_time;
    _stateLabel.text = shippModel.shipping_status;
    _shippModel = shippModel;
}
-(void)setIsFistRow:(BOOL)isFistRow{
    if (isFistRow) {
        _stateLabel.textColor = [UIColor blackColor];
        _timeLabel.textColor = [UIColor blackColor];
        
        _lightLabel.frame = CGRectMake(30, 15, 20, 20);
        _lightLabel.layer.masksToBounds = YES;
        _lightLabel.backgroundColor = BackGreenColor;
        _lightLabel.layer.cornerRadius = 10;
        _lightLabel.layer.borderColor = [UIColor colorWithRed:0.58f green:0.88f blue:0.71f alpha:1.00f].CGColor;
        _lightLabel.layer.borderWidth = 1;
        
        _lineupView.hidden = YES;
    }else{
        _stateLabel.textColor = [UIColor grayColor];
        _timeLabel.textColor = [UIColor grayColor];
        _lightLabel.frame = CGRectMake(33, 17.5, 15, 15);
        _lightLabel.layer.masksToBounds = YES;
        _lightLabel.backgroundColor = [UIColor grayColor];
        _lightLabel.layer.cornerRadius = 7.5;
        _lineupView.hidden = NO;
    }
    _isFistRow = isFistRow;
}
-(void)createSubView{
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, SYS_WIDTH -90, 0)];
    _stateLabel.numberOfLines = 0;
    _stateLabel.font = SYS_FONT(16);
    [self.contentView addSubview:_stateLabel];
    
     _timeLabel= [[UILabel alloc]initWithFrame:CGRectMake(80, 15, SYS_WIDTH -190, 20)];
    _timeLabel.font = SYS_FONT(15);
    [self.contentView addSubview:_timeLabel];
    
    _lightLabel = [[UILabel alloc]init];
    
    [self.contentView addSubview:_lightLabel];
    
    _linedownView = [[UIView alloc]initWithFrame:CGRectMake(40, 35,1 ,35)];
    _linedownView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_linedownView];
    
    _lineupView = [[UIView alloc]initWithFrame:CGRectMake(40, 0,1 , 15)];
    _lineupView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_lineupView];
    
   _lineView = [[UIView alloc]initWithFrame:CGRectMake(80,0, SYS_WIDTH-110, 1)];
    _lineView.backgroundColor = BACKGROUND_COLOR;
    [self.contentView addSubview:_lineView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
