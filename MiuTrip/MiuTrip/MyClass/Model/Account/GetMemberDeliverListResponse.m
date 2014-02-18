//
//  GetMemberDeliverListResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetMemberDeliverListResponse.h"

@implementation GetMemberDeliverListResponse

- (void)getObjects
{
    if (![_delivers isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *delivers = [NSMutableArray array];
    for (NSDictionary *object in _delivers) {
        MemberDeliverDTO *memberDeliver = [[MemberDeliverDTO alloc]init];
        [memberDeliver parshJsonToResponse:object];
        [delivers addObject:memberDeliver];
    }
    _delivers = delivers;
}

@end

@implementation MemberDeliverDTO



@end