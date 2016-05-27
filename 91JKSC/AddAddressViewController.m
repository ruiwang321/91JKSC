//
//  AddAddressViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
    UIButton *_selAreaBtn;
    
    UITextField *pickerTextFeild;
    
    NSArray *provinceArr;
    NSArray *cityArr;
    NSArray *districtArr;
    
    NSInteger provinceIndex;
    NSInteger cityIndex;
    NSInteger districtIndex;
    
    NSString *allName;
}

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(235, 235, 235);
    [self createNavBar];
    [self createSubView];
}

- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.5, 20)];
    titleView.text = @"添加新收货地址";
    titleView.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(leftBtn)];

}

// 创建子视图
- (void)createSubView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, SYS_WIDTH, 202)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    //划横线
    for (int i = 0; i < 4; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 50 + 51 * i, SYS_WIDTH - 20, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1];
        [bgView addSubview:lineView];
    }
    // 创建textField
    for (int i = 0; i < 4; i++) {
        if (i == 2) {
            continue;
        }
        UITextField *textFiexd = [[UITextField alloc] initWithFrame:CGRectMake(10, 9 + 51 * i, SYS_WIDTH - 52, 32)];
        textFiexd.tag = 150 + i;
        if (i==1) {
            textFiexd.keyboardType = UIKeyboardTypeNumberPad;
        }
        textFiexd.placeholder = @[@"收货人姓名", @"手机号码", @"", @"详细地址"][i];
        textFiexd.delegate = self;
        textFiexd.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:textFiexd];
    }
    
    // 创建选择省市Button
    _selAreaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selAreaBtn.frame = CGRectMake(10, 121, SYS_WIDTH - 75, 15);
    _selAreaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_selAreaBtn setTitle:@"选择省市区" forState:UIControlStateNormal];
    [_selAreaBtn setTitleColor:[UIColor colorWithRed:111/255.0f green:111/255.0f blue:111/255.0f alpha:1] forState:UIControlStateNormal];
    _selAreaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_selAreaBtn addTarget:self action:@selector(selAreaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_selAreaBtn];
    
    UIImageView *downImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    downImg.frame = CGRectMake(SYS_WIDTH - 38, 120, 22, 22);
    [bgView addSubview:downImg];
    
    // 保存并使用按钮
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 250 + 64, SYS_WIDTH - 20, 43)];
    saveBtn.backgroundColor = BackGreenColor;
    saveBtn.layer.cornerRadius = 5;
    saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [saveBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

#pragma mark - 回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 按钮点击事件

// 保存地址按钮点击事件
- (void)saveBtnClicked {
    UITextField *nameTF = (UITextField *)[self.view viewWithTag:150];
    UITextField *phoneTF = (UITextField *)[self.view viewWithTag:151];
    UITextField *areaTF = (UITextField *)[self.view viewWithTag:153];

    if (nameTF.text.length <=0 || phoneTF.text.length <=0 || areaTF.text.length <=0) {
          [MBProgressHUD showError:@"请输入完整信息"];
    }else {
        if ([phoneTF.text characterAtIndex:0] == '1' && phoneTF.text.length == 11) {
            NSDictionary *params = @{
                                     @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                     @"true_name"   :nameTF.text,
                                     @"mob_phone"   :phoneTF.text,
                                     @"area_info"   :_selAreaBtn.titleLabel.text,
                                     @"address"     :areaTF.text
                                     };
            
            [LoadDate httpPost:[NSString stringWithFormat:@"%@%@",API_ADDRESS,@"add_address.html"] param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                if ([obj[@"code"] isEqualToNumber:@200]) {
                    self.orderVC.haveAddress = YES;
                    [self.orderVC.addressModel setValuesForKeysWithDictionary:obj[@"data"]];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.isSetDefault) {
                        // 设置默认地址
                        NSString *url = [NSString stringWithFormat:@"%@%@",API_ADDRESS,@"is_default.html"];
                        NSDictionary *parmas = @{
                                                 @"key"         :[[NSUserDefaults standardUserDefaults] objectForKey:@"login_key"],
                                                 @"address_id"  :obj[@"data"][@"address_id"]
                                                 };
                        [LoadDate httpPost:url param:parmas finish:^(NSData *data, NSDictionary *obj, NSError *error) {
                            
                            if ([obj[@"code"] isEqualToNumber:@200]) {
                                
                            }
                        }];
                    }
                    
                }
            }];
        }else {
            [MBProgressHUD showError:@"手机号格式不正确"];
        }
            
    }
}

// 导航栏返回按钮
- (void)leftBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

