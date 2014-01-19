//
//  GetCantonByIDRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCantonByIDResponse.h"

@interface GetCantonByIDRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *ID;        //区域ID	是	int

@end
