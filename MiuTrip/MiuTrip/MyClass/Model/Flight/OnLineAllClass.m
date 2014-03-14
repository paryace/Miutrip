//
//  OnLineAllClass.m
//  MiuTrip
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "OnLineAllClass.h"
#import "GetNormalFlightsResponse.h"
#import "GetLoginUserInfoRequest.h"
#import "GetCorpStaffRequest.h"
#import "GetContactRequest.h"

@implementation SearchFlightDTO

- (id)init
{
    if (self = [super init]) {
        _FirstRoute = [[RouteEntity alloc]init];
    }
    return self;
}

@end

@implementation CraftTypeDTO

@end

@implementation AirlineDTO

@end

@implementation AirportDTO

@end

@implementation TC_APIFlightInsuranceConfig

@end

@implementation TC_APImInfo

@end

@implementation StopItem

@end

@implementation Rule

@end

@implementation CabinDTO

@end

@implementation RouteEntity

- (id)init
{
    if (self = [super init]) {
        _Flight = [[DomesticFlightDataDTO alloc]init];
        _RCofRate = @"0";
    }
    return self;
}

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    [super parshJsonToResponse:jsonData];
    if ([Utils isEmpty:_RCofRate]) {
        _RCofRate = @"0";
    }
}

- (void)setRCofRate:(NSString *)RCofRate
{
    if (_RCofRate != RCofRate) {
        if ([Utils isEmpty:RCofRate]) {
            RCofRate = @"0";
        }
        _RCofRate = RCofRate;
    }
}

- (NSDictionary *)getRequestJsonString
{
    NSDictionary *dic = [super getRequestJsonString];
    return dic;
}

@end

@implementation SOSubmitDTO

@end

@implementation DeliveryTypeDTO

- (id)init
{
    self = [super init];
    if (self) {
        _IsNeed = [NSNumber numberWithInteger:0];
    }
    return self;
}

@end

@implementation OnlinePassengersDTO

- (id)init
{
    self = [super init];
    if (self) {
        _AgeType = [NSNumber numberWithInteger:1];
        _CardType = [NSNumber numberWithInteger:0];
        _NationalityName = @"中国";
        _NationalityCode = @"CN";
        _InsuranceType = [NSNumber numberWithInteger:0];
        _InsuranceNum = [NSNumber numberWithInteger:0];
        _InsuranceUnitPrice = @"0";
        _Gender = [NSNumber numberWithInteger:1];
    }
    return self;
}

//OnlinePassengersDTO *opd = [[OnlinePassengersDTO alloc]init];
//
//opd.PassengerID = [NSNumber numberWithInt:123456];
//opd.Name = @"马宏亮";
//opd.AgeType = [NSNumber numberWithInt:1];
//opd.Gender = [NSNumber numberWithInt:1];
//opd.CardType = [NSNumber numberWithInt:0];
//
//opd.BirthDate = @"1990-05-19";
//opd.CardNumber = @"410928198909012256";
//opd.NationalityName = @"中国";
//opd.NationalityCode = @"CN";
//opd.CorpUID = @"22";

+ (NSArray*)getOnlinePassengersWithData:(NSArray*)data
{
    NSMutableArray *passengers = [NSMutableArray array];
    for (id object in data) {
        OnlinePassengersDTO *passenger = [[OnlinePassengersDTO alloc]init];
        if ([object isKindOfClass:[GetLoginUserInfoResponse class]]) {
            [passenger getDataWithLoginUserInfo:object];
        }else if ([object isKindOfClass:[BookPassengersResponse class]]){
            [passenger getDataWithBookPassenger:object];
        }
        [passengers addObject:passenger];
    }
    
    return passengers;
}

- (void)getDataWithLoginUserInfo:(GetLoginUserInfoResponse*)loginUserInfo
{
    self.PassengerID = [NSNumber numberWithInteger:[loginUserInfo.UID integerValue]];
    self.Name = loginUserInfo.UserName;
    //    self.BirthDate = loginUserInfo.Birthday;
    //    self.Gender = [NSNumber numberWithInteger:[loginUserInfo.Gender integerValue]];
    self.CorpUID = [NSString stringWithFormat:@"%@",loginUserInfo.CorpID];
    if ([loginUserInfo.IDCardList count] != 0) {
        MemberIDcardResponse *IDCard = [loginUserInfo.IDCardList objectAtIndex:0];
        self.CardNumber = IDCard.CardNumber;
        self.CardType = IDCard.CardType;
    }
}

- (void)getDataWithBookPassenger:(BookPassengersResponse*)passenger
{
    self.PassengerID = passenger.PassengerID;
    self.Name = passenger.UserName;
    //    self.BirthDate = passenger.Birthday;
    //    self.Gender = [NSNumber numberWithInteger:[passenger.Gender integerValue]];
    self.CorpUID = passenger.CorpUID;
    if ([passenger.IDCardList count] != 0) {
        MemberIDcardResponse *IDCard = [passenger.IDCardList objectAtIndex:0];
        self.CardNumber = IDCard.CardNumber;
        self.CardType = IDCard.CardType;
    }
}

- (void)setCardNumber:(NSString *)CardNumber
{
    if (_CardNumber != CardNumber) {
        _CardNumber = CardNumber;
    }
    
    NSString *birthDay = [_CardNumber substringWithRange:NSMakeRange(6, 8)];
    _BirthDate = [Utils formatDateWithString:birthDay startFormat:@"yyyyMMdd" endFormat:@"yyyy-MM-dd"];
}

@end

@implementation CostCenteritem

@end

@implementation OnlineContactDTO

- (id)init
{
    self = [super init];
    if (self) {
        self.ConfirmType = [NSNumber numberWithInteger:0];
    }
    return self;
}

+ (OnlineContactDTO*)getOnlineContactWithData:(id)data
{
    OnlineContactDTO *passenger = [[OnlineContactDTO alloc]init];
    if ([data isKindOfClass:[GetLoginUserInfoResponse class]]) {
        [passenger getDataWithLoginUserInfo:data];
    }else if ([data isKindOfClass:[BookPassengersResponse class]]){
        [passenger getDataWithBookPassenger:data];
    }else if ([data isKindOfClass:[OnlineContactDTO class]]){
        passenger = data;
    }
    
    return passenger;
}

- (void)getDataWithLoginUserInfo:(GetLoginUserInfoResponse*)loginUserInfo
{
    self.ContactID = loginUserInfo.UID;
    self.UserName = loginUserInfo.UserName;
    self.Mobilephone = loginUserInfo.Mobilephone;
    self.Email = loginUserInfo.Email;
}

- (void)getDataWithBookPassenger:(BookPassengersResponse*)passenger
{
    self.ContactID = passenger.CorpUID;
    self.UserName = passenger.UserName;
    self.Mobilephone = passenger.Mobilephone;
    self.Fax = passenger.Fax;
    self.Email = passenger.Email;
}


@end