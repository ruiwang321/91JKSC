    //
//  GoodsEvaluateViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/13.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "GoodsEvaluateViewController.h"
#import "EvaluateTableViewCell.h"
#import "EvaluateView.h"

typedef enum {
    LoadTypesAllEvaluate = 300, // 数据加载类型  与选择按钮tag值对应
    LoadTypesBadEvaluate,
    LoadTypesMiddleEvaluate,
    LoadTypesGoodEvaluate,
    LoadTypesImageEvaluate
} LoadTypes;

@interface GoodsEvaluateViewController () <UITableViewDelegate, UITableViewDataSource> {
    int pageIndex[5];
}

@property (nonatomic, strong) NSString *goodId;
/** 选择按钮工具条 */
@property (nonatomic, strong) UIView *selToolBar;

/** 全部评价列表数据源 */
@property (nonatomic, strong) NSMutableArray *allEvaluateArr;
/** 好评列表数据源 */
@property (nonatomic, strong) NSMutableArray *goodEvaluateArr;
/** 中评列表数据源 */
@property (nonatomic, strong) NSMutableArray *middleEvaluateArr;
/** 差评列表数据源 */
@property (nonatomic, strong) NSMutableArray *badEvaluateArr;
/** 差评列表数据源 */
@property (nonatomic, strong) NSMutableArray *imageEvaluateArr;

/** 全部评价列表 */
@property (nonatomic, strong) UITableView *allEvaluateList;
/** 好评列表 */
@property (nonatomic, strong) UITableView *goodEvaluateList;
/** 中评列表 */
@property (nonatomic, strong) UITableView *middleEvaluateList;
/** 差评列表 */
@property (nonatomic, strong) UITableView *badEvaluateList;
/** 晒图列表 */
@property (nonatomic, strong) UITableView *imageEvaluateList;
@end

@implementation GoodsEvaluateViewController

- (instancetype)initWithGoodsId:(NSString *)goodsId
{
    self = [super init];
    if (self) {
        _goodId = goodsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < sizeof(pageIndex)/4; i++) {
        pageIndex[i] = 1;
    }
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:@"商品评价" andSEL:@selector(backClicked)];

    [self createSelBtnBar];
    [self loadNetDataWithPage:1 andType:LoadTypesAllEvaluate];
}

#pragma mark 创建列表选择工具条
- (void)createSelBtnBar {
    _selToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, 50)];
    [self.view addSubview:_selToolBar];
    for (int i = 0; i < 5; i++) {
        int a[5] = {0,3,2,1,4};
        UILabel *label = [[UILabel alloc] init];
        label.text = @[@"全部评价", @"好评", @"中评", @"差评", @"晒图"][i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [label sizeToFit];
        label.center = CGPointMake(SYS_WIDTH/5.0f/2.0f*(2*i+1), 15);
        label.tag = 100 + a[i];
        label.textColor = RGB(50, 50, 50);
        [_selToolBar addSubview:label];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH/5.0*i, 35, SYS_WIDTH/5.0f, 10)];
        num.textAlignment = NSTextAlignmentCenter;
        num.font = [UIFont systemFontOfSize:10];
        num.tag = 200 + a[i];
        num.textColor = RGB(50, 50, 50);
        [_selToolBar addSubview:num];
        num.text = @"0";
        
        UIButton *selBtn = [[UIButton alloc] initWithFrame:CGRectMake(SYS_WIDTH/5.0*i, 0, SYS_WIDTH/5.0f, 50)];
        [_selToolBar addSubview:selBtn];
        [selBtn addTarget:self action:@selector(selBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        selBtn.tag = 300 + a[i];
    }
    [(UILabel *)[_selToolBar viewWithTag:100] setTextColor:BackGreenColor];
    [(UILabel *)[_selToolBar viewWithTag:200] setTextColor:BackGreenColor];
}

