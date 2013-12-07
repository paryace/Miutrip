//
//  GetCorpSeverCardListResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"


@interface GetCorpServerCardListResponse : BaseResponseModel

@property (strong, nonatomic) NSString      *UID;                   //用户ID
@property (strong, nonatomic) NSString      *CorpID;                //公司ID
@property (strong, nonatomic) NSString      *UserName;              //用户名称
@property (strong, nonatomic) NSString      *LastName;              //英文名字
@property (strong, nonatomic) NSString      *FirstName;             //...
@property (strong, nonatomic) NSString      *MiddleName;            //...
@property (strong, nonatomic) NSString      *HotelPolicyTitle;      //酒店政策描述
@property (strong, nonatomic) NSString      *FlightPolicyTitle;     //机票政策描述

@end