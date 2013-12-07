//
//  GetCorpCostRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "GetCorpCostResponse.h"
///////////////////////////////////////////////////////

@interface GetCorpCostRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *corpId;

@end