#pragma mark - 按钮点击事件
- (void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selBtnClicked:(UIButton *)btn {

    for (int i = 0; i < 5; i++) {
        [(UILabel *)[_selToolBar viewWithTag:100 + i] setTextColor:RGB(50, 50, 50)];
        [(UILabel *)[_selToolBar viewWithTag:200 + i] setTextColor:RGB(50, 50, 50)];
    }
    [(UILabel *)[_selToolBar viewWithTag:btn.tag - 100] setTextColor:BackGreenColor];
    [(UILabel *)[_selToolBar viewWithTag:btn.tag - 200] setTextColor:BackGreenColor];
    
    
    
    switch (btn.tag) {
        case LoadTypesAllEvaluate: {
            [self.view bringSubviewToFront:self.allEvaluateList];
            break;
        }
        case LoadTypesGoodEvaluate: {
            [self.view bringSubviewToFront:self.goodEvaluateList];
            break;
        }
        case LoadTypesMiddleEvaluate: {
            [self.view bringSubviewToFront:self.middleEvaluateList];
            break;
        }
        case LoadTypesBadEvaluate: {
            [self.view bringSubviewToFront:self.badEvaluateList];
            break;
        }
        case LoadTypesImageEvaluate: {
            [self.view bringSubviewToFront:self.imageEvaluateList];
            break;
        }
        default:
            break;
    }
}

#pragma mark - 网络数据加载
- (void)loadNetDataWithPage:(int)index andType:(LoadTypes)loadType {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_GOODS,@"goodsEvaluate.html"];
    NSString *state;
    switch (loadType) {
        case LoadTypesAllEvaluate:
            state = @"0";
            break;
        case LoadTypesBadEvaluate:
            state = @"1";
            break;
        case LoadTypesMiddleEvaluate:
            state = @"2";
            break;
        case LoadTypesGoodEvaluate:
            state = @"3";
            break;
        case LoadTypesImageEvaluate:
            state = @"4";
            break;
        default:
            break;
    }
    NSDictionary *params = @{
                             @"goods_id"        :_goodId,
                             @"state"           :state,
                             @"page"            :[NSString stringWithFormat:@"%d",index],
                             @"num"             :@"10"
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            // 更新数量显示
            NSDictionary *numMsgDic = obj[@"data"][@"totalArr"];
            for (int i = 0; i < numMsgDic.allValues.count; i++) {
                UILabel *label = (UILabel *)[_selToolBar viewWithTag:200 + i];
                label.text = numMsgDic[[NSString stringWithFormat:@"total%d",i]];
            }
            NSMutableArray *dataArr;
            switch (loadType) {
                case LoadTypesAllEvaluate:
                    dataArr = self.allEvaluateArr;
                    break;
                case LoadTypesGoodEvaluate:
                    dataArr = self.goodEvaluateArr;
                    break;
                case LoadTypesMiddleEvaluate:
                    dataArr = self.middleEvaluateArr;
                    break;
                case LoadTypesBadEvaluate:
                    dataArr = self.badEvaluateArr;
                    break;
                case LoadTypesImageEvaluate:
                    dataArr = self.imageEvaluateArr;
                    break;
                default:
                    break;
            }
            if (index == 1) {
                pageIndex[loadType-300] = 1;
                [dataArr removeAllObjects];
            }
            NSArray *dicArr = obj[@"data"][@"list"];
            for (NSDictionary *dic in dicArr) {
                EvaluateModel *model = [[EvaluateModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [dataArr addObject:model];
            }
            switch (loadType) {
                case LoadTypesAllEvaluate:
                    if ([obj[@"data"][@"total"] longLongValue]< 10*index) {
                        [self.allEvaluateList.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.allEvaluateList.mj_footer endRefreshing];
                    }
                    [self.allEvaluateList.mj_header endRefreshing];
                    [self.allEvaluateList reloadData];
                    break;
                case LoadTypesGoodEvaluate:
                    if ([obj[@"data"][@"total"] longLongValue]< 10*index) {
                        [self.goodEvaluateList.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.goodEvaluateList.mj_footer endRefreshing];
                    }
                    [self.goodEvaluateList.mj_header endRefreshing];
                    
                    [self.goodEvaluateList reloadData];
                    break;
                case LoadTypesMiddleEvaluate:
                    if ([obj[@"data"][@"total"] longLongValue]< 10*index) {
                        [self.middleEvaluateList.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.middleEvaluateList.mj_footer endRefreshing];
                    }
                    [self.middleEvaluateList.mj_header endRefreshing];
                    
                    [self.middleEvaluateList reloadData];
                    break;
                case LoadTypesBadEvaluate:
                    if ([obj[@"data"][@"total"] longLongValue]< 10*index) {
                        [self.badEvaluateList.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.badEvaluateList.mj_footer endRefreshing];
                    }
                    [self.badEvaluateList.mj_header endRefreshing];
                    
                    [self.badEvaluateList reloadData];
                    break;
                case LoadTypesImageEvaluate:
                    if ([obj[@"data"][@"total"] longLongValue]< 10*index) {
                        [self.imageEvaluateList.mj_footer setState:MJRefreshStateNoMoreData];
                    }else{
                        [self.imageEvaluateList.mj_footer endRefreshing];
                    }
                    [self.imageEvaluateList.mj_header endRefreshing];
                    
                    [self.imageEvaluateList reloadData];
                    break;
                default:
                    break;
            }
            
        }
    }];
}
#pragma mark - tableView代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataArr;
    if (tableView == _allEvaluateList) {
        dataArr = self.allEvaluateArr;
    }else if (tableView == _goodEvaluateList) {
        dataArr = self.goodEvaluateArr;
    }else if (tableView == _middleEvaluateList) {
        dataArr = self.middleEvaluateArr;
    }else if (tableView == _badEvaluateList) {
        dataArr = self.badEvaluateArr;
    }else if (tableView == _imageEvaluateList) {
        dataArr = self.imageEvaluateArr;
    }
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[EvaluateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (tableView == _allEvaluateList) {
        [cell createCellWithModel:self.allEvaluateArr andIndex:indexPath.row];
    }else if (tableView == _goodEvaluateList) {
        [cell createCellWithModel:self.goodEvaluateArr andIndex:indexPath.row];
    }else if (tableView == _middleEvaluateList) {
        [cell createCellWithModel:self.middleEvaluateArr andIndex:indexPath.row];
    }else if (tableView == _badEvaluateList) {
        [cell createCellWithModel:self.badEvaluateArr andIndex:indexPath.row];
    }else if (tableView == _imageEvaluateList) {
        [cell createCellWithModel:self.imageEvaluateArr andIndex:indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *dataArr;
    if (tableView == _allEvaluateList) {
        dataArr = self.allEvaluateArr;
    }else if (tableView == _goodEvaluateList) {
        dataArr = self.goodEvaluateArr;
    }else if (tableView == _middleEvaluateList) {
        dataArr = self.middleEvaluateArr;
    }else if (tableView == _badEvaluateList) {
        dataArr = self.badEvaluateArr;
    }else if (tableView == _imageEvaluateList) {
        dataArr = self.imageEvaluateArr;
    }
    EvaluateModel *model = dataArr[indexPath.row];
    return  model.rowHeight;
}
#pragma mark - getter
- (UITableView *)allEvaluateList {
    if (_allEvaluateList == nil) {
        _allEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SYS_WIDTH, SYS_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _allEvaluateList.delegate = self;
        _allEvaluateList.dataSource = self;
        [self.view addSubview:_allEvaluateList];
        __weak typeof(self) weakSelf = self;
        _allEvaluateList.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:1 andType:LoadTypesAllEvaluate];
        }];
        
        _allEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesAllEvaluate-300] andType:LoadTypesAllEvaluate];
        }];

    }
    return _allEvaluateList;
}

