//
//  GetHotelCitesResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetHotelCitesResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *CityID;
@property(strong,nonatomic) NSString *CityName;
@property(strong,nonatomic) NSString *Splling;
@end
