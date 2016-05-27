//
//  TradeDetailTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/25.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//


#import "TradeDetailTableViewCell.h"
#import "TradeDetailModel.h"
#import "LoginViewController.h"
#import "ShareSheetView.h"
@implementation TradeDetailTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
   
}
-(void)createViewWithModel:(TradeDetailModel *)model andIndex:(NSInteger)index
{

    _trademodel = model;
  
    //标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, SYS_WIDTH, 30)];
    titleLabel.text = model.goods_name;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:titleLabel];
    //价钱
    UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(12,titleLabel.frame.size.height+8, SYS_WIDTH, 30)];
    valueLabel.text = [NSString stringWithFormat:@"￥%@",model.goods_price];
    valueLabel.font = [UIFont systemFontOfSize:20];
    valueLabel.textColor = BackGreenColor;
    [self addSubview:valueLabel];
    
    self.heartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.heartBtn.frame = CGRectMake(12, 12+titleLabel.frame.size.height+valueLabel.frame.size.height, 60,30);
    
    [self.heartBtn setImage:[UIImage imageNamed:@"favor-default"] forState:UIControlStateNormal];
    [self.heartBtn setImage:[UIImage imageNamed:@"favor-select"] forState:UIControlStateSelected];
    self.heartBtn.tag = 10;
    [self.heartBtn addTarget:self action:@selector(collection) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.heartBtn];
    
    
    
   

    //分享
   _shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(SYS_WIDTH-40,  12+titleLabel.frame.size.height+valueLabel.frame.size.height,30, 30);
    [_shareBtn setImage:[UIImage imageNamed:@"iconfont-fenxiang-2"] forState:UIControlStateNormal];
    _shareBtn.backgroundColor = [UIColor whiteColor];
    [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shareBtn.layer.borderWidth = 1;
    _shareBtn.layer.masksToBounds=YES;
    _shareBtn.layer.cornerRadius = 5;
    _shareBtn.tag = 20;
    
    _shareBtn.layer.borderColor = [[UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f] CGColor];
    [self addSubview:_shareBtn];
    
    
    
}

-(void)testHttpMsPostIsFavourites:(TradeDetailModel *)model andView:(UIView *)view {
    
    NSString *urlPath = [NSString stringWithFormat:@"%@is_favorites.html",API_MyFavourites];
    
        NSDictionary * paramsDic = @{@"key":[Function getKey],@"fav_id":model.goods_id};
        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.
                self.isDict = obj;
                
                if ([[[self.isDict objectForKey:@"data"] objectForKey:@"is_fav"] isEqualToString:@"1"]) {
                    self.heartBtn.selected = YES;
                }else{
                    self.heartBtn.selected = NO;
                    
                }
                
                self.goods_id = model.goods_id;
                self.log_id = [[self.isDict objectForKey:@"data"] objectForKey:@"log_id"];
                
                
            }else{
                [MBProgressHUD showError:@"网络状态不给力"];
                self.heartBtn.selected = NO;
            }
            
        }];

}

-(void) testHttpMsPost{

    NSString *urlPath = [NSString stringWithFormat:@"%@add_favorites.html",API_MyFavourites];

  
    if ([Function isLogin]) {
        MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        NSDictionary * paramsDic = @{@"key":[Function getKey],@"fav_type":@"0",@"fav_id":self.goods_id,@"log_msg":@"1"};
        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.
                self.loginDic = obj;
                self.isStr  = [self.loginDic objectForKey:@"code"];
                self.dataDict = [self.loginDic objectForKey:@"data"];
                
                if (self.isStr.longLongValue == 200) {
                    NSDictionary *dataDict = [self.loginDic objectForKey:@"data"];
                    self.log_id = [dataDict objectForKey:@"log_id"];
                    [hud hide:YES];
                    self.heartBtn.selected = YES;
                    
                }else if(self.isStr.longLongValue == 202){

                    [MBProgressHUD showError:[self.loginDic objectForKey:@"msg"]];
                }else{
                    
                    [MBProgressHUD showError:[self.loginDic objectForKey:@"msg"]];
                }
                
            }else{
                [MBProgressHUD showError:@"网络状态不给力"];
            }
            
        }];

    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:loginVC animated:YES completion:nil];

    }
    
}
-(void) testHttpMsPostCancel{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@cancel_favorites.html",API_MyFavourites];
    if ([Function isLogin]) {
      MBProgressHUD *hud = [MBProgressHUD showMessage:@""];
        NSDictionary * paramsDic = @{@"key":[Function getKey],@"log_id":self.log_id};
        
        [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
            if (error == nil) {
                //obj即为解析后的数据.
                
                self.cancelDict = obj;
                self.cancelStr  = [self.cancelDict objectForKey:@"code"];
                if (self.cancelStr.longLongValue == 200) {
                    
                    self.heartBtn.selected = NO;
                    [hud hide:YES];
                }else{
                    [MBProgressHUD showError:@"网络状态不给力"];
                }
            }else{
                [MBProgressHUD showError:@"网络状态不给力"];
            }
            
        }];

    }else{
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:loginVC animated:YES completion:nil];
    }
    
}

-(void)collection{
   

    if (self.heartBtn.selected) {
      
        [self testHttpMsPostCancel];
        
        
    }else{
       [self testHttpMsPost];
       
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
