//
//  SubmitOrderRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
@interface SubmitOrderRequest : BaseRequestModel

@property(strong,nonatomic) NSNumber *FeeType;
@property(strong,nonatomic) NSNumber *ReserveType;
@property(strong,nonatomic) NSString *PolicyUid;
@property(strong,nonatomic) NSNumber *CityId;
@property(strong,nonatomic) NSString *CityName;
@property(strong,nonatomic) NSNumber *HotelID;
@property(strong,nonatomic) NSNumber *RoomOTAType;
@property(strong,nonatomic) NSNumber *RoomTypeID;
@property(strong,nonatomic) NSNumber *OTAType;
@property(strong,nonatomic) NSNumber *OTAPolicyID;
@property(strong,nonatomic) NSString *ComeDate;
@property(strong,nonatomic) NSString *LeaveDate;
@property(strong,nonatomic) NSNumber *RoomNumber;
@property(strong,nonatomic) NSString *ArriveTime;
@property(strong,nonatomic) NSString *ContactID;
@property(strong,nonatomic) NSString *ContactName;
@property(strong,nonatomic) NSString *ContactMobile;
@property(strong,nonatomic) NSNumber *ConfirmType;
@property(strong,nonatomic) NSString *GuestMobile;
@property(strong,nonatomic) NSString *ReasonCode;
@property(strong,nonatomic) NSString *Remarks;
@property(strong,nonatomic) NSString *UserIP;
@property(strong,nonatomic) NSNumber *CcIndex;
@property(strong,nonatomic) NSString *CcValue;
@property(strong,nonatomic) NSArray  *Guests;


@end
