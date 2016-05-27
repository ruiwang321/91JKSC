//
//  TableViewController.m
//  SlidePageScrollView
//
//  Created by tanyang on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TableViewController.h"
#import "MJRefresh.h"
#import "OrderModel.h"
#import "MeTableViewCell.h"
#import "MoreOrderTableViewCell.h"
#import "OrderDetailViewController.h"
@interface TableViewController ()
/* 我的订单 nsarray**/
//待付款
@property (nonatomic,strong) NSMutableArray *orderArr;
//全部订单
@property (nonatomic,strong) NSMutableArray *allOrderArr;
//代发货订单
@property (nonatomic,strong)NSMutableArray *daifahuoArr;
//待收货订单
@property (nonatomic,strong)NSMutableArray *daishouhuoArr;
//待评价订单
@property (nonatomic,strong)NSMutableArray *daipingjiaArr;
//待退款订单
@property (nonatomic,strong)NSMutableArray *refundArr;

/*全部订单*/
//全部订单
@property (nonatomic,strong)NSDictionary *allOrderDict;
//代发货订单
@property (nonatomic,strong)NSDictionary *daifahuoDict;
//待收货订单
@property (nonatomic,strong)NSDictionary *daishouhuoDict;
//待评价订单
@property (nonatomic,strong)NSDictionary *daipingjiaDict;
//代发货订单
@property (nonatomic,strong)NSDictionary *daifukuanDict;
//待退款订单
@property (nonatomic,strong)NSDictionary *refundDict;

@property (nonatomic,strong)UIView *messageView;

@property (nonatomic,strong)UILabel * titleLabel;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUND_COLOR;
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    __typeof (self) __weak weakSelf = self;
    
//    [self.tableView setTableHeaderView:[self createHeaderView]];
    
//
//    [self.tableView beginUpdates];
//    [self.tableView setTableHeaderView:_messageView];
//    [self.tableView endUpdates];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf delayInSeconds:0 block:^{
                [weakSelf loadDataMyOrder:weakSelf.typeStr andIndex:weakSelf.page andNum:weakSelf.itemNum];
            [weakSelf.tableView.mj_header endRefreshing];
         }];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [weakSelf delayInSeconds:0 block:^{
            weakSelf.itemNum += 4;
            [weakSelf loadDataMyOrder:weakSelf.typeStr andIndex:weakSelf.page andNum:weakSelf.itemNum];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        }];
    }];
   
    [self loadDataMyOrder:self.typeStr andIndex:self.page andNum:self.itemNum];

    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(centerNoti:) name:@"50" object:nil];
    
}
-(void)centerNoti:(NSNotification *)notification{
    
    NSDictionary *nameDictionary = [notification userInfo];
    for (NSString *str in [nameDictionary objectForKey:@"order"]) {
        [self loadDataMyOrder:str andIndex:self.page andNum:self.itemNum];
    }
    
}
-(UIView *)createHeaderView{
    _messageView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_SCALE(25))];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_SCALE(60), 3, SYS_SCALE(19), SYS_SCALE(19))];
    imageV.image = [UIImage imageNamed:@"ic"];
    [_messageView addSubview:imageV];
    
    _titleLabel  = [[UILabel  alloc]initWithFrame:CGRectMake(SYS_SCALE(88), 3, SYS_WIDTH-SYS_SCALE(88), SYS_SCALE(19))];
    _titleLabel.font = SYS_FONT(14);
    
    
    [_messageView addSubview:_titleLabel];
    
    if ([self.typeStr isEqualToString:@"10"]) {
        if (self.orderArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daifukuanDict[@"data"][@"total"]];
            
            return _messageView;
        }else{
            return nil;
        }
    }else if ([self.typeStr isEqualToString:@"20"]){
        if (self.daifahuoArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daifahuoDict[@"data"][@"total"]];
            return _messageView;
        }else{
            
            return nil;
        }
        
    }else if([self.typeStr isEqualToString:@"30"]){
        if (self.daishouhuoArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daishouhuoDict[@"data"][@"total"]];
            return _messageView;
        }else{
            return nil;
        }
        
    }else if([self.typeStr isEqualToString:@"40"]){
        if (self.daipingjiaArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daipingjiaDict[@"data"][@"total"]];
            return _messageView;
        }else{
            return nil;
        }
    }else if ([self.typeStr isEqualToString:@"50"]){
        if (self.allOrderArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_allOrderDict[@"data"][@"total"]];
            return _messageView;
        }else{
            return nil;
        }
    }else{
        if (self.refundArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_refundDict[@"data"][@"total"]];
            return _messageView;
        }else{
            return nil;
        }
    }
}
- (void)delayInSeconds:(CGFloat)delayInSeconds block:(dispatch_block_t) block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC),  dispatch_get_main_queue(), block);
}

