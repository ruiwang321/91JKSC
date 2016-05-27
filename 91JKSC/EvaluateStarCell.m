//
//  EvaluateStarCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EvaluateStarCell.h"
#import "RatingBar.h"
#import "UIView+ViewController.h"
@implementation EvaluateStarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

// 重写cellframe的setter
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 0;
    frame.origin.x += 10;
    frame.size.width -= 20;
    frame.size.height -= 0;
    [super setFrame:frame];
}
-(void)giveCellWithDict:(NSDictionary *)dict{
    if ([dict[@"evaluate_store_info"] count]>0) {
       
        _ratingBar3.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
        _ratingBar1.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
        _ratingBar2.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
        
        
         _evaluateBtn.hidden =YES;
        [_ratingBar1 displayRating:[dict[@"evaluate_store_info"][@"seval_desccredit"] longLongValue] andView:self];
        [_ratingBar2 displayRating:[dict[@"evaluate_store_info"][@"seval_servicecredit"] longLongValue] andView:self];
        [_ratingBar3 displayRating:[dict[@"evaluate_store_info"][@"seval_deliverycredit"] longLongValue] andView:self];
    }
    
}
-(void)createView{
    UILabel * orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 90, 50)];
    orderLabel.text = @"商品描述";
    orderLabel.font = SYS_FONT(16);
    [self.contentView addSubview:orderLabel];
    
    UILabel * serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 60, 90, 50)];
    serviceLabel.text = @"服务态度";
    serviceLabel.font = SYS_FONT(16);
    [self.contentView addSubview:serviceLabel];
    
    UILabel * wuliuLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 120, 90, 50)];
    wuliuLabel.text = @"物流速度";
    wuliuLabel.font = SYS_FONT(16);
    [self.contentView addSubview:wuliuLabel];
    
   _ratingBar1 = [[RatingBar alloc] init];
    _ratingBar1.frame = CGRectMake(SYS_WIDTH-150-20, 15, 175, 25);
    _ratingBar1.tag = 10;
    [self.contentView addSubview:_ratingBar1];
   
    [_ratingBar1 setImageDeselected:@"star-defalt" halfSelected:nil fullSelected:@"star" andDelegate:self];
    
    
    
    _ratingBar2 = [[RatingBar alloc] init];
    _ratingBar2.frame = CGRectMake(SYS_WIDTH-150-20, 70, 175, 25);
    _ratingBar2.tag = 20;
    [self.contentView addSubview:_ratingBar2];
   
    [_ratingBar2 setImageDeselected:@"star-defalt" halfSelected:nil fullSelected:@"star" andDelegate:self];
    
    
    
    _ratingBar3 = [[RatingBar alloc] init];
    _ratingBar3.frame = CGRectMake(SYS_WIDTH-150-20, 130, 0, 0);
    _ratingBar3.tag = 30;
    [self.contentView addSubview:_ratingBar3];
    [_ratingBar3 setImageDeselected:@"star-defalt" halfSelected:nil fullSelected:@"star" andDelegate:self];
    
    _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _evaluateBtn.frame = CGRectMake(SYS_WIDTH - 110, 180, 80, 30);
    _evaluateBtn.layer.cornerRadius = 3;
    _evaluateBtn.layer.borderWidth = 1;
    _evaluateBtn.layer.borderColor = [BackGreenColor CGColor];
    _evaluateBtn.titleLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    [_evaluateBtn setTitle:@"发表评价" forState:UIControlStateNormal];
    [_evaluateBtn setTitleColor:BackGreenColor forState:UIControlStateNormal];
    [_evaluateBtn addTarget:self action:@selector(sendTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_evaluateBtn];
    
    
}
-(void)ratingChanged:(float)newRating andView:(UIView *)baseView{
    if (baseView.tag == 10) {
        self.orderScore = [NSNumber numberWithFloat:newRating];
    }else if (baseView.tag == 20){
        self.serviceScore = [NSNumber numberWithFloat:newRating];
    }else{
        self.wuliuScore = [NSNumber numberWithFloat:newRating];
    }
   
}
-(void)sendTest:(UIButton *)btn{
    NSString *urlPath = [NSString stringWithFormat:@"%@addStore.html",API_EVALUATE];
    if (self.orderScore&&self.serviceScore && self.wuliuScore &&[Function isLogin]) {
        NSDictionary * paramsDic = @{
                                     @"key":[Function getKey],
                                     @"order_id":self.orderId,
                                     @"seval_desccredit":self.orderScore,
                                     @"seval_servicecredit":self.serviceScore,
                                     @"seval_deliverycredit":self.wuliuScore};

        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.

                if ([obj[@"code"] longLongValue] == 200) {
                    [MBProgressHUD showSuccess:@"评价成功"];
                    [self.viewController.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [MBProgressHUD showError:@"亲 网络不给力"];
            }
            
        }];
        
    }else{
        [MBProgressHUD show:@"请进行服务评价" icon:nil view:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
