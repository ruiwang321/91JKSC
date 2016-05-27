//
//  EditUserInfoViewController.h
//  91健康商城
//
//  Created by HerangTang on 16/4/11.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "BaseViewController.h"

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *member_nickname;
@property (nonatomic, copy) NSString *member_avatar;
@property (nonatomic, strong) NSNumber *member_sex;
@property (nonatomic, copy) NSString *member_email;
@property (nonatomic, copy) NSString *member_birthday;
@property (nonatomic ,copy) NSString *member_name;

@end

@interface EditUserInfoViewController : BaseViewController
/**用户信息*/
@property (nonatomic, strong) UserInfoModel *userInfoModel;

@property (nonatomic, strong) UITableView *infoList;

@property (nonatomic, strong) UIImageView *headerView;

@property (nonatomic,strong) UILabel * nickNameLabel;

@end
