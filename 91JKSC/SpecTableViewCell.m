//
//  SpecTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SpecTableViewCell.h"

@implementation SpecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self createSubView];
        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}
-(void)createSubView{
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(SYS_WIDTH-SYS_SCALE(49), SYS_SCALE(20), SYS_SCALE(30), SYS_SCALE(30));
    [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    _selectBtn.selected = NO;
    [_selectBtn setImage:[UIImage imageNamed:@"select-green"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 69, SYS_WIDTH-30, 1)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [self.contentView addSubview:lineView];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
