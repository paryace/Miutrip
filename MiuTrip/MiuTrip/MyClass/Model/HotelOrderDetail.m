//
//  HotelOrderDetail.m
//  MiuTrip
//
//  Created by SuperAdmin on 11/14/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "HotelOrderDetail.h"
#import "CommonlyName.h"

@implementation HotelOrderDetail

- (id)init
{
    if (self = [super init]) {
        _unfold = NO;
        NSInteger num = arc4random()%4 + 1;
        _passengers = [CommonlyName getCommonDataWithNum:num];
    }
    return self;
}

+ (NSArray*)getCommonDataWithNum:(NSInteger)num
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<num; i++) {
        HotelOrderDetail *detail = [[HotelOrderDetail alloc]init];
        [array addObject:detail];
    }
    return array;
}

@end
