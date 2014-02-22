
//
//  SavePassengerListRequest.m
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SavePassengerListRequest.h"

@implementation SavePassengerListRequest


@end

@implementation SavePassengerResponse

- (SavePassengerResponse*)getDataWithBookPassengers:(BookPassengersResponse*)passenger
{
    SavePassengerResponse *savePassenger = [[SavePassengerResponse alloc]init];
    [savePassenger parshJsonToResponse:[[passenger JSONRepresentation] JSONValue]];
//    savePassenger.IsServer = passenger.IsServer;
    savePassenger.Name = passenger.UserName;
    
    return savePassenger;
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