//
//  GetFlightOrderRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetFlightOrderListResponse.h"
#import "URLHelper.h"
@interface GetFlightOrderListRequest : BaseRequestModel

@property(strong, nonatomic) NSString *UID;
@property(strong, nonatomic) NSString *CorpID;
@property(strong, nonatomic) NSNumber *PageNumber;
@property(strong, nonatomic) NSNumber *PageSize;
@property(strong, nonatomic) NSString *TakeOffDateFrom;
@property(strong, nonatomic) NSString *OrderDateFrom;
@property(strong, nonatomic) NSString *OrderDateTo;
@property(strong, nonatomic) NSString *TakeOffDateTo;
@property(strong, nonatomic) NSNumber *PayStatus;
@property(strong, nonatomic) NSNumber *Status;
@property(strong, nonatomic) NSNumber *isCorpDelivery;
@property(strong, nonatomic) NSString *OrderByDesc;
@property(strong, nonatomic) NSString *OrderByAsc;
@property(strong, nonatomic) NSString *SerialId;
@property(strong, nonatomic) NSString *OrderID;
@property(strong, nonatomic) NSNumber *NotTravel;

@end
