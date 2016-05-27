//
//  TradeDetailThirdTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "TradeDetailThirdTableViewCell.h"
#import "TradeDetailModel.h"
#import "UIView+ViewController.h"
#import "OrderConfirmByIDViewController.h"
#import "ShoppingCartViewController.h"
#import "GoodsModel.h"
@interface TradeDetailThirdTableViewCell()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,strong)NSIndexPath * selectedIndex;
@property (nonatomic,strong)NSArray *dataArr;
@end

@implementation TradeDetailThirdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)createCellWithModel:(TradeDetailModel*)model andIndex:(NSInteger)index{
    //可伸缩条
    UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn.frame = CGRectMake(5,10, SYS_WIDTH-10, 30);
    cellBtn.backgroundColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.90f alpha:1.00f];
    
    cellBtn.layer.cornerRadius = 2;
    
    //伸缩条里面的字
    _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, SYS_WIDTH-40, 30)];
    _valueLabel.text = model.goods_jingle;
    _valueLabel.font = [UIFont systemFontOfSize:18];
    _valueLabel.textColor = [UIColor blackColor];
    [cellBtn addSubview:_valueLabel];
    

    //加入购物车
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(5, cellBtn.frame.size.height+20, SYS_WIDTH/2-10, 30);
    _loginBtn.backgroundColor = [UIColor colorWithRed:0.70f green:0.91f blue:0.64f alpha:1.00f];
    _loginBtn.tag =1556;
    [_loginBtn setTitleColor:[UIColor colorWithRed:0.05f green:0.62f blue:0.00f alpha:1.00f] forState:UIControlStateNormal ];
    [_loginBtn setTitle:@"加入购物车" forState:UIControlStateNormal];

    _loginBtn.layer.cornerRadius = 2;
    [self addSubview:_loginBtn];
    
    //购买
    _buyBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _buyBtn.frame = CGRectMake(SYS_WIDTH/2+5,cellBtn.frame.size.height+20, SYS_WIDTH/2-10,30);
    _buyBtn.backgroundColor = BackGreenColor;
    _buyBtn.layer.cornerRadius = 2;
    _buyBtn.tag = 1555;
    [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
//    [_buyBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_buyBtn];
    
    
    
    
//       伸缩条的下拉框
       _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downBtn.frame = CGRectMake(SYS_WIDTH-40, 8, 20, 20);
        _downBtn.layer.cornerRadius = 2;
        [_downBtn setImage:[UIImage imageNamed:@"iconfont-1-copy"] forState:UIControlStateNormal];
        [cellBtn addSubview:_downBtn];
    [cellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:cellBtn];
    
}



@end
