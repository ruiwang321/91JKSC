//
//  ShoppingCartViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "UIView+SHCZExt.h"
#import "OrderConfirmViewController.h"
#import "GoodsModel.h"
#import "GoodsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "TradeDetailViewController.h"
#import "TradeModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "CartBadgeSingleton.h"
#import "SpecView.h"

@interface ShoppingCartViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UIGestureRecognizerDelegate> {
    
    NSMutableArray *_dataArray; // 合格商品数据源
    
    NSMutableArray *_badDataArray; // 不合格商品数据源
    
    NSMutableArray *_allDataArray; // 所有商品数据源
    
    UIButton *_allSelBtn; // 购物车全选按钮
    
    UIView *_payBar; // 支付条
    
    NSArray *_specArr; //商品规格
    
    int   allCount;
    float   allPrice;
    BOOL isHaveNav;
    
}
/**
 *  购物车商品列表
 */
@property (nonatomic, strong) UITableView *shopsList;
/**
 *  支付总金额
 */
@property (nonatomic, strong) UILabel *totalAmount;
/**
 *  保存购物车选项信息的字典
 */
@property (nonatomic, strong) NSMutableArray *selLogArr;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createListView];
    [self createPayBar];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    _selLogArr = [NSMutableArray array];
   
}

- (void)viewWillAppear:(BOOL)animated {
    if (!isHaveNav) {
        [self createNavBar];
    }
   
    [self refreshData];
    
}

// 创建导航条
- (void)createNavBar { 
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"购物车";
    titleLabel.textColor = [UIColor whiteColor];
    if (_isPush) {
        [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
    }else {
        [self createNavWithLeftImage:@"item" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
    }
    isHaveNav = YES;
}
// 创建底部支付条
- (void)createPayBar {
    if (_payBar == nil && _dataArray.count > 0) {
        _payBar = [[UIView alloc] initWithFrame:CGRectMake(0, SYS_HEIGHT - 50, SYS_WIDTH, 50)];
        _payBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_payBar];
        
        // 全选Button
        _allSelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 60, 22)];
        [_allSelBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allSelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allSelBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        [_allSelBtn setImage:[UIImage imageNamed:@"select-green"] forState:UIControlStateSelected];
        [_allSelBtn addTarget:self action:@selector(allSelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_payBar addSubview:_allSelBtn];
        
        // 支付Button
        UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(SYS_WIDTH - 100, 6, 90, 37)];
        [payButton setTitle:@"去支付" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(gotoOrderConfirm) forControlEvents:UIControlEventTouchUpInside];
        payButton.backgroundColor = BackGreenColor;
        [_payBar addSubview:payButton];
        
        // 合计Label
        UILabel *totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 220, 15, 55, 22)];
        totalLabel.text = @"合计：";
        [_payBar addSubview:totalLabel];
        
        // 总金额
        _totalAmount = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH - 175, 15, 70, 22)];
        _totalAmount.text = @"￥0.00";
        _totalAmount.textColor = BackGreenColor;
        _totalAmount.adjustsFontSizeToFitWidth = YES;
        [_payBar addSubview:_totalAmount];
    }
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 54321) {
        [self createPayBar];
        return _allDataArray.count;

    }
    return _specArr?_specArr.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 54321) {
        NSString *reuseId = @"goodsCell";
        GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[GoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            
            [cell.goodsSelBtn addTarget:self action:@selector(goodsSelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.removeBtn addTarget:self action:@selector(removeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.goodsImageView addTarget:self action:@selector(goodsGoToDetail:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        cell.goodsSelBtn.tag = indexPath.row + 5000;
        cell.removeBtn.tag = indexPath.row + 100;
        cell.editBtn.tag = indexPath.row + 200;
        cell.goodsImageView.tag = indexPath.row + 300;
        
        
        cell.model = _allDataArray[indexPath.row];
        return cell;
    }
    UITableViewCell *specCell = [tableView dequeueReusableCellWithIdentifier:@"specCell"];
    if (specCell == nil) {
        specCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"specCell"];
        specCell.textLabel.text = _specArr[indexPath.row];
    }
    return specCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 54321) {
        return 145.0f;
    }
    return 175/3.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 54321) {
        
    }else {
        UIButton *optionBtn = [[[UIApplication sharedApplication].delegate window] viewWithTag:700];
        [optionBtn setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forState:UIControlStateNormal];
        [tableView removeFromSuperview];
    }
}

#pragma mark - 创建表格
- (void)createListView {

    _shopsList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    _shopsList.tag = 54321;
    _shopsList.delegate = self;
    _shopsList.dataSource = self;
    _shopsList.backgroundColor = BACKGROUND_COLOR;
    _shopsList.separatorStyle = UITableViewCellSeparatorStyleNone;
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    _shopsList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
        
    }];
    
    _shopsList.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    _shopsList.emptyDataSetDelegate = self;
    _shopsList.emptyDataSetSource = self;

    [self.view addSubview:_shopsList];
}

