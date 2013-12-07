//
//  FlightCancelOrderResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface CancelFlightOrderResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *isSuc;
@property(strong,nonatomic) NSString *cancelError;
@property(strong,nonatomic) NSString *cancelErrorCode;

@end
