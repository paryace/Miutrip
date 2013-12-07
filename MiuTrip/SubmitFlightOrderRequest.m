//
//  SubmitFlightOrderRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SubmitFlightOrderRequest.h"

@implementation SubmitFlightOrderRequest


-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"SaveOnlineOrder"];
    
}

@end
