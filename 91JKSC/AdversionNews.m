//
//  AdversionNews.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/18.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AdversionNews.h"

@implementation AdversionNews


-(id)initWithDict:(NSDictionary *)dict{
    
    if (self=[super init]) {
        self.title = dict[@"title"];
        self.icon = dict[@"icon"];
    }
    return self;
}

+(id)newsWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    
}
@end
