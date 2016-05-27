//
//  EvaluateView.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluateModel.h"
#import "UIImage+ZLPhotoLib.h"
#import "ZLPhoto.h"
@interface EvaluateView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,ZLPhotoPickerBrowserViewControllerDelegate>

@property (strong,nonatomic) NSArray *examples;
@property (nonatomic,strong) EvaluateModel * evaluateModel;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSMutableArray *assets;
@property (nonatomic , strong) NSMutableArray *photos;
-(void)createViewWithmodel:(EvaluateModel *)model;
@end
