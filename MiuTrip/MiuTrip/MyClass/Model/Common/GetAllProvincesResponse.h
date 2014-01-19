//
//  GetAllProvincesResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "GetCityByNameResponse.h"
#import "GetProvinceByIDResponse.h"

@interface GetAllProvincesResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber      *ProvinceID;        //省份ID	int
@property (strong, nonatomic) NSString      *ProvinceName;      //省份名称
@property (strong, nonatomic) NSString      *ProvinceNameEn;    //省份英文名称

@property (strong, nonatomic) NSArray       *Citys;             //城市列表	List<CityDTO>

@end
