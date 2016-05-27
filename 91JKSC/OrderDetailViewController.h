//
//  OrderDetailViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/28.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderDetailViewController : BaseViewController

@property (nonatomic,strong)NSString *orders_id;
@property (nonatomic,strong)NSString *order_state;
@property (nonatomic,assign)BOOL isRefund;
@end
