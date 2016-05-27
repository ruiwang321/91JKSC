//
//  ShippmentModel.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShippmentModel : NSObject
/*
 物流单号
 */
@property (nonatomic,copy)NSString * shipping_code;
/*
 时间
 */
@property (nonatomic,copy)NSString * shipping_time;
/*
 物流公司名称
 */
@property (nonatomic,copy)NSString * shipping_name;
/*
 物流状态
 */
@property (nonatomic,copy)NSString * shipping_status;
/*
 信息的高度
 */
@property (nonatomic,assign)NSInteger messageHight;
/*
 row的高度
 */
@property (nonatomic,assign)NSInteger rowHight;

@end
