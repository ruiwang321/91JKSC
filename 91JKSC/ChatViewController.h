//
//  ChatViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/4/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"

@interface ChatViewController : BaseViewController
@property (nonatomic, copy) NSString *memberId;
- (instancetype)initWithTitle:(NSString *)title memberId:(NSString *)memberId;

@end
