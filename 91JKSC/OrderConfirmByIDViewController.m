//
//  OrderConfirmByIDViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "OrderConfirmByIDViewController.h"
#import "OrderListCell.h"

#import "GoodsModel.h"
#import "ShowAddressViewController.h"
#import "AddAddressViewController.h"
#import "TradeDetailViewController.h"
#import "TradeModel.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WebViewController.h"
#import "OrderDetailViewController.h"
@interface OrderConfirmByIDViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate> {
    
    UITableView *_orderList; // 订单商品列表
    UIButton *_aliSel;
    UIButton *_wechatSel;
    UILabel *_payMoneyLabel;

    UITextField *_callSeller;
    NSDictionary *messageDict;
    BOOL isLight;
    NSString * callText;
}
/**
 *  商品列表数据源
 */
@property (nonatomic, strong) NSMutableArray *goodsDataSource;
@property (nonatomic ,strong)UILabel *numLabel;
@property (nonatomic ,assign)NSInteger indexNum;
@end

@implementation OrderConfirmByIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _indexNum = 1;
    isLight = YES;
    [self createNavBar];
    [self createPayBar];
    [self createTabelView];
    [self jsonToModel];

}

- (void)viewWillAppear:(BOOL)animated {
    [_orderList reloadData];
}

- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.text = @"订单确认";
    titleView.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}

- (void)createTabelView {
    _orderList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    _orderList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderList.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
    _orderList.delegate = self;
    _orderList.dataSource = self;
    [self.view addSubview:_orderList];
}

- (void)createPayBar {
    UILabel *yingfujineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, SYS_HEIGHT - 34, 80, 15)];
    yingfujineLabel.text = @"应付金额：";
    yingfujineLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    yingfujineLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:yingfujineLabel];
    
    _payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, SYS_HEIGHT - 34, 120, 15)];
    _payMoneyLabel.textColor = BackGreenColor;
    _payMoneyLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_payMoneyLabel];
    
    _payMoneyLabel.text = [NSString stringWithFormat:@"￥%@",_jsonObj[@"list"][0][@"price"][@"order"]];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payBtn.frame = CGRectMake(SYS_WIDTH - 100, SYS_HEIGHT - 44, 90, 37);
    [payBtn setTitle:@"确认并付款" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    payBtn.backgroundColor = BackGreenColor;
    [self.view addSubview:payBtn];
    
    
}

#pragma mark - 数据实例化
- (void)jsonToModel {
    if ([_jsonObj[@"address"] count] == 0) {
        _haveAddress = NO;
    }else {
        _haveAddress = YES;
        [self.addressModel setValuesForKeysWithDictionary:_jsonObj[@"address"]];
    }
    [self.goodsDataSource removeAllObjects];
    for (NSDictionary *arrDic in _jsonObj[@"list"][0][@"goods"]) {
        GoodsModel *model = [[GoodsModel alloc] init];
        [model setValuesForKeysWithDictionary:arrDic];
        
        [self.goodsDataSource addObject:model];
    }
    
    
    // 数据实例化完成 刷新表格
    [_orderList reloadData];
}

// 返回
- (void)dismissMyself {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求（更改商品数量）
- (void)testHttpMsPostBuy {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中"];
    
    NSString *urlPath = [NSString stringWithFormat:@"%@addById.html",API_ORDER];

    NSDictionary * paramsDic = @{@"key":[Function getKey],@"goods_id":[_goodsDataSource[0] goods_id],@"num":[NSString stringWithFormat:@"%ld",_indexNum],@"select_spec":[_goodsDataSource[0] select_spec]};
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        [hud hide:YES];
        if (error == nil) {
            //obj即为解析后的数据.

            if ([obj[@"code"] longLongValue] == 200) {
                _jsonObj = obj[@"data"];
                [self.goodsDataSource removeAllObjects];
                for (NSDictionary *arrDic in obj[@"data"][@"list"][0][@"goods"]) {
                    GoodsModel *model = [[GoodsModel alloc] init];
                    [model setValuesForKeysWithDictionary:arrDic];
                    
                    [self.goodsDataSource addObject:model];
                }
                
                _payMoneyLabel.text = [NSString stringWithFormat:@"￥%@",_jsonObj[@"list"][0][@"price"][@"order"]];
                
                // 数据实例化完成 刷新表格
                [_orderList reloadData];
            }
            
            
        }else{
            [MBProgressHUD showError:@"亲，网络不给力呀~"];
        }
        
    }];
}

