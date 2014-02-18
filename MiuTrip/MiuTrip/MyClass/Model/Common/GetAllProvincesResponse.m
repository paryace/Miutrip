//
//  GetAllProvincesResponse.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetAllProvincesResponse.h"

@implementation GetAllProvincesResponse

- (void)getObjects
{
    if (![_pros isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *pros = [NSMutableArray array];
    for (NSDictionary *dic in _pros) {
        ProvinceDTO *province = [[ProvinceDTO alloc]init];
        [province parshJsonToResponse:dic];
        [province getObjects];
        [pros addObject:province];
    }
    
    _pros = pros;
}

@end


@implementation ProvinceDTO

- (void)getObjects
{
    if (![_Citys isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *Citys = [NSMutableArray array];
    for (NSDictionary *dic in _Citys) {
        CityDTO *city = [[CityDTO alloc]init];
        [city parshJsonToResponse:dic];
        [city getObjects];
        [Citys addObject:city];
    }
    
    _Citys = Citys;
}

@end