#pragma mark - 列表空显示页面代理和数据源方法

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    // 移除支付bar
    [_payBar removeFromSuperview];
    _allSelBtn = nil;
    _payBar = nil;
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
    emptyView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 227, 166)];
    emptyImgView.image = [UIImage imageNamed:@"img_cart_null"];
    emptyImgView.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT * 0.3);
    [emptyView addSubview:emptyImgView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 0, 130, 50);
    homeButton.center = CGPointMake(SYS_WIDTH / 2, CGRectGetMaxY(emptyImgView.frame) + 30);
    [homeButton setImage:[UIImage imageNamed:@"img_go_maintab"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    homeButton.layer.cornerRadius = 5;
    
    [emptyView addSubview:homeButton];
    
    return emptyView;
}

#pragma mark ----- 菜单按钮的点击事件
-(void)leftBtn:(UIButton *)btn
{
    if (_isPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}


#pragma mark - 按钮点击事件
- (void)gotoOrderConfirm {
    if (_selLogArr.count <= 0) {
        [MBProgressHUD showError:@"您还未选中任何商品"];
        return;
    }
    // 网络请求订单列表

    NSMutableArray *cartsArr = [NSMutableArray array];
    for (GoodsModel *model in _selLogArr) {
        if (model.goods_state.boolValue && model.goods_verify.boolValue) {
            [cartsArr addObject:model.cart_id];
        }
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:cartsArr options:kNilOptions error:nil];
    NSString *cart_ids = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{
                             @"key"     :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                             @"cart_id" :cart_ids
                             };

    [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_ORDER,@"addByCart.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {

        if ([obj[@"code"] longLongValue] == 200) {
            OrderConfirmViewController *orderConfVC = [[OrderConfirmViewController alloc] init];
            
            orderConfVC.jsonObj = obj[@"data"];
            [self.navigationController pushViewController:orderConfVC animated:YES];
        }else{
            [MBProgressHUD show:obj[@"msg"] icon:nil view:self.view];
        }
    }];
    
    
    
    
}

- (void)homeButtonClicked {
    if (_isPush) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        self.tabBarController.selectedIndex = 0;
    }
}

#pragma mark cell内按钮点击事件
// 移除按钮点击事件
- (void)removeBtnClicked:(UIButton *)btn {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要删除这个宝贝吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
   
    alertView.tag = btn.tag;
    
    [alertView show];
}
// 编辑按钮点击事件
- (void)editBtnClicked:(UIButton *)btn {

    [self popEditView:btn.tag - 200];
}

// 点击商品跳转详情页面
- (void)goodsGoToDetail:(UIButton *)btn {
    TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
    TradeModel *model = [_allDataArray objectAtIndex:btn.tag - 300];
    
    tradeDetailVC.goods_id = model.goods_id;
    
    [self.navigationController pushViewController:tradeDetailVC animated:YES];
}

