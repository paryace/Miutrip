//
//  GetCityRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCityResponse.h"

@interface GetCityRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *ID;        //城市ID int

@end
