//
//  GetCityByNameResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "GetProvinceByIDResponse.h"

@interface GetCityByNameResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber      *CityID;        //城市ID	int
@property (strong, nonatomic) NSString      *CityCode;      //城市首字母
@property (strong, nonatomic) NSString      *CityName;      //城市名称
@property (strong, nonatomic) NSString      *CityNameEn;    //城市英文名称
@property (strong, nonatomic) NSNumber      *ProvinceID;    //省份ID	int
@property (strong, nonatomic) NSString      *BriefCode;     //简码
@property (strong, nonatomic) NSString      *AirportCode;   //机场简码

@property (strong, nonatomic) NSArray       *Cantons;       //区域列表	List<CantonDTO>

@end
