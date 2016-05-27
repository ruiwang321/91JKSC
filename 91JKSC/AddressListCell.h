//
//  AddressListCell.h
//  91健康商城
//
//  Created by HerangTang on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressListCell : UITableViewCell
/**
 *  选中表示图片
 */
@property (nonatomic, strong) UIImageView *selImgView;
/**
 *  姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;
/**
 *  手机
 */
@property (nonatomic, strong) UILabel *phoneLabel;
/**
 *  地址信息
 */
@property (nonatomic, strong) UILabel *areaLabel;
/**
 *  编辑按钮
 */
@property (nonatomic, strong) UIButton *editBtn;

@end
