//
//  OrderConfirmByIDViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressModel.h"

typedef void(^getOrderID)(NSDictionary *messageDict);

@interface OrderConfirmByIDViewController : BaseViewController
/**
 *  页面将显示的json数据
 */
@property (nonatomic, strong) NSMutableDictionary *jsonObj;
/**
 *   地址实例
 */
@property (nonatomic, strong) AddressModel *addressModel;
/**
 *  判断用户有无收货地址
 */
@property (nonatomic, assign, getter=isHaveAddress) BOOL haveAddress;


@property (nonatomic,copy)getOrderID orderIDblock;

@property (nonatomic,assign)BOOL isShow;

-(void)getOrderID:(getOrderID)block;

@end
