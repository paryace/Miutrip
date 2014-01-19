//
//  GetCantonByIDResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "GetProvinceByIDResponse.h"

@interface GetCantonByIDResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber      *CID;                   //区域ID	int
@property (strong, nonatomic) NSString      *Canton_Name;           //区域名称
@property (strong, nonatomic) NSNumber      *CityID;                //城市ID	int
@property (strong, nonatomic) NSString      *Canton_EnName;         //区域英文名称

@end
