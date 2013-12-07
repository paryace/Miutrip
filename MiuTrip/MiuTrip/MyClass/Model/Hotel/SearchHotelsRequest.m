//
//  SearchHotelsRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SearchHotelsRequest.h"

@implementation SearchHotelsRequest

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_HOTEL widthMethodName:@"SearchHotels"];
    
}

@end
