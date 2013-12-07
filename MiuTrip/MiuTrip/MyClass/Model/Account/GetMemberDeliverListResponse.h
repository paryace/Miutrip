//
//  GetMemberDeliverListResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"


@interface GetMemberDeliverListResponse : BaseResponseModel

@property (nonatomic , strong)  NSNumber  *AddID;
@property (nonatomic , strong)  NSString  *UID;
@property (nonatomic , strong)  NSString  *RecipientName;
@property (nonatomic , strong)  NSNumber  *Province;
@property (nonatomic , strong)  NSNumber  *City;
@property (nonatomic , strong)  NSNumber  *Canton;
@property (nonatomic , strong)  NSString  *Address;
@property (nonatomic , strong)  NSString  *ZipCode;
@property (nonatomic , strong)  NSString  *Tel;
@property (nonatomic , strong)  NSString  *Mobile;


@property (nonatomic , strong)  NSString  *CityMode;
@property (nonatomic , strong)  NSString  *ProvinceMode;
@property (nonatomic , strong)  NSString  *CantonMode;
@property (nonatomic , strong)  NSString  *LastUseDate;

@end


