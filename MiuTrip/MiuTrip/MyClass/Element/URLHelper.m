//
//  URLHelper.m
//  MiuTrip
//
//  Created by stevencheng on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "URLHelper.h"

@implementation URLHelper


+(NSString *)getRequestURLByBusinessType:(BusinessType)businessType widthMethodName:(NSString *) methodName{
    
    NSMutableString *string = [[NSMutableString alloc]init];
    [string appendString:MiuTripURL];
    
    switch (businessType) {
        case BUSINESS_FLIGHT:
            [string appendString:URL_TYPE_FLIGHT];
            break;
        case BUSINESS_HOTEL:
            [string appendString:URL_TYPE_HOTEL];
            break;
        case BUSINESS_COMMON:
            [string appendString:URL_TYPE_COMMON];
            break;
        case BUSINESS_ACCOUNT:
            [string appendString:URL_TYPE_ACCOUNT];
            break;
    }
    
    [string appendString:methodName];
    [string appendString:@"/api/"];
    
    return [string description];
    
}

@end
