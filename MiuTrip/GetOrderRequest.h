//
//  GetOrderRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
@interface GetOrderRequest : BaseRequestModel

@property(strong,nonatomic) NSNumber *Page;
@property(strong,nonatomic) NSNumber *PageSize;
@property(strong,nonatomic) NSNumber *Status;
@property(strong,nonatomic) NSString *OrderID;
@property(strong,nonatomic) NSString *StartDate;
@property(strong,nonatomic) NSString *EndDate;
@end
