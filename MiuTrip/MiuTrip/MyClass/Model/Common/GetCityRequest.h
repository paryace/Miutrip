//
//  GetCityRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface GetCityRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *ID;

@end


@interface GetCityResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *CityID;
@property (nonatomic , strong) NSString  *CityCode;
@property (nonatomic , strong) NSString  *CityName;
@property (nonatomic , strong) NSString  *CityNameEn;
@property (nonatomic , strong) NSString  *ProvinceID;
@property (nonatomic , strong) NSString  *BriefCode;
@property (nonatomic , strong) NSString  *AirportCode;
@property (nonatomic , strong) NSString  *Cantons;

@end


@interface CantonResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *CID;
@property (nonatomic , strong) NSString  *Canton_Name;
@property (nonatomic , strong) NSString  *CnatonID;
@property (nonatomic , strong) NSString  *Canton_EnName;

@end