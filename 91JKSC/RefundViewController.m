//
//  RefundViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "RefundViewController.h"
#import "SpecView.h"
#import "RefundTableViewCell.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIButton+WebCache.h"
#import "CheckRefundViewController.h"
@interface RefundViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,selectDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,assign)NSInteger selectIndex;
@end

@implementation RefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createNavBar];
    [self loadData];
    
    _photoNameArr = [[NSMutableArray alloc]init];
    _reasonStr = @" 请先选择退款原因";
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"申请退款";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableView *)refundTableView{
    if (!_refundTableView) {
    
        _refundTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStylePlain];
        _refundTableView.dataSource = self;
        _refundTableView.delegate = self;
        _refundTableView.backgroundColor = [UIColor clearColor];
        [_refundTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 70)];
        UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, 20, SYS_WIDTH-20, 50);
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        submitBtn.backgroundColor =BackGreenColor;
        [submitBtn addTarget:self action:@selector(submitRefund:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:submitBtn];
        _refundTableView.tableFooterView = backView;
        [self.view addSubview:_refundTableView];
    }
    return _refundTableView;
}
-(void)viewDidLayoutSubviews {
   
    if ([self.refundTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.refundTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return SYS_SCALE(110);
            break;
        case 1:
            return SYS_SCALE(60);
            break;
        case 2:
            return SYS_SCALE(60);
            break;
        case 3:
            return SYS_SCALE(90);
            break;
        default:
            return SYS_SCALE(220);
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundTableViewCell *cell = [[RefundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.layer.cornerRadius = 4;
    // 取消cell点击效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //标题
    UILabel * titlabel = [[UILabel alloc]initWithFrame:CGRectMake(SYS_SCALE(10), SYS_SCALE(10), SYS_SCALE(80), SYS_SCALE(40))];
    titlabel.font = SYS_FONT(15);
    titlabel.textColor = [UIColor blackColor];
    [cell.contentView addSubview:titlabel];
    switch (indexPath.row) {
        case 0:{
            
            //我要退款
            titlabel.text = @"退款类型:";
            
            _moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _moneyBtn.frame = CGRectMake(SYS_SCALE(10), SYS_SCALE(60), SYS_SCALE(120), SYS_SCALE(40));
            
            [_moneyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [_moneyBtn setTitleColor:BackGreenColor forState:UIControlStateSelected];
            _moneyBtn.userInteractionEnabled = YES;
            _moneyBtn.titleLabel.font = SYS_FONT(16);
            [_moneyBtn setBackgroundImage:[UIImage imageNamed:@"tuikuan-default"] forState:UIControlStateNormal];
            [_moneyBtn setBackgroundImage:[UIImage imageNamed:@"tuikuan-select"] forState:UIControlStateSelected];
            [_moneyBtn addTarget:self action:@selector(selectWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_moneyBtn];
            
            //我要退货
             _goodsBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            _goodsBtn.frame = CGRectMake(SYS_SCALE(140), SYS_SCALE(60), SYS_SCALE(120), SYS_SCALE(40));
            
            [_goodsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _goodsBtn.userInteractionEnabled = YES;
            [_goodsBtn setTitleColor:BackGreenColor forState:UIControlStateSelected];
            _goodsBtn.titleLabel.font = SYS_FONT(16);
            [_goodsBtn setBackgroundImage:[UIImage imageNamed:@"tuikuan-default"] forState:UIControlStateNormal];
            [_goodsBtn setBackgroundImage:[UIImage imageNamed:@"tuikuan-select"] forState:UIControlStateSelected];
             [_goodsBtn addTarget:self action:@selector(selectWithBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_goodsBtn];
            
            if (2>[_isRefundDict[@"data"][@"type"] count]>0) {
                _goodsBtn.hidden = YES;
                [_moneyBtn setTitle:_isRefundDict[@"data"][@"type"][0][@"type_info"] forState:UIControlStateNormal];
            }else {
                _goodsBtn.hidden = NO;
                _moneyBtn.hidden = NO;
                [_moneyBtn setTitle:_isRefundDict[@"data"][@"type"][0][@"type_info"] forState:UIControlStateNormal];
                [_goodsBtn setTitle:_isRefundDict[@"data"][@"type"][1][@"type_info"] forState:UIControlStateNormal];
            }
            
            
            
            
            
//            int i = 0;
//            for (NSDictionary * type in _isRefundDict[@"data"][@"type"][@"type_info"]) {
//                UIButton * typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                typeBtn.frame = CGRectMake(10+(120 *i), 60, 120, 40);
//                i = i+1;
//                [typeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//                [typeBtn setTitleColor:BackGreenColor forState:UIControlStateSelected];
//                typeBtn.tag += 20;
//                typeBtn.userInteractionEnabled = YES;
//                [typeBtn setBackgroundImage:[UIImage imageNamed:@"tuikuan-default"] forState:UIControlStateNormal];
//                [typeBtn setBackgroundImage:[UIImage imageNamed:@"tuikuan-select"] forState:UIControlStateSelected];
//                [typeBtn setTitle:type[@"type_info"] forState:UIControlStateNormal];
//                [typeBtn addTarget:self action:@selector(selectWithBtn:) forControlEvents:UIControlEventTouchUpInside];
//                [cell.contentView addSubview:typeBtn];
//                
//            }
            
        }
            
            break;
        case 1:{
            
            titlabel.text = @"退款原因:";
            
            
            UIButton * reasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            reasonBtn.frame = CGRectMake(SYS_SCALE(110), SYS_SCALE(10), SYS_WIDTH -SYS_SCALE(110), SYS_SCALE(40));
            _textL = [[UILabel alloc]initWithFrame:CGRectMake(0, SYS_SCALE(10), SYS_WIDTH-SYS_SCALE(130), SYS_SCALE(20))];
            _textL.textAlignment = NSTextAlignmentLeft;
            _textL.text = _reasonStr;
            _textL.font = SYS_FONT(15);
            _textL.textColor = [UIColor grayColor];
            
            [reasonBtn setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            reasonBtn.imageEdgeInsets = UIEdgeInsetsMake(SYS_SCALE(8), SYS_WIDTH-SYS_SCALE(140), SYS_SCALE(8), 0);
            [reasonBtn addTarget:self action:@selector(shouReason:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:reasonBtn];
            [reasonBtn addSubview:_textL];
        }
            break;
        case 2:{
            //退款金额
            titlabel.text = @"退款金额:";
            
            _textF = [[UITextField alloc]initWithFrame:CGRectMake(SYS_SCALE(110), SYS_SCALE(10), SYS_WIDTH -SYS_SCALE(110), SYS_SCALE(40))];
            _textF.placeholder = [NSString stringWithFormat:@"%@%@",@" 请输入退款金额，不得超过",_isRefundDict[@"data"][@"money"]];
            [_textF setValue:SYS_FONT(15) forKeyPath:@"_placeholderLabel.font"];
            _textF.keyboardType = UIKeyboardTypeDecimalPad;
            [_textF setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
            _textF.delegate = self;
            _textF.borderStyle = UITextBorderStyleNone;
            [cell.contentView addSubview:_textF];
            self.sumTextField = _textF;
            
        }
            
            break;
        case 3:{
            //退款说明
            titlabel.text = @"退款说明:";
            
            _detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(110, 10, SYS_WIDTH-110, 70)];
            _detailTextView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
            _detailTextView.font = SYS_FONT(15);
            _detailTextView.delegate = self;//设置它的委托方法
            _detailTextView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
            _detailTextView.text = @"请在此描述详细问题";
            _detailTextView.textColor = [UIColor grayColor];
            _detailTextView.userInteractionEnabled = YES;
            [cell.contentView addSubview: _detailTextView];//加入到整个页面中
            
        }
            break;
        case 4:{
            //上传图片
            titlabel.text = @"上传图片";

            UIButton * addPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addPhotoBtn.frame = CGRectMake(SYS_SCALE(10), SYS_SCALE(60),SYS_SCALE(100), SYS_SCALE(100));
            [addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"add-pic"] forState:UIControlStateNormal];
            [addPhotoBtn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addPhotoBtn];
            
            UILabel * messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(SYS_SCALE(10), SYS_SCALE(180), SYS_WIDTH - SYS_SCALE(20), SYS_SCALE(20))];
            messageLabel.text = @"最多上传3张,每张不超过5M,支持jPG、BMP、PNG";
            messageLabel.font = SYS_FONT(15);
            messageLabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:messageLabel];
            
            // 这个属性不能少
            self.automaticallyAdjustsScrollViewInsets = NO;
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.backgroundColor = [UIColor whiteColor];
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.alwaysBounceVertical = NO;
            scrollView.frame = CGRectMake(SYS_SCALE(120), SYS_SCALE(60), SYS_WIDTH-SYS_SCALE(120), SYS_SCALE(100));
            [cell.contentView addSubview:scrollView];
            self.scrollView = scrollView;
            [self reloadScrollView];
        }
            
            break;
        default:
            break;
    }
    return cell;
}
-(void)selectWithBtn:(UIButton *)btn{

    if (_goodsBtn == nil){
        btn.selected = YES;
        _goodsBtn = btn;
    }
    else if (_goodsBtn !=nil && _goodsBtn == btn){
        btn.selected = YES;
        
    }
    else if (_goodsBtn!= btn && _goodsBtn!=nil){
        _goodsBtn.selected = NO;
        btn.selected = YES;
        _goodsBtn = btn;
    }
    
    
    

}
#pragma mark ---- 网络数据
-(void)loadData{
 
    NSString *pathstr = [NSString stringWithFormat:@"%@check.html",API_REFUND];
    NSDictionary * Dic = @{
                                       @"key"           :[Function getKey],
                                       @"order_id":self.orderID,
                                       };
    [LoadDate httpPost:pathstr param:Dic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            
            NSString *str= [obj objectForKey:@"code"];
            
            if (str.longLongValue == 200) {
              /*
               {
               code = 200;
               data =     {
               money = "0.01";
               reason =         (
               {
               "reason_id" = 0;
               "reason_info" = "\U8ba2\U5355\U4fe1\U606f\U6709\U8bef";
               },
               {
               "reason_id" = 1;
               "reason_info" = "\U6211\U4e0d\U60f3\U4e70\U4e86";
               },
               {
               "reason_id" = 2;
               "reason_info" = "\U5fc3\U60c5\U4e0d\U597d";
               },
               {
               "reason_id" = 3;
               "reason_info" = "\U672a\U6536\U5230\U8d27";
               },
               {
               "reason_id" = 4;
               "reason_info" = "\U4e0d\U80fd\U6309\U65f6\U53d1\U8d27";
               }
               );
               type =         (
               {
               "type_id" = 1;
               "type_info" = "\U4ec5\U9000\U6b3e";
               }
               );
               };
               msg = "\U8bf7\U6c42\U6210\U529f";
               }
*/
                _isRefundDict = obj;
                [obj objectForKey:@"msg"];
                [self.refundTableView reloadData];
            }else{
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
            }
        }else{
            [MBProgressHUD showError:@"网络不给力"];
        }
        
    }];
}
#pragma mark ---- 上传照片
-(void)addPhoto:(UIButton *)btn{
    [self loadDataWithImage];
}

#pragma mark ----- 退款原因
-(void)shouReason:(UIButton *)btn{
    if (!_showReasonView) {
        _showReasonView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, SYS_HEIGHT)];
        _showReasonView.backgroundColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];
        _showReasonView.alpha = 0.9;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissregisView:)];
        tap.delegate = self;
        [_showReasonView addGestureRecognizer:tap];
        [self.view addSubview:_showReasonView];
        _reasonView = [[SpecView alloc]initWithFrame:CGRectMake(5, SYS_HEIGHT/2-SYS_SCALE(50)*[_isRefundDict[@"data"][@"reason"]count]+30<SYS_SCALE(60)?SYS_SCALE(60): SYS_HEIGHT/2-SYS_SCALE(50)*[_isRefundDict[@"data"][@"reason"]count]+SYS_SCALE(30), SYS_WIDTH-10, SYS_SCALE(50)*[_isRefundDict[@"data"][@"reason"]count]+SYS_SCALE(30)>SYS_HEIGHT-SYS_SCALE(80)?SYS_HEIGHT-SYS_SCALE(80):SYS_SCALE(50)*[_isRefundDict[@"data"][@"reason"]count]+SYS_SCALE(50))];
        _reasonView.arr = _isRefundDict[@"data"][@"reason"];
        _reasonView.delegate = self;
        _reasonView.layer.cornerRadius = 5;
        _reasonView.layer.masksToBounds = YES;
        _reasonView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_reasonView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SYS_SCALE(20), SYS_SCALE(10), SYS_WIDTH-SYS_SCALE(40), SYS_SCALE(30))];
        titleLabel.text = @"退款原因";
        titleLabel.font = SYS_FONT(18);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_reasonView addSubview:titleLabel];
    }
    _showReasonView.hidden = NO;
    _reasonView.hidden = NO;
  
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    } if ([touch.view isKindOfClass:[UITableViewCell class]]){
        return NO;
    }
    _showReasonView.hidden = YES;
    _reasonView.hidden = YES;
    return YES;
}
-(void)dismissregisView:(UITapGestureRecognizer *)gesture{
    _reasonView.hidden = YES;
}
-(BOOL)selectText:(NSString *)goodSpec andForRow:(NSString *)row{
    _textL.text = goodSpec;
    _showReasonView.hidden = YES;
    _reasonStr = goodSpec;
    _reasonID = row;
    return YES;
}
#pragma mark ---- textViewDelegate
-(void)textViewDidBeginEditing:(UITextView*)textView{
    if([_detailTextView.text isEqualToString:@"请在此描述详细问题"]){
        
        _detailTextView.text=@"";
        
        _detailTextView.textColor=[UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView*)textView{
    if(textView.text.length<1){
        textView.text=@"请在此描述详细问题";
        textView.textColor=[UIColor grayColor];
        
    }
    [textView resignFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    if (_textF.text.floatValue >[_isRefundDict[@"data"][@"money"] floatValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"金额不得超过%@",_isRefundDict[@"data"][@"money"] ] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }

     [_textF resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textF resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.floatValue >[_isRefundDict[@"data"][@"money"] floatValue]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"金额不得超过%@",_isRefundDict[@"data"][@"money"] ] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    [textField resignFirstResponder];
    return YES;
}
#pragma mark ----- 上传图片
- (void)reloadScrollView{
    
    // 先移除，后添加
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger column = 4;
    // 加一是为了有个添加button
    NSUInteger assetCount = self.assets.count;
    
    CGFloat width = self.view.frame.size.width / column;
    for (NSInteger i = 0; i < assetCount; i++) {
        
        NSInteger row = i / column;
        NSInteger col = i % column;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.frame = CGRectMake(width * col, row * width, width, width);
        
        // 如果是本地ZLPhotoAssets就从本地取，否则从网络取
        if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
            [btn setBackgroundImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
        }else if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLPhotoAssets class]]) {
            [btn setImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
        }else if ([self.assets[i] isKindOfClass:[NSString class]]){
            [btn sd_setImageWithURL:[NSURL URLWithString:self.assets[i]] forState:UIControlStateNormal];
        }else if([self.assets[i] isKindOfClass:[ZLPhotoPickerBrowserPhoto class]]){
            ZLPhotoPickerBrowserPhoto *photo = self.assets[i];
            photo.toView = btn.imageView;
            [btn sd_setImageWithURL:photo.photoURL forState:UIControlStateNormal];
        }else if ([[self.assets objectAtIndex:i] isKindOfClass:[ZLCamera class]]) {
            [btn setBackgroundImage:[self.assets[i] thumbImage] forState:UIControlStateNormal];
        }
        
        btn.tag = i;
        [btn addTarget:self action:@selector(tapBrowser:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width-100, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    
}
- (NSMutableArray *)assets{
    if (!_assets) {
        NSArray *urls;
        _assets = urls.mutableCopy;
        self.photos = @[].mutableCopy;
        for (NSString *url in urls) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,url]];
            [self.photos addObject:photo];
        }
    }
    
    return _assets;
}
#pragma mark - 选择图片
- (void)photoSelecte{

    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 5
    pickerVc.maxCount = 3 ;
    // Jump AssetsVc
    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Recoder Select Assets
    pickerVc.selectPickers = self.assets;
    // Filter: PickerPhotoStatusAllVideoAndPhotos, PickerPhotoStatusVideos, PickerPhotoStatusPhotos.
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    // Desc Show Photos, And Suppor Camera
    pickerVc.topShowPhotoPicker = YES;
    // CallBack
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        
        self.assets = status.mutableCopy;
        [self reloadScrollView];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (ZLPhotoAssets *asset in status) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                photo.asset = asset;
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                ZLCamera *camera = (ZLCamera *)asset;
                photo.photoImage = [camera photoImage];
            }
            [arr addObject:photo];
            
        }
        self.photos = arr;
    };
    [pickerVc showPickerVc:self];

}
#pragma mark - 选择图片
- (void)takeCamera{

    ZLCameraViewController *cameraVc = [[ZLCameraViewController alloc] init];
    cameraVc.maxCount = self.assets.count < 3?(3-self.assets.count):0;
    // CallBack
    cameraVc.callback = ^(NSArray *status){
        
        [self.assets addObjectsFromArray:status];
        [self reloadScrollView];

        for (ZLPhotoAssets *asset in status) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                photo.asset = asset;
            }else if ([asset isKindOfClass:[ZLCamera class]]){
                ZLCamera *camera = (ZLCamera *)asset;
                photo.photoImage = [camera photoImage];
            }
            [self.photos addObject:photo];
    
        }
       
    };
    
    [cameraVc showPickerVc:self];
    
}
- (void)tapBrowser:(UIButton *)btn{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.photos;
    // 能够删除
    pickerBrowser.delegate = self;
    // 当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    // 展示控制器
    [pickerBrowser showPushPickerVc:self];
}
-(void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    [self.photos removeObjectAtIndex:index];
    [self.assets removeObjectAtIndex:index];
    [self reloadScrollView];
}
#pragma mark ----  选择图片
-(void)loadDataWithImage{
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}


