//
//  MainViewController.m
//  91JKSC
//
//  Created by 商城 阜新 on 16/2/17.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "UIView+SHCZExt.h"
#import "ButtonModel.h"
#import "SideTableViewCell.h"
#import "AdversionCollectionViewCell.h"
#import "TradeViewController.h"
#import "ServicesViewController.h"
#import "ShoppingCartViewController.h"
#import "LoginModel.h"
#import "Function.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "CartBadgeSingleton.h"
#import "TradeDetailViewController.h"
#import "GoodsModel.h"
#import "QRCodeReaderViewController.h"

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate> {
    UIView *emptyView;
}
/**
 轮播图数组
 */
@property(nonatomic, nonnull,strong)NSMutableArray * openadsArr;
/**分类列表*/
@property (nonatomic,strong)NSMutableArray *listArr ;
@property (nonatomic,strong)UICollectionView * collectionV;
@property (nonatomic , strong) UIPageControl *pageControl;
@property (nonatomic , strong) NSMutableArray *newses;
@property (nonatomic , strong) NSTimer *timer;
@property (nonatomic ,strong)UITextField *textField;

@property (nonatomic, strong) UILabel *badge;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation MainViewController

- (void)dealloc {
    
    [[CartBadgeSingleton sharedManager] removeObserver:self forKeyPath:@"cartArr"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(45, 3, 99, 30)];
    imageView.image = [UIImage imageNamed:@"91jksc"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40,14, 99, 30)];
    label.text = @"91jksc.com";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Dauphin" size:23];
    
    [self createNavWithLeftImage:@"item"    andRightImage:@[@"cart",@"dimensional"] andTitleView:label andTitle:nil andSEL:@selector(leftBtn:) ];

    [self testHttpMsPost];
    
    [self createCartBadge];
    
    [[CartBadgeSingleton sharedManager] getCartBadgeNumBynet];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    
}

-(NSMutableArray *)openadsArr{
    if (!_openadsArr) {
        _openadsArr = [[NSMutableArray alloc]init];
    }
    return _openadsArr;
}

#pragma mark ----- 请求网络数据
-(void) testHttpMsPost{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@/lists.html",API_CLASS];
    NSDictionary * paramsDic=nil;
    if ([Function getUserName].length != 0) {
        paramsDic = @{@"username":[Function getUserName],@"client":@"ios",@"ip2long":[LoadDate getIPDress],@"deviceName":DEVICE,@"macAddress":MAC_ADDRESS};
    }else{
    
       paramsDic = @{@"username":@"username",@"client":@"ios",@"ip2long":[LoadDate getIPDress],@"deviceName":DEVICE,@"macAddress":MAC_ADDRESS};
    }
    
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中"];
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        [hud hide:YES];
        if (error == nil) {
            //obj即为解析后的数据.
 
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                NSDictionary *dict = [obj objectForKey:@"data"];
                self.openadsArr = [dict objectForKey:@"openads"];
                _listArr = [dict objectForKey:@"list"];
                [self createCollectionView];
                [self.collectionV reloadData];
            }
            
        }else{
            [self createNonNetView];
        }

    }];
    
    
}

