//
//  MiuTripOrderDetail.h
//  MiuTrip
//
//  Created by apple on 13-11-30.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Miutrip_FltOrderDTO : NSObject

@property (strong, nonatomic) NSString      *ID;                //订单ID
@property (strong, nonatomic) NSString      *UID;               //用户ID
@property (strong, nonatomic) NSString      *CorpID;            //企业ID
@property (strong, nonatomic) NSString      *OrderSource;       //预定渠道      OTA "Ctrip --携程 Mango --芒果 TongCheng --同城"
@property (strong, nonatomic) NSString      *SUPOrderID;        //供应商订单号（如同城订单号）
@property (strong, nonatomic) NSString      *SerialId;          //供应商流水号
@property (strong, nonatomic) NSString      *CreateTime;        //订单创建时间
@property (strong, nonatomic) NSString      *OrderClass;        //机票类型      N:国内 I:国际
@property (assign, nonatomic) CGFloat       Amount;             //订单总金额     订单总金额（包含燃油、机建、保险）
@property (assign, nonatomic) CGFloat       Tax;                //机建费
@property (assign, nonatomic) CGFloat       OilFee;             //燃油费
@property (assign, nonatomic) CGFloat       InsuranceFee;       //保险费
@property (strong, nonatomic) NSString      *PayType;           //支付方式
@property (strong, nonatomic) NSString      *PayStatus;         //支付状态
@property (assign, nonatomic) CGFloat       ServerFee;          //服务费
@property (assign, nonatomic) CGFloat       SendTicketFee;      //送票费
@property (strong, nonatomic) NSString      *FlightWay;         //航程类型      "S --单程 D--往返程 M--联程"
@property (assign, nonatomic) NSInteger     Persons;            //乘客人数
@property (strong, nonatomic) NSString      *ServerFrom;        //订单来源IP

//"1--创建待支付 2---出票中 3--已出票 4--驳回  5--已取消"
@property (assign, nonatomic) NSInteger     Status;             //订单状态

@property (strong, nonatomic) NSString      *OperateTime;       //订单操作时间
@property (strong, nonatomic) NSString      *PolicyUID;         //政策执行人UID
@property (assign, nonatomic) NSInteger     PolicyID;           //政策ID
@property (strong, nonatomic) NSString      *ExpensesType;      //费用类型
@property (strong, nonatomic) NSString      *PrintTicketTime;   //机票打印时间
@property (strong, nonatomic) NSString      *LimitTime;         //订单过期时间
@property (strong, nonatomic) NSString      *RejectTime;        //订单驳回时间
@property (strong, nonatomic) NSString      *CancelTime;        //订单取消时间
@property (strong, nonatomic) NSMutableArray *FltPassengers;     //订单乘机人             List<Miutrip_FltPassengerDTO>

@end

