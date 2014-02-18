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

- (void)getObjects
{
    if (![_Cantons isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *Canton = [NSMutableArray array];
    for ( NSDictionary *dic in _Cantons) {
        CantonDTO *canton = [[CantonDTO alloc]init];
        [canton parshJsonToResponse:dic];
        [Canton addObject:canton];
    }
    
    _Cantons = Canton;
}

@end

@implementation CantonDTO


@end