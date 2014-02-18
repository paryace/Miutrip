//
//  GetLoginUserInfoResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetLoginUserInfoResponse.h"

@implementation GetLoginUserInfoResponse

- (void)getObjects
{
    NSMutableArray *IDCardList = [NSMutableArray array];
    for (NSDictionary *dic in _IDCardList) {
        MemberIDcardResponse *idCard = [[MemberIDcardResponse alloc]init];
        [idCard parshJsonToResponse:dic];
        [IDCardList addObject:idCard];
    }
    _IDCardList = IDCardList;
}

- (MemberIDcardResponse*)getDefaultIDCard
{
    MemberIDcardResponse *IDCardInfo = nil;
    for (MemberIDcardResponse *SubIDCardInfo in self.IDCardList) {
        if ([SubIDCardInfo.IsDefault isEqualToString:@"T"]) {
            IDCardInfo = SubIDCardInfo;
            break;
        }
    }
    
    if (IDCardInfo == nil) {
        if ([self.IDCardList count] != 0) {
            IDCardInfo = [self.IDCardList objectAtIndex:0];
        }
    }
    
    return IDCardInfo;
}


@end
