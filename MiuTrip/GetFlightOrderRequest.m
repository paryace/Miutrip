//
//  GetFlightOrderRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetFlightOrderRequest.h"

@implementation GetFlightOrderRequest

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"GetOrder"];
    
}
@end
