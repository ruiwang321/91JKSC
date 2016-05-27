//
//  MessageListViewCell.h
//  91健康商城
//
//  Created by HerangTang on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocketMessageModel;
@interface MessageListViewCell : UITableViewCell

@property (nonatomic, strong) SocketMessageModel *messageModel;
@property (nonatomic, assign) NSInteger last_time;
@end
