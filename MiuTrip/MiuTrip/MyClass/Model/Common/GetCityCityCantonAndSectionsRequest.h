//
//  GetCityCityCantonAndSectionsRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCityCityCantonAndSectionsResponse.h"

@interface GetCityCityCantonAndSectionsRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *cityId;        //城市ID	是	int

@end
