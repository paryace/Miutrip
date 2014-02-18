//
//  GetFlightorderListResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "OnLineAllClass.h"

@interface GetFlightOrderResponse : BaseResponseModel

@property(strong, nonatomic) NSString *ID;
@property(strong, nonatomic) NSString *UID;
@property(strong, nonatomic) NSString *CorpID;
@property(strong, nonatomic) NSString *OrderSource;
@property(strong, nonatomic) NSString *SUPOrderID;
@property(strong, nonatomic) NSString *SerialId;
@property(strong, nonatomic) NSDate   *CreateTime;
@property(strong, nonatomic) NSString *OrderClass;
@property(strong, nonatomic) NSNumber *Amount;
@property(strong, nonatomic) NSNumber *Tax;
@property(strong, nonatomic) NSNumber *OilFee;
@property(strong, nonatomic) NSNumber *InsuranceFee;
@property(strong, nonatomic) NSString *PayType;
@property(strong, nonatomic) NSString *PayStatus;
@property(strong, nonatomic) NSNumber *ServerFee;
@property(strong, nonatomic) NSNumber *SendticketFee;
@property(strong, nonatomic) NSString *FlightWay;
@property(strong, nonatomic) NSNumber *Persons;
@property(strong, nonatomic) NSString *ServerFrom;
@property(strong, nonatomic) NSNumber *Status;
@property(strong, nonatomic) NSDate   *OperateTime;
@property(strong, nonatomic) NSString *PolicyUID;
@property(strong, nonatomic) NSNumber *PolicyID;
@property(strong, nonatomic) NSString *ExpensesType;
@property(strong, nonatomic) NSDate   *PrintTicketTime;
@property(strong, nonatomic) NSDate   *LimitTime;
@property(strong, nonatomic) NSDate   *RejectTime;
@property(strong, nonatomic) NSDate   *CancelTime;
@property(strong, nonatomic) NSDictionary *FltPassengers;
@property(strong, nonatomic) NSDictionary *FltInsurance;
@property(strong, nonatomic) NSString *FltDeliver;
@property(strong, nonatomic) NSDictionary *Flts;
@property(strong, nonatomic) NSString *Contact;
@property(strong, nonatomic) NSString *MailCode;
@property(strong, nonatomic) NSString *OrderDetailRefund;
@end

@interface OnlineRefundDTO : BaseResponseModel

@property(strong, nonatomic) NSString *RefundStatus;
@property(strong, nonatomic) NSNumber *ShouldRecAnt;
@property(strong, nonatomic) NSNumber *RealRetAmt;

@end
