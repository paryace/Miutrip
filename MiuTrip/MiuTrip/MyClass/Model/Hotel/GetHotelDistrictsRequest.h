//
//  GetHotelDistrictsRequest.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-22.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetHotelDistrictsResponse.h"

@interface GetHotelDistrictsRequest : BaseRequestModel

@property (nonatomic,strong) NSNumber *cityId;

@end
