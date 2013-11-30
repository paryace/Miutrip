//
//  HotelCitesRequest.m
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelCitesRequest.h"

@implementation HotelCitesRequest



-(NSString *)getRequestURLString{
    
  return [URLHelper getRequestURLByBusinessType:BUSINESS_HOTEL widthMethodName:@"GetHotelCities"];
    
}

@end
