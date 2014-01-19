//
//  GetSectionsByCityIdRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetSectionsByCityIdResponse.h"

@interface GetSectionsByCityIdRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *cityId;            //城市ID	是	int

@end
