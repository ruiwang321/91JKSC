//
//  TradeDetailTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TradeDetailModel;
@interface TradeDetailTableViewCell : UITableViewCell
@property (nonatomic,strong)NSString *isStr;
@property (nonatomic,strong)NSString *cancelStr;
@property (nonatomic,strong)NSDictionary *isDict;
@property (nonatomic,strong)NSDictionary *cancelDict;
@property (nonatomic,strong)NSDictionary *loginDic;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong)  UILabel *label;
@property (nonatomic,strong)UIButton * heartBtn;
@property (nonatomic,strong)NSDictionary * dataDict;
@property (nonatomic,strong)NSString *log_id;
@property (nonatomic,strong)NSString *goods_id;
@property (nonatomic,strong)TradeDetailModel *trademodel;
@property (nonatomic,strong)UIButton * shareBtn;

-(void)createViewWithModel:(TradeDetailModel *)model andIndex:(NSInteger)index;
-(void)testHttpMsPostIsFavourites:(TradeDetailModel *)model andView:(UIView *)view;
@end
