//
//  SubmitFlightOrderRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
#import "SubmitFlightOrderResponse.h"
#import "OnLineAllClass.h"

@interface SubmitFlightOrderRequest : BaseRequestModel

@property (strong, nonatomic) SearchFlightDTO   *Flights;               //
@property (strong, nonatomic) NSString          *PayType;               //第三方支付
@property (strong, nonatomic) DeliveryTypeDTO   *DeliveryType;          //0: 不需要配送/普通配送 1 ：定期配送
@property (strong, nonatomic) NSArray           *Passengers;            //List<OnlinePassengersDTO>
@property (strong, nonatomic) NSString          *UID;                   //预订人ID
@property (strong, nonatomic) NSString          *CorpID;                //公司ID
@property (strong, nonatomic) NSString          *PolicyID;              //政策执行人ID
@property (strong, nonatomic) NSString          *PolicyUID;             //政策执行人会员ID
@property (strong, nonatomic) NSString          *ServerFrom;            //当前IP
@property (strong, nonatomic) NSNumber          *MailCode;              //邮寄配送方式ID
@property (strong, nonatomic) NSString          *Addition;              //订单附加描述
@property (strong, nonatomic) OnlineContactDTO  *Contacts;              //订单联系人信息

@end


