//
//  Function.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/1.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "Function.h"

@implementation Function




+(BOOL)isLogin{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"]) {
        return YES;
    }else{
        return NO;
    }
    
}
+(NSString *)getKey{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"];
    
}

+(NSString *)getUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
}

+ (void)removeKey {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login_key"];
}

+(NSString *)getUserName{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

+(BOOL)allow_camera{
    NSString *str = [NSString stringWithFormat:@"%@/Library/Caches/allowcamera.txt",NSHomeDirectory()];
    if ([[NSFileManager defaultManager]fileExistsAtPath:str ]) {
        return YES;
    }else{
        return NO;
    }
}


@end
