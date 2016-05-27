//
//  ChatViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/19.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ChatViewController.h"
#import "SocketManager.h"
#import "MessageListViewCell.h"

@interface ChatViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, SocketManagerDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *myTitle;

@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) UITableView *messageList;
@property (nonatomic, strong) UITextView *messageView;

@property (nonatomic, strong) NSMutableArray *messagesDataSource;
@end

@implementation ChatViewController

- (instancetype)initWithTitle:(NSString *)title memberId:(NSString *)memberId
{
    self = [super init];
    if (self) {
        _myTitle = title;
        _memberId = memberId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _index = 1;
    [self createChatTool];
    [self createMessageList];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:nil andTitle:_myTitle andSEL:@selector(backClicked)];
    _messagesDataSource = [NSMutableArray arrayWithCapacity:0];
    
    [SocketManager shareManager].delegate = self;
    [self getChatLogWithIndex:_index];
}

- (void)createMessageList {
    _messageList = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64-53) style:UITableViewStylePlain];
    _messageList.delegate = self;
    _messageList.dataSource = self;
    _messageList.backgroundColor = BACKGROUND_COLOR;
    [_messageList registerNib:[UINib nibWithNibName:@"MessageListViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    _messageList.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_messageList];
    
    __weak typeof(self) weakSelf = self;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf getChatLogWithIndex:++weakSelf.index];
    }];
    [header setTitle:@"无更多历史消息" forState:MJRefreshStateNoMoreData];
    [header setTitle:@"下拉加载历史消息" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载历史消息" forState:MJRefreshStatePulling];
    [header setTitle:@"正在加载历史消息" forState:MJRefreshStateRefreshing];

    _messageList.mj_header = header;
    header.lastUpdatedTimeLabel.hidden = YES;
}

- (void)createChatTool {
    _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SYS_HEIGHT-53, SYS_WIDTH, 53)];
    [self.view addSubview:_toolView];
    
    _messageView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SYS_WIDTH-20, 33)];
    _messageView.returnKeyType = UIReturnKeySend;
    _messageView.layer.borderColor = BACKGROUND_COLOR.CGColor;
    _messageView.layer.borderWidth = 1;
    _messageView.layer.cornerRadius = 4;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [_toolView addSubview:_messageView];
    _messageView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - tableView数据源和 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.last_time = 0;
    }else if (indexPath.row<=_messagesDataSource.count) {
        cell.last_time = [_messagesDataSource[indexPath.row-1] add_time];
    }else {
        cell.last_time = 0;
    }
    cell.messageModel = _messagesDataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [_messagesDataSource[indexPath.row] cellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView  {
        if (scrollView == _messageList) {
            [_messageView resignFirstResponder];
        }
}

#pragma mark - textView代理方法

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]>=1) {
            [[SocketManager shareManager].socket emit:@"private message" withItems:@[@{@"member_id":_memberId, @"message":_messageView.text, @"type":@"1"}]];
            textView.text = @"";
        }else {
            textView.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能发送空白消息" message:@"" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return NO;
    }
    return YES;
}

#pragma mark - 按钮点击事件

- (void)backClicked {
    [SocketManager shareManager].delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 通知中心回调方法
- (void)keyboardWillShow:(NSNotification *)aNotification
{

    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:curve.floatValue animations:^{
        _toolView.frame = CGRectMake(0, SYS_HEIGHT-53-height, SYS_WIDTH, 53);
        _messageList.frame = CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64-53-height);
        [self scrollToBottomWithAnimated:NO];
    }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:curve.floatValue animations:^{
        _toolView.frame = CGRectMake(0, SYS_HEIGHT-53, SYS_WIDTH, 53);
        _messageList.frame = CGRectMake(0, 64, SYS_WIDTH, SYS_HEIGHT-64-53);
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 获取聊天记录
- (void)getChatLogWithIndex:(NSInteger)index {
    NSString *url = [NSString stringWithFormat:@"%@%@",API_URL,@"/index/Chat/log.html"];
    NSDictionary *params = @{
                             @"key"         :[Function getKey],
                             @"member_id"   :_memberId,
                             @"page"        :[NSString stringWithFormat:@"%zd",index],
                             @"num"         :@"10"
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        for (NSDictionary *arrDic in obj[@"data"][@"list"]) {
            SocketMessageModel *model = [[SocketMessageModel alloc] init];
            
            [model setValuesForKeysWithDictionary:arrDic];
            [_messagesDataSource insertObject:model atIndex:0];
            
        }
        [_messageList.mj_header endRefreshing];
        if ([obj[@"data"][@"list"] count] < 10) {
            [_messageList.mj_header setState:MJRefreshStateNoMoreData];
        }
        [_messageList reloadData];
        
        // 刷新结束设置表格偏移量  防止抖动
        CGFloat offset = 0;
        for (int i = 0; i < [obj[@"data"][@"list"] count]; i++) {
            offset +=[_messagesDataSource[i] cellHeight];
        }
        _messageList.contentOffset = CGPointMake(0, offset);
        
        if (index == 1) {
            
            [self scrollToBottomWithAnimated:NO];
        }
    }];
}

#pragma mark - 消息管理器代理方法

- (void)socket:(SocketIOClient *)socket didReceiveMessage:(id)message {

    if ([[message lastObject][@"obj_id"] integerValue] == [_memberId integerValue]) {
        SocketMessageModel *model = [[SocketMessageModel alloc] init];
        
        [model setValuesForKeysWithDictionary:[message lastObject]];
        [_messagesDataSource addObject:model];
        [_messageList reloadData];
        [self scrollToBottomWithAnimated:YES];
    }
}

// 滚动到底部
- (void)scrollToBottomWithAnimated:(BOOL)animated
{
    if (_messagesDataSource.count > 1) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_messagesDataSource.count - 1 inSection:0];
        [self.messageList scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}
@end