#pragma mark - tableView数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isShow == YES) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            return self.goodsDataSource.count;
        }
        case 2: {
            return 1;
        }
        
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderListCell *cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.layer.cornerRadius = 4;
    // 取消cell点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 给每行cell添加子控件
    switch (indexPath.section) {
        case 0: {// 收货地址
            if (self.isHaveAddress == YES) {
                // 有收货地址 显示默认收货地址
                UIImageView *localImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location"]];
                localImage.frame = CGRectMake(2, 29, 27, 27);
                [cell.contentView addSubview:localImage];
                
                UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(SYS_WIDTH - 48, 30, 22, 22)];
                moreImg.image = [UIImage imageNamed:@"more"];
                [cell.contentView addSubview:moreImg];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 15, 85, 16)];
                nameLabel.font = [UIFont systemFontOfSize:16];
                nameLabel.textColor = RGB(64, 64, 64);
                [cell.contentView addSubview:nameLabel];
                
                UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 200, 15, 110, 16)];
                phoneLabel.font = [UIFont systemFontOfSize:16];
                nameLabel.textColor = RGB(64, 64, 64);
                [cell.contentView addSubview:phoneLabel];
                
                UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 50, SYS_WIDTH - 50, 14)];
                addressLabel.font = [UIFont systemFontOfSize:14];
                addressLabel.textColor = RGB(160, 160, 160);
                [cell.contentView addSubview:addressLabel];
                
                nameLabel.text = self.addressModel.true_name;
                phoneLabel.text = self.addressModel.mob_phone;
                addressLabel.text = [NSString stringWithFormat:@"%@%@",self.addressModel.area_info, self.addressModel.address];
                
            }else {
                // 无收货地址 提示添加
                cell.textLabel.text = @"请添加收货地址";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
                UIImageView *moreImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
                moreImg.frame = CGRectMake(SYS_WIDTH - 48, 14, 22, 22);
                [cell.contentView addSubview:moreImg];
            }
            break;
        }
        case 1: {// 商品
            // 不可变子控件
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 8, 1, 66)];
            lineView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
            [cell.contentView addSubview:lineView];
            
            UILabel *shuliangLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 40, 11)];
            shuliangLabel.font = [UIFont systemFontOfSize:11];
            shuliangLabel.textColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1];
            [cell.contentView addSubview:shuliangLabel];
            
            UILabel *xuanxiangLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 35, SYS_WIDTH - 200, 11)];
            xuanxiangLabel.font = [UIFont systemFontOfSize:11];
            xuanxiangLabel.textColor = [UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1];
            [cell.contentView addSubview:xuanxiangLabel];
            
            UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(SYS_WIDTH - 48, 30, 22, 22)];
            moreImg.image = [UIImage imageNamed:@"more"];
            [cell.contentView addSubview:moreImg];
            // 商品图
            UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 8, 80, 66)];
            [cell.contentView addSubview:goodsImg];
            
            // 商品名称
            UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, SYS_WIDTH - 125, 13)];
            goodsName.font = [UIFont systemFontOfSize:13];
            goodsName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
            [cell.contentView addSubview:goodsName];
            
            // 商品价格
            UILabel *goodsMoney = [[UILabel alloc] initWithFrame:CGRectMake(100, 55, 100, 13)];
            goodsMoney.textColor = BackGreenColor;
            goodsMoney.font = [UIFont systemFontOfSize:13];
            [cell.contentView addSubview:goodsMoney];
            
            // ----------------------赋值-----------------
