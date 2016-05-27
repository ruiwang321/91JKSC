//
//  LoadDate.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/1.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "LoadDate.h"
#import "LoginViewController.h"
#import "SHCZMainView.h"
#import "LiftSlideViewController.h"
#import <MMDrawerController/MMDrawerController.h>
#import "UIView+ViewController.h"
static BOOL isFirst = NO;
static BOOL canCHeckNetwork = NO;

@implementation LoadDate

#pragma mark ----- 获取IP地址
+(NSString *)getIPDress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
//    NSData *data = [NSData dataWithBytes:(__bridge const void * _Nullable)(address) length:20];
    address = @"2130706433";
    return address;
    
}
//调用
+(void) httpGet:(NSString *)urlpath param:(NSDictionary *)dict finish:(void (^)(NSData *data,NSDictionary *obj, NSError *error))cb{
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    
    [self checkNetWork];
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        cb(nil, nil,error);
        return;
    }
    
    //2..实现解析
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //成功 cb是对方传递过来的对象 这里是直接调用
        
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        cb(responseObject, obj,nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        cb(nil, nil ,error);
    }];
    
};





+(void) httpPost:(NSString *)urlpath param:(NSDictionary *)dict finish:(void (^)(NSData *data,NSDictionary *obj, NSError *error))cb{
    
    // 状态栏转圈
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    
    [self checkNetWork];
    //只能在监听完善之后才可以调用
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //BOOL isWifiOK = [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
    //BOOL is3GOK = [[AFNetworkReachabilityManager sharedManager]isReachableViaWWAN];
    //网络有问题
    if(isOK == NO && canCHeckNetwork == YES){
        NSError *error = [NSError errorWithDomain:@"网络错误" code:400 userInfo:nil];
        cb(nil, nil,error);
        return;
    }
    
    //2..实现解析
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlpath parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        if ([dic[@"code"] longLongValue] == 201) {
            
            // key失效  移除本地失效key
            [Function removeKey];
            
            
            
        }else if ([dic[@"code"]longLongValue] == 200) {
            // 数据正常
            cb(responseObject, dic,nil);
        }else {
            cb(responseObject, dic,nil);
        }
        
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        cb(nil, nil ,error);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}





+(BOOL) checkNetWork{
    
    if (isFirst == NO) {
        //网络只有在startMonitoring完成后才可以使用检查网络状态
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            canCHeckNetwork = YES;
        }];
        isFirst = YES;
    }
    
    return canCHeckNetwork;
    
}



@end
