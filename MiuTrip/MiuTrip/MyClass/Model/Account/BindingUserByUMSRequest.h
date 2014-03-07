//
//  BindingUserByUMSRequest.h
//  MiuTrip
//
//  Created by apple on 14-3-7.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseRequestModel.h"

@interface BindingUserByUMSRequest : BaseRequestModel

@property (strong, nonatomic) NSString *UmsUid;//OTA 类型
@property (strong, nonatomic) NSString *Password;//觅优账号密码

@property (assign, nonatomic) NSNumber *RememberMe;//是否记住登录状态

@property (strong, nonatomic) NSString *UserName;//觅优账号用户名

@end
