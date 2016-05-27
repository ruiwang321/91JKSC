
//
//  MeViewController.m
//  91jksc
//
//  Created by 商城 阜新 on 16/1/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "MeCollectionViewCell.h"
#import "UIView+SHCZExt.h"
#import "MyFavoritesModel.h"
#import "TradeDetailViewController.h"
#import "TradeModel.h"
#import <AFNetworking.h>
#import <UIViewController+MMDrawerController.h>
#import "UIView+ViewController.h"
#import "SHCZMainView.h"
#import "LiftSlideViewController.h"
#import "OrderModel.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderListView.h"
#import "MoreOrderTableViewCell.h"
#import "OrderConfirmByIDViewController.h"
#import "OrderDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "EditUserInfoViewController.h"
#import "AddEvaluateViewController.h"
#import "RefundViewController.h"
@interface MeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,assign)BOOL isTrue;
/*五个按钮*/
@property (nonatomic,strong) NSMutableArray * btnArray;

/*baseView的分割线*/
@property (nonatomic,strong) UIView *lineView;

/*用户头像*/
@property (nonatomic,strong) UIImageView *imageV;

/*从相册中获取图片的信息*/
@property (nonatomic,strong) NSDictionary *imageDictInfo;
/*上传图片返回的字典*/
@property (nonatomic,strong) NSDictionary *respondeDict;

/*订单状态*/
@property (nonatomic,strong)NSString *orderStareStr;

@property (nonatomic,assign)NSInteger index;
/*全部订单*/
@property (nonatomic,strong)NSDictionary *allOrderDict;
@property (nonatomic,strong)NSDictionary *daifahuoDict;
@property (nonatomic,strong)NSDictionary *daishouhuoDict;
@property (nonatomic,strong)NSDictionary *daipingjiaDict;
@property (nonatomic,strong)NSDictionary *daifukuanDict;

@property (nonatomic,strong)UIButton *btn;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIView *messageView;
/*我的订单tableView*/
@property (nonatomic,strong) UITableView *orderTableView;
@property (nonatomic,strong) UITableView *allOrderTableV;
@property (nonatomic,strong)UITableView *daifahuoTableV;
@property (nonatomic,strong)UITableView *daiShouhuoTableV;
@property (nonatomic,strong)UITableView *daiPingJiaTableV;
/* 我的订单 nsarray**/
@property (nonatomic,strong) NSMutableArray *orderArr;
@property (nonatomic,strong) NSMutableArray *allOrderArr;
@property (nonatomic,strong)NSMutableArray *daifahuoArr;
@property (nonatomic,strong)NSMutableArray *daishouhuoArr;
@property (nonatomic,strong)NSMutableArray *daipingjiaArr;

@property (nonatomic,strong)UIScrollView *btnScroll;
/*退款*/
@property (nonatomic,strong)UITableView * refundTableView;
@property (nonatomic,strong)NSMutableArray *refundArr;
@property (nonatomic,strong)NSDictionary *refundDict;