- (UITableView *)goodEvaluateList {
    if (_goodEvaluateList == nil) {
        _goodEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SYS_WIDTH, SYS_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _goodEvaluateList.delegate = self;
        _goodEvaluateList.dataSource = self;
        [self.view addSubview:_goodEvaluateList];
        __weak typeof(self) weakSelf = self;
        [self loadNetDataWithPage:1 andType:LoadTypesGoodEvaluate];
        _goodEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:1 andType:LoadTypesGoodEvaluate];
        }];
        
        _goodEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesGoodEvaluate-300] andType:LoadTypesGoodEvaluate];
        }];
        _goodEvaluateList.mj_footer.automaticallyHidden = YES;
    }
    return _goodEvaluateList;
}

- (UITableView *)middleEvaluateList {
    if (_middleEvaluateList == nil) {
        _middleEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SYS_WIDTH, SYS_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _middleEvaluateList.delegate = self;
        _middleEvaluateList.dataSource = self;
        [self.view addSubview:_middleEvaluateList];
        [self loadNetDataWithPage:1 andType:LoadTypesMiddleEvaluate];
        __weak typeof(self) weakSelf = self;
        _middleEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:1 andType:LoadTypesMiddleEvaluate];
        }];
        
        _middleEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesMiddleEvaluate-300] andType:LoadTypesMiddleEvaluate];
        }];
        _middleEvaluateList.mj_footer.automaticallyHidden = YES;
    }
    return _middleEvaluateList;
}

- (UITableView *)badEvaluateList {
    if (_badEvaluateList == nil) {
        _badEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SYS_WIDTH, SYS_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _badEvaluateList.delegate = self;
        _badEvaluateList.dataSource = self;
        [self.view addSubview:_badEvaluateList];
        __weak typeof(self) weakSelf = self;
        [self loadNetDataWithPage:1 andType:LoadTypesBadEvaluate];
        _badEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:1 andType:LoadTypesBadEvaluate];
        }];
        
        _badEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesBadEvaluate-300] andType:LoadTypesBadEvaluate];
        }];
    }
    return _badEvaluateList;
}

- (UITableView *)imageEvaluateList {
    if (_imageEvaluateList == nil) {
        _imageEvaluateList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+50, SYS_WIDTH, SYS_HEIGHT-64-50) style:UITableViewStyleGrouped];
        _imageEvaluateList.delegate = self;
        _imageEvaluateList.dataSource = self;
        [self.view addSubview:_imageEvaluateList];
        [self loadNetDataWithPage:1 andType:LoadTypesImageEvaluate];
        __weak typeof(self) weakSelf = self;
        _imageEvaluateList.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:1 andType:LoadTypesImageEvaluate];
        }];
        
        _imageEvaluateList.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
            [weakSelf loadNetDataWithPage:++pageIndex[LoadTypesImageEvaluate-300] andType:LoadTypesImageEvaluate];
        }];
    }
    return _imageEvaluateList;
}

- (NSMutableArray *)allEvaluateArr {
    if (_allEvaluateArr == nil) {
        _allEvaluateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _allEvaluateArr;
}

- (NSMutableArray *)goodEvaluateArr {
    if (_goodEvaluateArr == nil) {
        _goodEvaluateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodEvaluateArr;
}

- (NSMutableArray *)middleEvaluateArr {
    if (_middleEvaluateArr == nil) {
        _middleEvaluateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _middleEvaluateArr;
}

- (NSMutableArray *)badEvaluateArr {
    if (_badEvaluateArr == nil) {
        _badEvaluateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _badEvaluateArr;
}

- (NSMutableArray *)imageEvaluateArr {
    if (_imageEvaluateArr == nil) {
        _imageEvaluateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _imageEvaluateArr;
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
