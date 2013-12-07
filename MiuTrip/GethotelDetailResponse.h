//
//  GethotelDetailResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GethotelDetailResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *starRatedId;
@property(strong,nonatomic) NSString *sstarRatedName;
@property(strong,nonatomic) NSString *cityName;
@property(strong,nonatomic) NSString *sectionName;
@property(strong,nonatomic) NSString *chainName;
@property(strong,nonatomic) NSNumber *bizSectionName;
@property(strong,nonatomic) NSNumber *hotelId;
@property(strong,nonatomic) NSString *hotelName;
@property(strong,nonatomic) NSString *hotelType;
@property(strong,nonatomic) NSNumber *hotlCode;
@property(strong,nonatomic) NSNumber *hotelChainId;
@property(strong,nonatomic) NSString *intro;
@property(strong,nonatomic) NSString *nearby;
@property(strong,nonatomic) NSString *street;
@property(strong,nonatomic) NSString *streetAddr;
@property(strong,nonatomic) NSString *longitude;
@property(strong,nonatomic) NSString *latitude;
@property(strong,nonatomic) NSString *openingDate;
@property(strong,nonatomic) NSString *decoDate;
@property(strong,nonatomic) NSString *additionService;
@property(strong,nonatomic) NSString *service;
@property(strong,nonatomic) NSString *facility;
@property(strong,nonatomic) NSString *catering;
@property(strong,nonatomic) NSString *recreation;
@property(strong,nonatomic) NSString *creditCard;
@property(strong,nonatomic) NSNumber *lowestPrice;
@property(strong,nonatomic) NSNumber *highestPrice;
@property(strong,nonatomic) NSString *remark;
@property(strong,nonatomic) NSString *commentTotal;
@property(strong,nonatomic) NSString *commnetGood;

@end
