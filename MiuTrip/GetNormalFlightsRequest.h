//
//  GetNormalFlightsRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
@interface GetNormalFlightsRequest : BaseRequestModel

@property(strong, nonatomic) NSString *DepartCity;
@property(strong, nonatomic) NSString *ClassNo;
@property(strong, nonatomic) NSString *ArriveCity;
@property(strong, nonatomic) NSString *DepartDate;
@property(strong, nonatomic) NSString *ArriveTime;
@property(strong, nonatomic) NSString *ArriceDate;
@property(strong, nonatomic) NSString *AirLine;
@property(strong, nonatomic) NSString *FlightWay;
@property(strong, nonatomic) NSString *FlightSource;
@property(strong, nonatomic) NSString *SendTicketCity;
@property(strong, nonatomic) NSString *PassengerType;
@end
