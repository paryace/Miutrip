//
//  SaveSMSRequest.h
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "SaveSMSResponse.h"
////////////////////////////////////

@interface SaveSMSRequest : BaseRequestModel


@property (nonatomic , strong) NSNumber  *SMSID;
@property (nonatomic , strong) NSNumber  *BussinessType;
@property (nonatomic , strong) NSString  *OrderID;
@property (nonatomic , strong) NSString  *Mobile;
@property (nonatomic , strong) NSString  *SmsContent;
@property (nonatomic , strong) NSString  *AddCode;
@property (nonatomic , strong) NSNumber  *Priority;
@property (nonatomic , strong) NSDate  *SendTime;
@property (nonatomic , strong) NSDate  *ScheduleTime;
@property (nonatomic , strong) NSDate  *Deadline;
@property (nonatomic , strong) NSString  *Satatus;
@property (nonatomic , strong) NSNumber  *TotalCount;
@property (nonatomic , strong) NSNumber  *Retry;
@property (nonatomic , strong) NSString  *Creater;
@property (nonatomic , strong) NSDate  *CreateTime;
@property (nonatomic , strong) NSString  *Channel;
@property (nonatomic , strong) NSDate  *OperatreTime;
@property (nonatomic , strong) NSString  *ErrorCode;

@end
