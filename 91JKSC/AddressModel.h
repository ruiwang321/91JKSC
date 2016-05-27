//
//  AddressModel.h
//  91健康商城
//
//  Created by HerangTang on 16/3/7.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject
/**
 *  地址
 */
@property (nonatomic, copy) NSString *address;
/**
 *  地址id
 */
@property (nonatomic, copy) NSString *address_id;
/**
 *  地区内容
 */
@property (nonatomic, copy) NSString *area_info;
/**
 *  手机号码
 */
@property (nonatomic, copy) NSString *mob_phone;
/**
 *  收货人姓名
 */
@property (nonatomic, copy) NSString *true_name;
/**
 *  是否为默认地址
 */
@property (nonatomic, copy) NSString *is_default;

@end
