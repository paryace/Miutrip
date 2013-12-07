//
//  LoginUesrInfoRequest.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LoginUserInfoRequest.h"

@implementation LoginUserInfoRequest


-(BOOL)isCacheabled{
    return YES;
}


-(long long)getCachePeriod{
    return 24*60*60;
}

-(NSString *)getRequestConditions{
    return @"LoginUserInfoRequest";
}

@end
