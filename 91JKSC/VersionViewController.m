//
//  VersionViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/28.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * versionTableView;
@property (nonatomic,strong)NSDictionary *dataDict;
@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavBar];
    [self loadListData];
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"版本说明";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView *)versionTableView{
    if (!_versionTableView) {
        _versionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStyleGrouped];
        _versionTableView.delegate = self;
        _versionTableView.dataSource = self;
        _versionTableView.bounces = NO;
        _versionTableView.backgroundColor = [UIColor clearColor];
        _versionTableView.separatorStyle = UITableViewCellAccessoryNone;
        [_versionTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.view addSubview:_versionTableView];
        
    }
    return  _versionTableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return [_dataDict[@"list"] count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [[NSString stringWithFormat:@"%@",_dataDict[@"list"][indexPath.row][@"content"] ] boundingRectWithSize:CGSizeMake(SYS_WIDTH,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(15)} context:nil].size;
    if (indexPath.section == 0) {
        return 20;
    }else{
        return size.height+5;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = SYS_FONT(15);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_dataDict[@"list"][indexPath.row][@"content"]];
    }else{
        cell.textLabel.font = SYS_FONT(16);
        cell.textLabel.text = _dataDict[@"title"];
    }
    return cell;
}
-(void)loadListData{
    NSString * pathURL = [NSString stringWithFormat:@"%@%@",API_URL,@"/index/Version/info.html"];
    
    NSDictionary *dic = @{
                          @"type":@"1",
                          @"version":self.version
                          };
    [LoadDate httpPost:pathURL param:dic finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            if ([obj[@"code"] longLongValue] == 200) {
                _dataDict = obj[@"data"];
                [self.versionTableView reloadData];
                /*
                 
              {
                 code = 200;
                 data =     {
                     list =         {
                         content = "2. \U66f4\U591a\U4f18\U60e0\U656c\U8bf7\U671f\U5f85.";
                     };
                     title = "2.0.0\U66f4\U65b0\U5185\U5bb9";
                     total = 1;
                  };
                 msg = "\U8bf7\U6c42\U6210\U529f!";
              }
                 
                 */
          
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