// 弹出编辑View
- (void)popEditView:(NSInteger)row {
    _specArr = [_allDataArray[row] goods_spec];
    // 创建遮罩层
    UIView *maskView = [[UIView alloc] initWithFrame:SYS_BOUNDS];
    maskView.tag = 11111;
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UITapGestureRecognizer *tapReconizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMaskView:)];
    tapReconizer.delegate = self;
    [maskView addGestureRecognizer:tapReconizer];
    
    UIView *editView = [[UIView alloc] initWithFrame:CGRectMake(5, 218, SYS_WIDTH - 10, 175)];
    editView.center = CGPointMake(SYS_WIDTH/2, SYS_HEIGHT/2);
    editView.backgroundColor = [UIColor whiteColor];
    editView.layer.cornerRadius = 3;
    [maskView addSubview:editView];
    
    // 编辑商品Label
    UILabel *bianjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 22, 80, 18)];
    bianjiLabel.text = @"编辑商品";
    bianjiLabel.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    bianjiLabel.font = [UIFont systemFontOfSize:18];
    [editView addSubview:bianjiLabel];
    
    //商品选项Button
    UIButton *goodsOptionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodsOptionsBtn.frame = CGRectMake(6, 58, CGRectGetWidth(editView.frame)-109, 40);
    [goodsOptionsBtn setTitle:[_allDataArray[row] select_spec] forState:UIControlStateNormal];
    goodsOptionsBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    goodsOptionsBtn.layer.cornerRadius = 4;
    goodsOptionsBtn.tag = 700;
    goodsOptionsBtn.backgroundColor = [UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1];
    [goodsOptionsBtn setTitleColor:[UIColor colorWithRed:160/255.0f green:160/255.0f blue:160/255.0f alpha:1] forState:UIControlStateNormal];
    [goodsOptionsBtn addTarget:self action:@selector(goodsOptionsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:goodsOptionsBtn];
    
    // 修改商品数量背景
    UIImageView *numBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_orderconfirm_num(1)"]];
    numBgView.frame = CGRectMake(CGRectGetWidth(editView.frame)-99, CGRectGetMidY(goodsOptionsBtn.frame) - 19, 94, 38);
    numBgView.userInteractionEnabled = YES;
    [editView addSubview:numBgView];
    
    // 加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(62, 0, 32, 38);
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [numBgView addSubview:addBtn];
    
    // 减按钮
    UIButton *decBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    decBtn.frame = CGRectMake(0, 0, 32, 38);
    [decBtn addTarget:self action:@selector(decBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [numBgView addSubview:decBtn];
    
    // 数量输入TextField
    UITextField *numTF = [[UITextField alloc] initWithFrame:CGRectMake(32, 0, 30, 38)];
    numTF.tag = 888;
    numTF.textAlignment = NSTextAlignmentCenter;
    numTF.font = [UIFont systemFontOfSize:12];
    numTF.keyboardType = UIKeyboardTypeNumberPad;
    numTF.text = [_allDataArray[row] goods_num];
    [numBgView addSubview:numTF];
    
    
    // 线条
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 117, SYS_WIDTH - 10, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [editView addSubview:lineView];
    
    // 保存编辑Button
    UIButton *saveBut = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBut.frame = CGRectMake(SYS_WIDTH - 65, 124, 40, 40);
    saveBut.tag = 150 + row;
    [saveBut setTitle:@"保存" forState:UIControlStateNormal];
    [saveBut setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1] forState:UIControlStateNormal];
    [saveBut addTarget:self action:@selector(saveButClicked:) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:saveBut];
    
    // 取消编辑Button
    UIButton *cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBut.frame = CGRectMake(SYS_WIDTH - 130, 124, 40, 40);
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1] forState:UIControlStateNormal];
    [cancelBut addTarget:self action:@selector(cancelButClicked) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:cancelBut];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:maskView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == 11111) {
        return YES;
    }
    return NO;
}

#pragma mark 编辑视图中按钮点击事件
- (void)addBtnClicked {
    UITextField *numTF = [[[UIApplication sharedApplication].delegate window] viewWithTag:888];
    NSInteger num = numTF.text.integerValue;
    numTF.text = [NSString stringWithFormat:@"%ld",++num];
}

- (void)decBtnClicked {
    UITextField *numTF = [[[UIApplication sharedApplication].delegate window] viewWithTag:888];
    NSInteger num = numTF.text.integerValue;
    numTF.text = [NSString stringWithFormat:@"%ld",--num==0?1:num];
}

