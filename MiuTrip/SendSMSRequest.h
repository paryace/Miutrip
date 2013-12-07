//
//  SendSMSRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

@interface SendSMSRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *sn;
@property (nonatomic , strong) NSString  *key;

@end

@interface SMS_SendRequest : BaseRequestModel

@property (nonatomic , strong) NSString  *Sendtime;
@property (nonatomic , strong) NSString  *mobile;
@property (nonatomic , strong) NSString  *content;
@property (nonatomic , strong) NSString  *addcode;
@property (nonatomic , strong) NSString  *charset;
@property (nonatomic , strong) NSString  *priority;

@end



@interface SMS_SendResponse : BaseResponseModel

@property (nonatomic , strong) NSString  *Result;
@property (nonatomic , strong) NSString  *Count;
@property (nonatomic , strong) NSString  *ErrorCode;

@end