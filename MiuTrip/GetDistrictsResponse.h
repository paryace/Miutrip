//
//  GetDistrictsResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetDistrictsResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *ID;
@property(strong,nonatomic) NSString *DistrictName;
@end
