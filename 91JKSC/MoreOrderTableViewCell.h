//
//  MoreOrderTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListView.h"
#import "OrderModel.h"
@interface MoreOrderTableViewCell : UITableViewCell

@property (nonatomic,strong)OrderListView *orderview;


-(void)createViewWithBaseView:(OrderModel*)model;
@end
