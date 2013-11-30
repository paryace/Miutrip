//
//  LoginResponse.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-30.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface LoginResponse : BaseResponseModel

@property (nonatomic,strong) NSString *authTkn;

@end
