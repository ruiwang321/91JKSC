//
//  SocketManager.h
//  91健康商城
//
//  Created by HerangTang on 16/4/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_1JKSC-swift.h"
#import "SocketMessageModel.h"

@protocol SocketManagerDelegate <NSObject>

- (void)socket:(SocketIOClient *)socket didReceiveMessage:(id)message;

@optional

- (void)socketDidOpen:(SocketIOClient *)socket withData:(id)data;
- (void)socketDidClose:(SocketIOClient *)socket withData:(id)data;

@end

@interface SocketManager : NSObject <UIAlertViewDelegate>

@property (nonatomic, weak) id<SocketManagerDelegate> delegate;
@property (nonatomic, strong) SocketIOClient *socket;
/**
 *  存放未读消息的联系人
 */
@property (nonatomic, strong) NSMutableArray *unreadMessages;

+ (instancetype)shareManager;

- (void)sendMessage:(NSString *)message toUser:(NSString *)userId;

@end
