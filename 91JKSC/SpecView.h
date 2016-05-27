//
//  SpecView.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeDetailModel.h"




@protocol selectDelegate <NSObject>

-(BOOL)selectText:(NSString *)goodSpec andForRow:(NSString *)row;

@end


@interface SpecView : UIView<UITableViewDelegate,UITableViewDataSource>




@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,assign)NSIndexPath * selectedIndex;
@property (nonatomic,retain)id<selectDelegate>delegate;
@property (nonatomic,strong)UIButton *selectBtn;
@property (nonatomic,strong)UIButton *specBtn;
@property (nonatomic,strong)NSArray * selectArr;

@end
