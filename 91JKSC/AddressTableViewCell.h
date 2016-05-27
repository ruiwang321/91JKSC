//
//  AddressTableViewCell.h
//  91健康商城
//
//  Created by HerangTang on 16/4/5.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
/**
 *  默认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
/**
 *  名字
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/**
 *  手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/**
 *  地址
 */
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;
@end
