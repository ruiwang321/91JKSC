//
//  MyFavoriteViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/6.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import "MyFavoritesModel.h"
#import "GoodsEvaluateViewController.h"
#import "MeCollectionViewCell.h"
#import "TradeDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface MyFavoriteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
/*我的收藏collectionView*/
@property (nonatomic,strong) UICollectionView *favourCollectionV;
/*我的收藏*/
@property (nonatomic,strong) NSMutableArray *favoritesArr;

@property (nonatomic,strong)NSDictionary * dataDict;

@property (nonatomic,assign)NSInteger index;
@end

@implementation MyFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _index = 1;
    [self createNavWithLeftImage:@"item" andRightImage:nil andTitleView:nil andTitle:@"我的收藏" andSEL:@selector(leftBtn:)];
    
}
-(void)leftBtn:(UIButton *)btn
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [self testHttpMsPost:1 andNum:6];
}
-(NSMutableArray *)favoritesArr
{
    if (!_favoritesArr) {
        _favoritesArr = [[NSMutableArray alloc]init];
    }
    return _favoritesArr;
}
#pragma mark ----- 我的收藏
-(UICollectionView *)favourCollectionV{
    if (!_favourCollectionV) {
        UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _favourCollectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, SYS_WIDTH, SYS_HEIGHT -64) collectionViewLayout:headerFlowLayout];
        _favourCollectionV.delegate = self;
        _favourCollectionV.dataSource = self;
        _favourCollectionV.showsHorizontalScrollIndicator = NO;
        _favourCollectionV.showsVerticalScrollIndicator = YES;
        _favourCollectionV.tag = 200;
        
        _favourCollectionV.emptyDataSetSource = self;
        _favourCollectionV.emptyDataSetDelegate = self;
        _favourCollectionV.backgroundColor = BACKGROUND_COLOR;
        [self.view addSubview:self.favourCollectionV];
        
        [_favourCollectionV registerClass:[MeCollectionViewCell class] forCellWithReuseIdentifier:@"MeCollectionViewCell"];
        __weak typeof(self) weakSelf = self;
        _favourCollectionV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData];
            
            
            
        }];
        
        _favourCollectionV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage];
            
        }];
    }
    return _favourCollectionV;
}

//下拉刷新
-(void)refreshData{
    
    _index = 1;
    [self testHttpMsPost:_index andNum:6];
    
    
    
}
//上拉加载
-(void)reloadMoreMessage{
    _index = _index+1;

    if (_index*6 <= [_dataDict[@"total"] integerValue] ) {

        [self testHttpMsPost:_index andNum:6];
    }else{
        if (_index*6 -[_dataDict[@"total"] integerValue]>0 && _index*6 -[_dataDict[@"total"] integerValue]<6) {
            [self testHttpMsPost:_index andNum:([_dataDict[@"total"] integerValue]-(_index-1)*6)];
            return;
        }else{
            [_favourCollectionV.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
    }
    
}
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.favoritesArr.count;
    
    
}


- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(15.0f, 10.0f, 0.0f, 10.0f);
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SYS_WIDTH-30)/2,  (SYS_WIDTH-30)/2/0.775);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellID = @"MeCollectionViewCell";
    
    MeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[MeCollectionViewCell alloc] init];
        
    }
    cell.layer.masksToBounds =YES;
    cell.layer.cornerRadius = 5;
    cell.backgroundColor = [UIColor whiteColor];
    MyFavoritesModel *model = [self.favoritesArr objectAtIndex:indexPath.item];
    ImageWithUrl(cell.imageV, model.goods_image);
    cell.titleLabel.text = model.goods_name;
    NSMutableAttributedString * moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"RMB:%@",model.log_price]];
    
    [moneyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12/375.0f*SYS_WIDTH] range:NSMakeRange(0, 4)];
    cell.moneyLabel.attributedText = moneyStr;
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
    MyFavoritesModel *model = [self.favoritesArr objectAtIndex:indexPath.item];
    
    tradeDetailVC.goods_id = model.fav_id;
    
    
    [self.navigationController pushViewController:tradeDetailVC animated:YES];
}
#pragma mark ----我的收藏网络请求
-(void) testHttpMsPost:(NSInteger)indexP andNum:(NSInteger)number{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@/favorites_lists.html",API_MyFavourites];
    
    NSDictionary * paramsDic = @{@"key":[Function getKey],@"page":[NSString stringWithFormat:@"%ld",(long)indexP],@"num":[NSString stringWithFormat:@"%d",6]};
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.

            _dataDict = obj[@"data"];
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                NSMutableArray * marr = [[NSMutableArray alloc]init];
                NSDictionary *dict = [obj objectForKey:@"data"];
                for (NSDictionary *dic in dict[@"list"]) {
                    MyFavoritesModel *model = [[MyFavoritesModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [marr addObject: model];
                }
            
                if (_index == 1) {
                     self.favoritesArr = marr;
                }else{
                    [self.favoritesArr addObjectsFromArray:marr];
                }
            }else{
                self.favoritesArr = nil;
            }
            [self.favourCollectionV reloadData];
            [_favourCollectionV.mj_header endRefreshing];
            [_favourCollectionV.mj_footer endRefreshing];
            
            
        }else{
            [MBProgressHUD showError:@"网络不给力"];
            
        }
        
    }];
    
}

#pragma mark - 返回空页面数据源和代理方法
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
    emptyView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 198, 240)];
    emptyImgView.image = [UIImage imageNamed:@"non-favor"];
    emptyImgView.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT * 0.3);
    [emptyView addSubview:emptyImgView];
    
    return emptyView;
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
