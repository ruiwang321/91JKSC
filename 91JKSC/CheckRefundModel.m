//
//  CheckRefundModel.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "CheckRefundModel.h"

@implementation CheckRefundModel
-(void)setTime:(NSString *)time
{
    NSString *confromTimespStr;
    if ([time isEqualToString:@""]) {
         confromTimespStr = @"";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time.longLongValue];
       confromTimespStr = [formatter stringFromDate:confromTimesp];
        CGSize size = [confromTimespStr boundingRectWithSize:CGSizeMake(SYS_WIDTH/3-20,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
        _timeHight = size.height;

    }
    _time = confromTimespStr;
}
-(void)setMessage:(NSString *)message{
    CGSize size = [message boundingRectWithSize:CGSizeMake(SYS_WIDTH-20,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
    _messageHight = size.height;
    _message = message;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    
}
@end
