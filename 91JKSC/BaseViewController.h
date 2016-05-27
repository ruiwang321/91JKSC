//
//  BaseViewController.h
//  model
//
//  Created by 商城 阜新 on 16/1/4.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)createNavWithLeftImage:(NSString *)leftImageName andRightImage:(NSArray *)rightImageName andTitleView:(UIView *)titleView andTitle:(NSString *)title andSEL:(SEL)sel;
@property (nonatomic,retain)UITableView *tableView;

@property (nonatomic,retain)NSMutableArray *dataArr;


@end
