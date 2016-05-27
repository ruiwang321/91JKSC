//
//  AccountDetailViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/2/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountDetailViewController : BaseViewController


@property (nonatomic,strong)UITextField *presentTextField;
@property (nonatomic,strong)UITextField *alterpassword;

@property (nonatomic,strong)UITextField *againTextField;
@property (nonatomic,strong) UIView * alterView;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)NSDictionary *dict;
@property (nonatomic,strong)UILabel *numlabel;
@property (nonatomic,assign)BOOL isChangePass;
@end
