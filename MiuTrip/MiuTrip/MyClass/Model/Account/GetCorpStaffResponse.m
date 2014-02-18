//
//  GetCorpStaffResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetCorpStaffResponse.h"
#import "GetContactResponse.h"
@implementation GetCorpStaffResponse

- (void)getObjects
{
    if (![_customers isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in _customers) {
        BookPassengersResponse *passengers = [[BookPassengersResponse alloc]init];
        [passengers parshJsonToResponse:dict];
        
        
        
        [result addObject:passengers];
    }
    _customers = result;
}

@end



@implementation CorpStaffDTO


- (void)parshJsonToResponse:(NSObject *)jsonData
{
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *dict = (NSDictionary*)jsonData;
    [dict setValue:[NSNumber numberWithBool:NO] forKey:@"selected"];
    
    [super parshJsonToResponse:jsonData];
    
    _IDCardList = [NSMutableArray array];
    for (NSDictionary *IDCardData in [dict objectForKey:@"IDCardList"]) {
        MemberIDcardResponse *IDCard = [[MemberIDcardResponse alloc]init];
        [IDCard parshJsonToResponse:IDCardData];
        [_IDCardList addObject:IDCard];
    }
    
    _AirlineCardList = [NSMutableArray array];
    for (NSDictionary *AirLineCardData in [dict objectForKey:@"AirlineCardList"]) {
        AirlineCardReaponse *AirLineCard = [[AirlineCardReaponse alloc]init];
        [AirLineCard parshJsonToResponse:AirLineCardData];
        [_AirlineCardList addObject:AirLineCard];
    }
}

@end
