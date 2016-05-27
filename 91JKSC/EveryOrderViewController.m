//
//  EveryOrderViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/13.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EveryOrderViewController.h"
#import "RatingBar.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
#import "UIButton+WebCache.h"
@interface EveryOrderViewController ()<RatingBarDelegate,UITextViewDelegate,UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZLPhotoPickerBrowserViewControllerDelegate>
{
    UITextView *_textView;
    UILabel *uilabel;
    NSDictionary *_imageDictInfo;
}
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
@property (weak,nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *photoNameArr;
@property (nonatomic,assign)CGFloat scroe;
@property (nonatomic,strong)UIButton * selectBtn;
@end

@implementation EveryOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavBar];
    [self createView];
    _scroe = 5.0f;
    _photoNameArr = [[NSMutableArray alloc]init];
    _imageDictInfo = [[NSDictionary alloc]init];
    self.view.backgroundColor = BACKGROUND_COLOR;
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"评价晒单";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createView{
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 74, SYS_WIDTH-20, 200)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius  = 3.0f;
    [self.view addSubview:whiteView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(90, 8, 1, 66)];
    lineView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [whiteView addSubview:lineView];
    
    // 商品图
    UIImageView *goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 8, 66, 66)];
    [whiteView addSubview:goodsImg];
    
    // 商品名称
    UILabel *goodsName = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, SYS_WIDTH - 125, 13)];
    goodsName.font = [UIFont systemFontOfSize:14/375.0f*SYS_WIDTH];
    goodsName.textColor = [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];
    [whiteView addSubview:goodsName];
    
    UIView *linesView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SYS_WIDTH-20, 1)];
    linesView.backgroundColor = [UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1];
    [whiteView addSubview:linesView];
    // ----------------------赋值-----------------
    ImageWithUrl(goodsImg, self.goodsmodel.goods_image);
    goodsName.text = self.goodsmodel.goods_name;
    
    RatingBar *ratingBar1 = [[RatingBar alloc] init];
    ratingBar1.frame = CGRectMake(100, 50, 150, 25);
    ratingBar1.tag = 10;
    [whiteView addSubview:ratingBar1];
    ratingBar1.isIndicator = NO;//指示器，就不能滑动了，只显示评分结果
    [ratingBar1 setImageDeselected:@"star-defalt" halfSelected:nil fullSelected:@"star" andDelegate:self];
    if (self.evaluateModel.geval_scores) {
        ratingBar1.isIndicator = YES;//指示器，就不能滑动了，只显示评分结果
        [ratingBar1 displayRating:self.evaluateModel.geval_scores.floatValue  andView:self.view];
    }
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 90, SYS_WIDTH-40, 70)];
    _textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    _textView.font = SYS_FONT(15);//设置字体名字和字体大小
    
    _textView.delegate = self;//设置它的委托方法
    
    _textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色


    _textView.text = @"写下购买体会或使用过程中带来的帮助等，可以为其他小伙伴提供参考";
    _textView.textColor = [UIColor grayColor];

    if (self.evaluateModel.comment_message) {
        _textView.userInteractionEnabled = NO;
        _textView.text =self.evaluateModel.comment_message;
    }
    [whiteView addSubview: _textView];//加入到整个页面中

    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(120, whiteView.frame.size.height-40, 110, 38);
    [addBtn setBackgroundImage:[UIImage imageNamed:@"shaidan"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:addBtn];
    
 
    // 匿名Button
    _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, SYS_HEIGHT-60-25, 100, 22)];
    [_selectBtn setTitle:@"匿名评价" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select-green"] forState:UIControlStateSelected];
    _selectBtn.titleLabel.font = SYS_FONT(15);
    _selectBtn.selected = NO;
    [_selectBtn addTarget:self action:@selector(allSelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectBtn];
    
    
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(10, SYS_HEIGHT-60, SYS_WIDTH-20, 38);
    submitBtn.layer.cornerRadius = 5;
    submitBtn.backgroundColor = BackGreenColor;
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    if (self.isTrue) {
        submitBtn.hidden = YES;
        _selectBtn.hidden = YES;
        addBtn.hidden = YES;
        
    }
    
    NSLog(@"%@",self.evaluateModel.geval_image);
    
    
    
    // 这个属性不能少
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = BACKGROUND_COLOR;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.frame = CGRectMake(10, 284, SYS_WIDTH-20, SYS_HEIGHT-283-60-60);
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView = scrollView;
     [self reloadScrollView];
}
-(void)allSelBtnClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
}
- (NSMutableArray *)assets{
    if (!_assets) {
        NSArray *urls;
        if (self.evaluateModel.geval_image.count>0) {
            urls = self.evaluateModel.geval_image;
        }
         self.photos = @[].mutableCopy;
        _assets = urls.mutableCopy;
        
        for (NSString *url in urls) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,url]];
            [self.photos addObject:photo];
        }
        
    }
    
    return _assets;
}
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
            [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,self.assets[i]]] forState:UIControlStateNormal];
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
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGRectGetMaxY([[self.scrollView.subviews lastObject] frame]));
    
}

