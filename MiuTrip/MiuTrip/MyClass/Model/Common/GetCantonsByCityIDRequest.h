//
//  GetCantonsByCityIDRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface GetCantonsByCityIDRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *CityID;

@end


@interface GetCantonsByCityIDResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *CID;
@property (nonatomic , strong) NSString  *Canton_Name;
@property (nonatomic , strong) NSString  *CityID;
@property (nonatomic , strong) NSString  *Canton_EnName;

@end