//
//  GetMailConfigRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetMailConfigRequest.h"

@implementation GetMailConfigRequest


-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"GetAPIMailConfig"];
    
}


@end

