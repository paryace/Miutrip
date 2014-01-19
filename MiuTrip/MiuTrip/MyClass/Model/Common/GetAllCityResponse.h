//
//  GetAllCityResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "GetProvinceByIDResponse.h"

@interface GetAllCityResponse : BaseResponseModel

@property (strong, nonatomic) NSArray       *cities;        //城市列表	List<CityDTO>

+ (NSArray *)getAllCityResponseWithData:(NSObject *)jsonData;

@end
