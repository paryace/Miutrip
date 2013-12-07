//
//  GetCityByProvinceIDRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCityByProvinceIDResponse.h"
////////////////////////////////////////////////////////////////////////////////////////////

@interface GetCityByProvinceIDRequest : BaseRequestModel

@property (nonatomic , strong) NSNumber  *provinceID;

@end
