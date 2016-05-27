//
//  EvaluateStarCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingBar.h"
@interface EvaluateStarCell : UITableViewCell<RatingBarDelegate>


@property (nonatomic,strong)UIButton * evaluateBtn;
@property (nonatomic,strong)NSNumber * orderScore;
@property (nonatomic,strong)NSNumber * serviceScore;
@property (nonatomic,strong)NSNumber * wuliuScore;
@property (nonatomic,strong)NSNumber *orderId;

@property (nonatomic,strong) RatingBar *ratingBar1;
@property (nonatomic,strong) RatingBar *ratingBar2;
@property (nonatomic,strong) RatingBar *ratingBar3;

-(void)giveCellWithDict:(NSDictionary *)dict;
@end