// 选择地址区域按钮点击事件
- (void)selAreaBtnClicked:(UIButton *)btn {
    [btn setTitle:@"北京市北京市朝阳区" forState:UIControlStateNormal];
    // 读取地址json文件
    [self loadAreaInfo];
    pickerTextFeild = [[UITextField alloc] initWithFrame:CGRectMake(-10, 0, 1, 1)];
    [self.view addSubview:pickerTextFeild];
    // 创建地址选择器
    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 150)];
    mPickerView.backgroundColor = [UIColor whiteColor];
    pickerTextFeild.inputView = mPickerView;
    [pickerTextFeild becomeFirstResponder];
    
    mPickerView.delegate = self;
    mPickerView.dataSource = self;
}
// 读取地址json文件
- (void)loadAreaInfo {
    NSString *provincePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSData *provinceData = [NSData dataWithContentsOfFile:provincePath];
    NSDictionary *provinceDic = [NSJSONSerialization JSONObjectWithData:provinceData options:kNilOptions error:nil];
    provinceArr = [provinceDic objectForKey:@"province"];
    
    id cityItem = [provinceArr objectAtIndex:0];
    NSString *cityFilePath = [[NSBundle mainBundle] pathForResource:[cityItem objectForKey:@"spellName"] ofType:@"json"];
    NSData *cityData = [NSData dataWithContentsOfFile:cityFilePath];
    NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:cityData options:kNilOptions error:nil];
    cityArr = [cityDic objectForKey:@"city"];
    
    id districtItem = [cityArr objectAtIndex:0];
    NSString *districtFilePath = [[NSBundle mainBundle] pathForResource:[districtItem objectForKey:@"spellName"] ofType:@"json"];
    NSData *districtData = [NSData dataWithContentsOfFile:districtFilePath];
    NSDictionary *districtDic = [NSJSONSerialization JSONObjectWithData:districtData options:kNilOptions error:nil];
    districtArr = [districtDic objectForKey:@"district"];
}

#pragma mark - pickerView代理和数据源方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger row = 0;
    switch (component)
    {
        case 0:
            row = [provinceArr count];
            break;
        case 1:
            row = [cityArr count];
            break;
        case 2:
            row = [districtArr count];
            break;
        default:
            break;
    }
    return row;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    id item;
    switch (component)
    {
        case 0:
            item = [provinceArr objectAtIndex:row];
            provinceIndex = row;
            break;
        case 1:
            item = [cityArr objectAtIndex:row];
            cityIndex = row;
            break;
        case 2:
            item = [districtArr objectAtIndex:row];
            districtIndex = row;
            break;
        default:
            break;
    }
    if (item)
    {
        title = [item objectForKey:@"name"];
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (0 == component)
    {
        provinceIndex = row;
        id cityItem = [provinceArr objectAtIndex:row];
        NSString *cityFilePath = [[NSBundle mainBundle] pathForResource:[cityItem objectForKey:@"spellName"] ofType:@"json"];
        if (cityFilePath)
        {
            NSData *cityData = [NSData dataWithContentsOfFile:cityFilePath];
            NSDictionary *cityDic = [NSJSONSerialization JSONObjectWithData:cityData options:kNilOptions error:nil];
            cityArr = [cityDic objectForKey:@"city"];
            
            id districtItem = [cityArr objectAtIndex:0];
            NSString *districtFilePath = [[NSBundle mainBundle] pathForResource:[districtItem objectForKey:@"spellName"] ofType:@"json"];
            if (districtFilePath)
            {
                NSData *districtData = [NSData dataWithContentsOfFile:districtFilePath];
                NSDictionary *districtDic = [NSJSONSerialization JSONObjectWithData:districtData options:kNilOptions error:nil];
                districtArr = [districtDic objectForKey:@"district"];
            } else {
                districtArr = [[NSArray alloc] init];
            }
        } else {
            cityArr = [[NSArray alloc] init];
            districtArr = [[NSArray alloc] init];
        }
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        
        allName = [NSString stringWithFormat:@"%@%@%@", [[provinceArr objectAtIndex:row] objectForKey:@"name"], [[cityArr objectAtIndex:0] objectForKey:@"name"], [[districtArr objectAtIndex:0] objectForKey:@"name"]];
    }
    
    if (1 == component)
    {
        cityIndex = row;
        id districtItem = [cityArr objectAtIndex:row];
        NSString *districtFilePath = [[NSBundle mainBundle] pathForResource:[districtItem objectForKey:@"spellName"] ofType:@"json"];
        if (districtFilePath)
        {
            NSData *districtData = [NSData dataWithContentsOfFile:districtFilePath];
            NSDictionary *districtDic = [NSJSONSerialization JSONObjectWithData:districtData options:kNilOptions error:nil];
            districtArr = [districtDic objectForKey:@"district"];
        } else {
            districtArr = [[NSArray alloc] init];
        }
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
        
        allName = [NSString stringWithFormat:@"%@%@%@", [[provinceArr objectAtIndex:provinceIndex] objectForKey:@"name"], [[cityArr objectAtIndex:row] objectForKey:@"name"], [[districtArr objectAtIndex:0] objectForKey:@"name"]];
    }
    
    if (2 == component) {
        districtIndex = row;
        allName = [NSString stringWithFormat:@"%@%@%@", [[provinceArr objectAtIndex:provinceIndex] objectForKey:@"name"], [[cityArr objectAtIndex:cityIndex] objectForKey:@"name"], [[districtArr objectAtIndex:row] objectForKey:@"name"]];
    }
    // 更新地址信息
    [_selAreaBtn setTitle:allName forState:UIControlStateNormal];
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
