//
//  GetHoteltrafficInfoResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetHoteltrafficInfoResponse : BaseResponseModel

@property(strong,nonatomic) NSString *startlocation;
@property(strong,nonatomic) NSString *locationName;
@property(strong,nonatomic) NSString *arrivalWay;
@property(strong,nonatomic) NSNumber *distance;

@end
