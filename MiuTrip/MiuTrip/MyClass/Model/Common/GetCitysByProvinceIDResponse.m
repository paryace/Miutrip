//
//  GetCitysByProvinceIDResponse.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetCitysByProvinceIDResponse.h"

@implementation GetCitysByProvinceIDResponse

- (void)getObjects
{
    if (![_citys isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *citys = [NSMutableArray array];
    for (NSDictionary *dic in _citys) {
        CityDTO *city = [[CityDTO alloc]init];
        [city parshJsonToResponse:dic];
        [city getObjects];
        [citys addObject:city];
    }
    _citys = citys;
}

@end
