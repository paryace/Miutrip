//
//  GetCantonByIDRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface GetCantonByIDRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *ID;

@end



@interface GetCantonByIDResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *CID;
@property (nonatomic , strong) NSString  *Canton_Name;
@property (nonatomic , strong) NSString  *CityID;
@property (nonatomic , strong) NSString  *Canton_EnName;

@end