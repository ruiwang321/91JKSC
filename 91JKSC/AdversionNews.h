//
//  AdversionNews.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/18.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdversionNews : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

-(id)initWithDict:(NSDictionary *)dict;
+(id)newsWithDict : (NSDictionary *) dict;
@end
