//
//  AirOrderDetail.h
//  MiuTrip
//
//  Created by SuperAdmin on 11/14/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirOrderDetail : NSObject

@property (assign, nonatomic) NSInteger                 *goal;              //1:因公 2:因私
@property (assign, nonatomic) NSInteger                 *queryType;         //1:为自己 2:为他人/多人
@property (assign, nonatomic) NSInteger                 *voyageType;        //航程类型

@property (strong, nonatomic) NSString                  *origin;            //起始地点
@property (strong, nonatomic) NSString                  *destination;       //目的地

@property (strong, nonatomic) NSString                  *departureDate;     //出发日期
@property (strong, nonatomic) NSString                  *departureTime;     //出发时间

@property (assign, nonatomic) BOOL                      ticketDeliver;      //送票
@property (strong, nonatomic) NSString                  *airlineName;       //航空公司名字
@property (assign, nonatomic) NSInteger                 passengerNum;       //乘客数
//1:不限  2:经济舱  3:头等舱/商务舱
@property (assign, nonatomic) NSInteger                 positionGrade;      //仓位等级

@property (strong, nonatomic) NSArray                   *passengers;        //联系人

@property (strong, nonatomic) NSString                  *orderNum;          //订单号
@property (assign, nonatomic) NSInteger                 orderStatus;        //订单状态
@property (strong, nonatomic) NSString                  *seatType;          //舱位类型
@property (assign, nonatomic) NSInteger                 ticketPrice;        //机票价格

@property (strong, nonatomic) NSString                  *name;
@property (strong, nonatomic) NSString                  *phoneNum;

@property (assign, nonatomic) BOOL                      unfold;

+ (NSArray*)getCommonDataWithNum:(NSInteger)num;

@end
