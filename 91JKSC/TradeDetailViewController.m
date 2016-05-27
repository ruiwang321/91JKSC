//
//  TradeDetailViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "TradeDetailViewController.h"
#import "TradeDetailTableViewCell.h"

#import "PictureDetailTableViewCell.h"
#import "EvaluateTableViewCell.h"
#import "EvaluateModel.h"
#import "ButtonModel.h"
#import "ShoppingCartViewController.h"
#import "TradeDetailModel.h"
#import "UIImageView+WebCache.h"
#import "OrderConfirmByIDViewController.h"
#import "ShoppingCartViewController.h"
#import "GoodsModel.h"
#import "LoginViewController.h"
#import "CartBadgeSingleton.h"
#import "SpecView.h"
#import "ShareSheetView.h"
#import "GoodsEvaluateViewController.h"
@interface TradeDetailViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,selectDelegate,UIGestureRecognizerDelegate> {
    MBProgressHUD *_hud;
}
@property (nonatomic ,strong)UIScrollView *mainScrollView;
@property (nonatomic,strong)UITableView *tableV;
@property (nonatomic,strong)UITableView *detailTableView;
@property (nonatomic,strong)UITableView *evaluateTableView;
@property (nonatomic,strong)UITableView *businessTableView;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)NSMutableArray *evaluateArr;
@property (nonatomic,strong)UITableView *serviesTableView;
@property (nonatomic,strong)UIView *myNavBar;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *badge;

@property (nonatomic,strong)SpecView *specView;
@property (nonatomic,strong)NSString * specString;
@property (nonatomic,strong)UIView *showSpecView;

//分享
@property (nonatomic,strong)UIView * sharebaseView;
@property (nonatomic,strong)ShareSheetView *sheetView;
@property (nonatomic,strong)UIView *emptyView;
@end

@implementation TradeDetailViewController

- (void)dealloc {
    [[CartBadgeSingleton sharedManager] removeObserver:self forKeyPath:@"cartArr"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BACKGROUND_COLOR;
    _modelArr = [[NSMutableArray alloc]init];

    _evaluateArr = [[NSMutableArray alloc]init];
    
    _hud = [MBProgressHUD showMessage:@"加载中"];
    
    [self createBtn];
    
    [self createCartBadge];
    
    [self testHttpMsPost];
    
}

//调用
-(void) testHttpMsPost{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@goods_details.html",API_GOODS];
    NSDictionary * paramsDic = @{@"goods_id":self.goods_id};
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        [_hud hide:YES];
        if (error == nil) {
            //obj即为解析后的数据.
           
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                NSDictionary *dict = [obj objectForKey:@"data"];
                
                TradeDetailModel *model = [[TradeDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dict];
                for (NSDictionary *dic in model.comment) {
                    EvaluateModel *evaModel = [[EvaluateModel alloc]init];
                    [evaModel setValuesForKeysWithDictionary:dic];
                    [_evaluateArr addObject:evaModel];
                }
                [_modelArr addObject:model];
                [self createScrollView];
                [self.tableV reloadData];
            }
            
        }else{
            [MBProgressHUD showError:@"亲，网络不给力呀~"];
            [self createNoWIFI];
        }
        
    }];
    
    
}
-(void)createScrollView{

    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    [self.view addSubview:_mainScrollView];
    [self createTableView];

}
#pragma mark 创建导航条
-(void)createBtn{
    _myNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 64)];
    [self.view addSubview:_myNavBar];
    
    [ButtonModel createLittleBtn:CGRectMake(7, 25, 44, 44) andImageName:@"img_arrow" andTarget:@selector(leftBtn:) andClassObject:self andTag:10 andColor:[UIColor clearColor] andBaseView:_myNavBar andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH-50, 25, 44, 44) andImageName:@"cart" andTarget:@selector(leftBtn:) andClassObject:self andTag:12 andColor:[UIColor clearColor] andBaseView:_myNavBar andTitleName:nil andFont:14];
}
-(void)leftBtn:(UIButton *)btn{
    if (btn.tag == 10) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if ([Function isLogin]) {
            ShoppingCartViewController *cart = [[ShoppingCartViewController alloc] init];
            cart.isPush = YES;
            [self.navigationController pushViewController:cart animated:YES];
        }else {
            [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
        }
    }
    
    
}

