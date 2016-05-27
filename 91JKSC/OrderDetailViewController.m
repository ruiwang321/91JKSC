//
//  OrderDetailViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/28.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderListCell.h"
#import "Order.h"
#import "GoodsModel.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "TradeDetailViewController.h"
#import "AddEvaluateViewController.h"
#import "RefundViewController.h"
#import "ShippmentViewController.h"
#import "CheckRefundViewController.h"
#import "ChatViewController.h"

@interface OrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *orderDetailTableView;
@property (nonatomic,strong)NSDictionary *listDict;
@property (nonatomic,strong) UILabel *payMoneyLabel;
@property (nonatomic,strong)UIButton *payBtn;
@property (nonatomic,strong)UIButton * otherBtn;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavBar];
    [self reloadDetailData];
    [self createTableView];
}


- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.350, 20)];
    titleView.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
    if (self.order_state.longLongValue == 10) {
       titleView.text = @"等待付款";
    }else if (self.order_state.longLongValue == 20){
        titleView.text = @"等待发货";
    }else if (self.order_state.longLongValue == 30){
        titleView.text = @"等待收货";
    }else if (self.order_state.longLongValue == 40){
       titleView.text = @"交易成功";
    }else{
        titleView.text = @"已取消交易";
    }
    
}
-(void)dismissMyself{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createTableView{
  
    self.orderDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64-50) style:UITableViewStyleGrouped];
    self.orderDetailTableView.dataSource = self;
    self.orderDetailTableView.delegate = self;
    self.orderDetailTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.orderDetailTableView registerClass:[OrderListCell class] forCellReuseIdentifier:@"OrderListCell"];
    [self.view addSubview:self.orderDetailTableView];
    
}
- (void)createPayBar {
    if (self.order_state.longLongValue == 10) {
        UILabel *yingfujineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SYS_HEIGHT - 34, 80, 15)];
        yingfujineLabel.text = @"应付金额：";
        yingfujineLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        yingfujineLabel.font = [UIFont systemFontOfSize:15/375.0f*SYS_WIDTH];
        [self.view addSubview:yingfujineLabel];
        
        _payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, SYS_HEIGHT - 34, 100, 15)];
        _payMoneyLabel.textColor = BackGreenColor;
        _payMoneyLabel.font = [UIFont systemFontOfSize:15/375.0f*SYS_WIDTH];
        [self.view addSubview:_payMoneyLabel];
        
        _payMoneyLabel.text = [NSString stringWithFormat:@"￥%@",_listDict[@"order_amount"]];
    }
    
    _payBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn.frame = CGRectMake(SYS_WIDTH - 100, SYS_HEIGHT - 44, 90, 37);
    
    [_payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _payBtn.layer.cornerRadius = 2;
    _payBtn.tag = 150;
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:15/375.0f*SYS_WIDTH];
   _payBtn.backgroundColor = BackGreenColor;
    [self.view addSubview:_payBtn];
    
    _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherBtn.frame = CGRectMake(SYS_WIDTH - 200, SYS_HEIGHT - 44, 90, 37);
    [_otherBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _otherBtn.tag = 151;
    _otherBtn.layer.cornerRadius = 2;
    _otherBtn.layer.borderWidth = 1;
    _otherBtn.layer.borderColor =[UIColor colorWithRed:0.48f green:0.48f blue:0.49f alpha:1.00f].CGColor;
    [_otherBtn setTitleColor:[UIColor colorWithRed:0.48f green:0.48f blue:0.49f alpha:1.00f] forState:UIControlStateNormal];
    _otherBtn.titleLabel.font = [UIFont systemFontOfSize:15/375.0f*SYS_WIDTH];
    [self.view addSubview:_otherBtn];
    
    
    
    if (self.order_state.longLongValue == 10) {
        [_payBtn setTitle:@"确认并付款" forState:UIControlStateNormal];
        _otherBtn.hidden = YES;
    }else if (self.order_state.longLongValue == 20){
        [_payBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        _payBtn.userInteractionEnabled = YES;
         _otherBtn.hidden = YES;
        [_otherBtn setTitle:@"退款" forState:UIControlStateNormal];
        _otherBtn.userInteractionEnabled = NO;
    }else if (self.order_state.longLongValue == 30){
        [_payBtn setTitle:@"确认收货" forState:UIControlStateNormal];
         _payBtn.userInteractionEnabled = YES;
         _otherBtn.hidden = YES;
        [_otherBtn setTitle:@"申请退款" forState:UIControlStateNormal];
        _otherBtn.userInteractionEnabled = YES;
    }else if (self.order_state.longLongValue == 40){
        [_payBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
         _payBtn.userInteractionEnabled = YES;
         _otherBtn.hidden = YES;
    }else{
        _payBtn.hidden = YES;
        _otherBtn.hidden = YES;
    }
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0||section == 1) {
        return 1;
    }else{
        return [_listDict[@"extend_order_goods"] count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.order_state.longLongValue == 10) {
        if (section == 1) {
            return 278;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        if (section == 2) {
            return 278;
        }else{
            return CGFLOAT_MIN;
        }
    }
}
#pragma mark tableView组脚视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.order_state.longLongValue == 10) {
        if (section == 1) {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            footerView.backgroundColor = [UIColor clearColor];
            [self createFootView:footerView];
            return footerView;
        }else{
            return nil;
        }
    }else{
        if (section == 2) {
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            footerView.backgroundColor = [UIColor clearColor];
            [self createFootView:footerView];
            return footerView;
        }else{
            return nil;
        }
    }
}
-(void)createFootView:(UIView *)footerView{
    // 创建合计统计View
    UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SYS_WIDTH - 20, 278)];
    totalView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
    [footerView addSubview:totalView];
    
    // 统计View中不变子控件
    UILabel *hejiLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 8, 35, 15)];
    hejiLabel.text = @"合计";
    hejiLabel.font = [UIFont systemFontOfSize:15/375.0f*SYS_WIDTH];
    hejiLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [totalView addSubview:hejiLabel];
    
    UILabel *youfeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 33, 35, 15)];
    youfeiLabel.text = @"邮费";
    youfeiLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    youfeiLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [totalView addSubview:youfeiLabel];
    
    UIView *hengxianView = [[UIView alloc] initWithFrame:CGRectMake(17, 59, SYS_WIDTH - 54, 1)];
    hengxianView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [totalView addSubview:hengxianView];
    
    UILabel *dingdanzongeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 68, 80, 20)];
    dingdanzongeLabel.text = @"订单总额";
    dingdanzongeLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    dingdanzongeLabel.font = SYS_FONT(16);
    [totalView addSubview:dingdanzongeLabel];
    
    
    // 商品合计金额Lebel
    UILabel *_goodsMoney = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 135, 8, 100, 15)];
    _goodsMoney.font = SYS_FONT(16);
    _goodsMoney.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    _goodsMoney.textAlignment = NSTextAlignmentRight;
    [totalView addSubview:_goodsMoney];
    
    // 邮费Lebel
    UILabel *_postage = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 135, 33, 100, 15)];
    _postage.font = SYS_FONT(15);
    _postage.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    _postage.textAlignment = NSTextAlignmentRight;
    [totalView addSubview:_postage];
    
    // 订单总金额
    UILabel *_totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 135, 68, 100, 15)];
    _totalMoney.font = SYS_FONT(16);
    _totalMoney.textColor = BackGreenColor;
    _totalMoney.textAlignment = NSTextAlignmentRight;
    [totalView addSubview:_totalMoney];
    
    // 留言给卖家
    UILabel *callSeller = [[UILabel alloc] initWithFrame:CGRectMake(17, 97, SYS_WIDTH - 54, 36)];
    callSeller.backgroundColor = [UIColor clearColor];
    callSeller.text = [NSString stringWithFormat:@"买家留言：%@",_listDict[@"order_message"]];
    callSeller.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    callSeller.font = [UIFont systemFontOfSize:14/375.0f*SYS_WIDTH];
    callSeller.layer.cornerRadius = 4;
    [totalView addSubview:callSeller];
    
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(0, 133, SYS_WIDTH-20, 1)];
    lines.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [totalView addSubview:lines];
    
    UIButton * custemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    custemBtn.frame = CGRectMake(17, 139, SYS_WIDTH-54, 40);
    [custemBtn setBackgroundImage:[UIImage imageNamed:@"contact"] forState:UIControlStateNormal];
    [custemBtn addTarget:self action:@selector(contactCustem:) forControlEvents:UIControlEventTouchUpInside];
    [totalView addSubview:custemBtn];
    
    
    UIView *linedownView = [[UIView alloc]initWithFrame:CGRectMake(0, 184, SYS_WIDTH-20, 1)];
    linedownView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [totalView addSubview:linedownView];
    
    UILabel * orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 191, 80, 20)];
    orderNumLabel.text = @"订单编号";
    orderNumLabel.font = SYS_FONT(16);
    orderNumLabel.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    [totalView addSubview:orderNumLabel];
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 218, 80, 20)];
    timeLabel.text = @"下单时间";
    timeLabel.font = SYS_FONT(16);
    timeLabel.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    [totalView addSubview:timeLabel];
    
    UILabel * payLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 245, 80, 20)];
    payLabel.text = @"支付方式";
    payLabel.font = SYS_FONT(16);
    payLabel.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    [totalView addSubview:payLabel];
    
    
    UILabel * orderNumL = [[UILabel alloc]initWithFrame:CGRectMake(totalView.frame.size.width -200, 191, 190, 20)];
    orderNumL.textAlignment = NSTextAlignmentRight;
    orderNumL.font = SYS_FONT(16);
    orderNumL.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    [totalView addSubview:orderNumL];
    
    UILabel * timeL = [[UILabel alloc]initWithFrame:CGRectMake(totalView.frame.size.width -200, 218, 190, 20)];
     timeL.textAlignment = NSTextAlignmentRight;
    timeL.font = SYS_FONT(16);
    timeL.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    [totalView addSubview:timeL];
    
    UILabel * payL = [[UILabel alloc]initWithFrame:CGRectMake(totalView.frame.size.width -200, 245, 190, 20)];
     payL.textAlignment = NSTextAlignmentRight;
    payL.font = SYS_FONT(16);
    payL.textColor = [UIColor colorWithRed:0.59f green:0.59f blue:0.59f alpha:1.00f];
    [totalView addSubview:payL];
    
    
    _goodsMoney.text = [NSString stringWithFormat:@"￥%@",_listDict[@"order_amount"]];
    _postage.text = [NSString stringWithFormat:@"￥%@",_listDict[@"shipping_fee"]];
    _totalMoney.text = [NSString stringWithFormat:@"￥%@",_listDict[@"order_amount"]];
    orderNumL.text = _listDict[@"order_sn"];
     NSString *confromTimespStr;
    if ([_listDict[@"add_time"] isEqualToString:@""]) {
        confromTimespStr =@"";
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_listDict[@"add_time"] longLongValue]];
        confromTimespStr = [formatter stringFromDate:confromTimesp];

        
    }
    
    timeL.text = confromTimespStr;
    payL.text = [_listDict[@"payment_id"] isEqualToString:@"2"]?@"支付宝支付":@"微信支付";
}
#pragma mark --- 联系客服
-(void)contactCustem:(UIButton *)btn{
    /*
     airlines:"客服"{
        member_id:"客服id"
        member_name:"客服用户名"
        member_nickname:"客服昵称"
     }
     */
    NSDictionary *customdict = _listDict[@"airlines"];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithTitle:customdict[@"member_nickname"] memberId:customdict[@"member_id"]];
    [self.navigationController pushViewController:chatVC animated:YES];
    
    NSDictionary *tempDic = @{customdict[@"member_id"]: customdict};
    [[NSUserDefaults standardUserDefaults] setObject:tempDic forKey:[Function getUserId]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.order_state.longLongValue == 10) {
        return 2;
    }else{
        return 3;
    }
}
-(void)createCellContentView:(UIView *)cellSub{
    UIImageView *localImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
    localImage.frame = CGRectMake(2, 29, 27, 27);
    [cellSub addSubview:localImage];
    
 
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 15, 85, 16)];
    nameLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    nameLabel.textColor = RGB(64, 64, 64);
    [cellSub addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 200, 15, 110, 16)];
    phoneLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    nameLabel.textColor = RGB(64, 64, 64);
    [cellSub addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 50, SYS_WIDTH - 50, 14)];
    addressLabel.font = [UIFont systemFontOfSize:14/375.0f*SYS_WIDTH];
    addressLabel.textColor = RGB(160, 160, 160);
    [cellSub addSubview:addressLabel];
    

    nameLabel.text = _listDict[@"reciver_name"];
    phoneLabel.text = _listDict[@"reciver_phone"];
    addressLabel.text = _listDict[@"reciver_address"];
}
-(void)createCellShangpinMessage:(UIView *)messageView andIndex:(NSIndexPath *)indexPath{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 8, 1, 66)];
    lineView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [messageView addSubview:lineView];
    
    UILabel *shuliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 40, 11)];
    shuliangLabel.font = [UIFont systemFontOfSize:11/375.0f*SYS_WIDTH];
    shuliangLabel.textColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1];
    [messageView addSubview:shuliangLabel];
    
    UILabel *xuanxiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 35, SYS_WIDTH - 200, 11)];
    xuanxiangLabel.font = [UIFont systemFontOfSize:11/375.0f*SYS_WIDTH];
    xuanxiangLabel.textColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1];
    [messageView addSubview:xuanxiangLabel];
    
    UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(SYS_WIDTH - 48, 30, 22, 22)];
    moreImg.image = [UIImage imageNamed:@"more"];
    [messageView addSubview:moreImg];
    // 商品图
    UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 80, 66)];
    [messageView addSubview:goodsImg];
    
    // 商品名称
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, SYS_WIDTH - 125, 13)];
    goodsName.font = [UIFont systemFontOfSize:13/375.0f*SYS_WIDTH];
    goodsName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [messageView addSubview:goodsName];
    
    // 商品价格
    UILabel *goodsMoney = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 100, 13)];
    goodsMoney.textColor = BackGreenColor;
    goodsMoney.font = [UIFont systemFontOfSize:13/375.0f*SYS_WIDTH];
    [messageView addSubview:goodsMoney];
    

    NSString *str ;
    UIButton * refundBtn = [UIButton  buttonWithType:UIButtonTypeCustom];
    refundBtn.frame = CGRectMake(SYS_WIDTH - 120, 55, 90, 25);
    refundBtn.backgroundColor = [UIColor whiteColor];
    refundBtn.titleLabel.font = SYS_FONT(15);
    [refundBtn setTitleColor:BackGreenColor forState:UIControlStateNormal];
    refundBtn.layer.borderWidth = 1;
    refundBtn.layer.borderColor = BackGreenColor.CGColor;
    refundBtn.layer.cornerRadius = 5;
    refundBtn.tag = indexPath.row+1000;
    [refundBtn addTarget:self action:@selector(refundOrder:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:refundBtn];
    NSLog(@"%@",_listDict[@"is_refund"]);
    if ([_listDict[@"extend_order_goods"][indexPath.row][@"is_refund"] integerValue] == 0) {
        refundBtn.hidden = YES;
    }else{
        refundBtn.hidden = NO;
        if ([_listDict[@"extend_order_goods"][indexPath.row][@"refund_state"] isEqualToString:@""]) {
            [refundBtn setTitle:@"退款" forState:UIControlStateNormal];
        }else if([_listDict[@"extend_order_goods"][indexPath.row][@"refund_state"] isEqualToString:@"3"]){
            
            [refundBtn setTitle:@"退款成功" forState:UIControlStateNormal];
        }else{
            
            [refundBtn setTitle:@"退款中" forState:UIControlStateNormal];
        }
    }
   
    // ----------------------赋值-----------------

    ImageWithUrl(goodsImg, _listDict[@"extend_order_goods"][indexPath.row][@"goods_image"]);
    goodsName.text = _listDict[@"extend_order_goods"][indexPath.row][@"goods_name"];
    goodsMoney.text = _listDict[@"extend_order_goods"][indexPath.row][@"goods_pay_price"];
    shuliangLabel.text = _listDict[@"extend_order_goods"][indexPath.row][@"goods_num"];
    

}
-(void)refundOrder:(UIButton *)btn{
   
    if ([btn.currentTitle isEqualToString:@"退款"]) {
        RefundViewController *refunVC = [[RefundViewController alloc]init];
        refunVC.orderID = self.orders_id;
        refunVC.goods_id = _listDict[@"extend_order_goods"][btn.tag-1000][@"goods_id"];;
        [self.navigationController pushViewController:refunVC animated:YES];
    }else{
        CheckRefundViewController *checkRVC = [[CheckRefundViewController alloc]init];
        checkRVC.refund_sn = _listDict[@"extend_order_goods"][btn.tag -1000][@"refund_sn"];
        [self.navigationController pushViewController:checkRVC animated:YES];
    }
}
-(void)createChangeTitle:(UIView *)changeView andTitle:(NSString *)state{

    NSString * imageName;
   
    if (state.longLongValue == 10) {
         imageName  = @"location";
        
    }else if (state.longLongValue == 20){
        imageName  = @"wuliu";
    
    }else if (state.longLongValue == 30){
        imageName  = @"waiting-sending";
        
    }else{
        imageName = @"sucess";
    }
    UIImageView *localImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    localImage.frame = CGRectMake(2, 29, 27, 27);
    [changeView addSubview:localImage];
    
    UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(SYS_WIDTH - 48, 30, 22, 22)];
    moreImg.image = [UIImage imageNamed:@"more"];
    [changeView addSubview:moreImg];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 15, 150, 16)];
    nameLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    nameLabel.textColor = RGB(64, 64, 64);
    [changeView addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 200, 15, 110, 16)];
    phoneLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    nameLabel.textColor = RGB(64, 64, 64);
    [changeView addSubview:phoneLabel];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 50, SYS_WIDTH - 50, 14)];
    addressLabel.font = [UIFont systemFontOfSize:14/375.0f*SYS_WIDTH];
    addressLabel.textColor = RGB(160, 160, 160);
    [changeView addSubview:addressLabel];

    
    if (state.longLongValue == 10) {
        nameLabel.text = _listDict[@"reciver_name"];
        phoneLabel.text = _listDict[@"reciver_phone"];
        addressLabel.text = _listDict[@"reciver_address"];
    }else if (state.longLongValue == 20){
        moreImg.hidden = YES;
        nameLabel.hidden = YES;
        phoneLabel.hidden = YES;
        addressLabel.hidden = YES;
        UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 29, SYS_WIDTH - 31, 27)];
        successLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
        successLabel.textColor = RGB(64, 64, 64);
        successLabel.text = @"等待卖家发货";
        [changeView addSubview:successLabel];
    }else if (state.longLongValue == 30){
        nameLabel.text = @"卖家已发货";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[_listDict[@"shipping_time"] integerValue]];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];

        addressLabel.text = confromTimespStr;
        phoneLabel.hidden = YES;
    }else{
        moreImg.hidden = YES;
        nameLabel.hidden = YES;
        phoneLabel.hidden = YES;
        addressLabel.hidden = YES;
        UILabel *successLabel = [[UILabel alloc]initWithFrame:CGRectMake(31, 29, SYS_WIDTH - 31, 27)];
        successLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
        successLabel.textColor = RGB(64, 64, 64);
        successLabel.text = @"感谢您在91商城购物，欢迎您再次光临!";
        [changeView addSubview:successLabel];
    }
   
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"OrderListCell";
    OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.layer.cornerRadius = 4;
    // 取消cell点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.order_state.longLongValue == 10) {
        if (indexPath.section == 0) {
            [self createCellContentView:cell.contentView];
            return cell;
        }else{
            [self createCellShangpinMessage:cell.contentView andIndex:indexPath];
            return cell;
        }

    }else{
        if (indexPath.section == 1) {
            [self createCellContentView:cell.contentView];
            return cell;
        }else if(indexPath.section == 2){
            [self createCellShangpinMessage:cell.contentView andIndex:indexPath];
            return cell;
        }else{
            [self createChangeTitle:cell.contentView andTitle:self.order_state];
            return cell;
        }

    }
}

