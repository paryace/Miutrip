//
//  CostCenterListResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetCorpCostResponse.h"

@implementation GetCorpCostResponse

- (void)getObjects
{
    NSMutableArray *costs = [NSMutableArray array];
    for (NSDictionary *dic in _costs) {
        CostCenterList *center = [[CostCenterList alloc]init];
        [center parshJsonToResponse:dic];
        [center getObjects];
        [costs addObject:center];
    }
    _costs = costs;
}

@end


@implementation CostCenterList

- (void)getObjects
{
    NSMutableArray *SelectItem = [NSMutableArray array];
    for (NSDictionary *dic in _SelectItem) {
        CostCenterItem *item = [[CostCenterItem alloc]init];
        [item parshJsonToResponse:dic];
        [SelectItem addObject:item];
    }
    _SelectItem = SelectItem;
}

@end

@implementation CostCenterItem



@end