-(void)createEvaluateTableView{
    NSInteger  hight = 0;
    for (EvaluateModel *model in _evaluateArr) {
        hight += model.rowHeight;
    }
    self.evaluateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tableV.frame.size.height+20, SYS_WIDTH, hight+50) style:UITableViewStylePlain];
    self.evaluateTableView.dataSource = self;
    self.evaluateTableView.delegate = self;
    self.evaluateTableView.tag = 777;
    self.evaluateTableView.scrollEnabled = NO;
    
    [self.evaluateTableView registerClass:[EvaluateTableViewCell class] forCellReuseIdentifier:@"EvaluateTableViewCell"];
    [self.evaluateTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_mainScrollView addSubview:self.evaluateTableView];

}
-(void)createTableView{
    
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH,218+SYS_WIDTH) style:UITableViewStylePlain];
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    self.tableV.tag = 999;
    self.tableV.scrollEnabled = NO;
    [self.tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableV registerClass:[TradeDetailTableViewCell class] forCellReuseIdentifier:@"TradeDetailTableViewCell"];

    self.tableV.layer.shadowOffset = CGSizeMake(10, 10);
    
    [_mainScrollView addSubview:self.tableV];
    
    if (_evaluateArr.count != 0&&_evaluateArr.count <= 2) {
        [self createEvaluateTableView];
    }
   
    self.detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (_evaluateArr.count>0?40:20) + self.evaluateTableView.frame.size.height+self.tableV.frame.size.height, SYS_WIDTH, (SYS_WIDTH-4)*3.55555+30) style:UITableViewStylePlain];
    self.detailTableView.dataSource = self;
    self.detailTableView.delegate = self;
    self.detailTableView.tag = 888;
    self.detailTableView.scrollEnabled = NO;
    [self.detailTableView registerClass:[PictureDetailTableViewCell class] forCellReuseIdentifier:@"PictureDetailTableViewCell"];
    [_mainScrollView addSubview:self.detailTableView];

     [self createServiceTableView];
    
    _mainScrollView.contentSize = CGSizeMake(0, self.tableV.frame.size.height+self.evaluateTableView.frame.size.height+self.detailTableView.frame.size.height+self.serviesTableView.frame.size.height+(_evaluateArr.count>0?40:20));
   
    
}
-(void)createServiceTableView{
    
    self.serviesTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.detailTableView.frame.size.height+self.detailTableView.frame.origin.y , SYS_WIDTH, 70) style:UITableViewStylePlain];
    self.serviesTableView.dataSource = self;
    self.serviesTableView.delegate = self;
    self.serviesTableView.tag = 666;
    self.serviesTableView.scrollEnabled = NO;
    [self.serviesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [_mainScrollView addSubview:self.serviesTableView];
    [self.view bringSubviewToFront:_myNavBar];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 999) {
        return 3;
    }else if(tableView.tag == 888){
        return 1;
    }else if(tableView.tag == 777){
        if (section == 0) {
            return 1;
        }else{
            return _evaluateArr.count>2?2:_evaluateArr.count;
        }
    }else {
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 999) {
        if (indexPath.row ==0) {
            return SYS_WIDTH;
        }else if(indexPath.row == 1){
            return 110;
        }else{
            return 108;
        }
    }else if(tableView.tag == 888){
        return (SYS_WIDTH-4)*3.55555 + 30;
        
    }else if(tableView.tag == 777){
        if (indexPath.section == 0) {
            return 50;
        }else{
            EvaluateModel *model = _evaluateArr[indexPath.row];
            return model.rowHeight;
        }
    }else{
        return 70;
    }
    
}
-(void)viewDidLayoutSubviews {
    if ([self.tableV respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableV setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([self.tableV respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableV setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([self.evaluateTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.evaluateTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, -5)];
    }
    if ([self.evaluateTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.evaluateTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, -5)];
    }
    if ([self.serviesTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.serviesTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, -5)];
    }
    if ([self.serviesTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.serviesTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, -5)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView.tag == 777){
        return 2;
    }else{
        return 1;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    TradeDetailModel *model = [_modelArr objectAtIndex:0];
    
    if (tableView.tag == 999) {
        if (indexPath.row ==0) {
            NSString *cellID = @"UITableViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc]init];
            }
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_WIDTH)];
            // 渐变色
            CAGradientLayer *gradient = [CAGradientLayer layer];
            gradient.frame = CGRectMake(0, 0, SYS_WIDTH, 100);
            gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.6].CGColor,
                               (id)[UIColor colorWithWhite:1 alpha:0].CGColor,nil];
            [imageV.layer insertSublayer:gradient atIndex:0];
            ImageWithUrl(imageV, model.goods_image);
             [cell setSeparatorInset:UIEdgeInsetsZero];
            [cell addSubview:imageV];

            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
            return cell;
        }else if(indexPath.row == 1){
            NSString *cellID = @"TradeDetailTableViewCell";
            TradeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[TradeDetailTableViewCell alloc]init];
            } 
            if ([Function isLogin]) {
                [cell testHttpMsPostIsFavourites:model andView:cell];
            }
            [cell createViewWithModel:model andIndex:0];
            [cell.shareBtn addTarget:self action:@selector(shareMessage) forControlEvents:UIControlEventTouchUpInside];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return cell;
        }else{
            NSString *cellID = @"UITableViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[UITableViewCell alloc]init];
            }
            //可伸缩条
            UIButton *cellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cellBtn.frame = CGRectMake(10,10, SYS_WIDTH-20, 40);
            cellBtn.backgroundColor = [UIColor colorWithRed:0.89f green:0.90f blue:0.90f alpha:1.00f];
            cellBtn.layer.cornerRadius = 2;
            [cell addSubview:cellBtn];
            //加入购物车
            _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _loginBtn.frame = CGRectMake(10, cellBtn.frame.size.height+20, SYS_WIDTH/2-15, 35);
            _loginBtn.backgroundColor = [UIColor colorWithRed:0.69f green:0.87f blue:0.77f alpha:1.00f];
            _loginBtn.tag =1556;
            [_loginBtn setTitleColor:BackGreenColor forState:UIControlStateNormal ];
            [_loginBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            
            _loginBtn.layer.cornerRadius = 2;
            [cell addSubview:_loginBtn];
            
            //购买
            _buyBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            _buyBtn.frame = CGRectMake(SYS_WIDTH/2+5,cellBtn.frame.size.height+20, SYS_WIDTH/2-15,35);
            _buyBtn.backgroundColor = BackGreenColor;
            _buyBtn.layer.cornerRadius = 2;
            _buyBtn.tag = 1555;
            [_buyBtn setTitle:@"购买" forState:UIControlStateNormal];
            
            [cell addSubview:_buyBtn];
            
            
            
            
            //   伸缩条的下拉框
            _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _downBtn.frame = CGRectMake(0,0, SYS_WIDTH-20, 40);
            _downBtn.layer.cornerRadius = 2;
            [_downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cellBtn addSubview:_downBtn];
            [_downBtn setTitle:model.goods_spec[0] forState:UIControlStateNormal];
            [_downBtn setTitleColor:[UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f] forState:UIControlStateNormal];
            _downBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            
            [ _buyBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_loginBtn addTarget:self action:@selector(buyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_downBtn addTarget:self action:@selector(showSpec) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_WIDTH -40, 10, 20, 20)];
            imageV.image = [UIImage imageNamed:@"下拉箭头"];
            imageV.userInteractionEnabled = YES;
            [_downBtn addSubview:imageV];
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
           
        }
        
    }else if(tableView.tag == 888){
        NSString *cellID = @"PictureDetailTableViewCell";
        PictureDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[PictureDetailTableViewCell alloc]init];
        }
      
        [cell createCellWithArray:model.mobile_body andIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(tableView.tag == 666){
        NSString *cellID = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }
        //91品牌服务保障 标签
        UILabel *simpleLabel = [[UILabel alloc]init];
        simpleLabel.frame = CGRectMake(10, 5, 68, 60);
        simpleLabel.textAlignment =NSTextAlignmentCenter;
        simpleLabel.numberOfLines = 2;
        simpleLabel.text = @"91品牌服务保障";
        simpleLabel.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:simpleLabel];
        NSArray *arr =@[@"detailpage-goods",@"detailpage-free",@"detailpage-healthy",@"detailpage-green"];
        NSArray *titleArr =@[@"包邮",@"现货",@"健康",@"绿色"];
        for (int i=0; i<4; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_WIDTH-i*10-i*50-60, 23, 20, 20)];
            imageView.image = [UIImage imageNamed:arr[i]];
            [cell addSubview:imageView];
            
            UILabel *titleLabel = [[UILabel alloc]init];
            titleLabel.frame = CGRectMake(SYS_WIDTH-i*10-i*50-40, 23, 40, 20);
            titleLabel.text = titleArr[i];
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor colorWithRed:0.55f green:0.77f blue:0.65f alpha:1.00f];
            [cell addSubview:titleLabel];
        }

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else{
        TradeDetailModel *model = [_modelArr objectAtIndex:0];
        if (indexPath.section == 0) {
            NSString *cellID = @"UITableViewCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"商品评价(%@)",model.comment_num];
            return cell;
        }else{
            NSString *cellID = @"EvaluateTableViewCell";
            EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[EvaluateTableViewCell alloc]init];
            }
            
            [cell createCellWithModel:_evaluateArr andIndex:indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            return cell;
        }


    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 777) {
        GoodsEvaluateViewController *gVC = [[GoodsEvaluateViewController alloc]initWithGoodsId:_goods_id];
        [self.navigationController pushViewController:gVC animated:YES];
    }
}
-(void)shareMessage{
    _sharebaseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
     _sharebaseView.backgroundColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
     _sharebaseView.alpha = 0.9;
    [self.view addSubview: _sharebaseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissshareBaseView:)];
    tap.delegate = self;
    [_sharebaseView addGestureRecognizer:tap];
    
    TradeDetailModel *model = [_modelArr objectAtIndex:0];
    _sheetView = [[ShareSheetView alloc]initWithFrame:CGRectMake(SYS_SCALE(10), SYS_SCALE(130), SYS_WIDTH-SYS_SCALE(20), SYS_WIDTH)];
    _sheetView.backgroundColor = [UIColor whiteColor];
    _sheetView.detailmodel = model;
    //取消调用
     __weak typeof(self) weakSelf = self;
    [_sheetView dissmissForSuper:^{
    weakSelf.sharebaseView.hidden = YES;
    }];
    
    [self.view addSubview:_sheetView];
    //微博回调
    [(AppDelegate *)[UIApplication sharedApplication].delegate isDismissBlock:^(BOOL right) {
        if (right) {
            weakSelf.sharebaseView.hidden = YES;
            weakSelf.sheetView.hidden = YES;
        }
    }];

    //微信回调
    [(AppDelegate *)[UIApplication sharedApplication].delegate isTrue:^(BOOL right) {
        if (right) {
            weakSelf.sharebaseView.hidden = YES;
            weakSelf.sheetView.hidden = YES;
        }
    }];
    //qq回调
    [(AppDelegate *)[UIApplication sharedApplication].delegate isQQDismissBlock:^(BOOL right) {
        if (right) {
            weakSelf.sharebaseView.hidden = YES;
            weakSelf.sheetView.hidden = YES;
        }
    }];
}
-(BOOL)selectText:(NSString *)goodSpec andForRow:(NSString *)row{
    [_downBtn setTitle:goodSpec forState:UIControlStateNormal];
    _showSpecView.hidden = YES;
    _specString = goodSpec;
    return YES;
}

