//
//  GetProvinceByNameRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetProvinceByNameResponse.h"

@interface GetProvinceByNameRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *name;          //省份名称

@end
