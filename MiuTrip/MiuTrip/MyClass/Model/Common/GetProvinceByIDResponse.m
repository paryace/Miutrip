//
//  GetProvinceByIDResponse.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetProvinceByIDResponse.h"

@implementation GetProvinceByIDResponse

@end

@implementation CityDTO

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    if (jsonData == NULL) {
        return;
    }
    NSDictionary *dictData = nil;
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        dictData = (NSDictionary*)jsonData;
    }else{
        return;
    }
    _CityID = [dictData objectForKey:@"CityID"];
    _CityCode = [Utils NULLToEmpty:[dictData objectForKey:@"CityCode"]];
    _CityName = [Utils NULLToEmpty:[dictData objectForKey:@"CityName"]];
    _CityNameEn = [Utils NULLToEmpty:[dictData objectForKey:@"CityNameEn"]];
    _ProvinceID = [dictData objectForKey:@"ProvinceID"];
    _BriefCode = [dictData objectForKey:@"BriefCode"];
    _AirportCode = [Utils NULLToEmpty:[dictData objectForKey:@"AirportCode"]];
    _Cantons = [CantonDTO getCantonsResponseWithData:[dictData objectForKey:@"Cantons"]];
}

@end

@implementation CantonDTO

+ (NSArray *)getCantonsResponseWithData:(NSObject *)cantonData
{
    if (cantonData == NULL) {
        return nil;
    }
    
    NSArray *cantonResponse = nil;
    if ([cantonData isKindOfClass:[NSArray class]]) {
        cantonResponse = (NSArray*)cantonData;
    }else{
        return nil;
    }
    NSMutableArray *responseData = [NSMutableArray array];
    for (NSDictionary *dict in cantonResponse) {
        CantonDTO *canton = [[CantonDTO alloc]init];
        [canton parshJsonToResponse:dict];
        [responseData addObject:canton];
    }
    return responseData;
}

@end