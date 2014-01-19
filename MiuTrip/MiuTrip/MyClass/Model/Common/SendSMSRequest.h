//
//  SendSMSRequest.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#import "SendSMSResponse.h"

@interface SendSMSRequest : BaseRequestModel

@property (strong, nonatomic) NSString      *sn;            //软件序列号
@property (strong, nonatomic) NSString      *key;           //关键字,必须和软件注册时的关键字保持一致
@property (strong, nonatomic) NSString      *sendtime;      //定时短信的定时时间,为空时，为即时发送短信,不为空时，为定时发送短信
@property (strong, nonatomic) NSArray       *mobile;        //手机号码(字符串数组,最多为200个手机号码)
@property (strong, nonatomic) NSString      *content;       //内容
@property (strong, nonatomic) NSString      *addcode;       //扩展号码
@property (strong, nonatomic) NSString      *charset;       //字符编码
@property (strong, nonatomic) NSNumber      *priority;      //短信等级，范围1~5，数值越高优先级越高	是	int

@end
