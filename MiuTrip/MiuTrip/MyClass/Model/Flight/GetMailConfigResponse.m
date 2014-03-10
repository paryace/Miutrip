//
//  GetMailConfigResponse.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetMailConfigResponse.h"

@implementation GetMailConfigResponse

- (void)getObjects
{
    if (![_mList isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *mList = [NSMutableArray array];
    for (NSDictionary *dict in _mList) {
        TC_APImInfo *info = [[TC_APImInfo alloc]init];
        [info parshJsonToResponse:dict];
        [mList addObject:info];
    }
    
    _mList = mList;
}

@end
