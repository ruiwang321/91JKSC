//
//  CartBadgeSingleton.h
//  91健康商城
//
//  Created by HerangTang on 16/3/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartBadgeSingleton : NSObject 
@property (nonatomic, strong) UILabel *badge;
@property (nonatomic ,strong) UIView *bgView;


@property (nonatomic, strong) NSMutableArray *cartArr;
@property (nonatomic ,assign) NSInteger num;


+ (instancetype)sharedManager;

- (void)getCartBadgeNumBynet;

@end
