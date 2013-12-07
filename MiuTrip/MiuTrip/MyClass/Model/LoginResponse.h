//
//  LoginResponse.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponseModel.h"

@interface LoginResponse : BaseResponseModel


@property (nonatomic,assign) NSString *token;
@property (nonatomic,assign) int id;
@property (nonatomic,assign) long  time;
@property (nonatomic,assign) double price;
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,assign) BOOL isEnabled;

@end
