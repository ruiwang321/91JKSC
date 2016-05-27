//
//  ShippmentViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/21.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShippmentViewController.h"
#import "ShippmentTableViewCell.h"
#import "ShippmentModel.h"
#import "ShippmentOneTableViewCell.h"
@interface ShippmentViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong)UITableView *shippmentTableView;
@property (nonatomic,strong)NSMutableArray *infoArr;

@end

@implementation ShippmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavBar];
    [self loadData];
}

- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"物流详情";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView *)shippmentTableView{
    if (!_shippmentTableView) {
        _shippmentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStyleGrouped];
        _shippmentTableView.dataSource = self;
        _shippmentTableView.delegate = self;
        _shippmentTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        [_shippmentTableView registerClass:[ShippmentTableViewCell class] forCellReuseIdentifier:@"ShippmentTableViewCell"];
        [_shippmentTableView registerClass:[ShippmentOneTableViewCell class] forCellReuseIdentifier:@"ShippmentOneTableViewCell"];
        [self.view addSubview:_shippmentTableView];
    }
    return _shippmentTableView;
}
-(NSMutableArray *)infoArr{
    if (!_infoArr) {
        _infoArr = [[NSMutableArray alloc]init];
        
    }
    return _infoArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.infoArr.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 120;
    }else{
        ShippmentModel *model = self.infoArr[indexPath.row];
        return model.rowHight;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        NSString *cellID = @"ShippmentOneTableViewCell";
        ShippmentOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ShippmentOneTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ShippmentModel *model = nil;
        if (self.infoArr.count>0) {
            model = self.infoArr[self.infoArr.count-1];
        }
        cell.shippModel = model;
        return cell;
    }else{
        NSString *cellID = @"ShippmentTableViewCell";
        ShippmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ShippmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        ShippmentModel *model = self.infoArr[self.infoArr.count-1 -indexPath.row];
        cell.shippModel = model;
        if (indexPath.row == 0) {
            cell.isFistRow = YES;
        }else{
            cell.isFistRow = NO;
        }
        if (self.infoArr.count ==1) {
            cell.linedownView.hidden = YES;
        }
        return cell;
    }
    
}

#pragma mark ---- 网络数据
-(void)loadData{
    
    NSString *pathstr = [NSString stringWithFormat:@"%@shippment.html",API_ORDER];
    NSDictionary * Dic = @{
                           @"key"           :[Function getKey],
                           @"order_id":self.orderID,
                           };
    [LoadDate httpPost:pathstr param:Dic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            NSString *str= [obj objectForKey:@"code"];
            
            if (str.longLongValue == 200) {
                for (NSDictionary *dic in obj[@"data"]) {
                    ShippmentModel *model = [[ShippmentModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.infoArr addObject:model];
                }
                [self.shippmentTableView reloadData];
                
                /*
                 code = 200;
                 data =     (
                 {
                 "shipping_code" = 123456;
                 "shipping_name" = "\U672a\U77e5\U7269\U6d41\U516c\U53f8!";
                 "shipping_status" = "\U6b63\U5728\U7b49\U5f85\U7269\U6d41\U516c\U53f8\U53d6\U4ef6!";
                 "shipping_time" = 1461206328;
                 }
                 );
                 */
                
                
            }else{
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
            }
        }else{
            [MBProgressHUD showError:@"网络不给力"];
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
