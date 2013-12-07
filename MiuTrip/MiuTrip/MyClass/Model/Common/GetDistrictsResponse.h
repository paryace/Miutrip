//
//  GetDistrictsResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Created by Y on 13-12-5.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetDistrictsResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *ID;
@property(strong,nonatomic) NSString *DistrictName;
@property (nonatomic , strong) NSDictionary  *Data;

@end


@interface DistrictMibileResponse : BaseResponseModel

@property (nonatomic , strong) NSNumber  *ID;
@property (nonatomic , strong) NSString  *DistrictName;
@end
