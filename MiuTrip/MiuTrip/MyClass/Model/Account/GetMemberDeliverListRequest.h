//
//  GetMemberDeliverListRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"
////////////////////////////////////////////////////////////////////////////

@interface GetMemberDeliverListRequest : BaseRequestModel

@property (nonatomic , strong)  NSString  *uid;
@property (nonatomic , strong)  NSString  *name;
@property (nonatomic , strong)  NSString  *pagingOptions;
@property (nonatomic , strong)  NSNumber  *FetchRecordCount;
@property (nonatomic , strong)  NSNumber  *PagerNumber;
@property (nonatomic , strong)  NSNumber  *PageSize;

@end