//            goodsImg.image = [UIImage imageNamed:@"商品图"];
             ImageWithUrl(goodsImg, [self.goodsDataSource[indexPath.row] goods_image]);
            goodsName.text = [self.goodsDataSource[indexPath.row] goods_name];
            goodsMoney.text = [NSString stringWithFormat:@"%@",[self.goodsDataSource[indexPath.row] goods_price]];
            shuliangLabel.text = [NSString stringWithFormat:@"数量:%@",[self.goodsDataSource[indexPath.row] goods_num]];
            xuanxiangLabel.text = [self.goodsDataSource[indexPath.row] goods_jingle];
            break;
        }
        case 2: {// 支付
            // 横线
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, SYS_WIDTH - 20, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
            [cell.contentView addSubview:lineView];
            
            cell.userInteractionEnabled = YES;
            // 支付宝支付
           
            
            UIImageView *aliImg = [[UIImageView alloc] initWithFrame:CGRectMake(28, 3, 46, 46)];
            aliImg.userInteractionEnabled = YES;
            aliImg.image = [UIImage imageNamed:@"支付宝"];
            [cell.contentView addSubview:aliImg];
            
            UILabel *aliName = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 100, 15)];
            aliName.text = @"支付宝支付";
            aliName.font = [UIFont systemFontOfSize:15];
            aliName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
            [cell.contentView addSubview:aliName];
            
            UILabel *aliMsg = [[UILabel alloc] initWithFrame:CGRectMake(80, 29, 200, 13)];
            aliMsg.text = @"推荐支付宝用户使用";
            aliMsg.font = [UIFont systemFontOfSize:13];
            aliMsg.textColor = [UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1];
            [cell.contentView addSubview:aliMsg];
            _aliSel = [UIButton buttonWithType:UIButtonTypeCustom];
            _aliSel.frame = CGRectMake(6, 15, 22, 22);
            [_aliSel setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            _aliSel.selected = isLight;
            [_aliSel setImage:[UIImage imageNamed:@"select-green"] forState:UIControlStateSelected];
            [_aliSel addTarget:self action:@selector(paymentSel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_aliSel];
            // 微信支付
            
            
            UIImageView *wechatImg = [[UIImageView alloc] initWithFrame:CGRectMake(28, 56, 46, 46)];
            wechatImg.userInteractionEnabled = YES;
            wechatImg.image = [UIImage imageNamed:@"wechat"];
            [cell.contentView addSubview:wechatImg];
            
            UILabel *wechatName = [[UILabel alloc] initWithFrame:CGRectMake(80, 63, 100, 15)];
            wechatName.text = @"微信支付";
            wechatName.font = [UIFont systemFontOfSize:15];
            wechatName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
            [cell.contentView addSubview:wechatName];
            
            UILabel *wechatMsg = [[UILabel alloc] initWithFrame:CGRectMake(80, 82, 200, 13)];
            wechatMsg.text = @"操作简单易用，支持大额支付";
            wechatMsg.font = [UIFont systemFontOfSize:13];
            wechatMsg.textColor = [UIColor colorWithRed:194/255.0f green:194/255.0f blue:194/255.0f alpha:1];
            [cell.contentView addSubview:wechatMsg];
            _wechatSel = [UIButton buttonWithType:UIButtonTypeCustom];
            _wechatSel.frame =CGRectMake(6, 68, 22, 22);
            [_wechatSel setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
            [_wechatSel setImage:[UIImage imageNamed:@"select-green"] forState:UIControlStateSelected];
            _wechatSel.selected = !isLight;
            [_wechatSel addTarget:self action:@selector(paymentSel:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_wechatSel];
            
            break;
        }
        default:
            break;
    }
    return cell;
}

-(void)changeColor:(UIButton *)btn{

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.isHaveAddress) {
            // 跳转显示地址页面
            ShowAddressViewController *showVC = [[ShowAddressViewController alloc] init];
            showVC.selMoedel = _addressModel;
            showVC.orderVC = self;
            [self.navigationController pushViewController:showVC animated:YES];
        }else {
            // 跳转添加地址页面 并自动设置成默认地址
            AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
            addVC.setDefault = YES;
            addVC.orderVC = self;
            [self.navigationController pushViewController:addVC animated:YES];
        }
    }else if(indexPath.section == 1){
        TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
        [self.navigationController pushViewController:tradeDetailVC animated:YES];

        tradeDetailVC.goods_id = _jsonObj[@"list"][0][@"goods"][0][@"goods_id"];
        
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[OrderListCell class]]) {
        // 下面这几行代码是用来设置cell的上下行线的位置
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        //按照作者最后的意思还要加上下面这一段，才能做到底部线控制位置，所以这里按stackflow上的做法添加上吧。
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == _orderList) {
            // 圆角弧度半径
            
            
            CGFloat cornerRadius = 5.f;
            // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
            cell.backgroundColor = UIColor.clearColor;
            
            // 创建一个shapeLayer
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
            // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
            CGMutablePathRef pathRef = CGPathCreateMutable();
            // 获取cell的size
            CGRect bounds = CGRectInset(cell.bounds, 0, 0);
            
            // CGRectGetMinY：返回对象顶点坐标
            // CGRectGetMaxY：返回对象底点坐标
            // CGRectGetMinX：返回对象左边缘坐标
            // CGRectGetMaxX：返回对象右边缘坐标
            
            // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
            BOOL addLine = NO;
            
            if ([tableView numberOfRowsInSection:indexPath.section]-1 == 0) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                addLine = NO;
            }else if (indexPath.row == 0 ) {
                // 初始起点为cell的左下角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            }else  if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                // 初始起点为cell的左上角坐标
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                // 添加cell的rectangle信息到path中（不包括圆角）
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
            layer.path = pathRef;
            backgroundLayer.path = pathRef;
            // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
            CFRelease(pathRef);
            // 按照shape layer的path填充颜色，类似于渲染render
            // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            layer.fillColor = [UIColor whiteColor].CGColor;
            // 添加分隔线图层
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                // 分隔线颜色取自于原来tableview的分隔线颜色
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            
            // view大小与cell一致
            UIView *roundView = [[UIView alloc] initWithFrame:bounds];
            // 添加自定义圆角后的图层到roundView中
            [roundView.layer insertSublayer:layer atIndex:0];
            roundView.backgroundColor = UIColor.clearColor;
            //cell的背景view
            //cell.selectedBackgroundView = roundView;
            cell.backgroundView = roundView;
            
            //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
            UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
            backgroundLayer.fillColor = tableView.separatorColor.CGColor;
            [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
            selectedBackgroundView.backgroundColor = UIColor.clearColor;
            cell.selectedBackgroundView = selectedBackgroundView;
        }
    }
}

