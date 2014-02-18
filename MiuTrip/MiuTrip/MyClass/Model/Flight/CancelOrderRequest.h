//
//  CancelOrderRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
#import "CancelOrderResponse.h"
@interface CancelOrderRequest : BaseRequestModel

@property(strong,nonatomic) NSString *OrderID;
@property(strong,nonatomic) NSNumber *ReasonID;
@end
