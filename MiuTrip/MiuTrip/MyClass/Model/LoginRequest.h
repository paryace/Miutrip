//
//  LoginRequest.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BaseRequestModel.h"
#import "SBJson.h"
#include "URLHelper.h"


@interface LoginRequest : BaseRequestModel

@property (nonatomic,weak) NSString *userName;
@property (nonatomic,weak) NSString *password;

@end
