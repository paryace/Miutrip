//
//  GetFlightOrderRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
@interface GetFlightOrderRequest : BaseRequestModel

@property(strong, nonatomic) NSString *OrderID;

@end
