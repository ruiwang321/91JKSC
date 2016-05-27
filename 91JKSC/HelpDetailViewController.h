//
//  HelpDetailViewController.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/22.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"

@interface HelpDetailViewController : BaseViewController


@property (nonatomic,strong)NSString *help_id;
-(void)loadHelpList;
@end
