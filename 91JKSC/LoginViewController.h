//
//  LoginViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"


@protocol changeName <NSObject>

-(void)changeBtnName;

@end
@interface LoginViewController : BaseViewController

@property (nonatomic,weak)id<changeName>delegate;

@end
