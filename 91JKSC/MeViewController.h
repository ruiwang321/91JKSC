//
//  MeViewController.h
//  91jksc
//
//  Created by 商城 阜新 on 16/1/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderListView.h"
@interface MeViewController : BaseViewController
/*用户名Label*/
@property (nonatomic,strong)UILabel *userNameLabel;
/*用户名*/
@property (nonatomic,strong)NSString *userName;
/*用户头像名*/
@property (nonatomic,strong)NSString *imageName;


@property (nonatomic,strong)NSString *nickName;
/*左右滑动的scrollView*/
@property (nonatomic,strong) UIScrollView *scrollView;

-(void)loadDataMyOrder:(NSString *)orderPage andIndex:(NSInteger)indexP andNum:(NSInteger)number;
@end
