//
//  HelpDetailTableViewCell.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpDetailModel.h"
@interface HelpDetailTableViewCell : UITableViewCell

@property (nonatomic ,strong)HelpDetailModel *helpDModel;
@property (nonatomic ,strong)UILabel * messageLabel;
@property (nonatomic ,strong)UIImageView *imageV;

@end
