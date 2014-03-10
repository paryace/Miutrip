//
//  GetFlightChangeRuleResponse.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetFlightChangeRuleResponse.h"
#import "Utils.h"

@implementation GetFlightChangeRuleResponse
- (void)parshJsonToResponse:(NSObject *)jsonData
{
    [super parshJsonToResponse:jsonData];
    if ([_rule isKindOfClass:[NSDictionary class]]) {
        NSDictionary *data = (NSDictionary*)_rule;
        Rule *rule = [[Rule alloc]init];
        [rule parshJsonToResponse:data];
        _rule = rule;
    }
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    NSMutableArray  *array = [NSMutableArray array];
    if (![Utils textIsEmpty:_rule.refund]) {
        [array addObject:[NSString stringWithFormat:@"退票规定:%@",_rule.refund]];
    }if (![Utils textIsEmpty:_rule.cDate]) {
        [array addObject:[NSString stringWithFormat:@"改期规定:%@",_rule.cDate]];
    }if (![Utils textIsEmpty:_rule.upgrades]) {
        [array addObject:[NSString stringWithFormat:@"升舱规定:%@",_rule.upgrades]];
    }if (![Utils textIsEmpty:_rule.transfer]) {
        [array addObject:[NSString stringWithFormat:@"签转规定:%@",_rule.transfer]];
    }if (![Utils textIsEmpty:_rule.rebate]) {
        [array addObject:[NSString stringWithFormat:@"返现:%@",_rule.rebate]];
    }
    
    for (int i = 0; i<[array count]; i++) {
        NSString *str  = [array objectAtIndex:i];
        if (i > 0) {
            [description appendFormat:@"\n"];
        }
        [description appendString:str];
    }
    
    return description;
}

@end
