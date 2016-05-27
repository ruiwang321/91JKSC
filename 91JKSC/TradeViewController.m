//
//  TradeViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/24.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "TradeViewController.h"
#import "TradeCollectionViewCell.h"
#import "TradeDetailViewController.h"
#import "TradeModel.h"
#import "TradeSysWidthCollectionViewCell.h"
#import "LoginViewController.h"
#import "ShoppingCartViewController.h"
#import "SearchViewController.h"
#import "UIScrollView+EmptyDataSet.h"

#import "CartBadgeSingleton.h"

@interface TradeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    MBProgressHUD *_hud;
}
@property (nonatomic ,strong)UICollectionView *collectionView;
@property (nonatomic ,assign)int i;
@property (nonatomic ,strong)NSMutableArray * listArr;
@property (nonatomic ,strong)NSMutableDictionary *dataDict;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *bigArray;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic, strong) UILabel *badge;
@property (nonatomic, strong) UIView *bgView;

@end


@implementation TradeViewController

static int page = 0;

- (void)dealloc {
    [[CartBadgeSingleton sharedManager] removeObserver:self forKeyPath:@"cartArr"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavWithLeftImage:@"img_arrow" andRightImage:@[@"cart",@"search"] andTitleView:nil andTitle:self.titleName andSEL:@selector(navBtn:)];
    _index = 1;
    _dataArray = [[NSMutableArray alloc]init];
    self.listArr = [[NSMutableArray alloc]init];
    _bigArray = [[NSMutableArray alloc]init];
    _dataDict = [[NSMutableDictionary alloc]init];

    _hud = [MBProgressHUD showMessage:@"加载中"];
    
    [self testHttpMsPost:1 andNum:6];
    [self createCollectionView];
    
    [self createCartBadge];
   self.view.backgroundColor = [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f];
}

//调用
-(void) testHttpMsPost:(NSInteger)indexP andNum:(NSInteger)number{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@class_goods.html",API_CLASS];
   
    NSDictionary * paramsDic=nil;
    if ([Function getUserName].length != 0) {
        paramsDic = @{@"username":[Function getUserName],@"client":@"ios",@"ip2long":[LoadDate getIPDress],@"deviceName":DEVICE,@"macAddress":MAC_ADDRESS,@"gc_id":self.gc_id,@"page":[NSString stringWithFormat:@"%ld",(long)indexP],@"num":[NSString stringWithFormat:@"%ld",(long)number]};
    }else{
        
        paramsDic = @{@"username":@"username",@"client":@"ios",@"ip2long":[LoadDate getIPDress],@"deviceName":DEVICE,@"macAddress":MAC_ADDRESS,@"gc_id":self.gc_id,@"page":[NSString stringWithFormat:@"%ld",(long)indexP],@"num":[NSString stringWithFormat:@"%ld",(long)number]};
    }

    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        [_hud hide:YES];
        if (error == nil) {
            //obj即为解析后的数据.
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                _dataDict = [obj objectForKey:@"data"];
                _dataArray = [_dataDict objectForKey:@"list"];
                NSMutableArray * list = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in self.dataArray) {
                    TradeModel *model = [[TradeModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [list addObject:model];
                }
                if (_index == 1) {
                    self.listArr = list;
                }else{
                    [self.listArr addObjectsFromArray:list];
                }
                [self.collectionView reloadData];
               
                
            }
            
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
            
        }else{
            [MBProgressHUD showError:@"亲，网络不给力呀~"];
        }
        
    }];
    
    
}
-(void)navBtn:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
    switch (btn.tag) {
        case 1000:
            // 返回
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case 2000:
            // 购物车
            if ([Function isLogin]) {
                ShoppingCartViewController *cart = [[ShoppingCartViewController alloc] init];
                cart.isPush = YES;
                [self.navigationController pushViewController:cart animated:YES];
            }else {
                [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
            }
            break;
        case 2001:
            // 搜索
            [self.navigationController pushViewController:[[SearchViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}
#pragma mark ----- 商品图
-(void)createCollectionView{
    UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, SYS_WIDTH, SYS_HEIGHT -64) collectionViewLayout:headerFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.tag = 200;
    self.collectionView.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f];

    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    
    [self.collectionView registerClass:[TradeCollectionViewCell class] forCellWithReuseIdentifier:@"TradeCollectionViewCellBig"];
    
    [self.collectionView registerClass:[TradeCollectionViewCell class] forCellWithReuseIdentifier:@"TradeCollectionViewCellSmall"];
    //    [self testHttpMsPost];

    __weak typeof(self) weakSelf = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
        
        
        
    }];
    
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf reloadMoreMessage];
        
    }];
    
    [self.view addSubview:self.collectionView];
 
}
//下拉刷新
-(void)refreshData{
    
    _index = 1;
    [self testHttpMsPost:_index andNum:6];
    
    
    
}
//上拉加载
-(void)reloadMoreMessage{
    _index = _index+1;
    NSLog(@"%@",_dataDict[@"total"]);
    if (_index*6 <= [_dataDict[@"total"] integerValue] ) {
        
        [self testHttpMsPost:_index andNum:6];
    }else{
        if (_index*6 -[_dataDict[@"total"] integerValue]>0 && _index*6 -[_dataDict[@"total"] integerValue]<6) {
            [self testHttpMsPost:_index andNum:([_dataDict[@"total"] integerValue]-(_index-1)*6)];
            return;
        }else{
            [_collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
    }
    
}

#pragma mark - 返回空页面数据源和代理方法
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
    emptyView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 198, 240)];
    emptyImgView.image = [UIImage imageNamed:@"non-page"];
    emptyImgView.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT * 0.3);
    [emptyView addSubview:emptyImgView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 0, 130, 50);
    homeButton.center = CGPointMake(SYS_WIDTH / 2, CGRectGetMaxY(emptyImgView.frame) + 30);
    [homeButton setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    homeButton.layer.cornerRadius = 5;
    
    [emptyView addSubview:homeButton];
    
    return emptyView;
}

- (void)homeButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.listArr.count;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TradeModel *model = [self.listArr objectAtIndex:indexPath.row];
    if (model.is_recommend.integerValue == 1) {
        
        return CGSizeMake(SYS_WIDTH - 20, (SYS_WIDTH - 20)/0.775);

    }else {
        return CGSizeMake((SYS_WIDTH-30)/2,  (SYS_WIDTH-30)/2/0.775);
    }
    
   
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TradeModel  *model = [self.listArr objectAtIndex:indexPath.row];
    static NSString * cellID;
    if (model.is_recommend.integerValue == 1) {
       cellID = @"TradeCollectionViewCellBig";
    }else{
        cellID= @"TradeCollectionViewCellSmall";
    }
    TradeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    [cell createCellWithModel: model andIndex:page];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
    TradeModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    tradeDetailVC.goods_id = model.goods_id;

    [self.navigationController pushViewController:tradeDetailVC animated:YES];
}


#pragma mark - 创建购物车数量badge
- (void)createCartBadge {
    UIButton *cartBtn = (UIButton *)[self.view viewWithTag:2000];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _bgView.backgroundColor = RGB(255, 147, 0);
    _bgView.layer.cornerRadius = 7;
     _bgView.center = CGPointMake(CGRectGetWidth(cartBtn.bounds)-10, 10);
    
    _badge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
    _badge.text = [NSString stringWithFormat:@"%ld",(unsigned long)[CartBadgeSingleton sharedManager].cartArr.count];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
