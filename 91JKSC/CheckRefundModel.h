//
//  CheckRefundModel.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckRefundModel : NSObject


/*
 状态id
 */
@property (nonatomic,copy)NSString * ids;
/*
 状态名称
 */
@property (nonatomic,copy)NSString * name;
/*
 状态描述
 */
@property (nonatomic,copy)NSString * message;
/*
 是否通过
 */
@property (nonatomic,assign)BOOL ischeck;
/*
 时间
 */
@property (nonatomic,copy)NSString * time;

/*
 信息文字高
 */
@property (nonatomic,assign)NSInteger messageHight;
/*
 时间文字高
 */
@property (nonatomic,assign)NSInteger timeHight;

@end