@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isTrue = YES;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createBaseView];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:@"我的" andSEL:@selector(leftBtn:)];
    //获取通知中心单例对象
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(centerNoti:) name:@"50" object:nil];

}
-(void)centerNoti:(NSNotification *)notification{

    NSDictionary *nameDictionary = [notification userInfo];
    for (NSString *str in [nameDictionary objectForKey:@"order"]) {
        [self loadDataMyOrder:str andIndex:1 andNum:6];
    }
   
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
-(NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc]init];
    }
    return _btnArray;
}
-(NSMutableArray *)refundArr{
    if (!_refundArr) {
        _refundArr = [[NSMutableArray alloc]init];
    }
    return _refundArr;
}
-(void)viewWillAppear:(BOOL)animated{
    _index = 1;
    [self loadDataMyOrder:@"10" andIndex:1 andNum:3];
    [self loadDataMyOrder:@"20" andIndex:1 andNum:3];
    [self loadDataMyOrder:@"30" andIndex:1 andNum:3];
    [self loadDataMyOrder:@"40" andIndex:1 andNum:3];
    [self loadDataMyOrder:@"50" andIndex:1 andNum:3];
    [self loadDataMyOrder:@"60" andIndex:1 andNum:3];

}
-(void)leftBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 创建顶端view
-(void)createBaseView{
    //最低端
    UIView * baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT*0.45)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    //绿色背景图
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT *0.2);
    titleView.backgroundColor = BackGreenColor;
    [baseView addSubview:titleView];
    //头像
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, titleView.frame.size.height-15, SYS_HEIGHT *0.14, SYS_HEIGHT *0.14)];
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.cornerRadius =SYS_HEIGHT *0.07;
    _imageV.layer.borderWidth = 2;
    _imageV.layer.borderColor = [UIColor whiteColor].CGColor;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,self.imageName]] placeholderImage:[UIImage imageNamed:@"profile"]];
    
    _imageV.userInteractionEnabled = YES;
    [baseView addSubview:_imageV];
    
    UIButton *imageVBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageVBtn.frame = CGRectMake(0, 0, SYS_HEIGHT *0.14, SYS_HEIGHT *0.14);
    [imageVBtn addTarget:self action:@selector(pushEditInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [_imageV addSubview:imageVBtn];
    
    
    NSString *str =[NSString stringWithFormat:@"%@/Library/Caches/login.txt", NSHomeDirectory()];
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [[NSData alloc] init];
    data = [fm contentsAtPath:str];
   
    
    //用户名
   _userNameLabel  = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.frame.size.width +25, titleView.frame.size.height +10, SYS_WIDTH -_imageV.frame.size.width +25, 20)];
    _userNameLabel.text = [self.nickName isEqualToString:@""]?self.userName:self.nickName;
    _userNameLabel.font = SYS_FONT(18);
    _userNameLabel.userInteractionEnabled = YES;
    [baseView addSubview:_userNameLabel];
    
    UIButton *usernameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    usernameBtn.frame = CGRectMake(0, 0, SYS_WIDTH -_imageV.frame.size.width +25, 30);
    [usernameBtn addTarget:self action:@selector(pushEditInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [_userNameLabel addSubview:usernameBtn];
    
    

    
    //编辑个人资料
    UILabel *memberNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageV.frame.size.width +20, titleView.frame.size.height +15+_userNameLabel.frame.size.height, SYS_WIDTH -_imageV.frame.size.width +25, 30)];
    memberNameLabel.text =@"编辑个人资料";
    memberNameLabel.userInteractionEnabled = YES;
    memberNameLabel.font = SYS_FONT(16);
    memberNameLabel.textColor = COLOR(158.1, 160.65, 160.65, 1.0);
    [baseView addSubview:memberNameLabel];
    
    UIButton *memberNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    memberNameBtn.frame = CGRectMake(0, 0, SYS_WIDTH -_imageV.frame.size.width +25, 20);
    [memberNameBtn addTarget:self action:@selector(pushEditInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [memberNameLabel addSubview:memberNameBtn];
    
    // 线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, baseView.frame.size.height-50, SYS_WIDTH, 1)];
    lineLabel.backgroundColor = BACKGROUND_COLOR;
    [baseView addSubview:lineLabel];
    
    _btnScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, baseView.frame.size.height-45, SYS_WIDTH, 45)];
    _btnScroll.alwaysBounceVertical = NO;
    _btnScroll.showsVerticalScrollIndicator = NO;
    _btnScroll.showsHorizontalScrollIndicator = NO;
    _btnScroll.backgroundColor = [UIColor whiteColor];
    

    [baseView addSubview:_btnScroll];
    
    
    NSArray *arr = @[@"全部订单",@"待付款",@"待发货",@"待收货",@"待评价",@"退款/退货"];
    for (int i=0; i<6; i++) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(SYS_WIDTH/5*i, 0, SYS_WIDTH/5, 40);
        [_btn setTitle:arr[i] forState:UIControlStateNormal];
        _btn.tag = 930+i;
        _btn.titleLabel.font = SYS_FONT(15);
         [_btn setTitleColor:COLOR(158.1, 160.65, 160.65, 1.0) forState:UIControlStateNormal];
        [_btn setTitleColor:BackGreenColor forState:UIControlStateSelected];
        if (i == 0) {
            _btn.selected = YES;
            
        }
        [_btn addTarget:self action:@selector(buttonWithTarget:) forControlEvents:UIControlEventTouchUpInside];
        [_btnScroll addSubview:_btn];
        [self.btnArray addObject:_btn];
        
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,_btnScroll.frame.size.height-2 , SYS_WIDTH/5, 2)];
    
    _lineView.backgroundColor = BackGreenColor;
    
    [_btnScroll addSubview:_lineView];
    _btnScroll.contentSize = CGSizeMake(SYS_WIDTH/5+SYS_WIDTH, 0);
    [self createScrollViewWithView:baseView];

}
#pragma mark - 跳转个人资料编辑页面
- (void)pushEditInfoVC {
    EditUserInfoViewController *editInfoVC = [[EditUserInfoViewController alloc] init];
    editInfoVC.headerView = self.imageV;
    editInfoVC.nickNameLabel = self.userNameLabel;
    [self.navigationController pushViewController:editInfoVC animated:YES];
}


