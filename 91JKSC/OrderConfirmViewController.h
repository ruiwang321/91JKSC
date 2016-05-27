//
//  OrderConfirmViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/2/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

@interface OrderConfirmViewController : BaseViewController
/**
 *  页面将显示的json数据
 */
@property (nonatomic, strong) NSDictionary *jsonObj;
/**
 *   地址实例
 */
@property (nonatomic, strong) AddressModel *addressModel;
/**
 *  判断用户有无收货地址
 */
@property (nonatomic, assign, getter=isHaveAddress) BOOL haveAddress;

@end
