//
//  MessageListViewCell.m
//  91健康商城
//
//  Created by HerangTang on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MessageListViewCell.h"
#import "SocketMessageModel.h"

@interface MessageListViewCell ()

@property (nonatomic, strong) UIImageView *otherImage;
@property (nonatomic, strong) UIImageView *meImage;
@property (nonatomic, strong) UIButton *otherBtn;
@property (nonatomic, strong) UIButton *meBtn;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation MessageListViewCell

- (void)setMessageModel:(SocketMessageModel *)messageModel {
    _messageModel = messageModel;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:messageModel.add_time];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"今天 HH:mm"];
    }
    else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    _timeLabel.text = dateSMS;
    

    _timeLabel.hidden = (messageModel.add_time-_last_time < 600);
    
    
    if ([messageModel.member_id integerValue] == [[Function getUserId] integerValue])
    {
        [_meBtn setTitle:messageModel.message forState:UIControlStateNormal];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",ImageURL,messageModel.avatar];
        [_meImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default-profile"]];
        _meBtn.frame = CGRectMake(SYS_WIDTH-70-messageModel.messageSize.width, 20, messageModel.messageSize.width, messageModel.messageSize.height);
        [self setShowBtn:self.meBtn WithShowImage:self.meImage WithHideBtn:self.otherBtn WithHideImage:self.otherImage];
        
    } else {
        [_otherBtn setTitle:messageModel.message forState:UIControlStateNormal];
        _otherBtn.frame = CGRectMake(70, 20, messageModel.messageSize.width, messageModel.messageSize.height);
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",ImageURL,messageModel.avatar];
        [_otherImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default-profile"]];
        [self setShowBtn:self.otherBtn WithShowImage:self.otherImage WithHideBtn:self.meBtn WithHideImage:self.meImage];
        
    }
}

- (void)createSubViews {
    _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_otherBtn];
    
    _meBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _meBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_meBtn];
    
    _otherImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [self.contentView addSubview:_otherImage];
    
    _meImage = [[UIImageView alloc] initWithFrame:CGRectMake(SYS_WIDTH-60, 20, 50, 50)];
    [self.contentView addSubview:_meImage];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.contentView addSubview:_timeLabel];
    UIImage *bgImg = [UIImage imageNamed:@"chat-ground-white"];
    [_meBtn setBackgroundImage:[UIImage imageNamed:@"chat-ground-green"] forState:UIControlStateNormal];
    [_otherBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    [_otherBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _otherBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 10);
    _meBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 15);
    
    _meImage.layer.cornerRadius = 8;
    _otherImage.layer.cornerRadius = 8;
    _meImage.layer.masksToBounds = YES;
    _otherImage.layer.masksToBounds = YES;
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SYS_WIDTH, 10)];
    _timeLabel.text = @"时间";
    _timeLabel.font = [UIFont systemFontOfSize:9];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_timeLabel];
}

- (void)setShowBtn:(UIButton *)showBtn WithShowImage:(UIImageView *)showImage WithHideBtn:(UIButton *)hideBtn WithHideImage:(UIImageView *)hideImage
{
    [showBtn setTitle:self.messageModel.message forState:UIControlStateNormal];
    
    // 隐藏其他
    hideBtn.hidden = YES;
    hideImage.hidden = YES;
    // 显示自己
    showBtn.hidden = NO;
    showImage.hidden = NO;
    
}

- (void)awakeFromNib {
    [self createSubViews];
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    self.meBtn.titleLabel.numberOfLines=0;
    self.otherBtn.titleLabel.numberOfLines=0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
