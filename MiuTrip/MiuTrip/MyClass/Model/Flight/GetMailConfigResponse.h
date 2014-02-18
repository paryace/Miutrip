//
//  GetMailConfigResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetMailConfigResponse : BaseResponseModel

@property(strong, nonatomic) NSArray *mList;

- (void)getObjects;

@end

@interface TC_APIMImInfo : BaseResponseModel

@property(strong, nonatomic) NSString *mCode;
@property(strong, nonatomic) NSString *mName;
@property(strong, nonatomic) NSString *sPrice;
@property(strong, nonatomic) NSString *rPrice;
@property(strong, nonatomic) NSString *rTime;


@end