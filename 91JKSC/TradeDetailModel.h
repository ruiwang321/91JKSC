//
//  TradeDetailModel.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/7.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeDetailModel : NSObject


@property (nonatomic ,copy)NSString * goods_id;
@property (nonatomic ,copy)NSString *goods_image;
@property (nonatomic ,copy)NSString *goods_jingle;
@property (nonatomic ,copy)NSString *goods_name;
@property (nonatomic ,copy)NSString *goods_price;
@property (nonatomic ,strong)NSArray *goods_spec;
@property (nonatomic ,copy)NSString *goods_state;
@property (nonatomic ,copy)NSString *goods_storage;
@property (nonatomic ,copy)NSString *goods_verify;
@property (nonatomic ,strong)NSArray *mobile_body;
@property (nonatomic ,strong)NSArray *comment;
@property (nonatomic ,copy)NSString *comment_num;


@end
