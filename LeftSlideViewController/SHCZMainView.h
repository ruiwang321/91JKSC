//
//  SHCZMainView.h
//  test1
//
//  Created by Devil on 16/1/5.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "SHCZSideTableView.h"

@interface SHCZMainView : UIView

@property (nonatomic,strong) UIButton *userNameBtn;


@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)NSString *imageName;

@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)SHCZSideTableView *sideTableView;
@end
