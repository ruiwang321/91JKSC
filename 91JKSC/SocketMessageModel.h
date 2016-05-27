//
//  SocketMessageModel.h
//  91健康商城
//
//  Created by HerangTang on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketMessageModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, assign) long add_time;
@property (nonatomic, assign) int spend;

@property (nonatomic, assign) BOOL isHideTime;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGSize messageSize;
@end
