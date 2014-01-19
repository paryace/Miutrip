//
//  GetDistrictsResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetDistrictsResponse : BaseResponseModel

@property (strong, nonatomic) NSArray       *Data;          //行政区列表	List<DistrictMobile>

@end

@interface DistrictMobile : NSObject

@property (strong, nonatomic) NSNumber      *ID;            //行政区ID	int
@property (strong, nonatomic) NSString      *DistrictName;  //行政区名称

@end
