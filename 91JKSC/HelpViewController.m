//
//  HelpViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/22.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpDetailViewController.h"
@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *helpTableView;
@property (nonatomic,strong)NSArray *helplistArr;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,strong)NSDictionary *dataDict;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _index = 1;
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createNavBar];
    [self loadHelpList:1 andNum:10];
    
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"帮助";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(NSArray *)helplistArr{
    if (!_helplistArr) {
        _helplistArr = [[NSMutableArray alloc]init];
        
    }
    return _helplistArr;
}
-(void)dismissMyself{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView *)helpTableView{
    if (!_helpTableView) {
        _helpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStyleGrouped];
        _helpTableView.dataSource = self;
        _helpTableView.delegate = self;
        [_helpTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_helpTableView];
        __weak typeof(self) weakSelf = self;
        _helpTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf refreshData];
            
            
            
        }];
        
        _helpTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf reloadMoreMessage];
            
        }];
    }
    return _helpTableView;
}
//下拉刷新
-(void)refreshData{
    
    _index = 1;
    [self loadHelpList:1 andNum:10];
    
}
//上拉加载
-(void)reloadMoreMessage{
    _index = _index+1;

    if (_index*10 <= [_dataDict[@"data"][@"total"] integerValue] ) {
        [self loadHelpList:_index andNum:10];
    }else{
        if (_index*10 -[_dataDict[@"total"] integerValue]>0 && _index*10 -[_dataDict[@"total"] integerValue]<10) {
            [self loadHelpList:_index andNum:([_dataDict[@"total"] integerValue]-(_index-1)*10)];
            return;
        }else{
           [_helpTableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.helplistArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    NSDictionary *dic = self.helplistArr[indexPath.row];
    cell.textLabel.text = dic[@"help_title"];
     cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    HelpDetailViewController *helpDVC = [[HelpDetailViewController alloc]init];
    helpDVC.help_id = self.helplistArr[indexPath.row][@"help_id"];
   
    [self.navigationController pushViewController:helpDVC animated:YES];
}
#pragma mark ----- 加载帮助列表
-(void)loadHelpList:(NSInteger)indexP andNum:(NSInteger)number{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_HELP,@"lists.html"];
    NSDictionary *params = @{
                                 @"type":@"1",
                                 @"num"      :[NSString stringWithFormat:@"%ld",(long)number],
                                 @"page"     :[NSString stringWithFormat:@"%ld",(long)indexP]
                                 };
    
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            if ([obj[@"code"] longLongValue] == 200) {
                _dataDict = obj;
                self.helplistArr = obj[@"data"][@"list"];
                [self.helpTableView reloadData];
                
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
            [self.helpTableView.mj_footer endRefreshing];
            [self.helpTableView.mj_header endRefreshing];
        }else{
            [MBProgressHUD showError:@"请检查网络"];
        }

    }];
    

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
