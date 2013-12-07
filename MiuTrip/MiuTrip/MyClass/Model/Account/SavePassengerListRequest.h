//
//  SavePassengerListRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"
///////////////////////////////////////////////////////////////////////

@interface SavePassengerListRequest : BaseRequestModel

@property (nonatomic , strong) NSNumber  *Passengers;
@property (nonatomic , strong) NSNumber  *PassengerID;
@property (nonatomic , strong) NSString  *CorpUID;
@property (nonatomic , strong) NSNumber  *IsEmoloyee;
@property (nonatomic , strong) NSNumber  *IsServer;
@property (nonatomic , strong) NSString  *UserName;
@property (nonatomic , strong) NSString  *LastName;
@property (nonatomic , strong) NSString  *FirstName;
@property (nonatomic , strong) NSString  *MiddleName;
@property (nonatomic , strong) NSString  *Email;
@property (nonatomic , strong) NSString  *Country;
@property (nonatomic , strong) NSString  *Birthday;

@property (nonatomic , strong) NSNumber  *IDCardlist;

@property (nonatomic , strong) NSString  *UID;
@property (nonatomic , strong) NSNumber  *CardType;
//@property (nonatomic , strong) NSString  *UID;
@property (nonatomic , strong) NSString  *CardNumber;
@property (nonatomic , strong) NSString  *IsDefault;


@property (nonatomic , strong) NSString  *Telephone;
@property (nonatomic , strong) NSNumber  *Fax;
@property (nonatomic , strong) NSString  *ContactConfirmType;
@property (nonatomic , strong) NSNumber  *Type;


@end

