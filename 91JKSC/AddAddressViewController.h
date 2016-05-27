//
//  AddAddressViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderConfirmViewController.h"

@interface AddAddressViewController : BaseViewController
/**
 *   判断是否需要设置默认地址
 */
@property (nonatomic, assign, getter=isSetDefault) BOOL setDefault;

/**
 *  获取订单确认页面
 */
@property (nonatomic, strong) OrderConfirmViewController *orderVC;
@end
