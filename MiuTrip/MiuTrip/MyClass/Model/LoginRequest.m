//
//  LoginRequest.m
//  MiuTrip
//
//  Created by stevencheng on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LoginRequest.h"


@implementation LoginRequest


-(BOOL)isCacheabled{
    return NO;
}



-(NSString*)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_ACOUNT widthMethodName:@"login"];
}

@end
