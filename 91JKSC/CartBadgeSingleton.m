//
//  CartBadgeSingleton.m
//  91健康商城
//
//  Created by HerangTang on 16/3/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "CartBadgeSingleton.h"
#import "AppDelegate.h"
#import "GoodsModel.h"

@implementation CartBadgeSingleton

+ (instancetype)sharedManager {
    
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static CartBadgeSingleton *singleton = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singleton = [super allocWithZone:zone];
    });
    
    return singleton;
}

- (NSMutableArray *)cartArr {
    if (!_cartArr) {
        _cartArr = [NSMutableArray array];
    }
    return _cartArr;
}


- (void)getCartBadgeNumBynet {
    if ([Function isLogin]) {
        NSString *path = [NSString stringWithFormat:@"%@%@",API_CART, @"lists.html"];
        NSString *login_key = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"];
        
        NSDictionary *params = @{
                                 @"key"     :login_key,
                                 @"page"    :@"1",
                                 @"num"     :@"5"
                                 };
        [LoadDate httpPost:path param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                // 状态正常 请求成功
                NSArray *dataArray = [obj[@"data"] lastObject][@"list"];
                NSMutableArray *tempArray = [NSMutableArray array];
                [[[CartBadgeSingleton sharedManager] mutableArrayValueForKeyPath:@"cartArr"] removeAllObjects];
                for (NSDictionary *dic in dataArray) {
                    GoodsModel *model = [[GoodsModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [tempArray addObject:model];
                    [[[CartBadgeSingleton sharedManager] mutableArrayValueForKeyPath:@"cartArr"] addObject:model.goods_id];
                }
            }else {
                
            }
        }];
    }else {
        [[self mutableArrayValueForKey:@"cartArr"] removeAllObjects];
    }
}

@end
