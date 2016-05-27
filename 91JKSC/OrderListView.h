//
//  OrderListView.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderModel;
@interface OrderListView : UIView  <UICollectionViewDataSource,UICollectionViewDelegate>



@property (nonatomic,strong)UILabel * typeLabel;
@property (nonatomic,strong)UILabel *lineLabel;
@property (nonatomic,strong)UIImageView *imageV ;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UILabel * moneyNumLabel;
@property (nonatomic,strong) UIButton *justBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)OrderModel *ordermodel;
@property (nonatomic,strong)NSString * orderid;
@property (nonatomic,strong)NSString *orderstate;
-(void)createView:(OrderModel *)model;

@end
