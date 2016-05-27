//
//  TradeDetailViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"


typedef void (^returnTextBlock)(NSString *showText);
@interface TradeDetailViewController : BaseViewController

-(void) testHttpMsPost;

@property (nonatomic,copy)NSString *goods_id;

@property (nonatomic,strong) UIButton *buyBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,strong)UILabel *valueLabel;
@property (nonatomic,strong)NSString * specTitle;

@property (nonatomic,strong)returnTextBlock block;
- (void)returnText:(returnTextBlock)block;
-(void) testHttpMsPostBuy;

@end
