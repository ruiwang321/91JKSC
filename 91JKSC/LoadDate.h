//
//  LoadDate.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/1.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadDate : NSObject
+(void) httpGet:(NSString *)urlpath param:(NSDictionary *)dict finish:(void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;
+(void) httpPost:(NSString *)urlpath param:(NSDictionary *)dict finish:(void (^)(NSData *data,NSDictionary *obj, NSError *error))cb;
+(BOOL) checkNetWork;
+(NSString *)getIPDress;
@end
