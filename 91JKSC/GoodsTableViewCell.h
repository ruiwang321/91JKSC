//
//  GoodsTableViewCell.h
//  91健康商城
//
//  Created by HerangTang on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsModel;
@interface GoodsTableViewCell : UITableViewCell
/**
 *  单一商品选中按钮
 */
@property (nonatomic, strong) UIButton *goodsSelBtn;
/**
 *  商品名称
 */
@property (nonatomic, strong) UILabel *goodsName;
/**
 *  提示label
 */
@property (nonatomic, strong) UILabel *tipLabel;
/**
 *  商品图片
 */
@property (nonatomic, strong) UIButton *goodsImageView;
/**
 *  商品数量
 */
@property (nonatomic, strong) UILabel *goodsNumber;
/**
 *  商品选项
 */
@property (nonatomic, strong) UILabel *goodsOption;
/**
 *  移除按钮
 */
@property (nonatomic, strong) UIButton *removeBtn;
/**
 *  编辑按钮
 */
@property (nonatomic, strong) UIButton *editBtn;
/**
 *  商品价格
 */
@property (nonatomic, strong) UILabel *goodsPrice;
/**
 *  商品数据模型
 */
@property (nonatomic, strong) GoodsModel *model;

@end
