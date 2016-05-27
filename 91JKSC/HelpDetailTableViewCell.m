//
//  HelpDetailTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "HelpDetailTableViewCell.h"

@implementation HelpDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubView];
    }
    return self;
}
-(void)setHelpDModel:(HelpDetailModel *)helpDModel{
    if ([helpDModel.type isEqualToString:@"text"]) {
        _messageLabel.frame = CGRectMake(10, 10, SYS_WIDTH-20, helpDModel.messageHight);
        _messageLabel.text = helpDModel.value;
    }else{
        _imageV.frame = CGRectMake(0, 0, SYS_WIDTH, helpDModel.messageHight);
        ImageWithUrl(_imageV, helpDModel.value);
    }
    _helpDModel = helpDModel;
}
-(void)createSubView{
    _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 0)];
    _messageLabel.font = SYS_FONT(16);
    _messageLabel.numberOfLines = 0;
    [self.contentView addSubview:_messageLabel];
    
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 0)];
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageV];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
