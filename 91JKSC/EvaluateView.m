//
//  EvaluateView.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EvaluateView.h"
#import "ZLPhoto.h"
#import "UIView+ViewController.h"
@implementation EvaluateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photos = [[NSMutableArray alloc]init];
        [self createCollectionView];
    }
    return self;
}
-(void)createViewWithmodel:(EvaluateModel *)model{
    self.evaluateModel = model;
    [self.collectionView reloadData];
}
-(void)createCollectionView{
    UICollectionViewFlowLayout *headerFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    headerFlowLayout.itemSize = CGSizeMake(85, 85);
    headerFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    headerFlowLayout.minimumLineSpacing = 5;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:headerFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceHorizontal =YES;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.tag = 200;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
}
#pragma mark- UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
    
    return self.evaluateModel.geval_image.count;

}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    return CGSizeMake(85, 85);
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cellID = @"UICollectionViewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    if(!cell){
        cell = [[UICollectionViewCell alloc] init];
        
    }
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:self.bounds];
    ImageWithUrl(imageV, self.evaluateModel.geval_image[indexPath.item] );
    cell.backgroundView = imageV;
    cell.layer.cornerRadius = 3;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = BACKGROUND_COLOR.CGColor;
    cell.layer.masksToBounds = YES;
    return cell;
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 11) {
        [self.photos removeAllObjects];
        for (NSString *url in _evaluateModel.geval_image) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            photo.photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,url]
                              ];
            [self.photos addObject:photo];
        }
        ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
        // 淡入淡出效果
        // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
        // 数据源/delegate
        pickerBrowser.editing = NO;
        pickerBrowser.photos = self.photos;
        pickerBrowser.evaluateModel = self.evaluateModel;
        // 能够删除
        pickerBrowser.delegate = self;
        // 当前选中的值
        pickerBrowser.currentIndex = indexPath.row;
        // 展示控制器
        [pickerBrowser showPushPickerVc:self.viewController];

    }
}


@end