- (void)goodsOptionsBtnClicked {
    UITableView *optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 218, SYS_WIDTH - 10, 175) style:UITableViewStyleGrouped];
    optionsTableView.tag = 54322;
    optionsTableView.center = CGPointMake(SYS_WIDTH/2, SYS_HEIGHT/2);
    optionsTableView.delegate = self;
    optionsTableView.dataSource = self;
    [[[[UIApplication sharedApplication].delegate window] viewWithTag:11111] addSubview:optionsTableView];

    [optionsTableView reloadData];
    
}
// 遮罩视图手势
- (void)dismissMaskView:(UITapGestureRecognizer *)tap {
    UIView *maskView = [[[UIApplication sharedApplication].delegate window] viewWithTag:11111];
    
    if ([maskView viewWithTag:54322]) {
        [[maskView viewWithTag:54322] removeFromSuperview];
    }else {
        [maskView removeFromSuperview];
    }
}

// 保存编辑按钮点击事件
- (void)saveButClicked:(UIButton *)button {
    UITextField *numTF = [[[UIApplication sharedApplication].delegate window] viewWithTag:888];
    UIButton *optionBtn = [[[UIApplication sharedApplication].delegate window] viewWithTag:700];
    NSString *url = [NSString stringWithFormat:@"%@%@",API_CART,@"add.html"];
    NSDictionary *params = @{
                             @"key"         :[Function getKey],
                             @"goods_id"     :[_allDataArray[button.tag - 150] goods_id],
                             @"num"         :[NSString stringWithFormat:@"%ld",numTF.text.integerValue - [_allDataArray[button.tag - 150] goods_num].integerValue],
                             @"select_spec" :[[[[[UIApplication sharedApplication].delegate window] viewWithTag:700] titleLabel] text]
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
//            [_allDataArray[button.tag - 150] setGoods_num:numTF.text];
//            [_allDataArray[button.tag - 150] setSelect_spec:optionBtn.titleLabel.text];
//            [_shopsList reloadData];
            // 重新加载购物车列表
            [self loadData];
            [[[[UIApplication sharedApplication].delegate window] viewWithTag:11111] removeFromSuperview];
        }
    }];

}

- (void)cancelButClicked {
    [[[[UIApplication sharedApplication].delegate window] viewWithTag:11111] removeFromSuperview];
}

#pragma mark 单选按钮
- (void)goodsSelBtnClicked:(UIButton *)btn {
    
    GoodsModel *model = _allDataArray[btn.tag - 5000];
    if (!model.isSel) {
        
        btn.selected = YES;
        
        float price = [model.goods_num intValue]*[model.goods_price floatValue];
        model.isSel = YES;
        allPrice = allPrice + price;
        _totalAmount.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
        
    }else{
        
        btn.selected = NO;
        
        model.isSel = NO;
        float price = [model.goods_num intValue]*[model.goods_price floatValue];
        allPrice = allPrice - price;
        _totalAmount.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
        
    }
    
    if ([_selLogArr containsObject:model]) {
        
        [_selLogArr removeObject:model];
    }else{
        
        [_selLogArr addObject:model];
    }

    if (_dataArray.count == _selLogArr.count) {
        _allSelBtn.selected = YES;
    }else {
        _allSelBtn.selected = NO;
    }
    NSLog(@"总共：%ld选中：%ld",_dataArray.count,_selLogArr.count);
}
#pragma mark  全选按钮
- (void)allSelBtnClicked:(UIButton *)button {
    
    [_selLogArr removeAllObjects];
    if (!button.isSelected) {
        button.selected = YES;
        for (int i=0; i<_dataArray.count; i++) {
            

            [_dataArray[i] setIsSel:YES];
            
            
            
        }
        [_selLogArr addObjectsFromArray:_dataArray];
        [self caculateAllPrice];
        
    }else{
        button.selected = NO;
        for (int i=0; i<_dataArray.count; i++) {
            [_dataArray[i] setIsSel:NO];
            _totalAmount.text = @"￥0.00";
            allPrice = 0.00;
            
        }
    }
    NSLog(@"总共：%ld选中：%ld",_dataArray.count,_selLogArr.count);
    [_shopsList reloadData];
}
#pragma mark 计算总价

