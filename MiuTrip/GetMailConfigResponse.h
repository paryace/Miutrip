//
//  GetMailConfigResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetMailConfigResponse : BaseResponseModel

@property(strong, nonatomic) NSDictionary *nList;

@end

@interface TC_APIMImInfo : BaseResponseModel

@property(strong, nonatomic) NSString *mCode;
@property(strong, nonatomic) NSNumber *mName;
@property(strong, nonatomic) NSString *sPrice;
@property(strong, nonatomic) NSString *rprice;
@property(strong, nonatomic) NSString *rTime;

@end