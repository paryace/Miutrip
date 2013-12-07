//
//  GetAPIInsuranceConfigResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetInsuranceConfigResponse : BaseResponseModel

@end

@interface GetFlightInsuranceConfig_Response : BaseResponseModel

@property(strong,nonatomic) NSMutableArray *iList;

@end

@interface TC_APIFlightInsuranceConfig : BaseResponseModel

@property(strong,nonatomic) NSString *iCode;
@property(strong,nonatomic) NSNumber *iName;
@property(strong,nonatomic) NSString *sPrice;
@property(strong,nonatomic) NSString *rPrice;
@property(strong,nonatomic) NSString *rTime;
@property(strong,nonatomic) NSString *cTotal;

@end