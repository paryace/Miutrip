//
//  SendSMSResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface SendSMSResponse : BaseResponseModel

@property (strong, nonatomic) NSNumber      *Result;        //结果	bool
@property (strong, nonatomic) NSNumber      *Count;         //数量	int
@property (strong, nonatomic) NSString      *ErrorCode;     //错误码

@end
