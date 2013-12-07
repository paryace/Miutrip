//
//  GethotelImageListRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "URLHelper.h"
@interface GetHotelImageListRequest : BaseRequestModel

@property(strong,nonatomic) NSNumber *hotelId;
@property(strong,nonatomic) NSNumber *page;
@property(strong,nonatomic) NSNumber *pageSize;

@end
