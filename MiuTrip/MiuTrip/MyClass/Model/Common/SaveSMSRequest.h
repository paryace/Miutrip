//
//  SaveSMSRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "SaveSMSResponse.h"

@interface SaveSMSRequest : BaseRequestModel

@property (strong, nonatomic) NSNumber      *SMSID;             //短信ID	是	int
@property (strong, nonatomic) NSNumber      *BusinessType;      //业务类型	是	int	1：国内机票 2：国际机票 3：国内酒店 4：国际酒店 5：租车 6：市场推广 7：其他
@property (strong, nonatomic) NSString      *OrderID;           //订单ID
@property (strong, nonatomic) NSString      *Mobile;            //手机号码
@property (strong, nonatomic) NSString      *SmsContent;        //短信内容
@property (strong, nonatomic) NSString      *AddCode;           //附加号码
@property (strong, nonatomic) NSNumber      *Priority;          //短信等级	是	int	1：最低 2：低于标准 3：标准 4：高于标准 5：最高
@property (strong, nonatomic) NSString      *SendTime;          //发送时间
@property (strong, nonatomic) NSString      *ScheduleTime;      //计划发送时间
@property (strong, nonatomic) NSString      *Deadline;          //过期时间
@property (strong, nonatomic) NSString      *Satatus;           //状态	是	string	W:待处理 S:成功 F:失败 C:取消
@property (strong, nonatomic) NSNumber      *TotalCount;        //短信总数	是	int
@property (strong, nonatomic) NSNumber      *Retry;             //重试次数	是	int
@property (strong, nonatomic) NSString      *Creater;           //创建者
@property (strong, nonatomic) NSString      *CreateTime;        //创建时间
@property (strong, nonatomic) NSString      *Channel;           //通道
@property (strong, nonatomic) NSString      *OperateTime;       //操作时间
@property (strong, nonatomic) NSString      *ErrorCode;         //错误码

@end
