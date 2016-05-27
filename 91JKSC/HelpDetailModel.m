

//
//  HelpDetailModel.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "HelpDetailModel.h"
@implementation HelpDetailModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)setValue:(NSString *)value{
    if ([self.type isEqualToString:@"text"]) {
        CGSize size = [value boundingRectWithSize:CGSizeMake(SYS_WIDTH-20,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(17)} context:nil].size;
        _messageHight = size.height;
        _rowHight = _messageHight+20;
    }else{
        CGSize size = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,value]]]].size;
        _messageHight = size.height*SYS_WIDTH/size.width;
        _rowHight += _messageHight;
    }
    _value = value;
}

@end
