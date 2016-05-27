//
//  ShareSheetView.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeDetailModel.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>

typedef void(^superDissmiss)(void);

@interface ShareSheetView : UIView<TencentSessionDelegate>


@property (nonatomic,strong)TradeDetailModel *detailmodel;
@property (nonatomic,strong)NSString *imageUrlStr;
@property (nonatomic,strong)NSString *jingleStr;
@property (nonatomic,strong)superDissmiss block;


-(void)dissmissForSuper:(superDissmiss)block;
@end
