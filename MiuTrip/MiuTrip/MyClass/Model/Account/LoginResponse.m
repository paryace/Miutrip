//
//  LoginResponse.m
//  MiuTrip
//
//  Created by stevencheng on 13-11-30.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LoginResponse.h"
#import "UserDefaults.h"

@implementation LoginResponse

- (void)parshJsonToResponse:(NSDictionary *)jsonData
{
    [super parshJsonToResponse:jsonData];
    [UserDefaults shareUserDefault].authTkn = self.authTkn;
}

@end
