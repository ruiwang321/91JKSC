//
//  MeCollectionViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageV;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *moneyLabel;



-(void)createCell;
@end
