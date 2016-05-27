//
//  EvaluateTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateView.h"
#import "RatingBar.h"
@interface EvaluateTableViewCell : UITableViewCell<RatingBarDelegate>

@property (nonatomic,strong)UIImageView *imageV;

@property (nonatomic,strong)UILabel *userNameLabel;

@property (nonatomic,strong) EvaluateView *contentview;

@property (nonatomic,strong) NSMutableAttributedString *comment_message;

@property (nonatomic,strong) RatingBar *ratingBar1;
@property (nonatomic,assign)CGSize size;
@property (nonatomic,strong) UILabel *timeShowLabel;
@property (nonatomic,strong)NSString * commentStr;
@property (nonatomic,strong) UILabel * commentLabel;
@property (nonatomic,strong)EvaluateView *evalView;
-(void)createCellWithModel:(id)arr andIndex:(NSInteger)index;

@end
