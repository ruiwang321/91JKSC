//
//  MeTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
@interface MeTableViewCell : UITableViewCell<UIAlertViewDelegate>

@property (nonatomic,strong)UILabel * typeLabel;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic,strong)UIImageView *imageV ;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * moneyNumLabel;
@property (nonatomic,strong) UIButton *justBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) OrderModel *ordermodel;
-(void)createCellWithModel:(OrderModel *)model andIndex:(NSInteger)index;
@end
