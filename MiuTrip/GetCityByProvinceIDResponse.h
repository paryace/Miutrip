//
//  GetCityByProvinceIDResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-5.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetCityByProvinceIDResponse : BaseResponseModel

@property (nonatomic , strong) NSNumber  *CityID;
@property (nonatomic , strong) NSString  *CityCode;
@property (nonatomic , strong) NSString  *CityName;
@property (nonatomic , strong) NSString  *CityNameEn;
@property (nonatomic , strong) NSNumber  *ProvinceID;
@property (nonatomic , strong) NSString  *BriefCode;
@property (nonatomic , strong) NSString  *AirportCode;
@property (nonatomic , strong) NSDictionary  *Cantons;

@end


@interface CantonResponse : BaseResponseModel

@property (nonatomic , strong) NSNumber  *CID;
@property (nonatomic , strong) NSString  *Canton_Name;
@property (nonatomic , strong) NSNumber  *CityID;
@property (nonatomic , strong) NSString  *Canton_EnName;

@end