-(void)caculateAllPrice
{
    //取到数量和单价
    allCount=0;
    allPrice=0.0f;
    
    for (int i = 0; i<_dataArray.count; i++) {
        GoodsModel *model = _dataArray[i];
        NSLog(@"%@",model.goods_num);
        NSLog(@"%@",model.goods_price);
        float danPrice=0.0f;
        danPrice = [model.goods_num intValue] *[model.goods_price floatValue];
        allPrice =allPrice + danPrice;
    }
    _totalAmount.text = [NSString stringWithFormat:@"￥%.2f",allPrice];
    
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        if (buttonIndex == 1) {
            NSDictionary *params = @{
                                     @"key"     :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                     @"cart_id" :[_allDataArray[alertView.tag - 100] cart_id]
                                     };
            
            [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_CART,@"del.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                if ([obj[@"code"] isEqualToNumber:@200]) {
                    GoodsModel *model = _allDataArray[alertView.tag - 100];
                    // 移除商品成功 移除数据源和此条cell
                    [_allDataArray removeObject:model];
                    [_dataArray removeObject:model];
                    // 移除cartBadge cartArr中数据
                    [[[CartBadgeSingleton sharedManager] mutableArrayValueForKey:@"cartArr"] removeObject:model.goods_id];
                    // 判断移除的商品是否选中
                    if (model.isSel) {
                        // 移除选中 重新计算价格
                        [_selLogArr removeObject:model];
                        [self caculateAllPrice];
                    }
                    if (_selLogArr.count == 0) {
                        _allSelBtn.selected = NO;
                    }else if (_selLogArr.count == _dataArray.count) {
                        _allSelBtn.selected = YES;
                    }
                    NSLog(@"总共：%ld选中：%ld",_allDataArray.count,_selLogArr.count);
                    [_shopsList reloadData];
                }else {
                    NSLog(@"%@",obj[@"msg"]);
                }
                
            }];
        }

    
   

}

#pragma mark - 网络加载数据
- (void)loadData {
    NSString *path = [NSString stringWithFormat:@"%@%@",API_CART, @"lists.html"];
    NSString *login_key = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"];
    
        NSDictionary *params = @{
                                 @"key"     :login_key,
                                 @"page"    :@"1",
                                 @"num"     :@"5"
                                 };
        [LoadDate httpPost:path param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                // 状态正常 请求成功
                NSArray *dataArray = [obj[@"data"] lastObject][@"list"];
                NSMutableArray *tempArray = [NSMutableArray array];
                NSMutableArray *badTempArray = [NSMutableArray array];
                [[[CartBadgeSingleton sharedManager] mutableArrayValueForKeyPath:@"cartArr"] removeAllObjects];
                for (NSDictionary *dic in dataArray) {
                    GoodsModel *model = [[GoodsModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    if (model.goods_storage.integerValue >= model.goods_num.integerValue) {
                        [tempArray addObject:model];
                    }else {
                        [badTempArray addObject:model];
                    }
                    [[[CartBadgeSingleton sharedManager] mutableArrayValueForKeyPath:@"cartArr"] addObject:model.goods_id];
                }
                _dataArray = tempArray;
                _badDataArray = badTempArray;
                _allDataArray = [NSMutableArray arrayWithArray:_dataArray];
                [_allDataArray addObjectsFromArray:_badDataArray];
                [self.shopsList reloadData];
                [_shopsList.mj_header endRefreshing];
            }else {
                NSLog(@"%@",obj[@"msg"]);
                [_allDataArray removeAllObjects];
                [_shopsList reloadData];
                [_shopsList.mj_header endRefreshing];
            }
        }];
    
}

#pragma mark - 刷新页面数据
- (void)refreshData {
    for (int i=0; i<_dataArray.count; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:5000+i];
        btn.selected = NO;
        _totalAmount.text = @"￥0.00";
        allPrice = 0.00;
        for (GoodsModel *model in _dataArray) {
            model.isSel = NO;
        }
        [_selLogArr removeAllObjects];
    }
    _allSelBtn.selected = NO;
    [self loadData];
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
