//
//  GetCantonsByCityIDRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCantonsByCityIDResponse.h"

@interface GetCantonsByCityIDRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *CityID;        //城市ID  int

@end
