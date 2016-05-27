//
//  MessageViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MessageViewController.h"
#import <MMDrawerController/UIViewController+MMDrawerController.h>
#import "SocketManager.h"
#import "ChatViewController.h"
#import "MessageListCell.h"
@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *messageList;
@property (nonatomic, strong) NSMutableDictionary *messageDic;

@end

@implementation MessageViewController
- (void)viewWillAppear:(BOOL)animated {
    if ([Function isLogin]) {
        [self createMessageDicFromLocal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    UIImageView *developing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"non-message"]];
    developing.frame = CGRectMake(0, 0, 250, 250);
    developing.center = CGPointMake(SYS_WIDTH / 2, SYS_HEIGHT / 2);
    [self.view addSubview:developing];
    
    [self createMessageDicFromLocal];
    
    [[SocketManager shareManager].socket on:@"list" callback:^(NSArray * data, SocketAckEmitter * ack) {
        [self createMessageDicFromLocal];
        if ([[data lastObject][@"code"] isEqualToNumber:@200]) {
            NSMutableDictionary *tempChatMember = [NSMutableDictionary dictionaryWithCapacity:0];
            NSArray *dicArr = [data lastObject][@"data"][@"list"];
            for (NSDictionary *dic in dicArr) {

                [tempChatMember setValue:dic forKey:[NSString stringWithFormat:@"%ld", [dic[@"member_id"] integerValue]]];
            }
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault setObject:tempChatMember forKey:[Function getUserId]];
            [[NSUserDefaults standardUserDefaults] synchronize];
            for (NSDictionary *dic in tempChatMember.allValues) {
                SocketMessageModel *model = [[SocketMessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_messageDic setObject:model forKey:model.member_id];
            }
            [_messageList reloadData];
        }
        
    }];
    
    
    
    [[SocketManager shareManager].socket on:@"private message" callback:^(NSArray * data, SocketAckEmitter * ack) {
        
        if ([[data lastObject][@"member_id"] integerValue] == [[Function getUserId] integerValue]) {
            SocketMessageModel *model11 = _messageDic[[data lastObject][@"obj_id"]];
            model11.message = [data lastObject][@"message"];
            model11.add_time = [[data lastObject][@"add_time"] integerValue];
        }else {
            SocketMessageModel *model = [[SocketMessageModel alloc] init];
            [model setValuesForKeysWithDictionary:[data lastObject]];
            [_messageDic setObject:model forKey:model.member_id];
        }
        

        [_messageList reloadData];
    }];
}

// 创建导航条
- (void)createNavBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"消息";
    titleLabel.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"item" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
}

- (void)createMessageDicFromLocal {
    _messageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSDictionary *tempDic = [[NSUserDefaults standardUserDefaults] objectForKey:[Function getUserId]];
    
    for (NSDictionary *dic in tempDic.allValues) {
        
        if (dic[@"message"] == nil) {
            continue;
        }
        SocketMessageModel *model = [[SocketMessageModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_messageDic setObject:model forKey:model.member_id];
    }
    if (_messageDic.count > 0) {
        [self.messageList reloadData];
    }
}

- (void)leftBtn:(UIButton *)btn {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (UITableView *)messageList {
    if (_messageList == nil) {
        _messageList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64) style:UITableViewStylePlain];
        _messageList.delegate = self;
        _messageList.dataSource = self;
        [self.view addSubview:_messageList];
        [_messageList registerNib:[UINib nibWithNibName:@"MessageListCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        _messageList.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _messageList;
}

#pragma mark - 表格代理和数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    
    cell.messageModel = _messageDic.allValues[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithTitle:[_messageDic.allValues[indexPath.row] member_nickname] memberId:[_messageDic.allValues[indexPath.row] member_id]];
    [[[SocketManager shareManager] mutableArrayValueForKey:@"unreadMessages"] removeObject:[_messageDic.allValues[indexPath.row] member_id]];
    
    [self.navigationController pushViewController:chatVC animated:YES];
    [tableView reloadData];
}

@end
