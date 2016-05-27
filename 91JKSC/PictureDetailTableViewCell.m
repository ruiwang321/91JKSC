//
//  PictureDetailTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "PictureDetailTableViewCell.h"
#import "TradeDetailModel.h"
@implementation PictureDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)createCellWithArray:(NSArray *)arr andIndex:(NSInteger)index{
    //商品详情 标签
    UILabel *titleDetailLabel = [[UILabel alloc]init];
    titleDetailLabel.frame = CGRectMake(10, 5, SYS_WIDTH, 20);
    titleDetailLabel.text = @"商品详情";
    [self addSubview:titleDetailLabel];

        //图片显示
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(2,30 , SYS_WIDTH-4,(SYS_WIDTH-4)*3.55555)];
    ImageWithUrl(imageV, [arr[0] objectForKey:@"value"]);
    imageV.contentMode = UIViewContentModeScaleToFill;
         NSLog(@"%@%@",ImageURL,[arr[0] objectForKey:@"value"]);
    [self addSubview:imageV];


//    
//    //91品牌服务保障 标签
//    UILabel *simpleLabel = [[UILabel alloc]init];
//    simpleLabel.frame = CGRectMake(10, imageV.frame.size.height+titleDetailLabel.frame.size.height+20, 68, 60);
//    simpleLabel.lineBreakMode = UILineBreakModeWordWrap;
//    simpleLabel.textAlignment =NSTextAlignmentCenter;
//    simpleLabel.numberOfLines = 2;
//    simpleLabel.text = @"91品牌服务保障";
//    [self addSubview:simpleLabel];
//    NSArray *arr =@[@"detailpage-goods",@"detailpage-free",@"detailpage-healthy",@"detailpage-green"];
//    NSArray *titleArr =@[@"包邮",@"现货",@"健康",@"绿色"];
//    for (int i=0; i<4; i++) {
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_WIDTH-i*10-i*50-60, imageV.frame.size.height+titleDetailLabel.frame.size.height+50, 20, 20)];
//        imageView.image = [UIImage imageNamed:arr[i]];
//        [self addSubview:imageView];
//        
//        UILabel *titleLabel = [[UILabel alloc]init];
//        titleLabel.frame = CGRectMake(SYS_WIDTH-i*10-i*50-40, imageV.frame.size.height+titleDetailLabel.frame.size.height+50, 40, 20);
//        titleLabel.text = titleArr[i];
//        titleLabel.font = [UIFont systemFontOfSize:16];
//        titleLabel.textColor = [UIColor colorWithRed:0.55f green:0.77f blue:0.65f alpha:1.00f];
//        [self addSubview:titleLabel];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