#pragma mark - 选择图片
- (void)photoSelecte{
//    self.photos = @[].mutableCopy;
//    self.assets = @[].mutableCopy;
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // MaxCount, Default = 5
    pickerVc.maxCount =5;
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
    cameraVc.maxCount = self.assets.count < 5?(5-self.assets.count):0;
    // CallBack
    cameraVc.callback = ^(NSArray *status){
        
        [self.assets addObjectsFromArray:status];
        [self reloadScrollView];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
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
//        self.photos = arr;
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
    if (self.evaluateModel.geval_image.count>0) {
        pickerBrowser.editing = NO;
        pickerBrowser.evaluateModel = self.evaluateModel;
    }else{
        pickerBrowser.editing = YES;
    }
   
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
-(void)textViewDidBeginEditing:(UITextView*)textView{
    if([_textView.text isEqualToString:@"写下购买体会或使用过程中带来的帮助等，可以为其他小伙伴提供参考"]){
    
        _textView.text=@"";
     
        _textView.textColor=[UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView*)textView{
    if(textView.text.length<1){
        textView.text=@" 写下购买体会或使用过程中带来的帮助等，可以为其他小伙伴提供参考";
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
-(void)addPhoto:(UIButton *)btn{
    [self loadDataWithImage];
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

        }];

    }
    
    
}
-(void)submitPhoto:(UIButton *)btn{
    if (self.photos.count == 0) {
        [self loadDataWithimageName];
    }else{
        [self loadImageData];
    }
    
}
#pragma mark ---- 评价
-(void)loadDataWithimageName{
    
    NSString *changeurlPath = [NSString stringWithFormat:@"%@addGoods.html",API_EVALUATE];
    NSData *data = [NSJSONSerialization dataWithJSONObject:_photoNameArr options:kNilOptions error:nil];
    NSString *photos = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    NSDictionary * changeparamsDic;
    if (([_textView.text isEqualToString:@"写下购买体会或使用过程中带来的帮助等，可以为其他小伙伴提供参考"]||[_textView.text isEqualToString:@""])) {
        [MBProgressHUD show:@"请填写您的评价" icon:nil view:self.view];
    }else{
        changeparamsDic  = @{
                             @"key"           :[Function getKey],
                             @"order_id":self.orderID,
                             @"goods_id":self.goodsmodel.goods_id,
                             @"geval_scores":[NSString stringWithFormat:@"%f",_scroe],
                             @"geval_content":_textView.text,
                             @"geval_isanonymous":_selectBtn.selected?@"1":@"0",
                             @"geval_image":photos.length>0?photos:0
                             };
    
        [LoadDate httpPost:changeurlPath param:changeparamsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.
                NSString *str= [obj objectForKey:@"code"];
                if (str.longLongValue == 200) {
                    [MBProgressHUD showSuccess:@"评价成功"];
                    [self.navigationController popViewControllerAnimated:NO];
                }else{
                    [MBProgressHUD showError:[obj objectForKey:@"msg"]];
                }
            }else{
                [MBProgressHUD showError:@"网络不给力"];
            }
            
        }];
        
    }

}

-(void)ratingChanged:(float)newRating andView:(UIView *)baseView{
    _scroe = newRating;
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
