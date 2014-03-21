//
//  CancelHotelOrderRequest.h
//  MiuTrip
//
//  Created by Y on 14-1-2.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseRequestModel.h"

@interface CancelHotelOrderRequest : BaseRequestModel

@property (strong , nonatomic) NSString   *OrderID;
@property (strong , nonatomic) NSNumber    *ReasonID;

@end
