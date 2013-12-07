//
//  FlightCancelOrderRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "CancelFlightOrderRequest.h"

@implementation CancelFlightOrderRequest

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"CancelOrder"];
    
}

@end
