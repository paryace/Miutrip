//
//  GetOrderRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetOrderRequest.h"

@implementation GetOrderRequest

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_HOTEL widthMethodName:@"GetOrders"];
    
}
@end
