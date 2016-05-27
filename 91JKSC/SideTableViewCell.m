//
//  SideTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/20.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SideTableViewCell.h"

@implementation SideTableViewCell

- (void)awakeFromNib {

    self.Imagebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.Imagebtn.frame = CGRectMake(5, 3, 25, 25);
    
    [self addSubview:self.Imagebtn];
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


    
}

@end
