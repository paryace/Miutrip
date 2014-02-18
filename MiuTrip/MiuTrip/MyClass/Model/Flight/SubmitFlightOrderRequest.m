//
//  SubmitFlightOrderRequest.m
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SubmitFlightOrderRequest.h"

@implementation SubmitFlightOrderRequest

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"%@ %@",_onlineOrder,_Flights];
//}
- (BaseRequestModel *)initWidthBusinessType:(BusinessType)bussinessType methodName:(NSString *)methodName
{
    if (self = [super init]) {
        _Flights = [[SearchFlightDTO alloc]init];
        _DeliveryType = [[DeliveryTypeDTO alloc]init];
        _Contacts     = [[OnlineContactDTO alloc]init];
    }
    return self;
}
- (id)init
{
    if (self = [super init]) {
        _Flights = [[SearchFlightDTO alloc]init];
        _DeliveryType = [[DeliveryTypeDTO alloc]init];
    }
    return self;
}

-(NSString *)getRequestURLString{
    
    return [URLHelper getRequestURLByBusinessType:BUSINESS_FLIGHT widthMethodName:@"SaveOnlineOrder"];
    
}

@end
