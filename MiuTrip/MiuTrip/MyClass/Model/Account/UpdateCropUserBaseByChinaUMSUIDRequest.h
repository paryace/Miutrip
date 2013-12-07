//
//  UpdateCropUserBaseByChinaUMSUIDRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "UpdateCropUserBaseByChinaUMSUIDResponse.h"

@interface UpdateCropUserBaseByChinaUMSUIDRequest : BaseRequestModel

@property (nonatomic , strong) NSNumber  *UID;
@property (nonatomic , strong) NSNumber  *ChinaUmsUID;

@end


