//
//  GetMailConfigResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "OnLineAllClass.h"

@interface GetMailConfigResponse : BaseResponseModel

@property(strong, nonatomic) NSArray *mList;

- (void)getObjects;

@end
