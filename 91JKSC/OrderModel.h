//
//  OrderModel.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/17.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject


/*评价状态*/
@property (nonatomic ,copy)NSString *evaluation_state;
/*订单包含的商品*/
@property (nonatomic ,strong)NSArray *extend_order_goods;
/*订单总价*/
@property (nonatomic ,copy)NSString *order_amount;
/*订单id*/
@property (nonatomic ,copy)NSString *order_id;
/*订单编号*/
@property (nonatomic ,copy)NSString *order_sn;
/*订单状态*/
@property (nonatomic ,copy)NSString *order_state;
/*支付单号*/
@property (nonatomic ,copy)NSString *pay_sn;
/*支付方式*/
@property (nonatomic ,copy)NSString *payment_id;


@end
