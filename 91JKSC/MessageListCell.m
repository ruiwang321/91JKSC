//
//  MessageListCell.m
//  91健康商城
//
//  Created by 王睿 on 16/4/22.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MessageListCell.h"
#import "SocketMessageModel.h"
#import "SocketManager.h"

@implementation MessageListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _avatarImgView.layer.cornerRadius = 10;
    [_avatarImgView.layer setMasksToBounds:YES];

    _tipView.layer.cornerRadius = 7.5;
    _tipView.backgroundColor = RGB(255, 147, 0);
}

- (void)setMessageModel:(SocketMessageModel *)messageModel {
    _messageModel = messageModel;
    _messageLabel.text = messageModel.message;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ImageURL,messageModel.avatar];
    [_avatarImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default-profile"]];
    _nikeLabel.text = messageModel.member_nickname;
    
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
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    _timeLabel.text = dateSMS;
    _tipView.hidden = ![[SocketManager shareManager].unreadMessages containsObject:messageModel.member_id];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
