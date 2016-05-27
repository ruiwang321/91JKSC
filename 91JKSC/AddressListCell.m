//
//  AddressListCell.m
//  91健康商城
//
//  Created by HerangTang on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AddressListCell.h"

@implementation AddressListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)createSubViews {
    
    UILabel *bianji = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 80, 78, 80, 16)];
    bianji.textColor = RGB(75, 75, 75);
    bianji.textAlignment = NSTextAlignmentCenter;
    bianji.text = @"编辑";
    [self.contentView addSubview:bianji];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SYS_WIDTH - 80, 27, 0.5, 68)];
    lineView.backgroundColor = RGB(233, 233, 233);
    [self.contentView addSubview:lineView];
    
    // 选中图片
    _selImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 50, 22, 22)];
    [self.contentView addSubview:_selImgView];
    
    // 姓名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 22, 85, 17)];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_nameLabel];
    
    // 手机
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 95 - 150 , 22, 150, 17)];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    _phoneLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:_phoneLabel];
    
    // 地址
    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(37, 57, SYS_WIDTH - 132, 40)];
    _areaLabel.textColor = RGB(206, 206, 206);
    _areaLabel.font = [UIFont systemFontOfSize:15];
//    _areaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:_areaLabel];
   
    // 编辑按钮
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    _editBtn.frame = CGRectMake(SYS_WIDTH - 80, 38, 55, 60);
    _editBtn.center = CGPointMake(SYS_WIDTH-80/2, 60);
    [self.contentView addSubview:_editBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
