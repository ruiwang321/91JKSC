//
//  SearchViewController.m
//  91健康商城
//
//  Created by HerangTang on 16/3/14.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QRCodeReaderViewDelegate <NSObject>
- (void)loadView:(CGRect)rect;
@end

@interface QRCodeReaderView : UIView
@property (nonatomic, weak)   id<QRCodeReaderViewDelegate> delegate;
@property (nonatomic, assign) CGRect innerViewRect;
@end
