//
//  URLHelper.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#define URL_TYPE_FLIGHT  @"/flight_1_0/"
#define URL_TYPE_HOTEL   @"/hotel_1_0/"
#define URL_TYPE_COMMON  @"/common_1_0/"
#define URL_TYPE_ACCOUNT @"/account_1_0/"

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BusinessType){
    
    BUSINESS_FLIGHT = 0,
    BUSINESS_HOTEL = 1,
    BUSINESS_COMMON = 2,
    BUSINESS_ACCOUNT = 3
    
} ;

@interface URLHelper : NSObject


+(NSString *)getRequestURLByBusinessType:(BusinessType)businessType widthMethodName:(NSString *) mathodName;


@end