#pragma  mark ------- 创建scrollView
-(void)createScrollViewWithView:(UIView *)baseView {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, baseView.frame.size.height,SYS_WIDTH ,SYS_HEIGHT-baseView.frame.size.height);
    _scrollView.contentSize = CGSizeMake(6 * SYS_WIDTH, 0);
    _scrollView.delegate = self;
    _scrollView.backgroundColor = BackGreenColor;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceVertical =NO;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    
}

#pragma mark ---- 滑动scroll时调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView ==_scrollView) {
        if (scrollView.contentOffset.x>SYS_WIDTH) {
            [_btnScroll setContentOffset:CGPointMake(SYS_WIDTH/5, 0) animated:YES];
        }else{
            [_btnScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        CGRect frame = _lineView.frame;
        frame.origin.x = scrollView.contentOffset.x/5;
        
        _lineView.frame = frame;
        
        NSInteger pageNum = (scrollView.contentOffset.x + SYS_WIDTH/2) / SYS_WIDTH;
        for (UIButton * btn in self.btnArray) {
        
            if (btn.tag-930 <= pageNum+0.5) {
                btn.selected = YES;
            }
          
            if (btn.tag-930 > pageNum+0.5) {
                btn.selected = NO;
            }
            if (btn.tag-930 <= pageNum-0.5) {
                btn.selected = NO;
            }
        }
    }
    
}
-(void)buttonWithTarget:(UIButton *)btn{

    
    for (UIButton * btns in self.btnArray) {
        if (btns.selected == YES) {
            
            btns.selected = NO;
        }
        if (btn != btns) {
            
            btn.selected = NO;
        }
    }
     [_scrollView setContentOffset:CGPointMake((btn.tag-930) * SYS_WIDTH, 0) animated:YES];
    
   
}
#pragma mark ---- 创建tableView
-(UITableView *)allOrderTableV{
    if (!_allOrderTableV) {
        _allOrderTableV = [[UITableView alloc]initWithFrame:CGRectMake(SYS_WIDTH *0, 0, SYS_WIDTH, SYS_HEIGHT*0.55) style:UITableViewStyleGrouped];
        [_allOrderTableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _allOrderTableV.dataSource = self;
        _allOrderTableV.delegate = self;
        _allOrderTableV.tag = 50;
        _allOrderTableV.emptyDataSetDelegate= self;
        _allOrderTableV.emptyDataSetSource = self;
        [_allOrderTableV registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [_allOrderTableV registerClass:[MoreOrderTableViewCell class] forCellReuseIdentifier:@"MoreOrderTableViewCell"];
        
        [_scrollView addSubview:_allOrderTableV];
        __weak typeof(self) weakSelf = self;
        _allOrderTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage:@"50"];
            
        }];
        _allOrderTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData:@"50"];
            
        }];
    }
    return _allOrderTableV;
}
-(UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(SYS_WIDTH *1, 0, SYS_WIDTH, SYS_HEIGHT*0.55) style:UITableViewStyleGrouped];
        [_orderTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _orderTableView.dataSource = self;
        _orderTableView.delegate = self;
        _orderTableView.tag = 10;
        _orderTableView.emptyDataSetDelegate= self;
        _orderTableView.emptyDataSetSource = self;
        [_orderTableView registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [_orderTableView registerClass:[MoreOrderTableViewCell class] forCellReuseIdentifier:@"MoreOrderTableViewCell"];
        
        [_scrollView addSubview:_orderTableView];
        __weak typeof(self) weakSelf = self;
        _orderTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage:@"10"];
            
        }];
        _orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData:@"10"];
            
        }];
    }
    return _orderTableView;
}
-(UITableView *)daifahuoTableV{
    if (!_daifahuoTableV) {
        _daifahuoTableV = [[UITableView alloc]initWithFrame:CGRectMake(SYS_WIDTH *2, 0, SYS_WIDTH, SYS_HEIGHT*0.55) style:UITableViewStyleGrouped];
        [_daifahuoTableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _daifahuoTableV.dataSource = self;
        _daifahuoTableV.delegate = self;
        _daifahuoTableV.tag = 20;
        _daifahuoTableV.emptyDataSetDelegate= self;
        _daifahuoTableV.emptyDataSetSource = self;
        [_daifahuoTableV registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [_daifahuoTableV registerClass:[MoreOrderTableViewCell class] forCellReuseIdentifier:@"MoreOrderTableViewCell"];
        
        [_scrollView addSubview:_daifahuoTableV];
        __weak typeof(self) weakSelf = self;
        _daifahuoTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage:@"20"];
            
        }];
        _daifahuoTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData:@"20"];
           
        }];
    }
    return _daifahuoTableV;
}
-(UITableView *)daiShouhuoTableV{
    if (!_daiShouhuoTableV) {
        _daiShouhuoTableV = [[UITableView alloc]initWithFrame:CGRectMake(SYS_WIDTH *3, 0, SYS_WIDTH, SYS_HEIGHT*0.55) style:UITableViewStyleGrouped];
        [_daiShouhuoTableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _daiShouhuoTableV.dataSource = self;
        _daiShouhuoTableV.delegate = self;
        _daiShouhuoTableV.tag = 30;
        
        _daiShouhuoTableV.emptyDataSetDelegate= self;
        
        _daiShouhuoTableV.emptyDataSetSource = self;
        [_daiShouhuoTableV registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [_daiShouhuoTableV registerClass:[MoreOrderTableViewCell class] forCellReuseIdentifier:@"MoreOrderTableViewCell"];
        
        [_scrollView addSubview:_daiShouhuoTableV];
        __weak typeof(self) weakSelf = self;
        _daiShouhuoTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage:@"30"];
            
        }];
        _daiShouhuoTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData:@"30"];
            
        }];
    }
    return _daiShouhuoTableV;
}
-(UITableView *)daiPingJiaTableV{
    if (!_daiPingJiaTableV) {
        _daiPingJiaTableV = [[UITableView alloc]initWithFrame:CGRectMake(SYS_WIDTH *4, 0, SYS_WIDTH, SYS_HEIGHT*0.55) style:UITableViewStyleGrouped];
        [_daiPingJiaTableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _daiPingJiaTableV.dataSource = self;
        _daiPingJiaTableV.delegate = self;
        _daiPingJiaTableV.tag = 40;
        _daiPingJiaTableV.emptyDataSetDelegate= self;
        _daiPingJiaTableV.emptyDataSetSource = self;
        [_daiPingJiaTableV registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [_daiPingJiaTableV registerClass:[MoreOrderTableViewCell class] forCellReuseIdentifier:@"MoreOrderTableViewCell"];
        
        [_scrollView addSubview:_daiPingJiaTableV];
        __weak typeof(self) weakSelf = self;
        _daiPingJiaTableV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage:@"40"];
            
        }];
        _daiPingJiaTableV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData:@"40"];
        }];
    }
    return _daiPingJiaTableV;
}
-(UITableView *)refundTableView{
    if (!_refundTableView) {
        _refundTableView = [[UITableView alloc]initWithFrame:CGRectMake(SYS_WIDTH *5, 0, SYS_WIDTH, SYS_HEIGHT*0.55) style:UITableViewStyleGrouped];
        [_refundTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _refundTableView.dataSource = self;
        _refundTableView.delegate = self;
        _refundTableView.tag = 60;
        _refundTableView.emptyDataSetDelegate= self;
        _refundTableView.emptyDataSetSource = self;
        [_refundTableView registerClass:[MeTableViewCell class] forCellReuseIdentifier:@"MeTableViewCell"];
        [_refundTableView registerClass:[MoreOrderTableViewCell class] forCellReuseIdentifier:@"MoreOrderTableViewCell"];
        
        [_scrollView addSubview:_refundTableView];
        __weak typeof(self) weakSelf = self;
        _refundTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage:@"60"];
            
        }];
        _refundTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData:@"60"];
        }];
    }
    return _refundTableView;
}
//下拉刷新
-(void)refreshData:(NSString *)title{
    _index = 1;
    [self loadDataMyOrder:title andIndex:_index andNum:3];
}
//上拉加载
-(void)reloadMoreMessage:(NSString *)title{
    _index = _index+1;

    if (title.longLongValue == 10) {
        if (_index*3 <= [_daifukuanDict[@"data"][@"total"] integerValue] ) {
            [self loadDataMyOrder:title andIndex:_index andNum:3];
        }else{
            if (_index*3 -[_daifukuanDict[@"data"][@"total"] integerValue]>0 && _index*3 -[_daifukuanDict[@"data"][@"total"] integerValue]<3) {
                [self loadDataMyOrder:title andIndex:_index andNum:([_daifukuanDict[@"data"][@"total"] integerValue]-(_index-1)*3)];
                return;
            }else{
                [self.orderTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }

           
        }
        
    }else if (title.longLongValue == 20){
        if (_index*3 <= [_daifahuoDict[@"data"][@"total"] integerValue] ) {
            [self loadDataMyOrder:title andIndex:_index andNum:3];
        }else{
            if (_index*3 -[_daifahuoDict[@"data"][@"total"] integerValue]>0 && _index*3 -[_daifahuoDict[@"data"][@"total"] integerValue]<3) {
                [self loadDataMyOrder:title andIndex:_index andNum:([_daifahuoDict[@"data"][@"total"] integerValue]-(_index-1)*3)];
                return;
            }else{
                [self.daifahuoTableV.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
        }
        
    }else if (title.longLongValue == 30){
        if (_index*3 <= [_daishouhuoDict[@"data"][@"total"] integerValue] ) {
            [self loadDataMyOrder:title andIndex:_index andNum:3];
        }else{
            if (_index*3 -[_daishouhuoDict[@"data"][@"total"] integerValue]>0 && _index*3 -[_daishouhuoDict[@"data"][@"total"] integerValue]<3) {
                [self loadDataMyOrder:title andIndex:_index andNum:([_daishouhuoDict[@"data"][@"total"] integerValue]-(_index-1)*3)];
                return;
            }else{
               [self.daiShouhuoTableV.mj_footer setState:MJRefreshStateNoMoreData];
            }
            

        }
        
    }else if (title.longLongValue == 40){
        if (_index*3 <= [_daipingjiaDict[@"data"][@"total"] integerValue] ) {
            [self loadDataMyOrder:title andIndex:_index andNum:3];
        }else{
            if (_index*3 -[_daipingjiaDict[@"data"][@"total"] integerValue]>0 && _index*3 -[_daipingjiaDict[@"data"][@"total"] integerValue]<3) {
                [self loadDataMyOrder:title andIndex:_index andNum:([_daipingjiaDict[@"data"][@"total"] integerValue]-(_index-1)*3)];
                return;
            }else{
                [self.daiPingJiaTableV.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
            
        }
        
    }else if (title.longLongValue == 50){
        if (_index*3 <= [_allOrderDict[@"data"][@"total"] integerValue] ) {
            [self loadDataMyOrder:title andIndex:_index andNum:3];
        }else{
            if (_index*3 -[_allOrderDict[@"data"][@"total"] integerValue]>0 && _index*3 -[_allOrderDict[@"data"][@"total"] integerValue]<3) {
                [self loadDataMyOrder:title andIndex:_index andNum:([_allOrderDict[@"data"][@"total"] integerValue]-(_index-1)*3)];
                return;
            }else{
                 [self.allOrderTableV.mj_footer setState:MJRefreshStateNoMoreData];
            }
           
            
        }
    }else{
        if (_index*3 <= [_refundDict[@"data"][@"total"] integerValue] ) {
            [self loadDataMyOrder:title andIndex:_index andNum:3];
        }else{
            if (_index*3 -[_refundDict[@"data"][@"total"] integerValue]>0 && _index*3 -[_refundDict[@"data"][@"total"] integerValue]<3) {
                [self loadDataMyOrder:title andIndex:_index andNum:([_refundDict[@"data"][@"total"] integerValue]-(_index-1)*3)];
                return;
            }else{
                [self.refundTableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
            
        }
    }
    
    
}

#pragma mark- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10) {
        return self.orderArr.count;
    }else if (tableView.tag == 20){
        return self.daifahuoArr.count;
    }else if (tableView.tag == 30){
        return self.daishouhuoArr.count;
    }else if (tableView.tag == 40){
        return self.daipingjiaArr.count;
    }else if (tableView.tag == 50){
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
    if (tableView.tag == 10) {
        if (self.orderArr.count>0) {
            return 20;
        }else{
            return CGFLOAT_MIN;
        }
    }else if (tableView.tag == 20){
        if (self.daifahuoArr.count>0) {
            return 20;
        }else{
            return CGFLOAT_MIN;
        }
        
    }else if(tableView.tag == 30){
        if (self.daishouhuoArr.count>0) {
            return 20;
        }else{
            return CGFLOAT_MIN;
        }
        
    }else if(tableView.tag == 40){
        if (self.daipingjiaArr.count>0) {
            return 20;
        }else{
            return CGFLOAT_MIN;
        }
    }else if (tableView.tag == 50){
        if (self.allOrderArr.count>0) {
            return 20;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        if (self.refundArr.count>0) {
            return 20;
        }else{
            return CGFLOAT_MIN;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _messageView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_SCALE(25))];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SYS_SCALE(60), 3, SYS_SCALE(19), SYS_SCALE(19))];
    imageV.image = [UIImage imageNamed:@"ic"];
    [_messageView addSubview:imageV];
    
    _titleLabel  = [[UILabel  alloc]initWithFrame:CGRectMake(SYS_SCALE(88), 3, SYS_WIDTH-SYS_SCALE(88), SYS_SCALE(19))];
    _titleLabel.font = SYS_FONT(14);
    
    
    [_messageView addSubview:_titleLabel];
    
    if (tableView.tag == 10) {
        if (self.orderArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daifukuanDict[@"data"][@"total"]];
        
            return _messageView;
        }else{
            return nil;
        }
    }else if (tableView.tag == 20){
        if (self.daifahuoArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daifahuoDict[@"data"][@"total"]];
            return _messageView;
        }else{
        
            return nil;
        }
        
    }else if(tableView.tag == 30){
        if (self.daishouhuoArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daishouhuoDict[@"data"][@"total"]];
            return _messageView;
        }else{
            return nil;
        }
        
    }else if(tableView.tag == 40){
        if (self.daipingjiaArr.count>0) {
            _titleLabel.text = [NSString stringWithFormat:@"您有%@条订单信息，请及时处理。",_daipingjiaDict[@"data"][@"total"]];
            return _messageView;
        }else{
            return nil;
        }
    }else if (tableView.tag == 50){
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *model;
   
    if (tableView.tag == 10) {
        model = [self.orderArr objectAtIndex:indexPath.row];
    }else if (tableView.tag == 20){
        model = [self.daifahuoArr objectAtIndex:indexPath.row];
        
    }else if(tableView.tag == 30){
        model = [self.daishouhuoArr objectAtIndex:indexPath.row];
        
    }else if(tableView.tag == 40){
        model = [self.daipingjiaArr objectAtIndex:indexPath.row];
    }else if(tableView.tag == 50){
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
    
    if (tableView.tag == 10) {
        model = [self.orderArr objectAtIndex:indexPath.row];
    }else if (tableView.tag == 20){
        model = [self.daifahuoArr objectAtIndex:indexPath.row];
        
    }else if(tableView.tag == 30){
        model = [self.daishouhuoArr objectAtIndex:indexPath.row];
        
    }else if(tableView.tag == 40){
        model = [self.daipingjiaArr objectAtIndex:indexPath.row];
    }else if(tableView.tag == 50){
        model = [self.allOrderArr objectAtIndex:indexPath.row];
    }else{
         model = [self.refundArr objectAtIndex:indexPath.row];
    }
    OrderDetailViewController *orderDVC = [[OrderDetailViewController alloc]init];

    orderDVC.orders_id =model.order_id;
    orderDVC.order_state =model.order_state;
    if (tableView.tag == 60) {
        orderDVC.isRefund = YES;
    }else{
        orderDVC.isRefund = NO;
    }
    [self.navigationController pushViewController:orderDVC animated:YES];
    
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
                    if (_index == 1) {
                        self.orderArr = oreder;
                    }else{
                        [self.orderArr addObjectsFromArray:oreder];
                    }
                    
                    [self.orderTableView reloadData];
                    _daifukuanDict = obj;

                }else if (orderPage.longLongValue == 20){
                    if (_index == 1) {
                        self.daifahuoArr = oreder;
                    }else{
                        [self.daifahuoArr addObjectsFromArray:oreder];
                        
                    }
                    _daifahuoDict = obj;
                    [self.daifahuoTableV reloadData];
                    
                    
                }else if (orderPage.longLongValue == 30){
                    if (_index == 1) {
                        self.daishouhuoArr = oreder;
                    }else{
                        [self.daishouhuoArr addObjectsFromArray:oreder];
                       
                    }
                    [self.daiShouhuoTableV reloadData];
                    _daishouhuoDict = obj;
                    
                }else if (orderPage.longLongValue == 40){
                    if (_index == 1) {
                        self.daipingjiaArr = oreder;
                    }else{
                        [self.daipingjiaArr addObjectsFromArray:oreder];
                    }
                    [self.daiPingJiaTableV reloadData];
                    _daipingjiaDict = obj;
                }else if (orderPage.longLongValue == 50){
                    if (_index == 1) {
                        self.allOrderArr = oreder;
                    }else{
                        [self.allOrderArr addObjectsFromArray:oreder];
                    }
                    [self.allOrderTableV reloadData];
                    _allOrderDict = obj;
                }else{
                    if (_index == 1) {
                        self.refundArr = oreder;
                    }else{
                        [self.refundArr addObjectsFromArray:oreder];
                    }
                    [self.refundTableView reloadData];
                    _refundDict = obj;
                }
            }else if ([obj[@"code"] longLongValue] == 202){
                if (orderPage.longLongValue == 10) {
                    [self.orderArr removeAllObjects];
                    _daifukuanDict = obj;

                    [self.orderTableView reloadData];
                }else if (orderPage.longLongValue == 20){
                    [self.daifahuoArr removeAllObjects];
                    [self.daifahuoTableV reloadData];
                    _daifahuoDict = obj;
                    
                }else if (orderPage.longLongValue == 30){
                    [self.daishouhuoArr removeAllObjects];
                    [self.daiShouhuoTableV reloadData];

                    _daishouhuoDict = obj;
                    
                }else if (orderPage.longLongValue == 40){
                    [self.daipingjiaArr removeAllObjects];
                    [self.daiPingJiaTableV reloadData];
                    _daipingjiaDict = obj;
                }else if (orderPage.longLongValue == 50){
                    [self.allOrderArr removeAllObjects];
                    [self.allOrderTableV reloadData];
                    _allOrderDict = obj;
                }else{
                    [self.refundArr removeAllObjects];
                    [self.refundTableView reloadData];
                    _refundDict = obj;
                }
            }
            
            [hud hide:YES];
            [self.allOrderTableV.mj_header endRefreshing];
            [self.allOrderTableV.mj_footer endRefreshing];
            [self.orderTableView.mj_header endRefreshing];
            [self.orderTableView.mj_footer endRefreshing];
            [self.daifahuoTableV.mj_header endRefreshing];
            [self.daifahuoTableV.mj_footer endRefreshing];
            [self.daiShouhuoTableV.mj_header endRefreshing];
            [self.daiShouhuoTableV.mj_footer endRefreshing];
            [self.daiPingJiaTableV.mj_header endRefreshing];
            [self.daiPingJiaTableV.mj_footer endRefreshing];
            [self.refundTableView.mj_header endRefreshing];
            [self.refundTableView.mj_footer endRefreshing];

        }else{
            [hud hide:YES];
            [MBProgressHUD showError:@"网络不给力"];
        }
        
    }];

    
}

#pragma mark - 返回空页面数据源和代理方法
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(SYS_HEIGHT*0.45, 0, SYS_WIDTH, SYS_HEIGHT*0.55)];
    emptyView.backgroundColor = BACKGROUND_COLOR;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, SYS_HEIGHT*0.3, SYS_WIDTH-20, 30)];
    label.center = CGPointMake(SYS_WIDTH/2, SYS_HEIGHT*0.3);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    [emptyView addSubview:label];
    if (scrollView.tag == 10) {
        label.text = @"您没有待付款的订单";
    }else if (scrollView.tag == 20){
        label.text = @"您没有待发货的订单";
    }else if (scrollView.tag == 30){
        label.text = @"您没有待收货的订单";
    }else if (scrollView.tag == 40){
      label.text = @"您没有待评价的订单";
    }else if (scrollView.tag == 50){
        label.text = @"您没有任何订单";
    }else{
        label.text = @"您没有退款/退货的订单";
    }
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