#pragma mark tableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height[] = {self.isHaveAddress? 85 : 50, 82, 105};
    return height[indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 175;
    }else{
        return CGFLOAT_MIN;
    }
}
#pragma mark tableView组脚视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        footerView.backgroundColor = [UIColor clearColor];
        // 创建合计统计View
        UIView *totalView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SYS_WIDTH - 20, 175)];
        totalView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        [footerView addSubview:totalView];
        
        
        
        UILabel *goumaiNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 10, 60, 15)];
        goumaiNumLabel.text = @"购买数量";
        goumaiNumLabel.font = [UIFont systemFontOfSize:15];
        goumaiNumLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        [totalView addSubview:goumaiNumLabel];
        // 统计View中不变子控件
        UILabel *hejiLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 45, 35, 15)];
        hejiLabel.text = @"合计";
        hejiLabel.font = [UIFont systemFontOfSize:15];
        hejiLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        [totalView addSubview:hejiLabel];
        
        UILabel *youfeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 70, 35, 15)];
        youfeiLabel.text = @"邮费";
        youfeiLabel.font = [UIFont systemFontOfSize:15];
        youfeiLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        [totalView addSubview:youfeiLabel];
        
        UIView *hengxianView = [[UIView alloc] initWithFrame:CGRectMake(17, 96, SYS_WIDTH - 54, 1)];
        hengxianView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
        [totalView addSubview:hengxianView];
        
        UILabel *dingdanzongeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 105, 60, 20)];
        dingdanzongeLabel.text = @"订单总额";
        dingdanzongeLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        dingdanzongeLabel.font = [UIFont boldSystemFontOfSize:15];
        [totalView addSubview:dingdanzongeLabel];
        
        UIImageView*imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_WIDTH - 105, 10, 75, 28)];
        imageV.image = [UIImage imageNamed:@"img_orderconfirm_num(1)"];
        imageV.userInteractionEnabled = YES;
        [totalView addSubview:imageV];
        
        UIButton * jianBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jianBtn.frame = CGRectMake(0, 0, 26, 28);
        jianBtn.tag =600;
        jianBtn.backgroundColor = [UIColor clearColor];
        [jianBtn addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:jianBtn];
        
        UIButton *jiaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        jiaBtn.frame = CGRectMake(47, 0, 26, 28);
         jiaBtn.tag =601;
        jiaBtn.backgroundColor = [UIColor clearColor];
        [jiaBtn addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
        [imageV addSubview:jiaBtn];
        self.numLabel  = [[UILabel alloc]initWithFrame:CGRectMake(26, 0, 23, 28)];
        _numLabel.text = [NSString stringWithFormat:@"%ld",_indexNum];
        self.numLabel.font = [UIFont systemFontOfSize:11];
        self.numLabel.adjustsFontSizeToFitWidth = YES;
        self.numLabel.textAlignment =NSTextAlignmentCenter;
        [imageV addSubview:self.numLabel];
        
        
        
        
        
        // 商品合计金额Lebel
        UILabel *_goodsMoney = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 145, 45, 120, 15)];
        _goodsMoney.font = [UIFont systemFontOfSize:SYS_SCALE(15)];
        _goodsMoney.textAlignment = NSTextAlignmentRight;
        
        _goodsMoney.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        [totalView addSubview:_goodsMoney];
        
        // 邮费Lebel
        UILabel *_postage = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 145, 70, 120, 15)];
        _postage.font = [UIFont systemFontOfSize:SYS_SCALE(15)];
        
         _postage.textAlignment = NSTextAlignmentRight;
        _postage.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
        [totalView addSubview:_postage];
        
        // 订单总金额
        UILabel *_totalMoney = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 145, 105, 120, 15)];
        _totalMoney.font = [UIFont boldSystemFontOfSize:SYS_SCALE(15)];
        _totalMoney.textAlignment = NSTextAlignmentRight;
        _totalMoney.textColor = BackGreenColor;
        [totalView addSubview:_totalMoney];
        
        // 留言给卖家
         _callSeller= [[UITextField alloc] initWithFrame:CGRectMake(17, 132, SYS_WIDTH - 54, 36)];
        _callSeller.backgroundColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1];
        _callSeller.placeholder = @"留言给卖家";
        _callSeller.text = callText;
        _callSeller.layer.cornerRadius = 4;
        _callSeller.delegate = self;
        [totalView addSubview:_callSeller];
        
        
        
        _goodsMoney.text = [NSString stringWithFormat:@"￥%@",_jsonObj[@"list"][0][@"price"][@"goods"]];
        _postage.text = [NSString stringWithFormat:@"￥%@",_jsonObj[@"list"][0][@"price"][@"freight"]];
        _totalMoney.text = [NSString stringWithFormat:@"￥%@",_jsonObj[@"list"][0][@"price"][@"order"]];
        return footerView;
    }else{
        return nil;
    }
}
-(void)changeNumber:(UIButton *)btn{
   
    if (btn.tag ==601) {
        _indexNum++;

    }else{
        if (_indexNum == 1) {

            return;
        }
        _indexNum--;
        
    }
    [self testHttpMsPostBuy];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @[@"收货地址", @"", @"选择支付方式"][section];
}
#pragma mark 支付方式选择
- (void)paymentSel:(UIButton *)btn {
    isLight = !isLight;
    btn.selected = YES;
    if ([btn isEqual:_aliSel]) {
        _wechatSel.selected = !btn.selected;
    }else {
        _aliSel.selected = !btn.selected;
    }
}

