//
//  EvaluateTableViewCell.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "EvaluateTableViewCell.h"
#import "EvaluateModel.h"
#import "EvaluateView.h"
#import "RatingBar.h"
#import "UIView+ViewController.h"
@implementation EvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self subsView];
    }
    return self;
}
-(void)createCellWithModel:(id)arr andIndex:(NSInteger)index{
    
     EvaluateModel *model =[arr objectAtIndex:index];
    
    ImageWithUrl(_imageV, model.member_avatar);
    
    if (!model.geval_isanonymous.boolValue) {
        _userNameLabel.text = model.member_nickname;
    }else{
        NSString *originTel = model.member_nickname;
        NSString *namestr;
        if (model.member_nickname.length>2) {
           namestr  = [originTel stringByReplacingCharactersInRange:NSMakeRange(1, model.member_nickname.length-2) withString:@"**"];
        }else if(model.member_nickname.length >1){
            namestr  = [originTel stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"**"];
        }else{
            namestr = @"**";
        }

        _userNameLabel.text = namestr;
        
    }

    _timeShowLabel.text =model.geval_addtime;
    _commentLabel.text = model.comment_message;
    [_commentLabel setFrame:CGRectMake(19+_imageV.frame.size.width, _userNameLabel.frame.size.height+_timeShowLabel.frame.size.height+20, SYS_WIDTH-SYS_WIDTH*0.20 -20, model.messageHight)];
    
    [_ratingBar1 displayRating:[model.geval_scores floatValue] andView:self];
    
    if (model.geval_image.count>0) {
        [self createImageView:model];
        _evalView.hidden = NO;
    }else {
        _evalView.hidden = YES;
    }

}
-(void)subsView{
   
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, SYS_WIDTH*0.15, SYS_WIDTH*0.15)];
    
    _imageV.layer.cornerRadius =SYS_WIDTH*0.15/2;
    _imageV.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageV];
    
    
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(19+_imageV.frame.size.width, 15, SYS_WIDTH-9+_imageV.frame.size.width, 20)];
    _userNameLabel.font = [UIFont systemFontOfSize:16/375.0f*SYS_WIDTH];
    [self.contentView addSubview:_userNameLabel];
    
    _timeShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(19+_imageV.frame.size.width, _userNameLabel.frame.size.height+20, SYS_WIDTH-19-_imageV.frame.size.width, 20)];
    _timeShowLabel.textColor = [UIColor colorWithRed:0.50f green:0.50f blue:0.51f alpha:1.00f];
     _timeShowLabel.font = [UIFont systemFontOfSize:15/375.0f*SYS_WIDTH];
    [self.contentView addSubview:_timeShowLabel];
    
    
    
    _commentLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, _size.height)];
    _commentLabel.numberOfLines = 0;
    _commentLabel.font = SYS_FONT(15);
    _commentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_commentLabel];
    
    _ratingBar1 = [[RatingBar alloc] init];
    _ratingBar1.frame = CGRectMake(SYS_WIDTH-130, 10, 150, 25);
    _ratingBar1.tag = 10;
    _ratingBar1.isIndicator = YES;
    [self.contentView addSubview:_ratingBar1];
    [_ratingBar1 setImageDeselected:@"star-defalt" halfSelected:nil fullSelected:@"star" andDelegate:nil];
    
    
 
}
-(void)createImageView:(EvaluateModel *)model{

    if (!_evalView) {
        _evalView= [[EvaluateView alloc]initWithFrame:CGRectMake(19+_imageV.frame.size.width, _userNameLabel.frame.size.height+_timeShowLabel.frame.size.height+25+_commentLabel.frame.size.height, SYS_WIDTH-19+_imageV.frame.size.width, 85)];
        
        [self addSubview:_evalView];
    }
    [_evalView createViewWithmodel:model];
    _evalView.frame = CGRectMake(19+_imageV.frame.size.width, _userNameLabel.frame.size.height+_timeShowLabel.frame.size.height+25+_commentLabel.frame.size.height, SYS_WIDTH-19+_imageV.frame.size.width, 85);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
