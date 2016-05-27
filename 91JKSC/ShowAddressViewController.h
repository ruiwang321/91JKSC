//
//  ShowAddressViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderConfirmViewController.h"

@class AddressModel;
@interface ShowAddressViewController : BaseViewController

/**
 *  获取订单确认页面
 */
@property (nonatomic, strong) OrderConfirmViewController *orderVC;
/**
 *  对号选中的地址
 */
@property (nonatomic, strong) AddressModel *selMoedel;

@end
