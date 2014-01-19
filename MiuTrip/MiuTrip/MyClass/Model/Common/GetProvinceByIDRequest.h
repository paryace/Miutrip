//
//  GetProvinceByIDRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetProvinceByIDResponse.h"

@interface GetProvinceByIDRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *ID;        //省份ID          int

@end
