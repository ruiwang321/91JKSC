//
//  TradeDetailThirdTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecView.h"
@class TradeDetailModel;
@interface TradeDetailThirdTableViewCell : UITableViewCell


@property (nonatomic,copy)NSString *goods_id;

@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,strong)SpecView *specView;
@property (nonatomic,strong)UILabel *valueLabel;
-(void)createCellWithModel:(TradeDetailModel *)model andIndex:(NSInteger)index;
@end
