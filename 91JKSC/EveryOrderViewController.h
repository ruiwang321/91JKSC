//
//  EveryOrderViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/13.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "GoodsModel.h"
#import "EvaluateModel.h"
@interface EveryOrderViewController : BaseViewController


@property (nonatomic,strong)NSString * orderID;
@property (nonatomic,strong)GoodsModel *goodsmodel;
@property (nonatomic,strong)EvaluateModel *evaluateModel;
@property (nonatomic,assign)BOOL isTrue;
@end
