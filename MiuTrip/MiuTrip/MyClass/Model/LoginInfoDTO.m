//
//  LoginInfoDTO.m
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LoginInfoDTO.h"
#import "Model.h"
#import "Utils.h"

@implementation LoginInfoDTO

- (id)initWithData:(NSDictionary*)data
{
    if (self = [super init]) {
        //AirlineCardList IDCardList

        _AccessLevel = [[data objectForKey:@"AccessLevel"] integerValue];
        _Birthday    = [data objectForKey:@"Birthday"];
        _CorpID      = [[data objectForKey:@"CorpID"] integerValue];
        _CorpName    = [data objectForKey:@"CorpName"];
        _CorpNameEn  = [data objectForKey:@"CorpNameEn"];
        _Country     = [data objectForKey:@"Country"];
        _DeptID      = [[data objectForKey:@"DeptID"] integerValue];
        _DeptName    = [data objectForKey:@"DeptName"];
        _DeptNameEn  = [data objectForKey:@"DeptNameEn"];
        _Email       = [data objectForKey:@"Email"];
        _EmployeeID  = [data objectForKey:@"EmployeeID"];
        _FirstName   = [data objectForKey:@"FirstName"];
        _FltPreBookDays = [[data objectForKey:@"FltPreBookDays"] integerValue];
        _FltPreBookRC = [data objectForKey:@"FltPreBookRC"];
        _Gender      = [data objectForKey:@"Gender"];
        _HasPolicy   = [[data objectForKey:@"HasPolicy"] integerValue];
        _HotelRC     = [data objectForKey:@"HotelRC"];
        _HtlAmountLimtMax = [[data objectForKey:@"HtlAmountLimtMax"] floatValue];
        _IsNeedRC_FltN = [data objectForKey:@"IsNeedRC_FltN"];
        NSString *LastLoginTime = [[data objectForKey:@"LastLoginTime"] stringByMatching:@"\\d+"];
        if (LastLoginTime.length > 11) {
            _LastLoginTime = [LastLoginTime substringWithRange:NSMakeRange(0, 10)];
        }else
            _LastLoginTime = LastLoginTime;
        _LastMinute = [[data objectForKey:@"LastMinute"] integerValue];
        _LastName   = [data objectForKey:@"LastName"];
        _Logo       = [data objectForKey:@"Logo"];
        @try {
            _LogoBinary = (Byte *)[[Utils NULLToEmpty:[data objectForKey:@"LogoBinary"]] dataUsingEncoding:NSUTF8StringEncoding].bytes;
        }
        @catch (NSException *exception) {
            [[Model shareModel] showPromptText:[NSString stringWithFormat:@"异常:%@\n异常原因:%@",exception.name,exception.reason] model:YES];
        }
        @finally {
            
        }
        _CreateTime = [data objectForKey:@"CreateTime"];
        _OrderRange = [data objectForKey:@"OrderRange"];
        _MiddleName = [data objectForKey:@"MiddleName"];
        _Mobilephone = [data objectForKey:@"Mobilephone"];
        _OrderForSelf = [[data objectForKey:@"OrderForSelf"] integerValue];
        _PolicyID = [[data objectForKey:@"PolicyID"] integerValue];
        _PolicyName = [data objectForKey:@"PolicyName"];
        _PreMinute = [[data objectForKey:@"PreMinute"] integerValue];
        _ReportLimits = [[data objectForKey:@"ReportLimits"] integerValue];
        _UID = [data objectForKey:@"UID"];
        _UserName = [data objectForKey:@"UserName"];
    }
    return self;
}

@end
