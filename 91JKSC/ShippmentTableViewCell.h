//
//  ShippmentTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShippmentModel.h"
@interface ShippmentTableViewCell : UITableViewCell


@property (nonatomic,strong)ShippmentModel *shippModel;
@property (nonatomic,assign)BOOL isFistRow;

@property (nonatomic,strong)UILabel *stateLabel ;
@property (nonatomic,strong)UILabel *lightLabel ;
@property (nonatomic,strong)UILabel *timeLabel ;
@property (nonatomic,strong)UIView *linedownView ;
@property (nonatomic,strong)UIView *lineupView ;
@property (nonatomic,strong)UIView *lineView ;

@end
