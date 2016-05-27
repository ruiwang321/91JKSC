//
//  MyMessageViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/5/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MyMessageViewController.h"
#import "TYSlidePageScrollView.h"
#import "TableViewController.h"
#import "TYTitlePageTabBar.h"
#import "EditUserInfoViewController.h"
#import "OrderModel.h"
@interface MyMessageViewController ()<TYSlidePageScrollViewDataSource>
@property (nonatomic, weak) TYSlidePageScrollView *slidePageScrollView;
@property (nonatomic ,strong) UIButton *selectBtn;
@property (nonatomic,strong) UILabel *userNameLabel;
@property (nonatomic,strong) UIImageView *imageV;



@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSlidePageScrollView];
    
    [self addHeaderView];
    
    [self addTabPageMenu];
    
    [self addTableViewWithPage:1 itemNum:3 andType:@"50"];
    
    [self addTableViewWithPage:1 itemNum:3 andType:@"10"];
    
    [self addTableViewWithPage:1 itemNum:3 andType:@"20"];
    
    [self addTableViewWithPage:1 itemNum:3 andType:@"30"];
    
    [self addTableViewWithPage:1 itemNum:3 andType:@"40"];
    
    [self addTableViewWithPage:1 itemNum:3 andType:@"60"];
    
    [_slidePageScrollView reloadData];
    
     [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:@"我的" andSEL:@selector(leftBtn:)];
}
-(void)leftBtn:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addSlidePageScrollView
{
    TYSlidePageScrollView *slidePageScrollView = [[TYSlidePageScrollView alloc]initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    slidePageScrollView.pageTabBarIsStopOnTop = YES;
    slidePageScrollView.dataSource = self;
    [self.view addSubview:slidePageScrollView];
    _slidePageScrollView = slidePageScrollView;
}

- (void)addHeaderView
{
    UIView *imageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_slidePageScrollView.frame), 180)];
    imageView.backgroundColor = [UIColor whiteColor];
    //绿色背景图
    UIView *titleView = [[UIView alloc]init];
    titleView.frame = CGRectMake(0, 0, SYS_WIDTH, 80);
    titleView.backgroundColor = BackGreenColor;
    [imageView addSubview:titleView];
    // 线
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, titleView.frame.size.height, SYS_WIDTH, 1)];
    lineLabel.backgroundColor = BACKGROUND_COLOR;
    [imageView addSubview:lineLabel];
    //头像
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, titleView.frame.size.height-15, SYS_HEIGHT *0.14, SYS_HEIGHT *0.14)];
    _imageV.layer.masksToBounds = YES;
    _imageV.layer.cornerRadius =SYS_HEIGHT *0.07;
    _imageV.layer.borderWidth = 2;
    _imageV.layer.borderColor = [UIColor whiteColor].CGColor;
    [_imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,self.imageName]] placeholderImage:[UIImage imageNamed:@"profile"]];
    
    _imageV.userInteractionEnabled = YES;
    [imageView addSubview:_imageV];
    
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
    _userNameLabel.text = self.nickName;
    _userNameLabel.font = SYS_FONT(18);
    _userNameLabel.userInteractionEnabled = YES;
    [imageView addSubview:_userNameLabel];
    
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
    [imageView addSubview:memberNameLabel];
    
    UIButton *memberNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    memberNameBtn.frame = CGRectMake(0, 0, SYS_WIDTH -_imageV.frame.size.width +25, 20);
    [memberNameBtn addTarget:self action:@selector(pushEditInfoVC) forControlEvents:UIControlEventTouchUpInside];
    [memberNameLabel addSubview:memberNameBtn];
    
    
    UILabel *lowLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 179, SYS_WIDTH, 1)];
    lowLineLabel.backgroundColor = BACKGROUND_COLOR;
    [imageView addSubview:lowLineLabel];
    
    _slidePageScrollView.headerView = imageView;
}
#pragma mark - 跳转个人资料编辑页面
- (void)pushEditInfoVC {
    EditUserInfoViewController *editInfoVC = [[EditUserInfoViewController alloc] init];
    editInfoVC.headerView = self.imageV;
    editInfoVC.nickNameLabel = self.userNameLabel;
    [self.navigationController pushViewController:editInfoVC animated:YES];
}
- (void)addTabPageMenu
{
    TYTitlePageTabBar *titlePageTabBar = [[TYTitlePageTabBar alloc]initWithTitleArray:@[@"全部订单",@"待付款",@"待发货",@"待收货",@"待评价",@"退款/退货"]];
    titlePageTabBar.frame = CGRectMake(0, 0, CGRectGetWidth(_slidePageScrollView.frame), 40);
    titlePageTabBar.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    _slidePageScrollView.pageTabBar = titlePageTabBar;
}

- (void)addTableViewWithPage:(NSInteger)page itemNum:(NSInteger)num andType:(NSString *)type
{
    
    TableViewController *tableViewVC = [[TableViewController alloc]init];
    tableViewVC.itemNum = num;
    tableViewVC.page = page;
    tableViewVC.typeStr = type;
    [self addChildViewController:tableViewVC];
}



#pragma mark - dataSource

- (NSInteger)numberOfPageViewOnSlidePageScrollView
{
    return self.childViewControllers.count;
} 

- (UIScrollView *)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index
{
    TableViewController *tableViewVC = self.childViewControllers[index];
    return tableViewVC.tableView;
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
