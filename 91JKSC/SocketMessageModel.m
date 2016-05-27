//
//  SocketMessageModel.m
//  91健康商城
//
//  Created by HerangTang on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SocketMessageModel.h"

@implementation SocketMessageModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageSize = [message boundingRectWithSize:CGSizeMake(SYS_WIDTH-100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _messageSize = CGSizeMake(_messageSize.width+30, _messageSize.height+30);
    _cellHeight = MAX(90+10, _messageSize.height+50+10);
}

@end
