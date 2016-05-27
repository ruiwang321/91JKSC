//
//  FeedbackViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/4/8.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTV;

@end

@implementation FeedbackViewController

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTF.layer.cornerRadius = 4;
    UIView *leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    self.phoneTF.leftView = leftView;
    self.phoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    self.feedbackTV.layer.cornerRadius = 4;
    self.feedbackTV.delegate = self;
}

-(void)textViewDidBeginEditing:(UITextView*)textView{
    if([self.feedbackTV.text isEqualToString:@" 请输入您的宝贵意见:"]){
        self.feedbackTV.text=@"";
        self.feedbackTV.textColor=[UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView*)textView{
    if(textView.text.length<1){
        textView.text=@" 请输入您的宝贵意见:";
        textView.textColor=[UIColor grayColor];
    }
}

- (IBAction)done:(id)sender {
    if ([self.feedbackTV.text isEqualToString:@""]||[self.feedbackTV.text isEqualToString:@" 请输入您的宝贵意见:"]) {
        [MBProgressHUD show:@"请输入您的意见" icon:nil view:self.view];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",API_URL,@"/index/Feelback/add.html"];
    NSDictionary *params = @{
                             @"key"         :[Function getKey] ? [Function getKey] :@"",
                             @"content"     :self.feedbackTV.text,
                             @"macAddress"  :MAC_ADDRESS,
                             @"ip2long"     :[LoadDate getIPDress],
                             @"client"      :@"ios"
                             };
    [LoadDate httpPost:url param:params finish:^(NSData *data, NSDictionary *obj, NSError *error) {
        if ([obj[@"code"] isEqualToNumber:@200]) {
            [MBProgressHUD showSuccess:@"感谢您的反馈，我们会尽快处理"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
