//
//  GetNormalFlightsRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetNormalFlightsRequest.h"

@implementation GetNormalFlightsRequest


-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"GetNormalFlights"];
    
}

@end
