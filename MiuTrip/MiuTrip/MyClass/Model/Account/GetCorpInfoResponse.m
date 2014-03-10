//
//  GetCorpInfoResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetCorpInfoResponse.h"

@implementation GetCorpInfoResponse

- (void)getObjects
{
    NSMutableArray *corp_AddressList = [NSMutableArray array];
    for (NSDictionary *dictData in _Corp_AddressList) {
        Corp_AddressResponse *corp_Address = [[Corp_AddressResponse alloc]init];
        [corp_Address parshJsonToResponse:dictData];
        [corp_AddressList addObject:corp_Address];
    }
    _Corp_AddressList = corp_AddressList;
}

@end

@implementation Corp_AddressResponse


@end