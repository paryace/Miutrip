//
//  GetCantonByNameRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCantonByNameResponse.h"

@interface GetCantonByNameRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *name;      //区域名称

@end
