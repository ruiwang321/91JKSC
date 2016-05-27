//
//  SocketManager.m
//  91健康商城
//
//  Created by HerangTang on 16/4/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SocketManager.h"
#import "AppDelegate.h"
#import "MessageAlertView.h"
#import "ChatViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SHCZMainView.h"
#import "CartBadgeSingleton.h"
#import "LoginViewController.h"
#import "LiftSlideViewController.h"

@implementation SocketManager 

#pragma mark - private

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static SocketManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       share = [super allocWithZone:zone];
        NSURL* url = [[NSURL alloc] initWithString:@"http://api.91jksc.com:3001"];
        
        share.socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES}];
        
        [share addHandlers];
    
        [share.socket connect];
        share.unreadMessages = [NSMutableArray arrayWithCapacity:0];
    });
    return share;
}

- (void)addHandlers {
    [_socket on:@"connect" callback:^(NSArray * data, SocketAckEmitter * ack) {
        if ([Function isLogin]) {
            [self login];
        }else {
            [_socket disconnect];
        }
        if ([self.delegate respondsToSelector:@selector(socketDidOpen:withData:)]) {
            [self.delegate socketDidOpen:_socket withData:data];
        }
    }];
    
    [_socket on:@"private message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        if ([[data lastObject][@"member_id"] integerValue] == [[Function getUserId] integerValue]) {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[Function getUserId]]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[tempDic objectForKey:[data lastObject][@"obj_id"]]];
            [dic setObject:[data lastObject][@"message"] forKey:@"message"];
            [dic setObject:[data lastObject][@"add_time"] forKey:@"add_time"];
            [tempDic setObject:dic forKey:[data lastObject][@"obj_id"]];
            [[NSUserDefaults standardUserDefaults] setValue:tempDic forKey:[Function getUserId]];
        
        }else {
            NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[Function getUserId]]];
            [tempDic setValue:[data lastObject]
                       forKey:[data lastObject][@"member_id"]];
            [[NSUserDefaults standardUserDefaults] setValue:tempDic forKey:[Function getUserId]];
            
            if (_delegate == nil) {
                // 来消息弹出提示 并添加到未读消息数组
                if (![_unreadMessages containsObject:[data lastObject][@"member_id"]]) {
                    [[self mutableArrayValueForKey:@"unreadMessages"] addObject:[data lastObject][@"member_id"]];
                }
                [self setSoundAndShock];
                UITabBarController *mainTabBar = [(AppDelegate *)[UIApplication sharedApplication].delegate mainTabBar];
                [MessageAlertView showMessageAlertWithMessage:[data lastObject][@"message"] avatar:[data lastObject][@"avatar"] name:[data lastObject][@"member_nickname"] touchCallBack:^{
                    
                    ChatViewController *chatVC = [[ChatViewController alloc] initWithTitle:[data lastObject][@"member_nickname"] memberId:[data lastObject][@"member_id"]];
                    [[mainTabBar.selectedViewController selectedViewController]pushViewController:chatVC animated:YES];
                    [[[SocketManager shareManager] mutableArrayValueForKey:@"unreadMessages"] removeObject:[data lastObject][@"member_id"]];
                }];
            }else {
                if (![[(ChatViewController *)_delegate memberId] isEqualToString:[data lastObject][@"member_id"]]) {
                    // 来消息弹出提示 并添加到未读消息数组
                    if (![_unreadMessages containsObject:[data lastObject][@"member_id"]]) {
                        [[self mutableArrayValueForKey:@"unreadMessages"] addObject:[data lastObject][@"member_id"]];
                    }
                    
                    [self setSoundAndShock];
                    [MessageAlertView showMessageAlertWithMessage:[data lastObject][@"message"] avatar:[data lastObject][@"avatar"] name:[data lastObject][@"member_nickname"] touchCallBack:^{
                        UITabBarController *mainTabBar = [(AppDelegate *)[UIApplication sharedApplication].delegate mainTabBar];
                        ChatViewController *chatVC = [[ChatViewController alloc] initWithTitle:[data lastObject][@"member_nickname"] memberId:[data lastObject][@"member_id"]];
                        [[mainTabBar.selectedViewController selectedViewController]pushViewController:chatVC animated:YES];
                        [[[SocketManager shareManager] mutableArrayValueForKey:@"unreadMessages"] removeObject:[data lastObject][@"member_id"]];
                    }];
                }
            }

        }
        
        
        [self.delegate socket:_socket didReceiveMessage:data];
    }];
    

    
    [_socket on:@"close" callback:^(NSArray * data, SocketAckEmitter * ack) {
        if ([self.delegate respondsToSelector:@selector(socketDidClose:withData:)]) {
            [self.delegate socketDidClose:_socket withData:data];
        }
        
        // 退出登录
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"login_key"];
        [userDefaults removeObjectForKey:@"username"];
        [userDefaults removeObjectForKey:@"userid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[CartBadgeSingleton sharedManager] getCartBadgeNumBynet];
        // 置空首页头像信息 并返回首页 并清空未读消息数组
        [[[SocketManager shareManager] mutableArrayValueForKey:@"unreadMessages"] removeAllObjects];
        SHCZMainView *mainV = [(LiftSlideViewController *)[(MMDrawerController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController] leftDrawerViewController] mainview];
        [mainV.userNameBtn setTitle:@"请登录" forState:UIControlStateNormal];
        mainV.headImage.image = nil;
        UITabBarController *mainTab = (UITabBarController *)[(MMDrawerController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController] centerViewController];
        
        UITabBarController *secTab = mainTab.selectedViewController;
        UINavigationController *navVC = secTab.selectedViewController;
        [navVC popToRootViewControllerAnimated:YES];
        
        [mainTab setSelectedIndex:0];
        [(UITabBarController *)mainTab.selectedViewController setSelectedIndex:0];
        
        [_socket disconnect];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[data lastObject][@"msg"] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新登录", nil];
        [alertView show];
    }];
    
    [_socket on:@"list" callback:^(NSArray * data, SocketAckEmitter * ack) {
        if ([[data lastObject][@"code"] isEqualToNumber:@200]) {
            NSMutableDictionary *tempChatMember = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:[Function getUserId]]];
            NSArray *dicArr = [data lastObject][@"data"][@"list"];
            for (NSDictionary *dic in dicArr) {
                if (![_unreadMessages containsObject:dic[@"member_id"]]) {
                    [[self mutableArrayValueForKey:@"unreadMessages"] addObject:dic[@"member_id"]];
                }
                [tempChatMember setValue:dic forKey: dic[@"member_id"]];
            }
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:tempChatMember forKey: [Function getUserId]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }];
}
// 声音震动提示
- (void)setSoundAndShock {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
    }
}

#pragma mark - public

+ (instancetype)shareManager {
    return  [[self alloc] init];
}

- (void)sendMessage:(NSString *)message toUser:(NSString *)userId {

    NSDictionary *params = @{
                             @"member_id"       :userId,
                             @"message"         :message
                             };
    [_socket emit:@"private message" withItems:@[params]];
}

- (void)login {
    NSDictionary *dic = @{
                          @"key"            :[Function getKey],
                          @"client"         :@"ios",
                          @"ip2long"        :[LoadDate getIPDress],
                          @"deviceName"     :DEVICE,
                          @"macAddress"     :@"002324A10097"
                          };
    [_socket emit:@"login" withItems:@[dic]];
}

@end
