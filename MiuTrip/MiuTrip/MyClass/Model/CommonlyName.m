//
//  CommonlyName.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-15.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "CommonlyName.h"

@implementation CommonlyName

- (id)init
{
    if (self = [super init]) {
        _unfold = NO;
    }
    return self;
}

+ (NSArray*)getCommonDataWithNum:(NSInteger)num
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<num; i++) {
        CommonlyName *detail = [[CommonlyName alloc]init];
        [array addObject:detail];
    }
    return array;
}

@end
