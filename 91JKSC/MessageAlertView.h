//
//  MessageAlertView.h
//  91健康商城
//
//  Created by HerangTang on 16/4/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^touchCallBack)(void);
@interface MessageAlertView : UIView
+ (void)showMessageAlertWithMessage:(NSString *)message avatar:(NSString *)avatar name:(NSString *)name touchCallBack:(touchCallBack)touch;
@end
