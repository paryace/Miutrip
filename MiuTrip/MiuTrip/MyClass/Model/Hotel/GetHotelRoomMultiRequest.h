//
//  GetHotelRoomMultiRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
@interface GetHotelRoomMultiRequest : BaseRequestModel

@property(strong,nonatomic) NSString *ComeDate;
@property(strong,nonatomic) NSString *LeaveDate;
@property(strong,nonatomic) NSString *HotelIds;
@property(strong,nonatomic) NSString *PriceLow;
@property(strong,nonatomic) NSString *PriceHigh;

@end
