//
//  GetLoginUserInfoResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetLoginUserInfoResponse  : BaseResponseModel

@property (strong , nonatomic) NSString  *UID;
@property (strong , nonatomic) NSNumber  *AccessLeve;
@property (strong , nonatomic) NSString  *UserName;
@property (strong , nonatomic) NSString  *LastName;
@property (strong , nonatomic) NSString  *FirstName;
@property (strong , nonatomic) NSString  *MiddleName;
@property (strong , nonatomic) NSString  *Mobilephone;
@property (strong , nonatomic) NSString  *Email;
@property (strong , nonatomic) NSString  *Gender;
@property (strong , nonatomic) NSString  *Country;
@property (strong , nonatomic) NSString  *Birthday;
@property (strong , nonatomic) NSNumber  *OrderForSelf;
@property (strong , nonatomic) NSString  *EmployeeID;
@property (strong , nonatomic) NSNumber  *ReportLimits;
@property (strong , nonatomic) NSNumber  *CorpID;
@property (strong , nonatomic) NSString  *CorpName;
@property (strong , nonatomic) NSString  *CorpNameEn;
@property (strong , nonatomic) NSString  *Logo;
@property (strong , nonatomic) NSNumber  *LogoBinary;
@property (strong , nonatomic) NSString  *LastLoginTime;
@property (strong , nonatomic) NSNumber  *DeptID;
@property (strong , nonatomic) NSString  *DeptName;
@property (strong , nonatomic) NSString  *DeptNameEn;
@property (strong , nonatomic) NSString  *HasPolicy;
@property (strong , nonatomic) NSNumber  *PolicyID;
@property (strong , nonatomic) NSNumber  *PolicyName;
@property (strong , nonatomic) NSString  *IsNeedRC_FltN;
@property (strong , nonatomic) NSNumber  *PreMinute;
@property (strong , nonatomic) NSNumber  *LastMinute;
@property (strong , nonatomic) NSString  *FltpreBookRC;
@property (strong , nonatomic) NSNumber  *FltPreBookDays;
@property (strong , nonatomic) NSString  *HotelRC;
@property (strong , nonatomic) NSNumber  *HtlAmountLimtMax;


@end