//
//  GetCorpStaffResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetCorpStaffResponse : BaseResponseModel

@property (strong, nonatomic) NSArray       *customers;                 //所有员工

- (void)getObjects;

@end

@interface CorpStaffDTO : BaseResponseModel

@property (strong, nonatomic) NSString      *UniqueID;                  //唯一Id（为PassengerID和CorpUID 组合）
@property (assign, nonatomic) NSNumber      *PassengerID;               //旅客ID          NSInteger
@property (strong, nonatomic) NSString      *CorpUID;                   //公司用户ID
@property (assign, nonatomic) NSNumber      *IsEmoloyee;                //是否为员工         BOOL
@property (assign, nonatomic) NSNumber      *IsServer;                  //是否服务           BOOL
@property (strong, nonatomic) NSString      *UserName;                  //职员姓名
@property (strong, nonatomic) NSString      *LastName;                  //英文名字
@property (strong, nonatomic) NSString      *FirstName;                 //...
@property (strong, nonatomic) NSString      *MiddleName;                //...
@property (strong, nonatomic) NSString      *FullENName;                //英文全名
@property (strong, nonatomic) NSString      *Email;                     //邮箱
@property (assign, nonatomic) NSNumber      *DeptID;                    //部门ID             NSInteger
@property (strong, nonatomic) NSString      *DeptName;                  //部门名称
@property (strong, nonatomic) NSString      *DeptNameEN;                //部门英文名称
@property (assign, nonatomic) NSNumber      *PolicyID;                   //政策ID             NSInteger
@property (strong, nonatomic) NSString      *PolicyName;                //政策名称
@property (assign, nonatomic) NSNumber      *PreMinute;                 //Reason Code检测时间段前分钟数         NSInteger
@property (assign, nonatomic) NSNumber      *LastMinute;                //Reason Code检测时间段后分钟数         NSInteger
@property (assign, nonatomic) NSNumber      *FltPreBookDays;            //是否需要国内机票提前预订Reason Code T/F          NSInteger
@property (assign, nonatomic) NSNumber      *IntlFltPreBookDays;        //国内机票提前预订天数                            NSInteger
@property (assign, nonatomic) NSNumber      *HtlAmountLimtMax;          //酒店预订标准上限                               CGFloat
@property (strong, nonatomic) NSString      *EmployeeID;                //雇员ID
@property (strong, nonatomic) NSString      *HotelPolicyTitle;          //酒店政策主题
@property (strong, nonatomic) NSString      *FlightPolicyTitle;         //机票政策主题

@property (strong, nonatomic) NSMutableArray *IDCardList;               //身份卡列表	List<MemberIDcardResponse>
@property (strong, nonatomic) NSMutableArray *AirlineCardList;          //旅卡列表	List<AirlineCardReaponse>

@property (strong, nonatomic) NSNumber      *selected;


@end