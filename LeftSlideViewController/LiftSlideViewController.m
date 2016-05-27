//
//  LiftSlideViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "LiftSlideViewController.h"
#import "SHCZMainView.h"
#import "AccountDetailViewController.h"
#import "SocketManager.h"
#import "CartBadgeSingleton.h"

@interface LiftSlideViewController ()

@property (nonatomic, strong) UILabel *messageNumLabel;
@property (nonatomic, strong) UILabel *cartNumLabel;

@end

@implementation LiftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mainview = [[SHCZMainView alloc] initWithFrame:self.view.bounds];
//    _mainview.headImage
    [self.view addSubview:_mainview];
    
    [self createMessageNumLabel];
    if([Function getKey].length >0){
        [self testHttpMyMessage];
    }else{
        _mainview.headImage.image = [UIImage imageNamed:@"profile"];
        [_mainview.userNameBtn setTitle:@"请登录" forState:UIControlStateNormal];
    }
    
}
// 创建消息数量显示label
- (void)createMessageNumLabel {
    UITableViewCell *messageCell = [_mainview.sideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    _messageNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 7, 14, 14)];
    [messageCell.contentView addSubview:_messageNumLabel];
    _messageNumLabel.layer.cornerRadius = 7;
    _messageNumLabel.font = [UIFont systemFontOfSize:8];
    _messageNumLabel.layer.masksToBounds = YES;
    _messageNumLabel.backgroundColor = RGB(255, 147, 0);
    _messageNumLabel.textColor = [UIColor whiteColor];
    _messageNumLabel.textAlignment = NSTextAlignmentCenter;
    _messageNumLabel.hidden = YES;
    [[SocketManager shareManager] addObserver:self forKeyPath:@"unreadMessages" options:NSKeyValueObservingOptionNew context:nil];
    
    UITableViewCell *cartCell = [_mainview.sideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    _cartNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(31, 7, 14, 14)];
    _cartNumLabel.font = [UIFont systemFontOfSize:8];
    [cartCell.contentView addSubview:_cartNumLabel];
    _cartNumLabel.layer.cornerRadius = 7;
    _cartNumLabel.layer.masksToBounds = YES;
    _cartNumLabel.backgroundColor = RGB(255, 147, 0);
    _cartNumLabel.textColor = [UIColor whiteColor];
    _cartNumLabel.textAlignment = NSTextAlignmentCenter;
    _cartNumLabel.hidden = YES;
    [[CartBadgeSingleton sharedManager] addObserver:self forKeyPath:@"cartArr" options:NSKeyValueObservingOptionNew context:nil];
}
// 监听未读消息数量回调方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"unreadMessages"]) {
        [self setMessageNum:[NSString stringWithFormat:@"%ld",[SocketManager shareManager].unreadMessages.count]];
    }
    if ([keyPath isEqualToString:@"cartArr"]) {
        [self setCartNum:[NSString stringWithFormat:@"%ld",[CartBadgeSingleton sharedManager].cartArr.count]];
    }
}

- (void)setMessageNum:(NSString *)num {
    _messageNumLabel.hidden = [num isEqualToString:@"0"];
    _messageNumLabel.text = num;
}

- (void)setCartNum:(NSString *)num {
    _cartNumLabel.hidden = [num isEqualToString:@"0"];
    _cartNumLabel.text = num;
}

#pragma mark ---- 获取用户信息
-(void) testHttpMyMessage{
    
    NSString *urlPath = [NSString stringWithFormat:@"%@/info.html",API_USER];
    NSDictionary * paramsDic = @{@"key":[Function getKey]};
    
    [LoadDate httpPost:urlPath param:paramsDic finish:^(NSData *data,NSDictionary *obj, NSError *error) {
        if (error == nil) {
            //obj即为解析后的数据.
            
            NSString *str= [obj objectForKey:@"code"];
            if (str.longLongValue == 200) {
                 _dataDict = obj[@"data"];
                [_mainview.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[obj objectForKey:@"data"][@"member_avatar"]]] placeholderImage:[UIImage imageNamed:@"profile"]];
                [_mainview.userNameBtn setTitle:[obj[@"data"][@"member_nickname"] isEqualToString:@""]?[obj objectForKey:@"data"][@"member_name"]:obj[@"data"][@"member_nickname"] forState:UIControlStateNormal];
                _mainview.userName = [obj objectForKey:@"data"][@"member_name"];
                _mainview.imageName = [obj objectForKey:@"data"][@"member_avatar"];
                _mainview.nickName = obj[@"data"][@"member_nickname"];
                if (self.messageblock) {
                    self.messageblock(_dataDict);
                }
            }
            
            
            
        }else{
           
        }
        
    }];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:@"reloaddata"];
    [[SocketManager shareManager] removeObserver:self forKeyPath:@"unreadMessages"];
}
-(void)getUserMessage:(getUserMessage)block{
    
    self.messageblock = block;
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
