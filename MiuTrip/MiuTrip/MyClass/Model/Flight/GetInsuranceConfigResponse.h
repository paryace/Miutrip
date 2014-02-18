//
//  GetAPIInsuranceConfigResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "OnLineAllClass.h"

@interface GetInsuranceConfigResponse : BaseResponseModel

@end

@interface GetFlightInsuranceConfig_Response : BaseResponseModel

@property(strong,nonatomic) NSMutableArray *iList;

@end