#pragma makr 导航栏按钮点击事件
-(void)leftBtn:(UIButton *)btn
{
    if (btn.tag == 1000) {
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        
    }else if (btn.tag == 2000) {
        // 购物车
        if ([Function isLogin]) {
            [(UITabBarController *)self.mm_drawerController.centerViewController setSelectedIndex:0];
            [[(UITabBarController *)self.mm_drawerController.centerViewController selectedViewController] setSelectedIndex:1];
        }else {
            [self presentViewController:[[LoginViewController alloc] init]animated:YES completion:nil];
        }
        
    }else if (btn.tag == 2001) {
        // 二维码
        [self presentViewController:[[QRCodeReaderViewController alloc] init] animated:YES completion:nil];
    }
    
}
-(void)addTarget:(UIButton *)btn{

    if (btn.tag == 104||btn.tag == 106 ||btn.tag == 107) {
        ServicesViewController *servicesVC = [[ServicesViewController alloc]init];
        servicesVC.titleName = [[_listArr objectAtIndex:btn.tag-100] objectForKey:@"gc_name"];
        servicesVC.gc_id = [[_listArr objectAtIndex:btn.tag-100] objectForKey:@"gc_id"];
        [self.navigationController pushViewController:servicesVC animated:YES];
    }else{
        TradeViewController *tradeVC = [[TradeViewController alloc]init];
        tradeVC.titleName = [[_listArr objectAtIndex:btn.tag-100] objectForKey:@"gc_name"];
        tradeVC.gc_id =[[_listArr objectAtIndex:btn.tag-100] objectForKey:@"gc_id"];
    
        [self.navigationController pushViewController:tradeVC animated:YES];
    }
}
-(void)createBtn{
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134, 64+(SYS_HEIGHT-64) *0.27049+(SYS_HEIGHT-64)*0.013251, SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.22551) andImageName:SYS_WIDTH<700?@"image_zrjk":@"image_ipad_zrjk" andTarget:@selector(addTarget:) andClassObject:self andTag:100 andColor:[UIColor colorWithRed:0.44f green:0.77f blue:0.58f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134*2+SYS_WIDTH*0.46799, 64+(SYS_HEIGHT-64) *0.27049+(SYS_HEIGHT-64)*0.013251, SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.22551) andImageName:SYS_WIDTH<700?@"image_yybj":@"image_ipad_yybj" andTarget:@selector(addTarget:) andClassObject:self andTag:101 andColor:[UIColor colorWithRed:0.58f green:0.64f blue:0.48f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134, 64+(SYS_HEIGHT-64) *0.27049+(SYS_HEIGHT-64)*0.013251*2+(SYS_HEIGHT-64)*0.22551, SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.22551) andImageName:SYS_WIDTH<700?@"image_ylqx":@"image_ipad_ylqx" andTarget:@selector(addTarget:) andClassObject:self andTag:102 andColor:[UIColor colorWithRed:0.41f green:0.57f blue:0.80f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134*2+SYS_WIDTH*0.46799, 64+(SYS_HEIGHT-64)*(0.27049+0.013251*2+0.22551), SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.10612) andImageName:SYS_WIDTH<700?@"image_yp":@"image_ipad_yp" andTarget:@selector(addTarget:) andClassObject:self andTag:103 andColor:[UIColor colorWithRed:0.44f green:0.76f blue:0.72f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134*2+SYS_WIDTH*0.46799, 64+(SYS_HEIGHT-64) * (0.27049+0.013251*3+0.22551+0.10612), SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.10612) andImageName:SYS_WIDTH<700?@"image_jkfw":@"image_ipad_jkfw" andTarget:@selector(addTarget:) andClassObject:self andTag:104 andColor:[UIColor colorWithRed:0.54f green:0.81f blue:0.95f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134, 64+(SYS_HEIGHT-64) * (0.27049+0.013251*3+0.22551*2), SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.10612) andImageName:SYS_WIDTH<700?@"image_jkjd":@"image_ipad_jkjd" andTarget:@selector(addTarget:) andClassObject:self andTag:105 andColor:[UIColor colorWithRed:0.65f green:0.81f blue:0.04f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134, 64+(SYS_HEIGHT-64) * (0.27049+0.013251*4+0.22551*2+0.10612), SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.10612) andImageName:SYS_WIDTH<700?@"image_xxdj":@"image_ipad_xxdj" andTarget:@selector(addTarget:) andClassObject:self andTag:106 andColor:[UIColor colorWithRed:0.84f green:0.72f blue:0.36f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
    [ButtonModel createLittleBtn:CGRectMake(SYS_WIDTH *0.02134*2+SYS_WIDTH*0.46799, 64+(SYS_HEIGHT-64) * (0.27049+0.013251*3+0.22551*2), SYS_WIDTH *0.46799, (SYS_HEIGHT-64)*0.22551) andImageName:SYS_WIDTH<700?@"image_yygy":@"image_ipad_yygy" andTarget:@selector(addTarget:) andClassObject:self andTag:107 andColor:[UIColor colorWithRed:0.27f green:0.65f blue:0.71f alpha:1.00f] andBaseView:self.view andTitleName:nil andFont:14];
}
#pragma mark ----- 轮播图
-(void)createCollectionView{
   
    UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    headerFlowLayout.itemSize = CGSizeMake(SYS_WIDTH, (SYS_HEIGHT-64) *0.27049);
    headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    headerFlowLayout.minimumLineSpacing = 0;
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, (SYS_HEIGHT-64) *0.27049) collectionViewLayout:headerFlowLayout];
    self.collectionV
    .delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.pagingEnabled = YES;
    self.collectionV.tag = 10;
    self.collectionV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionV];
    
    
    [self.collectionV registerClass:[AdversionCollectionViewCell class] forCellWithReuseIdentifier:@"AdversionCollectionViewCell"];
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.openadsArr.count-1 inSection:100/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self addTimer];
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.center = CGPointMake(SYS_WIDTH*0.5, self.collectionV.frame.size.height * 0.85+SYS_HEIGHT *0.095);
    _pageControl.bounds = CGRectMake(0, 0, 150, self.openadsArr.count);
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.enabled = NO;
    _pageControl.numberOfPages = self.openadsArr.count;
    [self.view addSubview:_pageControl];


    
    UIImageView *imageV  = [[UIImageView  alloc]initWithFrame:CGRectMake( SYS_WIDTH *0.10667, 64+SYS_HEIGHT *0.01574, SYS_WIDTH *0.78666, SYS_HEIGHT *0.04853)];
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"image_search"];
    [self.view addSubview:imageV];

    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, SYS_WIDTH *0.69733, SYS_HEIGHT *0.04853);
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:searchBtn];
    [self createBtn];

}
#pragma mark 添加定时器
-(void) addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextpage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer ;
    
}

