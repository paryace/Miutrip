//
//  GetCommentListResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetCommentListResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *overallRating;
@property(strong,nonatomic) NSString *content;
@property(strong,nonatomic) NSString *createDate;

@end
