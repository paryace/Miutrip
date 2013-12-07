//
//  LogoutResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"


@interface LogoutResponse : BaseResponseModel

@property (nonatomic,strong) NSString *authTkn;

@end
