//
//  GetContactResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetContactResponse.h"
#import "HotelCustomerModel.h"

@implementation GetContactResponse

- (void)getObjects
{
    if (![_result isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *dict in _result) {
        BookPassengersResponse *passengers = [[BookPassengersResponse alloc]init];
        [passengers parshJsonToResponse:dict];
        
        [result addObject:passengers];
    }
    _result = result;
}

@end

@implementation BookPassengersResponse

- (id)init
{
    self = [super init];
    if (self) {
        self.Gender = @"M";
    }
    return self;
}

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSDictionary *dictData = (NSDictionary*)jsonData;
    
    [super parshJsonToResponse:jsonData];
    
    self.AirlineCardList = [NSMutableArray array];
    for (NSDictionary *dic in [dictData objectForKey:@"AirlineCardList"]) {
        AirlineCardReaponse *airline = [[AirlineCardReaponse alloc]init];
        [airline parshJsonToResponse:dic];
        [_AirlineCardList addObject:airline];
    }
    
    self.IDCardList = [NSMutableArray array];
    for (NSDictionary *dic in [dictData objectForKey:@"IDCardList"]) {
        MemberIDcardResponse *idCard = [[MemberIDcardResponse alloc]init];
        [idCard parshJsonToResponse:dic];
        [_IDCardList addObject:idCard];
    }
    
    if ([Utils textIsEmpty:self.Gender]) {
        self.Gender = @"M";
    }
    
    _unfold = [NSNumber numberWithBool:NO];
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

@implementation MemberIDcardResponse

- (NSString *)getCardTypeName
{
    /*
     0：身份证
     1：护照
     2：军官证
     3：回乡证
     4：港澳通行证
     5：台胞证
     9：其他
     */
    NSString *cardType = nil;
    switch ([_CardType integerValue]) {
        case 0:{
            cardType = @"身份证";
            break;
        }case 1:{
            cardType = @"护照";
            break;
        }case 2:{
            cardType = @"军官证";
            break;
        }case 3:{
            cardType = @"回乡证";
            break;
        }case 4:{
            cardType = @"港澳通行证";
            break;
        }case 5:{
            cardType = @"台胞证";
            break;
        }case 9:{
            cardType = @"其他";
            break;
        }
        default:
            cardType = @"身份证";
            break;
    }
    return cardType;
}

- (NSNumber *)getCardTypeCodeWithName:(NSString*)name
{
    NSNumber *cardType = nil;
    if ([name isEqualToString:@"身份证"]) {
        cardType = [NSNumber numberWithInteger:0];
    }else if ([name isEqualToString:@"护照"]){
        cardType = [NSNumber numberWithInteger:1];
    }else if ([name isEqualToString:@"军官证"]){
        cardType = [NSNumber numberWithInteger:2];
    }else if ([name isEqualToString:@"回乡证"]){
        cardType = [NSNumber numberWithInteger:3];
    }else if ([name isEqualToString:@"港澳通行证"]){
        cardType = [NSNumber numberWithInteger:4];
    }else if ([name isEqualToString:@"台胞证"]){
        cardType = [NSNumber numberWithInteger:5];
    }else if ([name isEqualToString:@"其他"]){
        cardType = [NSNumber numberWithInteger:9];
    }else{
        cardType = [NSNumber numberWithInteger:0];
    }
    
    return cardType;
}

@end

@implementation AirlineCardReaponse

@end