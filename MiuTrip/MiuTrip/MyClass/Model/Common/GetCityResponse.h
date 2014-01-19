//
//  GetCityResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "GetProvinceByIDResponse.h"

@interface GetCityResponse : BaseResponseModel

@property (strong, nonatomic) CityDTO       *city;

@end
