//
//  GetProvinceByIDResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetProvinceByIDResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber      *ProvinceID;            //省份ID          int
@property (strong, nonatomic) NSString      *ProvinceName;          //省份名称
@property (strong, nonatomic) NSString      *ProvinceNameEn;        //省份英文名称

@property (strong, nonatomic) NSArray       *Citys;                 //城市列表	List<CityDTO>

@end

@interface CityDTO : BaseResponseModel

@property (strong, nonatomic) NSNumber      *CityID;                //城市ID	int
@property (strong, nonatomic) NSString      *CityCode;              //城市首字母
@property (strong, nonatomic) NSString      *CityRequestParams;     //请求参数
@property (strong, nonatomic) NSString      *CityName;              //城市名称
@property (strong, nonatomic) NSString      *CityNameEn;            //城市英文名称
@property (strong, nonatomic) NSNumber      *ProvinceID;            //省份ID	int
@property (strong, nonatomic) NSString      *BriefCode;             //简码
@property (strong, nonatomic) NSString      *AirportCode;           //机场简码
@property (nonatomic)         BOOL          isHot;                  //是否热门

@property (strong, nonatomic) NSArray       *Cantons;               //区域列表	List<CantonDTO>

- (void)getObjects;


@end

@interface CantonDTO : BaseResponseModel

@property (strong, nonatomic) NSNumber      *CID;                   //区域ID	int
@property (strong, nonatomic) NSString      *Canton_Name;           //区域名称
@property (strong, nonatomic) NSNumber      *CityID;                //城市ID	int
@property (strong, nonatomic) NSString      *Canton_EnName;         //区域英文名称

@end