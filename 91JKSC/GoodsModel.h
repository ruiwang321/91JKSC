//
//  GoodsModel.h
//  91健康商城
//
//  Created by HerangTang on 16/3/3.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

/**
 *  购物车id
 */
@property (nonatomic, copy) NSString *cart_id;
/**
 *  加入购物车数量
 */
@property (nonatomic, copy) NSString *goods_num;
/**
 *  商品名称
 */
@property (nonatomic, copy) NSString *goods_name;
/**
 *  商品广告词
 */
@property (nonatomic, copy) NSString *goods_jingle;
/**
 *  商品全部规格
 */
@property (nonatomic, strong) NSArray *goods_spec;
/**
 *  商品选中规格
 */
@property (nonatomic, copy) NSString *select_spec;
/**
 *  商品价格
 */
@property (nonatomic, copy) NSString *goods_price;
/**
 *  商品库存
 */
@property (nonatomic, copy) NSString *goods_storage;
/**
 *  商品状态 0下架，1正常，10违规（禁售）
 */
@property (nonatomic, copy) NSString *goods_state;
/**
 *  商品审核 1通过，0未通过，10审核中
 */
@property (nonatomic, copy) NSString *goods_verify;

/**
 *  商品id
 */
@property (nonatomic, copy) NSString *goods_id;
/**
  * 商品图片
  */
@property (nonatomic ,copy)NSString *goods_image;
/**
 *  是否被选中
 */
@property (nonatomic, assign) BOOL isSel;
@end
