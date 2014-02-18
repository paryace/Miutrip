//
//  GetAPIInsuranceConfigRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
#import "GetInsuranceConfigResponse.h"
@interface GetInsuranceConfigRequest : BaseRequestModel

@property(strong,nonatomic) NSNumber *oTAType;

@end
