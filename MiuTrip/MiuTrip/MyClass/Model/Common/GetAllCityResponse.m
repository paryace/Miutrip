//
//  GetAllCityResponse.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetAllCityResponse.h"
#import "UserDefaults.h"

@implementation GetAllCityResponse

+ (NSArray *)getAllCityResponseWithData:(NSObject *)jsonData
{
    if (jsonData == NULL) {
        return nil;
    }
    
    NSArray *arrData = nil;
    if ([jsonData isKindOfClass:[NSArray class]]) {
        arrData = (NSArray *)jsonData;
    }else{
        return nil;
    }
    
    NSMutableArray *responseData = [NSMutableArray array];
    
    for (NSDictionary *dict in arrData) {
        CityDTO *city = [[CityDTO alloc]init];
        [city parshJsonToResponse:dict];
        [responseData addObject:city];
    }
    
    return responseData;
}

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    if (jsonData == nil) {
        return;
    }
    NSDictionary *dictData = nil;
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        dictData = (NSDictionary*)jsonData;
    }else
        return;
    self.cities = [GetAllCityResponse getAllCityResponseWithData:[dictData objectForKey:@"citys"]];
}

@end
