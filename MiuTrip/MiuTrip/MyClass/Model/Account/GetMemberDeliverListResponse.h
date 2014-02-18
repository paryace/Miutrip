//
//  GetMemberDeliverListResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"


@interface GetMemberDeliverListResponse : BaseResponseModel

@property (strong, nonatomic) NSArray   *delivers;

- (void)getObjects;

@end


@interface MemberDeliverDTO : BaseResponseModel

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


@property (nonatomic , strong)  NSString  *CityName;
@property (nonatomic , strong)  NSString  *ProvinceName;
@property (nonatomic , strong)  NSString  *Canton_Name;
//@property (nonatomic , strong)  NSString  *LastUseDate;

@end


