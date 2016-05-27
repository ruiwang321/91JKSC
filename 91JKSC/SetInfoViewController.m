//
//  SetInfoViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "SetInfoViewController.h"
#import "LiftSlideViewController.h"
@interface SetInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textTF;

@end
@class UserInfoModel;
@implementation SetInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    _textTF = [[UITextField alloc] initWithFrame:CGRectMake(10, 84, SYS_WIDTH-20, 40)];
    _textTF.backgroundColor = [UIColor whiteColor];
    _textTF.text = self.userInfoVC.userInfoModel.member_nickname;
    _textTF.layer.cornerRadius = 4;
    _textTF.delegate = self;
    [_textTF becomeFirstResponder];
    _textTF.placeholder = @"昵称长度最多16字符";
    [self.view addSubview:_textTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:_textTF];
}

// 创建导航条
- (void)createNavBar {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.text = @"修改昵称";
    titleLabel.textColor = [UIColor whiteColor];
    [self createNavWithLeftImage:@"img_arrow" andRightImage:nil andTitleView:titleLabel andTitle:nil andSEL:@selector(leftBtn:)];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(SYS_WIDTH-44-10, 20, 44, 44);
    [self.view addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)doneClicked {
    
    NSString *url = [NSString stringWithFormat:@"%@%@",API_USER,@"update.html"];
    if ([_textTF.text isEqualToString: self.userInfoVC.userInfoModel.member_nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSString *nikename = _textTF.text.length >= 16 ? [_textTF.text substringWithRange:NSMakeRange(0, 16)] : _textTF.text;
        NSDictionary *params = @{
                                 @"key"               :[Function getKey],
                                 @"member_nickname"   :nikename
                                 };
        
        [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
            if ([obj[@"code"] isEqualToNumber:@200]) {
                self.userInfoVC.userInfoModel.member_nickname = nikename;
                [self.userInfoVC.infoList reloadData];
               [[(AppDelegate *)[UIApplication sharedApplication].delegate slideVC] testHttpMyMessage];
                UIButton * nameB =[(LiftSlideViewController *)self.mm_drawerController.leftDrawerViewController mainview].userNameBtn;
                [nameB  setTitle:nikename forState:UIControlStateNormal];
                [(LiftSlideViewController *)self.mm_drawerController.leftDrawerViewController mainview].userName = nikename;

                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        
    }

}
#define MAX_LENGTH 16
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > MAX_LENGTH) {
                textField.text = [toBeString substringToIndex:MAX_LENGTH];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > MAX_LENGTH) {
            textField.text = [toBeString substringToIndex:MAX_LENGTH];
        }
    }
}


- (void)leftBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
   
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:_textTF];
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
