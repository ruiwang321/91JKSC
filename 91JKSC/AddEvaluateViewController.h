//
//  AddEvaluateViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderModel.h"
@interface AddEvaluateViewController : BaseViewController


@property (nonatomic,strong) NSDictionary *orderDict;

@property (nonatomic,strong)NSString *order_id;
@property (nonatomic,strong)NSArray *extend_order_goods;

@end
