//
//  GetFlightChangeRuleRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetFlightChangeRuleRequest.h"

@implementation GetFlightChangeRuleRequest


-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"GetAPIChangeRule"];
    
}

@end
