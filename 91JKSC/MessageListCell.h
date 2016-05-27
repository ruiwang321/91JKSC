//
//  MessageListCell.h
//  91健康商城
//
//  Created by 王睿 on 16/4/22.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SocketMessageModel;
@interface MessageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) SocketMessageModel *messageModel;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@end
