//
//  LiftSlideViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"
#import "SHCZMainView.h"

typedef void(^getUserMessage)(NSDictionary *messageDict);


@interface LiftSlideViewController : BaseViewController

@property (nonatomic,strong)SHCZMainView *mainview;
@property (nonatomic,strong)NSDictionary *dataDict;

@property (nonatomic,copy)getUserMessage messageblock;

-(void) testHttpMyMessage;
-(void)getUserMessage:(getUserMessage)block;

@end
