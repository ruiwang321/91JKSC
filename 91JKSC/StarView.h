//
//  StarView.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView



@property (nonatomic,strong)UIView * view;
@property (nonatomic,assign)NSInteger numberOfStar;

-(void)createStarView;
@end
