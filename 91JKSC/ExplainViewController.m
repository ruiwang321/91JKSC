//
//  ExplainViewController.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ExplainViewController.h"
#import "LoadDate.h"
@interface ExplainViewController ()
@property (nonatomic,strong)NSDictionary *dataDict;
@end

@implementation ExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    [self createNavBar];
    [self loadMessageForLabel];
}
- (void)createNavBar {
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(SYS_WIDTH * 0.736, 10, SYS_WIDTH * 0.217, 20)];
    titleView.textColor = [UIColor whiteColor];
    titleView.text = @"特别说明";
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleView andTitle:nil andSEL:@selector(dismissMyself)];
}
-(void)dismissMyself{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createLabel {
     CGSize size = [_dataDict[@"data"][@"content"] boundingRectWithSize:CGSizeMake(SYS_WIDTH-20,CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SYS_FONT(18)} context:nil].size;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 74, SYS_WIDTH-20, size.height)];
    label.text =[NSString stringWithFormat:@"    %@",_dataDict[@"data"][@"content"]];
    label.font = SYS_FONT(17);
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
}
-(void)loadMessageForLabel{
    NSString *pathURL = [NSString stringWithFormat:@"%@%@",API_URL,@"/index/Version/special.html"];
    NSDictionary * dic = @{
                           @"type":@"1",
                           @"version":self.version
                           };
    
    [LoadDate httpPost:pathURL param:dic finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if (error == nil) {
            if ([obj[@"code"] longLongValue] == 200) {
                _dataDict = obj;
        
                [self createLabel];
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
