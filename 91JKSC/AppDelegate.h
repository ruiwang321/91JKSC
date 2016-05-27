//
//  AppDelegate.h
//  91JKSC
//
//  Created by 商城 阜新 on 16/2/17.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMDrawerController;
@class LiftSlideViewController;
typedef void(^isTrueBlock)(BOOL right);
typedef void(^isDismissBlock)(BOOL right);
typedef void(^isQQDismissBlock) (BOOL right);
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *mainTabBar;
@property (nonatomic,strong)isTrueBlock block;
@property (nonatomic,strong)isDismissBlock isdismissBlock;
@property (nonatomic,strong)isQQDismissBlock isQQDismissBlock;
@property (strong,nonatomic) MMDrawerController * drawerController;
@property (nonatomic,strong) LiftSlideViewController *slideVC;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong)NSDictionary *messageDict;
@property (nonatomic,strong)NSString * WXCODE;
-(void)isTrue:(isTrueBlock)block;
-(void)isDismissBlock:(isDismissBlock)block;
-(void)isQQDismissBlock:(isQQDismissBlock)block;
@end

