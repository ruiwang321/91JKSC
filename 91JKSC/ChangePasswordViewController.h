//
//  ChangePasswordViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/4/6.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "LostPassWordViewController.h"
@interface ChangePasswordViewController : BaseViewController

/**
 *  安全问题
 */
@property (nonatomic, strong) NSString *securty;
/**
 *  临时key
 */
@property (nonatomic, strong) NSString *tempKey;
@end