#pragma mark - 懒加载
- (AddressModel *)addressModel {
    if (_addressModel == nil) {
        _addressModel = [[AddressModel alloc] init];
    }
    return _addressModel;
}

- (NSArray *)goodsDataSource {
    if (_goodsDataSource == nil) {
        _goodsDataSource = [NSMutableArray array];
    }
    return _goodsDataSource;
}

#pragma mark - 按钮点击事件
#pragma mark 订单支付
- (void)payBtnClicked {
  

    if (_wechatSel.selected || _aliSel.selected) {
        
        NSMutableDictionary *goodsDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *goodsSpec = [NSMutableDictionary dictionary];
        for (GoodsModel *modle in self.goodsDataSource) {
            [goodsDic setValue:modle.goods_num forKey:modle.goods_id];
            [goodsSpec setValue:modle.select_spec forKey:modle.goods_id];
        }
        
        NSDictionary *dic = @{
                              @"store_id"   :@"15",
                              @"goods"      :goodsDic,
                              @"select_spec":goodsSpec,
                              @"message"    :_callSeller.text?_callSeller.text:@""
                              };
        NSMutableArray *arr = [NSMutableArray arrayWithObject:dic];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:kNilOptions error:nil];
        NSString *goods = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString *goods_arr = [NSString stringWithFormat:@"%@",goods];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",API_ORDER,@"addSure.html"];

        NSDictionary *params;
        if ([Function getKey]&&_addressModel.address_id&&goods_arr.length >0) {
            params= @{
                      @"key"         :[Function getKey],
                      @"address_id"  :_addressModel.address_id,
                      @"payment_id"  :_aliSel.selected ? @"2" : @"6" ,
                      @"goods_arr"   :goods_arr
                      };

        }else{
            [MBProgressHUD showError:@"请输入完整信息"];
        }
        
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
 
            NSLog(@"%@",self.navigationController.viewControllers);
            messageDict = obj ;
            if ([obj[@"code"] longLongValue] ==200){
                
                NSDictionary *params2 = @{
                                          @"key"        : [Function getKey],
                                          @"ip2long"    : [LoadDate getIPDress],
                                          @"pay_id"     : obj[@"data"][0][@"pay_id"]
                                          };
                if (_aliSel.selected == YES) {
                    
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
                                    [self.navigationController popViewControllerAnimated:YES];
                                    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
                                    orderDVC.orders_id = messageDict[@"data"][0][@"order_id"];
                                    orderDVC.order_state =@"20";
                                    [self.navigationController pushViewController:orderDVC animated:NO];
                                    // 成功
//                                   [MBProgressHUD showSuccess:@"支付成功"];
                                }else
                                {
                                    [self.navigationController popViewControllerAnimated:YES];
                                    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
                                    orderDVC.orders_id = messageDict[@"data"][0][@"order_id"];
                                    
                                    orderDVC.order_state = @"10";
                                    [self.navigationController pushViewController:orderDVC animated:NO];
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
                            
                            PayReq *request = [[PayReq alloc] init];
                            request.partnerId = obj[@"data"][@"partnerid"];
                            request.prepayId= obj[@"data"][@"prepayid"];
                            request.package = obj[@"data"][@"package"];
                            request.nonceStr= obj[@"data"][@"noncestr"];
                            request.timeStamp= [obj[@"data"][@"timestamp"] intValue];
                            request.sign= obj[@"data"][@"sign"];
                            
                            [WXApi sendReq:request];
                            

                            [(AppDelegate *)[UIApplication sharedApplication].delegate  isTrue:^(BOOL right){
                                if (right) {
                                    [self.navigationController popViewControllerAnimated:YES];
                                    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
                                    orderDVC.orders_id = messageDict[@"data"][0][@"order_id"];
                                    
                                    orderDVC.order_state = @"20";
                                    [self.navigationController pushViewController:orderDVC animated:NO];
                                    
                                }else{
                                    [self.navigationController popViewControllerAnimated:YES];
                                    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
                                    orderDVC.orders_id = messageDict[@"data"][0][@"order_id"];
                                    
                                    orderDVC.order_state = @"10";
                                    [self.navigationController pushViewController:orderDVC animated:NO];
                                    
                                }
                            }];
                            
                            
                        }];
                        

                    }else{
                        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您未安装微信，是否安装" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                        alertV.tag =30;
                        [alertV show];
                    }
                }
                
            }
        
        }];
        
    
    }else {
        [MBProgressHUD showError:@"请选择支付方式"];
    
    }
    
}
-(void)getOrderID:(getOrderID)block{
    self.orderIDblock = block;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    CGFloat ofset = self.view.frame.size.height - (_callSeller.frame.origin.y + _callSeller.frame.size.height+600);

    if (ofset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y  = ofset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y  = 0.0;
        self.view.frame = frame;
    }];
    callText = textField.text;
    return YES;
}
#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *wxurl = [NSURL URLWithString:[WXApi getWXAppInstallUrl]];
        [[UIApplication sharedApplication] openURL:wxurl];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
