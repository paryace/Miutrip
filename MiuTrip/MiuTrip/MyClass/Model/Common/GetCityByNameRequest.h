//
//  GetCityByNameRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCityByNameResponse.h"

@interface GetCityByNameRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *name;          //城市名称

@end
