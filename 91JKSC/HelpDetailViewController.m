//
//  HelpDetailViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/22.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "HelpDetailModel.h"
#import "HelpDetailTableViewCell.h"
@interface HelpDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *helpTableView;
@property (nonatomic,strong)NSMutableArray *helplistArr;
@property (nonatomic,strong)NSDictionary *dataDict;
@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createNavBar];
    
   
}
-(void)viewWillAppear:(BOOL)animated{
     [NSThread detachNewThreadSelector:@selector(loadHelpList) toTarget:self withObject:nil];
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"帮助详情";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(NSMutableArray *)helplistArr{
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
        _helpTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, SYS_WIDTH, SYS_HEIGHT-70) style:UITableViewStyleGrouped];
        _helpTableView.dataSource = self;
        _helpTableView.delegate = self;
        _helpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _helpTableView.bounces = NO;
        [_helpTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_helpTableView registerClass:[HelpDetailTableViewCell class] forCellReuseIdentifier:@"HelpDetailTableViewCell"];
        [self.view addSubview:_helpTableView];
        
    }
    return _helpTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.helplistArr.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }else{
        HelpDetailModel *model = self.helplistArr[indexPath.row];
        return model.rowHight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellID = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _dataDict[@"data"][@"list"][@"help_title"];
        return cell;
    }else{
        NSString *cellID = @"HelpDetailTableViewCell";
        HelpDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HelpDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        HelpDetailModel *model = self.helplistArr[indexPath.row];
        cell.helpDModel = model;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark ----- 加载帮助列表
-(void)loadHelpList{
    NSString *url = [NSString stringWithFormat:@"%@%@",API_HELP,@"info.html"];
    NSDictionary *params = @{
                             @"help_id":self.help_id,
                             };
    
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            if ([obj[@"code"] longLongValue] == 200) {
                _dataDict = obj;
                for (NSDictionary *dic  in obj[@"data"][@"list"][@"help_info"]) {
                    HelpDetailModel *model = [[HelpDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.helplistArr addObject:model];
                }
                [self.helpTableView reloadData];
            }else {
                [MBProgressHUD showError:obj[@"msg"]];
            }
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
