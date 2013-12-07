//
//  GetFlightChangeRuleResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetFlightChangeRuleResponse : BaseResponseModel


@property(strong, nonatomic) NSString *rule;
@end

@interface  Rule : BaseResponseModel

@property(strong, nonatomic) NSString *refund;
@property(strong, nonatomic) NSString *cDate;
@property(strong, nonatomic) NSString *upgrades;
@property(strong, nonatomic) NSString *transfer;
@property(strong, nonatomic) NSString *rebate;

@end
