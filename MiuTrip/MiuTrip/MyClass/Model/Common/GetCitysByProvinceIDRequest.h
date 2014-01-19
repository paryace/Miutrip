//
//  GetCitysByProvinceIDRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCitysByProvinceIDResponse.h"

@interface GetCitysByProvinceIDRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *provinceId;        //省份ID	是	int

@end