#pragma mark --- 查看详情数据
-(void)reloadDetailData{
    NSString *urlPath = [NSString stringWithFormat:@"%@orderInfo.html",API_ORDER];
    
    if ([Function isLogin]) {
        NSDictionary * paramsDic = @{@"key":[Function getKey],@"order_id":self.orders_id};
        NSLog(@"%@",paramsDic);
        
        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.
                NSLog(@"%@",obj);
                if ([obj[@"code"] longLongValue] == 200) {
                  
                    _listDict = obj[@"data"];
                }
                [self.orderDetailTableView reloadData];
                [self createPayBar];
                hud.hidden = YES;
            }else{
                hud.hidden = YES;
                [MBProgressHUD showError:@"亲 网络不给力"];
            }
            
        }];
        
    }else{
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"请登录" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        av.tag = 333;
        [av show];
    }
    
    
}
-(void)payBtnClicked:(UIButton *)btn{
    
    if (btn.tag == 150) {
        
        switch (self.order_state.longLongValue) {
            case 10:
                [self trueAndPay];
                break;
            case 40:
                [self submitEvaluation];
                break;
            case 30:
                [self sureOrder];
                break;
            case 20:
                [self ReminderOrder];
                break;
            default:
                break;
        }
    }else {
        
    }
}
#pragma mark - 确认收货
- (void)sureOrder {
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:@"确认收货后钱款将直接打入卖家账户，是否继续？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertV.tag = 9;
    [alertV show];
}
#pragma mark ------ 评价晒单
-(void)submitEvaluation{
    AddEvaluateViewController *addEVC =[[AddEvaluateViewController alloc]init];
    addEVC.order_id = self.orders_id;
    addEVC.extend_order_goods =_listDict[@"extend_order_goods"];
    [self.navigationController pushViewController:addEVC animated:YES];
}
#pragma mark ------ 提醒发货
-(void)ReminderOrder{
    NSString *urlPath = [NSString stringWithFormat:@"%@/Remind.html",API_ORDER];
    
    NSDictionary * paramsDic = @{
                                 @"key":[Function getKey],
                                 @"order_id":self.orders_id
                                 };
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            if ([obj[@"code"] longLongValue] == 200){
                [MBProgressHUD showSuccess:@"已提醒卖家发货"];
            }else{
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }else{
            [MBProgressHUD showError:@"网络不给力"];
            
        }
        
    }];
}
#pragma mark ------ 确认并付款
- (void)trueAndPay{
    NSDictionary *params2 = @{
                              @"key"        : [Function getKey],
                              @"ip2long"    : [LoadDate getIPDress],
                              @"pay_id"     : _listDict[@"pay_sn"]
                              };
    if ([_listDict[@"payment_id"]  isEqualToString:@"2"]) {
        
        [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_PAYMENT, @"zfb_app_pay.html"] param:params2 finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            
            NSLog(@"%@",obj);
            
            // 支付宝支付
            
            
            NSString *partner = @"2088021907983629";
            
            NSString *seller = @"3329610268@qq.com";
            
            NSString *privateKey =AlipayPrivateKey;
            Order *order = [[Order alloc] init];
            order.partner = partner;
            order.seller = seller;
            
            order.tradeNO = obj[@"data"][@"out_trade_no"];
            order.productName = @"91健康商城"; //商品标题
            order.productDescription = obj[@"data"][@"body"]; //商品描述
            NSString *payMoney = obj[@"data"][@"total_fee"];
            order.amount = @"0.01";//商品价格
            
            order.notifyURL = obj[@"data"][@"notify_url"]; //回调URL
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            order.showUrl = @"m.alipay.com";
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"jkscalipay";
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    
                    //resultStatus = 9000支付成功
                    
                    NSNumber *resultStatus=resultDic[@"resultStatus"];
                    if (resultStatus.intValue==9000) {
                        // 成功
                        [_payBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
                    }else
                    {
                        [MBProgressHUD showError:@"支付失败"];
                    }
                }];
                
            }
            
            
            
        }];
    }else {
        NSLog(@"%d",[WXApi isWXAppInstalled]);
        if ([WXApi isWXAppInstalled]&& [WXApi isWXAppSupportApi]) {
            // 微信支付
            [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_PAYMENT, @"wx_app_pay.html"] param:params2 finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                NSLog(@"%@",obj);
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = obj[@"data"][@"partnerid"];
                request.prepayId= obj[@"data"][@"prepayid"];
                request.package = obj[@"data"][@"package"];
                request.nonceStr= obj[@"data"][@"noncestr"];
                request.timeStamp= [obj[@"data"][@"timestamp"] intValue];
                request.sign= obj[@"data"][@"sign"];
                
                [WXApi sendReq:request];
                
            }];
            
            
        }else{
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未安装微信，是否安装" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertV.tag =30;
            [alertV show];
        
    
        }

    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.order_state.longLongValue == 10) {
        if (indexPath.section == 1) {
            TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
            [self.navigationController pushViewController:tradeDetailVC animated:YES];
            tradeDetailVC.goods_id = _listDict[@"extend_order_goods"][indexPath.row][@"goods_id"];
        }

    }else if(self.order_state.longLongValue == 30){
        if (indexPath.section == 2) {
            TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
            [self.navigationController pushViewController:tradeDetailVC animated:YES];
            tradeDetailVC.goods_id = _listDict[@"extend_order_goods"][indexPath.row][@"goods_id"];
        
        }else if(indexPath.section == 0){
            ShippmentViewController *shippVC = [[ShippmentViewController alloc]init];
            shippVC.orderID = _listDict[@"order_id"];
            [self.navigationController pushViewController:shippVC animated:YES];
        }
    }else if (self.order_state.longLongValue == 0||self.order_state.longLongValue == 20||self.order_state.longLongValue == 40||self.order_state.longLongValue == 60){
        if (indexPath.section == 2) {
            TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
            [self.navigationController pushViewController:tradeDetailVC animated:YES];
            tradeDetailVC.goods_id = _listDict[@"extend_order_goods"][indexPath.row][@"goods_id"];
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *url = [NSString stringWithFormat:@"%@%@",API_ORDER,@"sureOrder.html"];
        NSDictionary *params = @{
                                 @"key"     :[Function getKey],
                                 @"order_id":_orders_id
                                 };
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                
                OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
                orderDVC.orders_id = self.orders_id;
                orderDVC.order_state = @"40";
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController pushViewController:orderDVC animated:YES];
                
            }
        }];
    }
}

@end
