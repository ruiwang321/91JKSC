//
//  OrderListView.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "OrderListView.h"
#import "GoodsModel.h"
#import "OrderModel.h"
#import "UIView+ViewController.h"
#import "OrderDetailViewController.h"
#import "AddEvaluateViewController.h"
#import "OrderDetailViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@implementation OrderListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)createView:(OrderModel *)model{
    _ordermodel = model;
    self.backgroundColor = [UIColor whiteColor];
    if (self.typeLabel == nil) {
        [self createBaseView];
    }
    if ([model.order_state isEqualToString:@"10"]) {
        _typeLabel.text = @"未付款";
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_justBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        
    }else if([model.order_state isEqualToString:@"0"]){
        _typeLabel.text = @"已取消";
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        _cancelBtn.hidden = YES;
        [_justBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    }else if([model.order_state isEqualToString:@"20"]){
        _typeLabel.text = @"已付款";
        [_cancelBtn setTitle:@"退款" forState:UIControlStateNormal];
        _cancelBtn.userInteractionEnabled = NO;
        _cancelBtn.hidden = YES;
        [_justBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        _justBtn.userInteractionEnabled = NO;
    }else if([model.order_state isEqualToString:@"30"]){
        _typeLabel.text = @"已发货";
        [_cancelBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        _cancelBtn.userInteractionEnabled = NO;
        [_justBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        _justBtn.userInteractionEnabled = NO;
    }else if([model.order_state isEqualToString:@"40"]){
        _cancelBtn.hidden = YES;
        if (model.evaluation_state.longLongValue == 0) {
            _typeLabel.text = @"已收货";
            [_justBtn setTitle:@"评价晒单" forState:UIControlStateNormal];
            _justBtn.userInteractionEnabled = YES;
        }else if(model.evaluation_state.longLongValue == 1){
            _typeLabel.text = @"已评价";
            [_justBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            _justBtn.userInteractionEnabled = NO;
        }else if(model.evaluation_state.longLongValue == 2){
            _typeLabel.text = @"已过期";
            [_justBtn setTitle:@"查看评价" forState:UIControlStateNormal];
            _justBtn.userInteractionEnabled = NO;
        }else{
            _typeLabel.frame =CGRectMake(SYS_SCALE(8), SYS_SCALE(8), SYS_SCALE(100), SYS_SCALE(30));
            _typeLabel.text = @"部分已评价";
            [_justBtn setTitle:@"继续评价" forState:UIControlStateNormal];
            _justBtn.userInteractionEnabled = YES;
        }

    }else if([model.order_state isEqualToString:@"60"]){
            _typeLabel.text = @"退款/退货";
            [_cancelBtn setTitle:@"取消退款" forState:UIControlStateNormal];
            _cancelBtn.userInteractionEnabled = NO;
            [_justBtn setTitle:@"退款中" forState:UIControlStateNormal];
            _justBtn.userInteractionEnabled = NO;
        
    }else {
        _typeLabel.text = @"购买成功";
    }
    
    
    self.moneyNumLabel.text = [NSString stringWithFormat:@"￥%@",model.order_amount];
    self.orderstate = model.order_state;
}
-(void)createBaseView{
    
    _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(8 ,8, SYS_SCALE(70), SYS_SCALE(30))];
    
    [self addSubview:_typeLabel];
    
    
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_typeLabel.frame.size.height+SYS_SCALE(15) , SYS_WIDTH, 1)];
    _lineLabel.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:_lineLabel];

    
    [self createCollectionView];
    
    
    
    
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,self.frame.size.height-SYS_HEIGHT *0.045-8 , SYS_SCALE(80), SYS_SCALE(30))];
    moneyLabel.text = @"订单金额：";
    moneyLabel.font = SYS_FONT(15);
    moneyLabel.textColor =COLOR(158.1, 160.65, 160.65, 1.0);
    [self addSubview:moneyLabel];
    
    _moneyNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(moneyLabel.frame.size.width,self.frame.size.height-SYS_HEIGHT *0.045-8 , SYS_SCALE(90), SYS_SCALE(30))];
    _moneyNumLabel.textAlignment = UITextAlignmentLeft;
    _moneyNumLabel.font = SYS_FONT(16);
    [self addSubview:_moneyNumLabel];
    
    UILabel *linesLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height-SYS_SCALE(50) , SYS_WIDTH, 1)];
    linesLabel.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:linesLabel];

    
    _cancelBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame =CGRectMake(self.frame.size.width-SYS_WIDTH*0.48,self.frame.size.height-SYS_HEIGHT *0.045-SYS_SCALE(8) ,SYS_WIDTH*0.213, SYS_HEIGHT *0.045);
    _cancelBtn.layer.cornerRadius = 3;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.borderColor = [COLOR(158.1, 160.65, 160.65, 1.0) CGColor];
    [_cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.titleLabel.font = SYS_FONT(16);
    [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:COLOR(158.1, 160.65, 160.65, 1.0) forState:UIControlStateNormal];
    [self addSubview:_cancelBtn];
    
    
    _justBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    _justBtn.frame =CGRectMake(self.frame.size.width-SYS_WIDTH*0.24,self.frame.size.height-SYS_HEIGHT *0.045-SYS_SCALE(8), SYS_WIDTH*0.213, SYS_HEIGHT *0.045);
    _justBtn.layer.cornerRadius = 3;
    _justBtn.layer.borderWidth = 1;
    _justBtn.layer.borderColor = [BackGreenColor CGColor];
    _justBtn.titleLabel.font = SYS_FONT(16);
    [_justBtn setTitle:@"立即支付" forState:UIControlStateNormal];
    [_justBtn addTarget:self action:@selector(justBuy:) forControlEvents:UIControlEventTouchUpInside];
    [_justBtn setTitleColor:BackGreenColor forState:UIControlStateNormal];
    [self addSubview:_justBtn];
    
    
    
    

}
#pragma mark --- 右侧按钮
-(void)justBuy:(UIButton *)btn{
    
    if ([btn.currentTitle isEqualToString:@"立即支付"]) {
        [self justBuyWithModel:_ordermodel];
    }else if ([btn.currentTitle isEqualToString:@"评价晒单"]||[btn.currentTitle isEqualToString:@"继续评价"]){
        AddEvaluateViewController *addEVC =[[AddEvaluateViewController alloc]init];
        addEVC.order_id = _ordermodel.order_id;
        addEVC.extend_order_goods =_ordermodel.extend_order_goods;
        [self.viewController.navigationController pushViewController:addEVC animated:YES];
        
    }else if ([btn.currentTitle isEqualToString:@"提醒发货"]){
        [self ReminderOrder:btn];
    }else if ([btn.currentTitle isEqualToString:@"确认收货"]){
        [self sureOrder:btn];
    }
    
}
#pragma mark - 确认收货
- (void)sureOrder:(UIButton *)btn {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_ORDER,@"sureOrder.html"];
    NSDictionary *params = @{
                             @"key"     :[Function getKey],
                             @"order_id":_ordermodel.order_id
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            
            OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
            orderDVC.orders_id = _ordermodel.order_id;
            orderDVC.order_state = @"40";
            //创建一个消息对象
            NSNotification * notice = [NSNotification notificationWithName:@"50" object:nil userInfo:@{
                                                                                                       @"order":@[@"40",@"50"]
                                                                                                       }];
            //发送消息
            [[NSNotificationCenter defaultCenter]postNotification:notice];
            [self.viewController.navigationController popViewControllerAnimated:YES];
            [self.viewController.navigationController pushViewController:orderDVC animated:YES];
        }
    }];
}
#pragma mark ----- 提醒发货
-(void)ReminderOrder:(UIButton *)btn{
    NSString *urlPath = [NSString stringWithFormat:@"%@/Remind.html",API_ORDER];
    
    NSDictionary * paramsDic = @{@"key":[Function getKey],@"order_id":_ordermodel.order_id};
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            if ([obj[@"code"] longLongValue] == 200){
                [MBProgressHUD showSuccess:@"已提醒卖家发货"];
            }else{
                NSLog(@"%@",obj[@"msg"]);
                [MBProgressHUD showError:obj[@"msg"]];
            }
        }else{
            [MBProgressHUD showError:@"网络不给力"];
            
        }
        
    }];
}
#pragma mark ---- 左侧按钮
-(void)cancelOrder:(UIButton *)btn{
    NSString *btnTitle = btn.currentTitle;
    if ([btnTitle isEqualToString:@"取消订单"]) {
        [self daifukuanLeftBtn:btn];
    }
}

