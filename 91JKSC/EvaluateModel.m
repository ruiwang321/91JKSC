//
//  EvaluateModel.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EvaluateModel.h"

@implementation EvaluateModel

-(void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
}
-(void)setComment_message:(NSString *)comment_message{
    CGSize size = [comment_message boundingRectWithSize:CGSizeMake(SYS_WIDTH - SYS_WIDTH*0.20-20,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(16)} context:nil].size;
    _messageHight = size.height;
    _rowHeight += size.height+80;
    _comment_message = comment_message;
}
-(void)setGeval_image:(NSArray *)geval_image{
    _rowHeight += geval_image.count>0?85:0;
    _geval_image = geval_image;
}
-(void)setGeval_addtime:(NSString *)geval_addtime{
    NSString *confromTimespStr;
    if ([geval_addtime isEqualToString:@""]) {
        confromTimespStr =@"";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:geval_addtime.longLongValue];
        confromTimespStr = [formatter stringFromDate:confromTimesp];

        
    }
    _geval_addtime = confromTimespStr;
}

@end
