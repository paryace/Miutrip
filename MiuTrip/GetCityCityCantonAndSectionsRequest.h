//
//  GetCityCityCantonAndSectionsRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface GetCityCityCantonAndSectionsRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *cityId;

@end


@interface GetCityCityCantonAndSectionsResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *CantonList;

@property (nonatomic , strong) NSString  *SectionList;

@end


@interface CantonResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *CID;
@property (nonatomic , strong) NSString  *Canton_Name;
@property (nonatomic , strong) NSString  *CityID;
@property (nonatomic , strong) NSString  *Canton_EnName;

@end


@interface SectionResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *Id;
@property (nonatomic , strong) NSString  *Name;
@property (nonatomic , strong) NSString  *CityId;

@end