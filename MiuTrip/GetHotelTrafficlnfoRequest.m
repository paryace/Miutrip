//
//  GetHotelTrafficlnfoRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetHotelTrafficlnfoRequest.h"

@implementation GetHotelTrafficlnfoRequest

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_HOTEL widthMethodName:@"GetHotelTrafficInfo"];
    
}
@end
