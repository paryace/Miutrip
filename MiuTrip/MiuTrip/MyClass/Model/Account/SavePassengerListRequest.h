//
//  SavePassengerListRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "SavePassengerListResponse.h"
#import "GetContactResponse.h"
///////////////////////////////////////////////////////////////////////

@interface SavePassengerListRequest : BaseRequestModel

@property (nonatomic , strong) NSArray  *Passengers;    // list <SavePassengerResponse>




@end

@interface SavePassengerResponse : BaseResponseModel

@property (nonatomic, strong) NSNumber  *PassengerID;
@property (nonatomic, strong) NSString  *CorpUID;
@property (nonatomic, strong) NSNumber  *IsEmoloyee;
@property (nonatomic, strong) NSNumber  *IsServer;
@property (nonatomic, strong) NSString  *Name;
@property (nonatomic, strong) NSString  *LastName;
@property (nonatomic, strong) NSString  *FirstName;
@property (nonatomic, strong) NSString  *MiddleName;
@property (nonatomic, strong) NSString  *FullENName;
@property (nonatomic, strong) NSString  *Email;
@property (nonatomic, strong) NSString  *Country;
@property (nonatomic, strong) NSString  *Birthday;
@property (nonatomic, strong) NSString  *LastUseDate;

@property (nonatomic, strong) NSArray   *IDCardList;   // list<MemberIDcardResponse>

@property (nonatomic, strong) NSString  *Telephone;
@property (nonatomic, strong) NSNumber  *Fax;
@property (nonatomic, strong) NSString  *ContactConfirmType;
@property (nonatomic, strong) NSString  *MobilePhone;
@property (nonatomic, strong) NSNumber  *Type;

+ (SavePassengerResponse*)getDataWithBookPassengers:(BookPassengersResponse*)passenger;

- (MemberIDcardResponse*)getDefaultIDCard;

@end

