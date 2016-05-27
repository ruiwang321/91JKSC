//
//  ShowAddressViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShowAddressViewController.h"
#import "AddressListCell.h"
#import "AddressModel.h"
#import "AddAddressViewController.h"
#import "EditAddressViewController.h"

@interface ShowAddressViewController () <UITableViewDataSource, UITableViewDelegate>
/**
 *  地址列表
 */
@property (nonatomic, strong) UITableView *addressList;
/**
 *  地址列表数据源
 */
@property (nonatomic, strong) NSMutableArray *listArray;

@end

@implementation ShowAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _listArray = [NSMutableArray array];
    [self createNavBar];
    [self createTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self requestData];
}

- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.text = @"收货地址";
    titleView.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(leftBtn)];
}

- (void)createTableView {
    _addressList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT - 64) style:UITableViewStyleGrouped];
    _addressList.backgroundColor = RGB(235, 235, 235);
    _addressList.dataSource = self;
    _addressList.delegate = self;
    [self.view addSubview:_addressList];
    [self addTableHeaderView];
}

- (void)addTableHeaderView {
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

#pragma mark - 网络加载数据
- (void)requestData {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"get_address.html"];
    NSDictionary *params = @{
                             @"key" :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"]
                             };
    
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            [_listArray removeAllObjects];
            for (NSDictionary *dic in obj[@"data"]) {
                AddressModel *model = [[AddressModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_listArray addObject:model];
            }
            [_addressList reloadData];
        }
    }];
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"addressCell";
    
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[AddressListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    AddressModel *model = _listArray[indexPath.row];
    cell.nameLabel.text =  model.true_name;
    cell.phoneLabel.text = model.mob_phone;
    cell.areaLabel.text = [NSString stringWithFormat:@"%@%@",model.area_info,model.address];
    if ([model.address_id isEqual:_selMoedel.address_id]) {
        cell.selImgView.image = [UIImage imageNamed:@"select-green"];
    }else {
        cell.selImgView.image = [UIImage imageNamed:@"select"];
    }
    cell.editBtn.tag = indexPath.row + 400;
    [cell.editBtn addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5f;
}
#pragma mark 滑动删除cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressModel *model = _listArray[indexPath.row];
    
    // 删除地址信息
    NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"del_address.html"];
    NSDictionary *params = @{
                             @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                             @"address_id"  :model.address_id
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            [_listArray removeObjectAtIndex:indexPath.row];
            if (model.is_default.boolValue && _listArray.count != 0) {
                // 设置其他地址为默认地址
                NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"is_default.html"];
                NSDictionary *parmas = @{
                                         @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                         @"address_id"  :[_listArray.firstObject address_id]
                                         };
                [LoadDate httpPost:url param:parmas finish:^(NSData *data, NSDictionary *obj, NSError *error) {

                }];
            }
            
            if (model.address_id == _selMoedel.address_id) {
                // 删除选中地址之后重设一个为选中地址
                _selMoedel = _listArray.firstObject;
                _orderVC.addressModel = _listArray.firstObject;
                if (_listArray.count == 0) {
                    _orderVC.haveAddress = NO;
                }
            }
            [tableView reloadData];
            
        }
    }];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark cell的点击回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _orderVC.addressModel = _listArray[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 按钮点击事件
- (void)leftBtn {

    for (AddressModel *model in _listArray) {
        if ([model.address_id isEqualToString:_selMoedel.address_id]) {
            _orderVC.addressModel = model;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
// 添加地址
- (void)addAddressBtnClicked {
    AddAddressViewController *addAddressVC = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addAddressVC animated:YES];
}
// 编辑地址信息
- (void)editBtnClicked:(UIButton *)btn {
    EditAddressViewController *editAddressVC = [[EditAddressViewController alloc] init];
    editAddressVC.addressModel = _listArray[btn.tag - 400];
    [self.navigationController pushViewController:editAddressVC animated:YES];
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
