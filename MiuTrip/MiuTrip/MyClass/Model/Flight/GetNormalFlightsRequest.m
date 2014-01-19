//
//  GetNormalFlightsRequest.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetNormalFlightsRequest.h"

@implementation GetNormalFlightsRequest

- (id)init
{
    self = [super init];
    if (self) {
        _FlightSource = @"Mango";
    }
    return self;
}

- (BaseRequestModel *)initWidthBusinessType:(BusinessType)bussinessType methodName:(NSString *)methodName
{
    self = [super initWidthBusinessType:bussinessType methodName:methodName];
    if (self) {
        _FlightSource = @"TongCheng";
        _FlightWay    = @"S";
        _PassengerType = @"ADU";
        _SendTicketCity = @"";
    }
    return self;
}

@end
