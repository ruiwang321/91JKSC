//
//  ShippmentModel.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShippmentModel.h"

@implementation ShippmentModel

-(void)setShipping_time:(NSString *)shipping_time
{
    NSString *confromTimespStr;
    if ([shipping_time isEqualToString:@""]) {
        confromTimespStr = @"";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:shipping_time.longLongValue];
        confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSLog(@"confromTimespStr =  %@",confromTimespStr);
    }
    _shipping_time = confromTimespStr;
}
-(void)setShipping_status:(NSString *)shipping_status{
    CGSize size = [shipping_status boundingRectWithSize:CGSizeMake(SYS_WIDTH-90,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(17)} context:nil].size;
    _messageHight = size.height;
    _rowHight = _messageHight+50;
    _shipping_status = shipping_status;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    
}
@end
