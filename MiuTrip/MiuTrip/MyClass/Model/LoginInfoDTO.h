//
//  LoginInfoDTO.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfoDTO : NSObject

@property (strong, nonatomic) NSString      *CreateTime;            //创建时间
@property (strong, nonatomic) NSString      *OrderRange;            //预定范围

@property (strong, nonatomic) NSString      *UID;                   //用户ID
@property (assign, nonatomic) NSInteger     AccessLevel;            //权限级别 0:出行者 1:管理者
@property (strong, nonatomic) NSString      *UserName;              //职员姓名
@property (strong, nonatomic) NSString      *LastName;              //英文名字
@property (strong, nonatomic) NSString      *FirstName;             //...
@property (strong, nonatomic) NSString      *MiddleName;            //...
@property (strong, nonatomic) NSString      *Mobilephone;           //职员手机号
@property (strong, nonatomic) NSString      *Email;                 //邮箱
@property (strong, nonatomic) NSString      *Gender;                //职员性别 M:男/F:女
@property (strong, nonatomic) NSString      *Country;               //国籍
@property (strong, nonatomic) NSString      *Birthday;              //职员生日 yyyy-MM-dd
@property (assign, nonatomic) NSInteger     OrderForSelf;           //是否限为本人预订 0:否 1:是
@property (strong, nonatomic) NSString      *EmployeeID;            //雇员ID
@property (assign, nonatomic) NSInteger     ReportLimits;           //报表限制
@property (assign, nonatomic) NSInteger     CorpID;                 //企业ID
@property (strong, nonatomic) NSString      *CorpName;              //企业名字
@property (strong, nonatomic) NSString      *CorpNameEn;            //企业英文名字
@property (strong, nonatomic) NSString      *Logo;                  //企业Logo
@property (assign, nonatomic) Byte          *LogoBinary;            //企业Logo字节码
@property (strong, nonatomic) NSString      *LastLoginTime;         //最后使用时间
@property (assign, nonatomic) NSInteger     DeptID;                 //部门ID
@property (strong, nonatomic) NSString      *DeptName;              //部门名称
@property (strong, nonatomic) NSString      *DeptNameEn;            //部门英文名称
@property (assign, nonatomic) NSInteger     HasPolicy;              //是否有政策
@property (assign, nonatomic) NSInteger     PolicyID;               //政策ID
@property (strong, nonatomic) NSString      *PolicyName;            //政策名称
@property (strong, nonatomic) NSString      *IsNeedRC_FltN;         //是否国内机票需要 ReasonCode  T/F
@property (assign, nonatomic) NSInteger     PreMinute;              //ReasonCode检测时间段前分钟数
@property (assign, nonatomic) NSInteger     LastMinute;             //ReasonCode检测时间段后分钟数
@property (strong, nonatomic) NSString      *FltPreBookRC;          //是否需要国内机票提前预订Reason Code T/F
@property (assign, nonatomic) NSInteger     FltPreBookDays;         //国内机票提前预订天数
@property (strong, nonatomic) NSString      *HotelRC;               //酒店预订ReasonCode
@property (assign, nonatomic) CGFloat      HtlAmountLimtMax;        //酒店预订标准上限

@property (strong, nonatomic) NSMutableArray *IDCardList;           //身份卡列表	List<MemberIDCardDTO>
@property (strong, nonatomic) NSMutableArray *AirlineCardList;      //旅卡列表	List<AirlineCardDTO>

- (id)initWithData:(NSDictionary*)data;

@end
