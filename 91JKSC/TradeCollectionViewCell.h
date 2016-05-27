//
//  TradeCollectionViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TradeModel;
@interface TradeCollectionViewCell : UICollectionViewCell
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *valueLabel;
@property (nonatomic ,strong)UIImageView *imageV;
@property (nonatomic ,strong)UILabel *moneyLabel;
@property (nonatomic ,strong)UILabel *detailLabel;
@property (nonatomic,strong)NSMutableAttributedString * moneyStr;
-(void)createCellWithModel:(id)model andIndex:(int)index;

@end
