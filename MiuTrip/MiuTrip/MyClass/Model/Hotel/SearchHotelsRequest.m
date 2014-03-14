//
//  SearchHotelsRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SearchHotelsRequest.h"

@implementation SearchHotelsRequest

- (id)init
{
    self = [super init];
    if (self) {
        _ServerFrom = deviceId;
        _StarRated  = @"";
    }
    return self;
}

- (BaseRequestModel *)initWidthBusinessType:(BusinessType)bussinessType methodName:(NSString *)methodName
{
    self = [super initWidthBusinessType:bussinessType methodName:methodName];
    if (self) {
        _ServerFrom = deviceId;
        _StarRated  = @"";
    }
    return self;
}

@end
