//
//  GetSectionsByCityIdRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface GetSectionsByCityIdRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *cityId;

@end


@interface GetSectionsByCityIdResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *sections;
@property (nonatomic , strong) NSString  *Id;
@property (nonatomic , strong) NSString  *Name;
@property (nonatomic , strong) NSString  *CityId;

@end