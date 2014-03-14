//
//  GetDistrictsRequest.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetDistrictsRequest.h"

@implementation GetDistrictsRequest

-(BOOL)isCacheabled
{
    return YES;
}

-(long long)getCachePeriod
{
    return 10 * 24 * 60 * 60;
}

-(NSString *)getRequestConditions
{
    NSString *conditions = [NSString stringWithFormat:@"%@:%@",NSStringFromClass(self.class),_CityID];
    return conditions;
}

@end
