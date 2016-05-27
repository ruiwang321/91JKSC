//
//  EvaluateTitleCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EvaluateTitleCell.h"

@implementation EvaluateTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

// 重写cellframe的setter
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 0;
    frame.origin.x += 10;
    frame.size.width -= 20;
    frame.size.height -= 0;
    [super setFrame:frame];
}
-(void)giveCellWithDict:(NSDictionary *)dict{
    if ([dict[@"evaluate_store_info"] count]>0) {
        _grayLabel.frame = CGRectMake(SYS_WIDTH-20-SYS_SCALE(140), 5, SYS_SCALE(140), 50);
        _grayLabel.text = @"已完成服务评价";
    }
}
-(void)createView{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 50)];
    titleLabel.text = @"服务评分";
    titleLabel.font = SYS_FONT(17);
    [self addSubview:titleLabel];
    
    _grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(SYS_WIDTH-20-120, 5, 110, 50)];
    _grayLabel.text = @"满意请给5星哦";
    _grayLabel.font = SYS_FONT(16);
    _grayLabel.textColor = [UIColor grayColor];
    [self addSubview:_grayLabel];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
