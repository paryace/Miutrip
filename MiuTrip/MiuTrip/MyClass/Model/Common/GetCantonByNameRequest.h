//
//  GetCantonByNameRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface GetCantonByNameRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *name;

@end



@interface GetCantonByNameResponse : BaseResponseModel

@property (nonatomic , strong) NSNumber  *CID;
@property (nonatomic , strong) NSString  *Canton_Name;
@property (nonatomic , strong) NSNumber  *CityID;
@property (nonatomic , strong) NSString  *Canton_EnName;

@end
