//
//  GetBizSummary_AtMiutripResponse.h
//  MiuTrip
//
//  Created by GX on 14-2-12.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetBizSummary_AtMiutripResponse : BaseResponseModel
//int
@property (strong, nonatomic) NSNumber      *FlightOrdersTotal;
@property (strong, nonatomic) NSNumber      *FlightOrdersPending;
@property (strong, nonatomic) NSNumber      *HotelOrdersTotal;
@property (strong, nonatomic) NSNumber      *HotelOrdersPending;
@property (strong, nonatomic) NSNumber      *CommonNamesTotal;
@property (strong, nonatomic) NSNumber      *CommonNamesDetailed;
@end