#pragma mark- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.typeStr isEqualToString:@"10"]) {
        return self.orderArr.count;
    }else if ([self.typeStr isEqualToString:@"20"]){
        return self.daifahuoArr.count;
    }else if ([self.typeStr isEqualToString:@"30"]){
        return self.daishouhuoArr.count;
    }else if ([self.typeStr isEqualToString:@"40"]){
        return self.daipingjiaArr.count;
    }else if ([self.typeStr isEqualToString:@"50"]){
        return self.allOrderArr.count;
    }else{
        return self.refundArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SYS_SCALE(210);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model;
    
    if ([self.typeStr isEqualToString:@"10"]) {
        model = [self.orderArr objectAtIndex:indexPath.row];
    }else if ([self.typeStr isEqualToString:@"20"]){
        model = [self.daifahuoArr objectAtIndex:indexPath.row];
        
    }else if([self.typeStr isEqualToString:@"30"]){
        model = [self.daishouhuoArr objectAtIndex:indexPath.row];
        
    }else if([self.typeStr isEqualToString:@"40"]){
        model = [self.daipingjiaArr objectAtIndex:indexPath.row];
    }else if([self.typeStr isEqualToString:@"50"]){
        model = [self.allOrderArr objectAtIndex:indexPath.row];
    }else{
        model = [self.refundArr objectAtIndex:indexPath.row];
    }
    if (model.extend_order_goods.count<2) {
        
        static NSString *cellID = @"MeTableViewCell";
        MeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[MeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        [cell createCellWithModel:model andIndex:indexPath.row];
        
        cell.justBtn.tag = indexPath.row+100;
        cell.cancelBtn.tag = indexPath.row;
        
        
        return cell;
    }else{
        static NSString * cellID = @"MoreOrderTableViewCell";
        MoreOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[MoreOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 5;
        [cell createViewWithBaseView:model];
        cell.orderview.justBtn.tag = indexPath.row+100;
        cell.orderview.orderid = model.order_id;
        cell.orderview.cancelBtn.tag = indexPath.row;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderModel *model;
    
    if ([self.typeStr isEqualToString:@"10"]) {
        model = [self.orderArr objectAtIndex:indexPath.row];
    }else if ([self.typeStr isEqualToString:@"20"]){
        model = [self.daifahuoArr objectAtIndex:indexPath.row];
        
    }else if([self.typeStr isEqualToString:@"30"]){
        model = [self.daishouhuoArr objectAtIndex:indexPath.row];
        
    }else if([self.typeStr isEqualToString:@"40"]){
        model = [self.daipingjiaArr objectAtIndex:indexPath.row];
    }else if([self.typeStr isEqualToString:@"50"]){
        model = [self.allOrderArr objectAtIndex:indexPath.row];
    }else{
        model = [self.refundArr objectAtIndex:indexPath.row];
    }
    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];
    
    orderDVC.orders_id =model.order_id;
    orderDVC.order_state =model.order_state;
    if ([self.typeStr isEqualToString:@"60"]) {
        orderDVC.isRefund = YES;
    }else{
        orderDVC.isRefund = NO;
    }
    [self.navigationController pushViewController:orderDVC animated:YES];
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}
#pragma mark ----我的订单列表
-(void)loadDataMyOrder:(NSString *)orderPage andIndex:(NSInteger)indexP andNum:(NSInteger)number{
    
    
    NSString *urlPath = [NSString stringWithFormat:@"%@lists.html",API_ORDER];
    NSDictionary * paramsDic = @{@"key":[Function getKey],@"state":orderPage,@"page":[NSString stringWithFormat:@"%ld",(long)indexP],@"num":[NSString stringWithFormat:@"%ld",(long)number]};
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            
            //obj即为解析后的数据.
            NSMutableArray*oreder = [[NSMutableArray alloc]init];
            if([obj[@"code"] isEqualToNumber:@200]){
                for (NSDictionary *dic in obj[@"data"][@"list"]) {
                    OrderModel *oredermodel = [[OrderModel alloc]init];
                    [oredermodel setValuesForKeysWithDictionary:dic];
                    [oreder addObject:oredermodel];
                }
                
                if (orderPage.longLongValue == 10) {
                    if (indexP == 1) {
                        self.orderArr = oreder;
                    }else{
                        [self.orderArr addObjectsFromArray:oreder];
                    }
                    
                    [self.tableView reloadData];
                    _daifukuanDict = obj;
                    
                }else if (orderPage.longLongValue == 20){
                    if (indexP == 1) {
                        self.daifahuoArr = oreder;
                    }else{
                        [self.daifahuoArr addObjectsFromArray:oreder];
                        
                    }
                    _daifahuoDict = obj;
                    [self.tableView reloadData];
                    
                    
                }else if (orderPage.longLongValue == 30){
                    if (indexP == 1) {
                        self.daishouhuoArr = oreder;
                    }else{
                        [self.daishouhuoArr addObjectsFromArray:oreder];
                        
                    }
                    [self.tableView reloadData];
                    _daishouhuoDict = obj;
                    
                }else if (orderPage.longLongValue == 40){
                    if (indexP == 1) {
                        self.daipingjiaArr = oreder;
                    }else{
                        [self.daipingjiaArr addObjectsFromArray:oreder];
                    }
                    [self.tableView reloadData];
                    _daipingjiaDict = obj;
                }else if (orderPage.longLongValue == 50){
                    if (indexP == 1) {
                        self.allOrderArr = oreder;
                    }else{
                        [self.allOrderArr addObjectsFromArray:oreder];
                    }
                    [self.tableView reloadData];
                    _allOrderDict = obj;
                }else{
                    if (indexP == 1) {
                        self.refundArr = oreder;
                    }else{
                        [self.refundArr addObjectsFromArray:oreder];
                    }
                    [self.tableView reloadData];
                    _refundDict = obj;
                }
                [self createHeaderView];
                [_messageView sizeToFit];
                CGRect newFrame = _messageView.frame;
                newFrame.size.height =  _messageView.frame.size.height;
                _messageView.frame = newFrame;
                [self.tableView setTableHeaderView:_messageView];
            }else if ([obj[@"code"] longLongValue] == 202){
                if (orderPage.longLongValue == 10) {
                    [self.orderArr removeAllObjects];
                    _daifukuanDict = obj;
                    
                   [self.tableView reloadData];
                }else if (orderPage.longLongValue == 20){
                    [self.daifahuoArr removeAllObjects];
                    [self.tableView reloadData];
                    _daifahuoDict = obj;
                    
                }else if (orderPage.longLongValue == 30){
                    [self.daishouhuoArr removeAllObjects];
                    [self.tableView reloadData];
                    
                    _daishouhuoDict = obj;
                    
                }else if (orderPage.longLongValue == 40){
                    [self.daipingjiaArr removeAllObjects];
                    [self.tableView reloadData];
                    _daipingjiaDict = obj;
                }else if (orderPage.longLongValue == 50){
                    [self.allOrderArr removeAllObjects];
                    [self.tableView reloadData];
                    _allOrderDict = obj;
                }else{
                    [self.refundArr removeAllObjects];
                    [self.tableView reloadData];
                    _refundDict = obj;
                }
                _messageView.hidden = YES;
            }
            
            [hud hide:YES];
            
        }else{
            [hud hide:YES];
            [MBProgressHUD showError:@"网络不给力"];
        }
        
    }];
    
}
#pragma mark ---懒加载
-(NSMutableArray *)daipingjiaArr{
    if (!_daipingjiaArr) {
        _daipingjiaArr = [[NSMutableArray alloc]init];
    }
    return _daipingjiaArr;
}
-(NSMutableArray *)daishouhuoArr{
    if (!_daishouhuoArr) {
        _daishouhuoArr = [[NSMutableArray alloc]init];
        
    }
    return _daishouhuoArr;
}
-(NSMutableArray *)daifahuoArr{
    if (!_daifahuoArr) {
        _daifahuoArr = [[NSMutableArray alloc]init];
        
    }
    return _daifahuoArr;
}
-(NSMutableArray *)allOrderArr{
    if (!_allOrderArr) {
        _allOrderArr = [[NSMutableArray alloc]init];
        
    }
    return _allOrderArr;
}
-(NSMutableArray *)orderArr{
    if (!_orderArr) {
        _orderArr = [[NSMutableArray alloc]init];
    }
    return _orderArr;
}

-(NSMutableArray *)refundArr{
    if (!_refundArr) {
        _refundArr = [[NSMutableArray alloc]init];
    }
    return _refundArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
