//
//  SearchViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/14.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SearchViewController.h"
#import "TradeCollectionViewCell.h"
#import "TradeModel.h"
#import "TradeDetailViewController.h"
//#import "MBProgressHUD+HM.h"

@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
/**
 *  搜索结果(数据源)
 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/**
 *  搜索输入框
 */
@property (nonatomic, strong) UITextField *searchTF;
/**
 *  搜索结果显示列表
 */
@property (nonatomic, strong) UICollectionView *resultList;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self searchNavBar];
    [self createCollectionView];
    [self.searchTF becomeFirstResponder];
}
// 创建搜索导航条
- (void)searchNavBar {
    
    UIView *navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 64)];
    navBar.backgroundColor = BackGreenColor;
    [self.view addSubview:navBar];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"img_arrow"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [navBar addSubview:backBtn];
    
    
    // 创建搜索输入框
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(50, 25, 250, 40)];
    _searchTF.delegate = self;
    _searchTF.clearButtonMode = UITextFieldViewModeAlways;
    _searchTF.placeholder = @"请输入商品名称";
    [_searchTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    _searchTF.returnKeyType = UIReturnKeySearch;
    [navBar addSubview:_searchTF];
    
  
    
}
// 创建CollectionView
-(void)createCollectionView{
    UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _resultList = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64, SYS_WIDTH, SYS_HEIGHT -64) collectionViewLayout:headerFlowLayout];
    _resultList.delegate = self;
    _resultList.dataSource = self;
    _resultList.showsHorizontalScrollIndicator = NO;
    _resultList.showsVerticalScrollIndicator = YES;
    _resultList.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f];
    [self.view addSubview:_resultList];
    
    [_resultList registerClass:[TradeCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

}

-(void)searchData{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_GOODS, @"goods_serach.html"];
    NSDictionary *params = @{
                             @"goods_name"  :_searchTF.text,
                             @"sort_type"   :@"1",
                             @"sort_value"  :@"1"
                             };
    
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        [self.dataSource removeAllObjects];
        if ([obj[@"code"] isEqualToNumber:@200]) {
            
            for (NSDictionary *dic in obj[@"data"]) {
                TradeModel *model = [[TradeModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataSource addObject:model];
            }
            [_resultList reloadData];
        }else {
            [MBProgressHUD showError:@"暂时没有该商品"];
            [_resultList reloadData];
        }
    }];
}
#pragma mark - textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchData];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - collectionView数据源和代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
    
}
- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SYS_WIDTH-30)/2,  (SYS_WIDTH-30)/2/0.775);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"cell";
    TradeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    TradeModel *model = self.dataSource[indexPath.row];

    [cell createCellWithModel:model andIndex:(int)indexPath.row];

    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    return cell; 
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
    TradeModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    tradeDetailVC.goods_id = model.goods_id;
    
    [self.navigationController pushViewController:tradeDetailVC animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchTF resignFirstResponder];
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSource;
}


#pragma mark - 按钮点击事件
- (void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
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