-(void)showSpec{
    if (!_specView) {
        _showSpecView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
        _showSpecView.backgroundColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        _showSpecView.alpha = 0.9;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissregisView:)];
        tap.delegate = self;
        [_showSpecView addGestureRecognizer:tap];
        
        //    _showSpecView.alpha = 0.6;
        [self.view addSubview:_showSpecView];
        
        TradeDetailModel *model = [_modelArr objectAtIndex:0];
        _specView = [[SpecView alloc]initWithFrame:CGRectMake(5, SYS_HEIGHT/2-70*model.goods_spec.count+30<60?60: SYS_HEIGHT/2-70*model.goods_spec.count+30, SYS_WIDTH-10, 70*model.goods_spec.count+30>SYS_HEIGHT-80?SYS_HEIGHT-80:70*model.goods_spec.count+30)];
        _specView.arr = model.goods_spec;
        _specView.delegate = self;
        _specView.layer.cornerRadius = 5;
        _specView.layer.masksToBounds = YES;
        _specView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_specView];
        
       
    }
   
    _showSpecView.hidden = NO;
    _specView.hidden = NO;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SYS_WIDTH-20, 30)];
    titleLabel.text = @"选项";
    titleLabel.textColor = [UIColor grayColor];
    [_specView addSubview:titleLabel];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
     if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
     return NO;
     } if ([touch.view isKindOfClass:[UITableViewCell class]]){
         return NO;
    }
    _showSpecView.hidden = YES;
    _specView.hidden = YES;
    _sharebaseView.hidden = YES;
    _sheetView.hidden = YES;
    return YES;
}
-(void)dismissregisView:(UITapGestureRecognizer *)gesture{
    _specView.hidden = YES;
    _showSpecView.hidden = YES;
}
-(void)dismissshareBaseView:(UITapGestureRecognizer *)gesture{
    _sharebaseView.hidden = YES;
    _sheetView.hidden = YES;
}
-(void)buyBtn:(UIButton *)btn{
    NSLog(@"%ld",(long)btn.tag);
    if (btn.tag == 1555) {
        [self testHttpMsPostBuy];
    }else if(btn.tag == 1556){
        [self testHttpMsPostAddCart];
    }
}
-(void) testHttpMsPostAddCart{
    TradeDetailModel *model = [_modelArr objectAtIndex:0];
    NSString *urlPath = [NSString stringWithFormat:@"%@add.html",API_CART];
    if ([Function isLogin]) {
        if (_specString.length == 0) {
            _specString = model.goods_spec[0];
        }
        MBProgressHUD * hud = [MBProgressHUD showMessage:@""];
        NSDictionary * paramsDic = @{@"key":[Function getKey],@"goods_id":self.goods_id,@"num":@"1",@"select_spec":_specString};
        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            [hud hide:YES];
            if (error == nil) {
                if ([[obj objectForKey:@"code"] isEqual:@200]) {
                    NSLog(@"data%@",[obj objectForKey:@"data"]);
                    
                    GoodsModel *model = [[GoodsModel alloc]init];
                    model.cart_id =[[[obj objectForKey:@"data"] objectForKey:@"ids"] firstObject];
                    if (![[CartBadgeSingleton sharedManager].cartArr containsObject:_goods_id]) {
                        [[[CartBadgeSingleton sharedManager] mutableArrayValueForKey:@"cartArr"] addObject:_goods_id];
                    }
                    [MBProgressHUD showSuccess:@"加入购物车成功"];
                }else{

                    [MBProgressHUD showError:obj[@"msg"]];
                    
                }
                
            }else{
                [MBProgressHUD showError:@"网络加载失败"];
            }
            
        }];

    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:loginVC animated:YES completion:nil];

    }
}
-(void)createNoWIFI{
    _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64)];
    _emptyView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 198, 240)];
    emptyImgView.image = [UIImage imageNamed:@"non-wifi-errorpage"];
    emptyImgView.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT * 0.3);
    [_emptyView addSubview:emptyImgView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 0, 130, 50);
    homeButton.center = CGPointMake(SYS_WIDTH / 2, CGRectGetMaxY(emptyImgView.frame) + 30);
    [homeButton setImage:[UIImage imageNamed:@"non-wifi-errorpage-button"] forState:UIControlStateNormal];
      [homeButton addTarget:self action:@selector(homeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    homeButton.layer.cornerRadius = 5;
    
    [_emptyView addSubview:homeButton];
    [self.view addSubview:_emptyView];
}
-(void)homeButtonClicked
{
    [_emptyView removeFromSuperview];
    [self testHttpMsPost];
}
#pragma mark --- 立即购买
-(void)testHttpMsPostBuy{
    TradeDetailModel *model = [_modelArr objectAtIndex:0];
    NSString *urlPath = [NSString stringWithFormat:@"%@addById.html",API_ORDER];
    if ([Function isLogin]) {
        NSDictionary * paramsDic = @{@"key":[Function getKey],@"goods_id":self.goods_id,@"num":@"1",@"select_spec":model.goods_spec[0]};
        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
             NSLog(@"%@",obj);
            if (error == nil) {
                //obj即为解析后的数据.
                if ([obj[@"code"] isEqualToNumber:@200]) {
                   
                    OrderConfirmByIDViewController *orderByIDVC = [[OrderConfirmByIDViewController alloc] init];
                    orderByIDVC.isShow = YES;
                    [orderByIDVC.jsonObj removeAllObjects];
                    orderByIDVC.jsonObj = [obj objectForKey:@"data"];
                    [self.navigationController pushViewController:orderByIDVC animated:YES];
                }else{
                   
                    [MBProgressHUD showError:obj[@"msg"]];
                }
            }else{
                [MBProgressHUD showError:@"网络状态不给力"];
            }
            
        }];

    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:loginVC animated:YES completion:nil];
    }
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    _myNavBar.backgroundColor = RGBAF(0.1, 0.48, 0.22, scrollView.contentOffset.y / 50);
    
}

