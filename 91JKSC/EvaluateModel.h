//
//  EvaluateModel.h
//  91健康商城
//
//  Created by 商城 阜新 on 16/2/26.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluateModel : NSObject


/*
 评论ID
 */
@property (nonatomic,copy)NSString *comment_id;
/*
 评论内容
 */
@property (nonatomic,copy)NSString *comment_message;
/*
 评论人ID
 */
@property (nonatomic,copy)NSString *comment_member_id;
/*
 评论人昵称
 */
@property (nonatomic,copy)NSString *member_nickname;
/*
 评论人头像
 */
@property (nonatomic,copy)NSString *member_avatar;
/*
 添加评论时间
 */
@property (nonatomic,copy)NSString *geval_addtime;
/*
 评论图片
 */
@property (nonatomic,strong)NSArray *geval_image;
/*
 评论分数
 */
@property (nonatomic,copy)NSString *geval_scores;

/*
 评价内容的高
 */
@property (nonatomic,assign)NSInteger messageHight;
/*
 评价的cell行高
 */
@property (nonatomic,assign)NSInteger rowHeight;
/*
是否匿名显示
 */
@property (nonatomic,copy)NSNumber * geval_isanonymous;
/*
 评价内容
 */
@property (nonatomic,copy)NSString * geval_content;
/*
 再次评价的信息
 */
@property (nonatomic,copy)NSString * geval_content_again;
/*
 geval_explain
 */
@property (nonatomic,copy)NSString * geval_explain;



@end
