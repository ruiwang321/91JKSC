//
//  CheckRefundViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/20.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "CheckRefundViewController.h"
#import "CheckRefundModel.h"
@interface CheckRefundViewController ()

@end

@implementation CheckRefundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavBar];
    self.view.backgroundColor = BACKGROUND_COLOR;
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"退款中";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
    [self loadData];
}
-(void)dismissMyself{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createBaseView{
    UIView *baseView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, SYS_WIDTH, SYS_SCALE(250))];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    NSMutableArray *ischeckArr = [[NSMutableArray alloc]init];
    CheckRefundModel *model;
    for (int i=0; i<3; i++) {
        model = self.checkArr[i];
        if (model.ischeck) {
            [ischeckArr addObject:model];
        }
    }
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SYS_WIDTH-20,model.messageHight+20)];
     titleLabel.text = [[ischeckArr lastObject] message];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = SYS_FONT(17);
    [baseView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.size.height+20, SYS_WIDTH, 1)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    [baseView addSubview:lineView];
    
    for (int i=0; i<3; i++) {
        CheckRefundModel *model = self.checkArr[i];
        UIButton * isBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [isBtn setBackgroundImage:[UIImage imageNamed:@"tuik-gray"] forState:UIControlStateNormal];
        [isBtn setBackgroundImage:[UIImage imageNamed:@"tuik-green"] forState:UIControlStateSelected];
        if (model.ischeck) {
            isBtn.selected  = YES;
        }
        
        
        if (i==0) {
            _isCheckBtn1 = isBtn;
            isBtn.frame = CGRectMake(SYS_SCALE(55), SYS_SCALE(97), SYS_SCALE(32), SYS_SCALE(32));
        }else if(i == 1){
            _isCheckBtn2 = isBtn;
            isBtn.frame = CGRectMake(SYS_SCALE(173), SYS_SCALE(97), SYS_SCALE(32), SYS_SCALE(32));
        }else{
            _isCheckBtn3 = isBtn;
            isBtn.frame = CGRectMake(SYS_SCALE(291), SYS_SCALE(97), SYS_SCALE(32), SYS_SCALE(32));
            [isBtn setBackgroundImage:[UIImage imageNamed:@"sucess-1"] forState:UIControlStateSelected];
        }
        [baseView addSubview:isBtn];
    }
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(_isCheckBtn1.frame.origin.x+32+2, SYS_SCALE(113), SYS_SCALE(82), 1)];
    lineView1.backgroundColor = BACKGROUND_COLOR;
    [baseView addSubview:lineView1];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(_isCheckBtn2.frame.origin.x+32+2, SYS_SCALE(113), SYS_SCALE(82), 1)];
    lineView2.backgroundColor = BACKGROUND_COLOR;
    [baseView addSubview:lineView2];
    if (_isCheckBtn2.selected) {
        lineView1.backgroundColor = BackGreenColor;
    }
    if (_isCheckBtn3.selected) {
        lineView2.backgroundColor = BackGreenColor;
    }
    
    for (int i=0; i<3; i++) {
        CheckRefundModel *model = self.checkArr[i];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SYS_WIDTH/3)*i+10, SYS_SCALE(140), SYS_WIDTH/3-20, 20)];
        label.text = model.name;
        label.font = SYS_FONT(15);
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        [baseView addSubview:label];
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((SYS_WIDTH/3)*i+10, label.frame.size.height+SYS_SCALE(150), SYS_WIDTH/3-20, model.timeHight)];
        timeLabel.text = [NSString stringWithFormat:@"(%@)",model.time];
        timeLabel.font = SYS_FONT(15);
        timeLabel.numberOfLines = 0;
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UIColor grayColor];
        if (model.ischeck) {
            label.textColor = BackGreenColor;
            timeLabel.textColor = BackGreenColor;
        }
        
        [baseView addSubview:timeLabel];
        
    }
    
    
}
#pragma mark ---- 懒加载
-(NSMutableArray *)checkArr{
    if (!_checkArr) {
        _checkArr = [[NSMutableArray alloc]init];
    }
    return _checkArr;
}
#pragma mark ---- 网络数据
-(void)loadData{
    
    NSString *pathstr = [NSString stringWithFormat:@"%@info.html",API_REFUND];
    NSDictionary * Dic = @{
                           @"key"           :[Function getKey],
                           @"refund_sn":self.refund_sn
                           };
//
    MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
    [LoadDate httpPost:pathstr param:Dic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {

                for (NSDictionary *dic in obj[@"data"][@"list"]) {
                    CheckRefundModel *model = [[CheckRefundModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.checkArr addObject:model];
                }
                [self createBaseView];
                hud.hidden = YES;
            }else{
                [MBProgressHUD showError:[obj objectForKey:@"msg"]];
                hud.hidden = YES;
            }
        }else{
            [MBProgressHUD showError:@"网络不给力"];
            hud.hidden = YES;
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
