//
//  LoginRequest.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-30.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"

@interface LoginRequest : BaseRequestModel

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property NSNumber *rememberMe;

@end