#pragma mark - 创建购物车数量badge
- (void)createCartBadge {
    UIButton *cartBtn = [_myNavBar viewWithTag:12];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _bgView.backgroundColor = RGB(255, 147, 0);
    _bgView.layer.cornerRadius = 7;
     _bgView.center = CGPointMake(CGRectGetWidth(cartBtn.bounds)-10, 10);
    
    _badge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _badge.text = [NSString stringWithFormat:@"%ld",[CartBadgeSingleton sharedManager].cartArr.count];
    _badge.font = [UIFont systemFontOfSize:8];
    _badge.textAlignment = NSTextAlignmentCenter;
    _badge.textColor = [UIColor whiteColor];
    [_bgView addSubview:_badge];
    [cartBtn addSubview:_bgView];
    [[CartBadgeSingleton sharedManager] addObserver:self forKeyPath:@"cartArr" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([CartBadgeSingleton sharedManager].cartArr == nil || [CartBadgeSingleton sharedManager].cartArr.count == 0) {
        _bgView.alpha = 0;
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([CartBadgeSingleton sharedManager].cartArr.count>0) {
        _badge.text = [NSString stringWithFormat:@"%ld",[CartBadgeSingleton sharedManager].cartArr.count];
        _bgView.alpha = 1;

    }else {
        _bgView.alpha = 0;
    }
}
-(void)returnText:(returnTextBlock)block{
    self.block = block;
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
