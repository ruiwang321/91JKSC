//
//  AddEvaluateCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AddEvaluateCell.h"
#import "GoodsModel.h"
@implementation AddEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createCell];
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
    // ----------------------赋值-----------------
        ImageWithUrl(_goodsImg, dict[@"goods_image"]);
        _goodsName.text = dict[@"goods_name"];
        if ([dict[@"evaluateinfo"] count] >0) {
            [_evaluateBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            _evaluateBtn.tag = 10;
        }else{
            
        }
}
-(void)createCell{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 8, 1, 66)];
    lineView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [self.contentView addSubview:lineView];

    // 商品图
    _goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 66, 66)];
    [self.contentView addSubview:_goodsImg];
    
    // 商品名称
     _goodsName= [[UILabel alloc] initWithFrame:CGRectMake(100, 14, SYS_WIDTH - 125, 13)];
    _goodsName.font = [UIFont systemFontOfSize:14/375.0f*SYS_WIDTH];
    _goodsName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [self.contentView addSubview:_goodsName];
    
    
    _evaluateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _evaluateBtn.frame = CGRectMake(SYS_WIDTH - 110, 42, 80, 30);
    _evaluateBtn.layer.cornerRadius = 3;
    _evaluateBtn.layer.borderWidth = 1;
    _evaluateBtn.layer.borderColor = [BackGreenColor CGColor];
    _evaluateBtn.titleLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    [_evaluateBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
    [_evaluateBtn setTitleColor:BackGreenColor forState:UIControlStateNormal];
    [self.contentView addSubview:_evaluateBtn];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
