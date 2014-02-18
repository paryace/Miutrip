//
//  GetCantonsByCityIDResponse.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetCantonsByCityIDResponse.h"
#import "GetProvinceByIDResponse.h"

@implementation GetCantonsByCityIDResponse

- (void)getObjects
{
    if (![_cantons isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *Cantons = [NSMutableArray array];
    for ( NSDictionary *dic in _cantons) {
        CantonDTO *canton = [[CantonDTO alloc]init];
        [canton parshJsonToResponse:dic];
        [Cantons addObject:canton];
    }
    
    _cantons = Cantons;
}

@end
