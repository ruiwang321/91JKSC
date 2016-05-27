//
//  AddressManageViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/5.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddressTableViewCell.h"
#import "AddressModel.h"
#import "EditAddressViewController.h"
#import "AddAddressViewController.h"

@interface AddressManageViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
/**
 *  地址列表数据源
 */
@property (nonatomic, strong) NSMutableArray *addressArr;
/**
 *  地址列表
 */
@property (nonatomic, strong) UITableView *addressList;
@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _addressArr = [NSMutableArray array];
    [self createNavBar];
    [self createTableView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataByNet];
}

- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.5, 20)];
    titleView.text = @"收货地址";
    titleView.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(leftBtn)];
    
}

- (void)createTableView {
    _addressList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:_addressList];
    _addressList.delegate = self;
    _addressList.dataSource = self;
    [_addressList registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"addressCell"];
    
    
    // 添加地址按钮
    UIButton *addAddressBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 50)];
    addAddressBtn.backgroundColor = [UIColor whiteColor];
    _addressList.tableFooterView = addAddressBtn;
    [addAddressBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addAddressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [addAddressBtn setImage:[UIImage imageNamed:@"ADD"] forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddressBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 表格代理和数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _addressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    AddressModel *model = _addressArr[indexPath.section];
    cell.defaultBtn.selected = model.is_default.boolValue;
    cell.nameLabel.text = model.true_name;
    cell.phoneLabel.text = model.mob_phone;
    cell.defaultBtn.tag = indexPath.section;
    cell.editBtn.tag = indexPath.section;
    cell.delBtn.tag = indexPath.section;
    cell.AddressLabel.text = [NSString stringWithFormat:@"%@%@",model.area_info,model.address];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

#pragma mark 网络加载数据
- (void)loadDataByNet {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"get_address.html"];
    NSDictionary *params = @{
                             @"key" :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"]
                             };
    
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            [_addressArr removeAllObjects];
            for (NSDictionary *dic in obj[@"data"]) {
                AddressModel *model = [[AddressModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_addressArr addObject:model];
            }
            [_addressList reloadData];
        }
    }];
}

// 导航栏返回按钮
- (void)leftBtn {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark cell上按钮点击事件
- (IBAction)defaultBtn:(UIButton *)sender {
    if (!sender.selected) {
        // 设置默认地址
        NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"is_default.html"];
        NSDictionary *parmas = @{
                                 @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                 @"address_id"  :[_addressArr[sender.tag] address_id]
                                 };
        [LoadDate httpPost:url param:parmas finish:^(NSData *data, NSDictionary *obj, NSError *error) {

            if ([obj[@"code"] isEqualToNumber:@200]) {
                for (AddressModel *model in _addressArr) {
                    model.is_default = @"0";
                }
                [_addressArr[sender.tag] setIs_default:@"1"];
                [_addressList reloadData];
            }
        }];
    }
}
- (IBAction)editBtn:(UIButton *)sender {
    EditAddressViewController *editVC = [[EditAddressViewController alloc] init];
    editVC.addressModel = _addressArr[sender.tag];
    [self.navigationController pushViewController:editVC animated:YES];
}
- (IBAction)deleBtn:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要删除这条地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alertView.tag = sender.tag;
    [alertView show];
}

// 添加地址
- (void)addAddressBtnClicked {
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc] init];
    if (_addressArr.count == 0) {
        addAddressVC.setDefault = YES;
    }
    [self.navigationController pushViewController:addAddressVC animated:YES];
}

#pragma mark alertView代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 删除地址信息
        AddressModel *model = _addressArr[alertView.tag];
        NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"del_address.html"];
        NSDictionary *params = @{
                                 @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                 @"address_id"  :[_addressArr[alertView.tag] address_id]
                                 };
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                [_addressArr removeObjectAtIndex:alertView.tag];
                if ([model.is_default boolValue] && _addressArr.count > 0) {
                    // 设置其他地址为默认地址
                    NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"is_default.html"];
                    NSDictionary *parmas = @{
                                             @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                             @"address_id"  :[_addressArr.firstObject address_id]
                                             };
                    [LoadDate httpPost:url param:parmas finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                        
                    }];
                    [_addressArr.firstObject setIs_default:@"1"];
                    
                }
                
                
                [_addressList reloadData];
            }
        }];
    }
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
