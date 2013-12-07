//
//  GetHotelimageListResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetHotelImageListResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *page;
@property(strong,nonatomic) NSNumber *pageSize;
@property(strong,nonatomic) NSNumber *totalPage;
@property(strong,nonatomic) NSNumber *totalCount;

@end
@interface HotelImages : NSObject

@property(strong,nonatomic) NSNumber *imageId;
@property(strong,nonatomic) NSString *imageName;
@property(strong,nonatomic) NSString *imageUrl;

@end