#pragma mark 删除定时器
-(void) removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

-(void) nextpage{
    NSIndexPath *currentIndexPath = [[self.collectionV indexPathsForVisibleItems] lastObject];
    
    NSIndexPath *currentIndexPathReset = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:100/2];
    [self.collectionV scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    NSInteger nextItem = currentIndexPathReset.item +1;
    NSInteger nextSection = currentIndexPathReset.section;
    if (nextItem==self.openadsArr.count) {
        nextItem=0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    
    [self.collectionV scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];

}

#pragma mark - 创建购物车数量badge
- (void)createCartBadge {
    UIButton *cartBtn = (UIButton *)[self.view viewWithTag:2000];
    
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
        _bgView.alpha = 1;
        _badge.text = [NSString stringWithFormat:@"%ld",[CartBadgeSingleton sharedManager].cartArr.count];
    }else {
        _bgView.alpha = 0;
    }
}


#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
        return 100;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
        return self.openadsArr.count;

    
}


-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

#pragma mark 当用户停止的时候调用
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (scrollView.tag == 10) {
        [self addTimer];

    }
}

#pragma mark 设置页码
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 10) {
        int page = (int) (scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%(self.openadsArr.count);
        self.pageControl.currentPage =page;

    }
   
}


- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     return CGSizeMake(SYS_WIDTH, (SYS_HEIGHT-64)*0.27049);
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
   static NSString *cellID = @"AdversionCollectionViewCell";
    
    AdversionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.news=self.newses[indexPath.item];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.view.frame];
    ImageWithUrl(imageV, [[self.openadsArr objectAtIndex:indexPath.item] objectForKey:@"image"]);
    cell.backgroundView =imageV;
        return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.openadsArr objectAtIndex:indexPath.row];
   
    if ([dict[@"type"] isEqualToString:@"url"]) {
        WebViewController *webVC = [[WebViewController alloc]init];
        webVC.urlStr = [dict objectForKey:@"data"];
        [self.navigationController pushViewController:webVC animated:YES];
    }else if([dict[@"type"] isEqualToString:@"good"]){
        TradeDetailViewController *tradeDetailVC = [[TradeDetailViewController alloc]init];
        tradeDetailVC.goods_id = dict[@"data"];
        [self.navigationController pushViewController:tradeDetailVC animated:YES];
    }else{
        if ([dict[@"data"] integerValue] == 5151 ||[dict[@"data"] integerValue] == 5008 ||[dict[@"data"] integerValue] == 5023) {
            ServicesViewController *servicesVC = [[ServicesViewController alloc]init];
            servicesVC.titleName =dict[@"gc_name"];
            servicesVC.gc_id = dict[@"data"];
            [self.navigationController pushViewController:servicesVC animated:YES];
        }else{
            TradeViewController *tradeVC = [[TradeViewController alloc]init];
            tradeVC.titleName = dict[@"gc_name"];
            tradeVC.gc_id = dict[@"data"];
            
            [self.navigationController pushViewController:tradeVC animated:YES];
        }
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //返回一个BOOL值，指定是否循序文本字段开始编辑
    
    return YES;
    
}
-(void)createNonNetView{
    emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64)];
    emptyView.backgroundColor = BACKGROUND_COLOR;
    
    UIImageView *emptyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 198, 240)];
    emptyImgView.image = [UIImage imageNamed:@"non-wifi-errorpage"];
    emptyImgView.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT * 0.3);
    [emptyView addSubview:emptyImgView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 0, 130, 50);
    homeButton.center = CGPointMake(SYS_WIDTH / 2, CGRectGetMaxY(emptyImgView.frame) + 30);
    [homeButton setImage:[UIImage imageNamed:@"non-wifi-errorpage-button"] forState:UIControlStateNormal];
    [homeButton addTarget:self action:@selector(homeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    homeButton.layer.cornerRadius = 5;
    
    [emptyView addSubview:homeButton];
    
    [self.view addSubview:emptyView];
}
-(void)homeButtonClicked{
    [emptyView removeFromSuperview];
    [self testHttpMsPost];
}
- (void)searchBtnClicked {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
