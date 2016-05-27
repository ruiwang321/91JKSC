//
//  ShippmentOneTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippmentModel.h"
@interface ShippmentOneTableViewCell : UITableViewCell


@property (nonatomic,strong)ShippmentModel *shippModel;

@property (nonatomic,strong)UILabel *stateL;
@property (nonatomic,strong)UILabel *busissL;
@property (nonatomic,strong)UILabel *numL;
@end
