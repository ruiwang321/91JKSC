//
//  RefundViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "SpecView.h"
@interface RefundViewController : BaseViewController

@property (nonatomic,strong)UITableView *refundTableView;
@property (nonatomic,strong)NSDictionary *isRefundDict;
@property (nonatomic,strong)UILabel *textL;
@property (nonatomic,strong)UITextField *sumTextField;
@property (nonatomic,strong)UITextView *detailTextView;
@property (nonatomic,strong)UIButton * goodsBtn;
@property (nonatomic,strong)UIButton *moneyBtn;
@property (nonatomic,strong)UIView *showReasonView;
@property (nonatomic,strong)SpecView *reasonView;
@property (nonatomic,strong)NSString *reasonStr;
@property (nonatomic,strong)NSString * reasonID;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
@property (nonatomic,strong)NSMutableArray *photoNameArr;
@property (nonatomic,strong)UITextField *textF;

@property (nonatomic,strong)NSString *orderID;
@property (nonatomic,strong)NSString * goods_id;
@end
