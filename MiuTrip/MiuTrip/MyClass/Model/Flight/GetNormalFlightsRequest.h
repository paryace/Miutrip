//
//  GetNormalFlightsRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetNormalFlightsResponse.h"

@interface GetNormalFlightsRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *DepartCity;            //出发城市
@property (strong, nonatomic) NSString      *ClassNo;               //舱位
@property (strong, nonatomic) NSString      *ArriveCity;            //到达城市
@property (strong, nonatomic) NSString      *DepartDate;            //去程日期
@property (strong, nonatomic) NSString      *ArriveDate;            //到达日期
@property (strong, nonatomic) NSString      *ArriveTime;            //到达时间（暂时没用）
@property (strong, nonatomic) NSString      *AirLine;               //航空公司
@property (strong, nonatomic) NSString      *FlightWay;             //航程类型
@property (strong, nonatomic) NSString      *FlightSource;          //OTA类型         OTA 类型 ：Ctrip，Mango
@property (strong, nonatomic) NSString      *SendTicketCity;        //送票城市
@property (strong, nonatomic) NSString      *PassengerType;         //年龄类型

@end
