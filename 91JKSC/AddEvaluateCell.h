//
//  AddEvaluateCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;
@interface AddEvaluateCell : UITableViewCell

-(void)giveCellWithDict:(NSDictionary *)dict;

@property (nonatomic,strong)UIButton *evaluateBtn;
@property (nonatomic,strong)UIImageView *goodsImg;
@property (nonatomic,strong)UILabel *goodsName;
@end
