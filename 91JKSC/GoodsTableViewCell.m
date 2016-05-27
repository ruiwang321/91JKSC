//
//  GoodsTableViewCell.m
//  91健康商城
//
//  Created by HerangTang on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "GoodsTableViewCell.h"
#import "GoodsModel.h"
#import <UIButton+WebCache.h>

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViewsWithRow];
        
        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}

// 重写cellframe的setter
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 10;
    frame.origin.x += 10;
    frame.size.width -= 20;
    frame.size.height -= 10;
    [super setFrame:frame];
}

#pragma mark - 重写goodsModel的setter方法给cell子控件赋值
- (void)setModel:(GoodsModel *)model {
    _model = model;
    _goodsName.text = model.goods_name;
    _goodsNumber.text = model.goods_num;
    _goodsPrice.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    _goodsOption.text = model.select_spec;
    _goodsSelBtn.selected = model.isSel;
    _goodsSelBtn.hidden = !(model.goods_num.integerValue <= model.goods_storage.integerValue);
    _tipLabel.text = model.goods_num.integerValue <= model.goods_storage.integerValue ? @"" :@"库存不足";
    [_goodsImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,model.goods_image]] forState:UIControlStateNormal];
}

- (void)createSubViewsWithRow {
    // 创建商品选中Button
    _goodsSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goodsSelBtn.frame = CGRectMake(7, 7, 22, 22);
    [_goodsSelBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [_goodsSelBtn setImage:[UIImage imageNamed:@"select-green"] forState:UIControlStateSelected];
    [self.contentView addSubview:_goodsSelBtn];
    
    // 创建商品名称Label
    _goodsName = [[UILabel alloc] initWithFrame:CGRectMake(33, 11, SYS_WIDTH - 60, 15)];
    _goodsName.font = [UIFont boldSystemFontOfSize:15];
    _goodsName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [self.contentView addSubview:_goodsName];
    
    // 创建提示label
    _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 120, 11, 60, 15)];
    _tipLabel.font = [UIFont boldSystemFontOfSize:15];
    _tipLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_tipLabel];
    
    // 创建商品图ImageView
    _goodsImageView = [[UIButton alloc] initWithFrame:CGRectMake(4, 38, 88, 88)];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_goodsImageView];
    
    // 创建商品单价Label
    _goodsPrice = [[UILabel alloc] initWithFrame:CGRectMake(193, 102, SYS_WIDTH - 230, 15)];
    _goodsPrice.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    _goodsPrice.font = [UIFont boldSystemFontOfSize:15];
    _goodsPrice.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_goodsPrice];
    
    // 移除Button
    _removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _removeBtn.frame = CGRectMake(95, 90, 49, 38);
    _removeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_removeBtn setTitle:@"移除" forState:UIControlStateNormal];
    [_removeBtn setTitleColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1] forState:UIControlStateNormal];
    [self.contentView addSubview:_removeBtn];
    
    // 编辑Button
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(144, 90, 49, 38);
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1] forState:UIControlStateNormal];
    [self.contentView addSubview:_editBtn];
    
    // 商品数量Label
    _goodsNumber = [[UILabel alloc] initWithFrame:CGRectMake(105, 66, 25, 15)];
    _goodsNumber.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_goodsNumber];
    
    // 商品选项Label
    _goodsOption = [[UILabel alloc] initWithFrame:CGRectMake(140, 66, SYS_WIDTH - 180, 13)];
    _goodsOption.font = [UIFont systemFontOfSize:13];
    _goodsOption.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [self.contentView addSubview:_goodsOption];
    
    // 不变子控件
    UILabel *shuliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 48, 22, 11)];
    shuliangLabel.text = @"数量";
    shuliangLabel.textColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1];
    shuliangLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:shuliangLabel];
    
    UILabel *xuanxiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 48, 22, 11)];
    xuanxiangLabel.text = @"选项";
    xuanxiangLabel.textColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1];
    xuanxiangLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:xuanxiangLabel];

}
// 重写绘制方法
- (void)drawRect:(CGRect)rect {
    // 横线
    [self drawLineFrom:CGPointMake(17, 80 - 44) to:CGPointMake(SYS_WIDTH - 17 * 2, 80 - 44)];
    [self drawLineFrom:CGPointMake(17, 172 - 44) to:CGPointMake(SYS_WIDTH - 17 * 2, 172 - 44)];
    [self drawLineFrom:CGPointMake(95, 134 - 44) to:CGPointMake(SYS_WIDTH - 17 * 2, 134 - 44)];
    // 竖线
    [self drawLineFrom:CGPointMake(95, 80 - 44) to:CGPointMake(95, 172 - 44)];
    [self drawLineFrom:CGPointMake(SYS_WIDTH - 17 * 2, 80 - 44) to:CGPointMake(SYS_WIDTH - 17 * 2, 172 - 44)];
    [self drawLineFrom:CGPointMake(144, 134 - 44) to:CGPointMake(144, 172 - 44)];
    [self drawLineFrom:CGPointMake(193, 134 - 44) to:CGPointMake(193, 172 - 44)];

}

// 绘制直线
- (void)drawLineFrom:(CGPoint)pF to:(CGPoint)pT {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(ctx, 0.9, 0.9, 0.9, 1);
    CGContextMoveToPoint(ctx, pF.x, pF.y);
    CGContextAddLineToPoint(ctx, pT.x, pT.y);
    
    CGContextStrokePath(ctx);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