#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 2:
                    return;
                case 0: //相机
                    [self takeCamera];
                    break;
                case 1: //相册
                    [self photoSelecte];
                    break;
            }
        }
        else {
            if (buttonIndex == 1) {
                return;
            } else {
                [self photoSelecte];
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
    }
}

#pragma mark ----- 上传图片网络加载
-(void)loadImageData{
    NSString *urlPath = [NSString stringWithFormat:@"http://img.91jksc.com/upload-images-upload-upload"];
    NSDictionary * paramsDic = @{@"file":self.photos};
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    for (int i=0; i<self.photos.count; i++) {
        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        NSData *imageData =  UIImageJPEGRepresentation([self.photos[i] photoImage],0.5);
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:urlPath parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [marr addObject:responseObject[@"name"]];
            if (marr.count == self.photos.count) {
                _photoNameArr =marr;
                [self loadDataWithimageName];
            }
            hud.hidden = YES;
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"--------------%@",error);
        }];
        
    }
    
    
}
#pragma mark ----- 提交
-(void)submitRefund:(UIButton *)btn{
    if (self.photos.count == 0) {
        [self loadDataWithimageName];
    }else{
        [self loadImageData];
    }
}

#pragma mark ---- 评价
-(void)loadDataWithimageName{
    
    NSString *changeurlPath = [NSString stringWithFormat:@"%@add.html",API_REFUND];
    NSString *photos;
    NSData *data = [NSJSONSerialization dataWithJSONObject:_photoNameArr options:kNilOptions error:nil];
    photos = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (_reasonStr.length != 0&&![_reasonStr isEqualToString:@" 请先选择退款原因"]  &&_sumTextField.text.length > 0&&_detailTextView.text.length > 0&&![_detailTextView.text isEqualToString:@"请在此描述详细问题"] && photos.length>0) {
        NSString *typeStr;
        if (2>[_isRefundDict[@"data"][@"type"] count]>0) {
            typeStr = _isRefundDict[@"data"][@"type"][0][@"type_id"];
        }else{
            if (_moneyBtn.selected == YES) {
               typeStr = _isRefundDict[@"data"][@"type"][0][@"type_id"];
            }else{
                typeStr = _isRefundDict[@"data"][@"type"][1][@"type_id"];
            }
        }
        NSDictionary * changeparamsDic = @{
                                           @"key"           :[Function getKey],
                                           @"order_id":self.orderID,
                                           @"goods_id":self.goods_id,
                                           @"type":typeStr,
                                           @"reason_id":_reasonID,
                                           @"reason_info":_reasonStr,
                                           @"reason_message":_detailTextView.text,
                                           @"money":_sumTextField.text,
                                           @"image":photos.length>0?photos:0
                                           };
        
        [LoadDate httpPost:changeurlPath param:changeparamsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.
                NSString *str= [obj objectForKey:@"code"];
                if (str.longLongValue == 200) {
//                    {
//                        code = 200;
//                        data =     {
//                            ids = 20;
//                            "refund_sn" = 540514488626483165;
//                            total = 1;
//                        };
//                        msg = "\U7533\U8bf7\U6210\U529f!";
//                    }

                    [MBProgressHUD showSuccess:@"已提交申请"];
                    [self.navigationController popViewControllerAnimated:YES];
                    CheckRefundViewController *checkRVC = [[CheckRefundViewController alloc]init];
                        checkRVC.refund_sn = obj[@"data"][@"refund_sn"];
                    
                    [self.navigationController pushViewController:checkRVC animated:NO];
                    
                }else{
                    [MBProgressHUD showError:[obj objectForKey:@"msg"]];
                }
            }else{
                [MBProgressHUD showError:@"网络不给力"];
            }
            
        }];
        
    }else{
        [MBProgressHUD showError:@"请填写完整信息"];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.sumTextField.text = _isRefundDict[@"data"][@"money"];
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
