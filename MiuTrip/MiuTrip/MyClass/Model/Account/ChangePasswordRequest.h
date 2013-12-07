//
//  ChangePasswordRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "ChangePasswordResponse.h"
/////////////////////////////////////////////////////////////////


@interface ChangePasswordRequest : BaseRequestModel

@property (nonatomic,strong) NSString *loginToken;
@property (nonatomic,strong) NSString *oldPassword;
@property (nonatomic,strong) NSString *password;


@end
