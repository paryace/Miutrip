
//
//  SubmitFlightOrderResponse.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SubmitFlightOrderResponse.h"

@implementation SubmitFlightOrderResponse

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [super parshJsonToResponse:jsonData];
    
    NSDictionary *responseData = (NSDictionary*)jsonData;

    NSMutableArray *OrderList = [NSMutableArray array];
    for (NSDictionary *dict in [responseData objectForKey:@"OrderList"]) {
        MsgPayEntity *order = [[MsgPayEntity alloc]init];
        [order parshJsonToResponse:dict];
        [OrderList addObject:order];
    }
    _OrderList = OrderList;
}

@end

@implementation MsgPayEntity



@end