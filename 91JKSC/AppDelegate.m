//
//  AppDelegate.m
//  91JKSC
//
//  Created by 商城 阜新 on 16/2/17.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LeftSortsViewController.h"
#import "MyTabBar.h"
#import "ShoppingCartViewController.h"
#import "VIPServicesViewController.h"
#import "MessageViewController.h"
#import "LiftSlideViewController.h"
#import <MMDrawerController/MMDrawerController.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MMDrawerController/MMDrawerVisualState.h>
#import "AccountDetailViewController.h"
#import "ShareViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SearchViewController.h"
#import "AccountDetailViewController.h"
#import "QRCodeReaderViewController.h"
#import "OrderDetailViewController.h"
#import "UIView+ViewController.h"
#import "Function.h"
#import "LoginViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import "MyFavoriteViewController.h"
#import "SocketManager.h"
#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
@interface AppDelegate ()<WXApiDelegate,UIApplicationDelegate,WeiboSDKDelegate,TencentApiInterfaceDelegate,TencentSessionDelegate,QQApiInterfaceDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
    
        UIApplicationShortcutItem * item1 = [[UIApplicationShortcutItem alloc]initWithType:@"search" localizedTitle:@"搜索" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"search"] userInfo:nil];
        UIApplicationShortcutItem * item2 = [[UIApplicationShortcutItem alloc]initWithType:@"saoyisao" localizedTitle:@"扫一扫" localizedSubtitle:@"" icon:[UIApplicationShortcutIcon iconWithTemplateImageName:@"dimensional"] userInfo:nil];
        [UIApplication sharedApplication].shortcutItems = @[item1, item2];

    }
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    MainViewController *mainVC = [[MainViewController alloc]init];
    VIPServicesViewController *vipVC = [[VIPServicesViewController alloc] init];
    ShoppingCartViewController *shopVC = [[ShoppingCartViewController alloc] init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    MyFavoriteViewController *favouritVC = [[MyFavoriteViewController alloc] init];
    AccountDetailViewController *accountVC = [[AccountDetailViewController alloc]init];

    
    UINavigationController *mainNVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *vipNVC = [[UINavigationController alloc] initWithRootViewController:vipVC];
    UINavigationController *shopNVC = [[UINavigationController alloc] initWithRootViewController:shopVC];
    UINavigationController *messageNVC = [[UINavigationController alloc] initWithRootViewController:messageVC];
    UINavigationController *favouritNVC = [[UINavigationController alloc] initWithRootViewController:favouritVC];
    UINavigationController *accountNVC = [[UINavigationController alloc] initWithRootViewController:accountVC];

    _mainTabBar = [[UITabBarController alloc] init];
    UITabBarController *tabbar1 = [[UITabBarController alloc] init];
    UITabBarController *tabbar2 = [[UITabBarController alloc] init];
//    _mainTabBar.viewControllers = @[mainNVC, vipNVC, shopNVC, messageNVC, favouritNVC, accountNVC];
    _mainTabBar.viewControllers = @[tabbar1, tabbar2];
    
    tabbar1.viewControllers = @[mainNVC, shopNVC];
    tabbar2.viewControllers = @[messageNVC, favouritNVC, accountNVC];
    
    tabbar1.tabBar.hidden = YES;
    tabbar2.tabBar.hidden = YES;
    
    _mainTabBar.tabBar.hidden = YES;
    _slideVC = [[LiftSlideViewController alloc] init];
    __weak typeof(self) weakself = self;
    [_slideVC getUserMessage:^(NSDictionary *messageDict) {
        
        weakself.dict = messageDict;
    
    }];
    _drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:_mainTabBar
                                             leftDrawerViewController:_slideVC
                                             rightDrawerViewController:nil];
    // 设置抽屉宽度
    _drawerController.maximumLeftDrawerWidth = SYS_WIDTH -50;
    // 设置抽屉开关手势
    [_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeCustom];
    [_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    // 取消弹性
    _drawerController.shouldStretchDrawer = NO;
    // 自定义滑动动画
    [_drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:3];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    // 自定义侧滑手势
    [_drawerController setGestureShouldRecognizeTouchBlock:^BOOL(MMDrawerController *drawerController, UIGestureRecognizer *gesture, UITouch *touch) {
        
        BOOL shouldRecognizeTouch = NO;
        
        if(drawerController.openSide == MMDrawerSideNone &&
           
           [gesture isKindOfClass:[UIPanGestureRecognizer class]]){
            
            UITabBarController *tabVC = (UITabBarController *)drawerController.centerViewController;
            
            if([[(UINavigationController *)[[tabVC selectedViewController] selectedViewController] topViewController] isKindOfClass:[MainViewController class]] ||
               [[(UINavigationController *)[[tabVC selectedViewController] selectedViewController] topViewController] isKindOfClass:[ShoppingCartViewController class]] ||
               [[(UINavigationController *)[[tabVC selectedViewController] selectedViewController] topViewController] isKindOfClass:[VIPServicesViewController class]] ||
               [[(UINavigationController *)[[tabVC selectedViewController] selectedViewController] topViewController] isKindOfClass:[MessageViewController class]] ||
               [[(UINavigationController *)[[tabVC selectedViewController] selectedViewController] topViewController] isKindOfClass:[MyFavoriteViewController class]] ||
               [[(UINavigationController *)[[tabVC selectedViewController] selectedViewController] topViewController] isKindOfClass:[AccountDetailViewController class]]){//判断哪个控制器可以滑到抽屉
                
                shouldRecognizeTouch = YES;//返回yes表示可以滑动到左右侧抽屉
                
            }else{
                
                shouldRecognizeTouch = NO;
                
            }
            
            /*UIView * customView = [nav.topViewController view];
             
             CGPoint location = [touch locationInView:customView];//返回触摸点在view的坐标
             
             shouldRecognizeTouch = (CGRectContainsPoint(customView.bounds, location));//意思就是当point的位置在rect里面就返回yes，否则返回no*/
            
        }
        
        return shouldRecognizeTouch;
        
    }];
    //向微信注册 APPID
    [WXApi registerApp:WeChatAPPID];
    
    //向新浪微博注册 APPKEY
    [WeiboSDK registerApp:WeiBoAPPKEY];
    
    self.window.rootViewController = _drawerController;
    
    if ([Function isLogin]) {
        [[SocketManager shareManager].socket connect];
    }
  TencentOAuth *tencent = [[TencentOAuth alloc] initWithAppId:@"1104986692" andDelegate:self];
//    tencent.sessionDelegate = self;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    
    
}
-(void)isTrue:(isTrueBlock)block{
    self.block = block;
}
-(void)isDismissBlock:(isDismissBlock)block{
    self.isdismissBlock = block;
}
-(void)isQQDismissBlock:(isQQDismissBlock)block{
    self.isQQDismissBlock = block;
}
-(void)onResp:(BaseResp*)resp{
 
    if ([resp isKindOfClass:NSClassFromString(@"PayResp")]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:

                self.block(YES);
                
                break;
            default:
                NSLog(@"支付失败，retcode=%@",resp.errStr);
                self.block(NO);
                [MBProgressHUD showError:[NSString stringWithFormat:@"支付失败"]];
                break;
        }
    }else if([resp isKindOfClass:NSClassFromString(@"SendMessageToWXResp")]){
        switch (resp.errCode) {
            case 0:
                 [MBProgressHUD showSuccess:@"微信分享成功"];
                break;
                
            default:
                
                 [MBProgressHUD showError:[NSString stringWithFormat:@"微信分享失败"]];
                break;
        }
    }else if ([resp isKindOfClass:NSClassFromString(@"SendAuthResp")]){
        if (resp.errCode == 0) {
            
             SendAuthResp *wxresq = (SendAuthResp *)resp;
            
            _WXCODE = wxresq.code;
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:@"wxloginresp" object:self userInfo:nil];
        }else if (resp.errCode == -2){
        
            [MBProgressHUD showSuccess:@"用户取消登陆"];
        
        }else{
            [MBProgressHUD showSuccess:@"微信登录失败"];
        }
    }else if([resp isKindOfClass:NSClassFromString(@"SendMessageToQQResp")]){

        switch ([[(QQBaseResp *)resp result] integerValue]) {
            case 0:
                [MBProgressHUD showSuccess:@"qq分享成功"];
                self.isQQDismissBlock(YES);
                break;
                
            default:
                [MBProgressHUD showError:@"qq分享失败"];
                self.isQQDismissBlock(NO);
                break;
        }
    }
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:NSClassFromString(@"WBSendMessageToWeiboResponse")]) {
        switch (response.statusCode) {
            case 0:
                [MBProgressHUD showSuccess:@"微博分享成功"];
            
                self.isdismissBlock(YES);
                break;
                
            default:
                [MBProgressHUD showError:@"微博分享失败"];
                self.isdismissBlock(NO);
                break;
        }
    }
    
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    
    [QQApiInterface handleOpenURL:url delegate:self];
    NSString *urlStr =[[url.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet] substringToIndex:2];

    if ([url.host isEqualToString:@"safepay"]) {
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        }];
    }else if([urlStr isEqualToString:@"wx"]){
        return [WXApi handleOpenURL:url delegate:self];
        
    }else if([urlStr isEqualToString:@"wb"]){
        return [WeiboSDK handleOpenURL:url delegate:self];
        
    }else if([urlStr isEqualToString:@"te"]) {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    
    return true;
}
-(BOOL)onTencentResp:(TencentApiResp *)resp{
    return YES;
}
-(BOOL)onTencentReq:(TencentApiReq *)req{
    return YES;
}
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return [TencentApiInterface handleOpenURL:url delegate:self]||[WXApi handleOpenURL:url delegate:self];
    
    
}

#pragma mark 3Dtouch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler{
    //判断先前我们设置的唯一标识
    if([shortcutItem.type isEqualToString:@"search"]){
        [(UINavigationController *)_mainTabBar.selectedViewController pushViewController:[[SearchViewController alloc] init] animated:NO];
    }else if ([shortcutItem.type isEqualToString:@"saoyisao"]) {
        [_mainTabBar presentViewController:[[QRCodeReaderViewController alloc] init] animated:YES completion:nil];
    }
    
}

@end
