//
//  Function.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/1.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Function : NSObject
+(BOOL)isLogin;

+(NSString *)getKey;

+(void)removeKey;

+(NSString *)getUserName;

+(NSString *)getUserId;
@end
