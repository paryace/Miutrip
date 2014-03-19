//
//  SubmitOrderResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface SubmitOrderResponse : BaseResponseModel


@property(strong,nonatomic) NSNumber *OrderType;
@property(strong,nonatomic) NSString *SerialId;
@property(strong,nonatomic) NSString *paySerialId;
@end
