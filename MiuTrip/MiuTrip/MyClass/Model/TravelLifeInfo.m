//
//  TravelLifeInfo.m
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "TravelLifeInfo.h"
#import "Utils.h"

@implementation TravelLifeInfo

- (id)initWithData:(NSDictionary*)data
{
    if (self = [super init]) {
        _Fli_City = [[data objectForKey:@"Fli_City"] integerValue];
        _Fli_FliCount = [[data objectForKey:@"Fli_FliCount"] integerValue];
        _Fli_FliMostStutes = [data objectForKey:@"Fli_FliMostStutes"];
        _Fli_FliPrice = [[data objectForKey:@"Fli_FliPrice"] floatValue];
        _Fli_FliTotalPrice = [[data objectForKey:@"Fli_FliTotalPrice"] floatValue];
        _Fli_FlightKM = [data objectForKey:@"Fli_FlightKM"];
        _Fli_HotCityCount = [[data objectForKey:@"Fli_HotCityCount"] integerValue];
        _Fli_HotCityName = [data objectForKey:@"Fli_HotCityName"];
        _Fli_province = [[data objectForKey:@"Fli_province"] integerValue];
        _Hot_HotDayCount = [[data objectForKey:@"Hot_HotDayCount"] integerValue];
        _Hot_HotMostCount = [[data objectForKey:@"Hot_HotMostCount"] integerValue];
        _Hot_HotName = [data objectForKey:@"Hot_HotName"];
        _Hot_HotPrice = [[data objectForKey:@"Hot_HotPrice"] floatValue];
        _Hot_HotStars = [data objectForKey:@"Hot_HotStars"];
        _Hot_HotTotalCount = [[data objectForKey:@"Hot_HotTotalCount"] integerValue];
        _Hot_HotTotalPrice = [[data objectForKey:@"Hot_HotTotalPrice"] floatValue];
        _Hot_RC_Count = [[data objectForKey:@"Hot_RC_Count"] integerValue];
        _TimeSpan = [data objectForKey:@"TimeSpan"];
        _UID = [data objectForKey:@"UID"];
    }
    return self;
}

@end