#pragma mark ---- 取消订单
-(void)daifukuanLeftBtn:(UIButton *)btn{
    NSString *urlPath = [NSString stringWithFormat:@"%@/cancleOrder.html",API_ORDER];
    
    NSDictionary * paramsDic = @{@"key":[Function getKey],@"order_id":_ordermodel.order_id};
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            if ([obj[@"code"] longLongValue] == 200){
                [MBProgressHUD showSuccess:@"取消成功"];
                //创建一个消息对象
                NSNotification * notice = [NSNotification notificationWithName:@"50" object:nil userInfo:@{
                                                                                                           @"order":@[@"10",@"50"]
                                                                                                           }];
                //发送消息
                [[NSNotificationCenter defaultCenter]postNotification:notice];
            }else{
                NSLog(@"%@",obj[@"msg"]);
                [MBProgressHUD showError:@"取消失败"];
            }
        }else{
            [MBProgressHUD showError:@"网络不给力"];
            
        }
        
    }];
}
-(void)justBuyWithModel:(OrderModel*)model{
    if ([model.payment_id  isEqualToString: @"6"] || [model.payment_id isEqualToString:@"2"]) {
        
        NSDictionary *params2 = @{
                                  @"key"        : [Function getKey],
                                  @"ip2long"    : [LoadDate getIPDress],
                                  @"pay_id"     : model.pay_sn
                                  };
        if ([model.payment_id  isEqualToString: @"2"]) {
            
            [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_PAYMENT, @"zfb_app_pay.html"] param:params2 finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                
                
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
                order.amount = [NSString stringWithFormat:@"%.2lf",[payMoney integerValue] / 100.0f];//商品价格
                
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
                            //创建一个消息对象
                            NSNotification * notice = [NSNotification notificationWithName:@"50" object:nil userInfo:@{
                                                                                                                       @"order":@[@"30",@"50"]
                                                                                                                       }];
                            //发送消息
                            [[NSNotificationCenter defaultCenter]postNotification:notice];
                        }else
                        {
                            
                        }
                    }];
                    
                }
                
                
                
            }];
        }else {
            // 微信支付
            [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_PAYMENT, @"wx_app_pay.html"] param:params2 finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                
                
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = obj[@"data"][@"partnerid"];
                request.prepayId= obj[@"data"][@"prepayid"];
                request.package = obj[@"data"][@"package"];
                request.nonceStr= obj[@"data"][@"noncestr"];
                request.timeStamp= [obj[@"data"][@"timestamp"] intValue];
                request.sign= obj[@"data"][@"sign"];
                
                [WXApi sendReq:request];
                
            }];
            
        }
        
    }
    
    
}
#pragma mark -----订单
-(void)createCollectionView{
    UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    headerFlowLayout.itemSize = CGSizeMake(SYS_SCALE(90), SYS_SCALE(90));
    headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    headerFlowLayout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,SYS_SCALE(50), self.frame.size.width, self.frame.size.height-SYS_SCALE(100)) collectionViewLayout:headerFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.tag = 20;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:self.collectionView];
    
}
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ordermodel.extend_order_goods.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellID = @"UICollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UICollectionViewCell alloc] init];
        
    }
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, cell.frame.size.width-8, cell.frame.size.height)];
    imageV.layer.borderWidth = 1;
    imageV.layer.borderColor = BACKGROUND_COLOR.CGColor;
    ImageWithUrl(imageV, [[self.ordermodel.extend_order_goods objectAtIndex:indexPath.row] objectForKey:@"goods_image"]);
    [cell addSubview:imageV];
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
    NSLog(@"%@",self.orderstate);
    orderDVC.orders_id = self.orderid;
    orderDVC.order_state = self.orderstate;
    [self.viewController.navigationController pushViewController:orderDVC animated:YES];
}

@end
