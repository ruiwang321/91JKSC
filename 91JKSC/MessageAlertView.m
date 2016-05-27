//
//  MessageAlertView.m
//  91健康商城
//
//  Created by HerangTang on 16/4/27.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "MessageAlertView.h"

@interface MessageAlertView ()

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy) touchCallBack touchCallBack;

@end

@implementation MessageAlertView
static MessageAlertView *singleton;
+ (void)showMessageAlertWithMessage:(NSString *)message avatar:(NSString *)avatar name:(NSString *)name touchCallBack:(touchCallBack)touch {
    MessageAlertView *mav = [[MessageAlertView alloc] init];
    //    [UIView animateWithDuration:0.2 animations:^{
    mav.frame = CGRectMake(0, 0, SYS_WIDTH, 64);
    //    }];
    
    mav.touchCallBack = touch;
    [mav creatSubViewWithMessage:message avatar:avatar name:name];
    mav.alpha = 1;
    [[[UIApplication sharedApplication].delegate window] addSubview:mav];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            mav.frame = CGRectMake(0, -64, SYS_WIDTH, 64);
        }completion:^(BOOL finished) {
            [mav removeFromSuperview];
        }];
    });
}


//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        singleton = [super allocWithZone:zone];
//    });
//    return singleton;
//}

- (void)creatSubViewWithMessage:(NSString *)message avatar:(NSString *)avatar name:(NSString *)name {
    if (!_messageLabel) {
        self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
        
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 24, 24)];
        [self addSubview:_avatarView];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, SYS_WIDTH - 50, 24)];
        [self addSubview:_messageLabel];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont systemFontOfSize:14];
        
        
        [self addGesture];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",ImageURL,avatar];
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default-profile"]];
    _messageLabel.text = message;
}

- (void)addGesture {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    CGPoint center = recognizer.view.center;
    CGFloat cornerRadius = recognizer.view.frame.size.width / 2;
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(center.x, (center.y + translation.y)>32?32:(center.y + translation.y));
    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        if (recognizer.view.center.y == 32) {
            return;
        }
        float slideFactor = 0.1 * slideMult;
        CGPoint finalPoint = CGPointMake(SYS_WIDTH/2, -32);
        finalPoint.x = MIN(MAX(finalPoint.x, cornerRadius),
                           self.bounds.size.width - cornerRadius);
        finalPoint.y = MIN(MAX(finalPoint.y, cornerRadius),
                           self.bounds.size.height - cornerRadius);
        [UIView animateWithDuration:slideFactor*2
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             recognizer.view.center = finalPoint;
                         }completion:^(BOOL finished) {
                             [self removeFromSuperview];
                         }];
    }
}
- (void)tap:(UITapGestureRecognizer *)recognizer {
    _touchCallBack();
    self.alpha = 0;
}

- (void)dealloc {
    
}

@end
