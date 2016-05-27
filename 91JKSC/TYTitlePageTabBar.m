//
//  TYTitlePageTabBar.m
//  TYSlidePageScrollViewDemo
//
//  Created by SunYong on 15/7/16.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "TYTitlePageTabBar.h"

@interface TYTitlePageTabBar ()
@property (nonatomic, strong) NSArray *btnArray;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, weak) UIView *horIndicator;
@property (nonatomic,strong) UIScrollView *btnScroll;

@property (nonatomic,strong) UIView *lineView;
@end

@implementation TYTitlePageTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textFont = [UIFont systemFontOfSize:SYS_SCALE(14)];
        _selectedTextFont = [UIFont systemFontOfSize:SYS_SCALE(16)];
        _textColor = [UIColor darkTextColor];
        _selectedTextColor = BackGreenColor;
        _horIndicatorColor = BackGreenColor;
        _horIndicatorHeight = 2;
        [self addHorIndicatorView];
    }
    return self;
}

- (instancetype)initWithTitleArray:(NSArray *)titleArray
{
    if (self = [super init]) {
        _titleArray = titleArray;
        [self addTitleBtnArray];
    }
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    [self addTitleBtnArray];
}

#pragma mark - add subView

- (void)addHorIndicatorView
{
    UIView *horIndicator = [[UIView alloc]init];
    horIndicator.backgroundColor = _horIndicatorColor;
    [self addSubview:horIndicator];
    _horIndicator = horIndicator;
}

- (void)addTitleBtnArray
{
    if (_btnArray) {
        [self removeTitleBtnArray];
    }
    
    _btnScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SYS_WIDTH, 40)];
    _btnScroll.alwaysBounceVertical = NO;
    _btnScroll.showsVerticalScrollIndicator = NO;
    _btnScroll.showsHorizontalScrollIndicator = NO;
    _btnScroll.backgroundColor = [UIColor whiteColor];
    
    
    [self addSubview:_btnScroll];

    
    NSMutableArray *btnArray = [NSMutableArray arrayWithCapacity:_titleArray.count];
    for (NSInteger index = 0; index < _titleArray.count; ++index) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index;
        button.titleLabel.font = _textFont;
        [button setTitle:_titleArray[index] forState:UIControlStateNormal];
        [button setTitleColor:_textColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(tabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnScroll addSubview:button];
        [btnArray addObject:button];
        if (index == 0) {
            [self selectButton:button];
        }
    }
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,_btnScroll.frame.size.height-2 , SYS_WIDTH/5, 2)];
    
    _lineView.backgroundColor = BackGreenColor;
    
    [_btnScroll addSubview:_lineView];
    _btnArray = [btnArray copy];
    _btnScroll.contentSize = CGSizeMake(SYS_WIDTH/5+SYS_WIDTH, 0);
}

#pragma mark - private menthod

- (void)removeTitleBtnArray
{
    for (UIButton *button in _btnArray) {
        [button removeFromSuperview];
    }
    _btnArray = nil;
}

- (void)selectButton:(UIButton *)button
{
    if (_selectBtn) {
        _selectBtn.selected = NO;
        if (_selectedTextFont) {
            _selectBtn.titleLabel.font = _textFont;
        }
    }
    if (button.tag == 4) {
       [_btnScroll setContentOffset:CGPointMake(SYS_WIDTH/5, 0) animated:YES];
    }else if(button.tag == 1){
         [_btnScroll setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    _selectBtn = button;
    
    CGRect frame = _horIndicator.frame;
    frame.origin.x = CGRectGetMinX(_selectBtn.frame);
    [UIView animateWithDuration:0.2 animations:^{
        _horIndicator.frame = frame;
        _lineView.frame = frame;
    }];
    
    _selectBtn.selected = YES;
    if (_selectedTextFont) {
        _selectBtn.titleLabel.font = _selectedTextFont;
    }
}


#pragma mark - action method
// clicked
- (void)tabButtonClicked:(UIButton *)button
{
    [self selectButton:button];
    
    // need ourself call this method
    [self clickedPageTabBarAtIndex:button.tag];
}

#pragma mark - override method
// override
- (void)switchToPageIndex:(NSInteger)index
{
    if (index >= 0 && index < _btnArray.count) {
        [self selectButton:_btnArray[index]];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnWidth = (CGRectGetWidth(self.frame)-_edgeInset.left-_edgeInset.right + _titleSpacing)/(_btnArray.count-1) - _titleSpacing;
    CGFloat viewHeight = CGRectGetHeight(self.frame)-_edgeInset.top-_edgeInset.bottom;
    
    [_btnArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        button.frame = CGRectMake(idx*(btnWidth+_titleSpacing)+_edgeInset.left, _edgeInset.top, btnWidth, viewHeight);
        
    }];
    
    NSInteger curIndex = 0;
    if (_selectBtn) {
        curIndex = [_btnArray indexOfObject:_selectBtn];
    }
    _horIndicator.frame = CGRectMake(curIndex*(btnWidth+_titleSpacing)+_edgeInset.left, CGRectGetHeight(self.frame) - _horIndicatorHeight, btnWidth, _horIndicatorHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
