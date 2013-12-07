//
//  GetCorpStaffResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetCorpStaffResponse : BaseResponseModel

@property (strong, nonatomic) NSString      *UniqueID;                  //唯一Id（为PassengerID和CorpUID 组合）
@property (strong, nonatomic) NSNumber     *PassengerID;                //旅客ID
@property (strong, nonatomic) NSString      *CorpUID;                   //公司用户ID
@property (strong, nonatomic) NSNumber          *IsEmoloyee;                 //是否为员工
@property (strong, nonatomic) NSNumber          *IsServer;                   //是否服务
@property (strong, nonatomic) NSString      *UserName;                  //职员姓名
@property (strong, nonatomic) NSString      *LastName;                  //英文名字
@property (strong, nonatomic) NSString      *FirstName;                 //...
@property (strong, nonatomic) NSString      *MiddleName;                //...
@property (strong, nonatomic) NSString      *FullENName;                //英文全名
@property (strong, nonatomic) NSString      *Email;                     //邮箱
@property (strong, nonatomic) NSNumber     *DeptID;                     //部门ID
@property (strong, nonatomic) NSString      *DeptName;                  //部门名称
@property (strong, nonatomic) NSString      *DeptNameEN;                //部门英文名称
@property (strong, nonatomic) NSNumber     *PolicyID;                   //政策ID
@property (strong, nonatomic) NSString      *PolicyName;                //政策名称
@property (strong, nonatomic) NSNumber     *PreMinute;                  //Reason Code检测时间段前分钟数
@property (strong, nonatomic) NSNumber     *LastMinute;                 //Reason Code检测时间段后分钟数
@property (assign, nonatomic) NSNumber     *FltPreBookDays;             //是否需要国内机票提前预订Reason Code T/F
@property (strong, nonatomic) NSNumber     *IntlFltPreBookDays;         //国内机票提前预订天数
@property (strong, nonatomic) NSNumber       *HtlAmountLimtMax;           //酒店预订标准上限
@property (strong, nonatomic) NSString      *EmployeeID;                //雇员ID
@property (strong, nonatomic) NSString      *HotelPolicyTitle;          //酒店政策主题
@property (strong, nonatomic) NSString      *FlightPolicyTitle;         //机票政策主题

@end


@interface BookPassengersResponse : BaseResponseModel

@property (strong, nonatomic) NSMutableArray *IDCardList;               //身份卡列表	List<MemberIDCardDTO>
@property (strong, nonatomic) NSMutableArray *AirlineCardList;          //旅卡列表	List<AirlineCardDTO>

@end


@interface MemberIDcardResponse : BaseResponseModel

@property (strong, nonatomic) NSString     *UID;
@property (strong, nonatomic) NSNumber     *CardType;
@property (strong, nonatomic) NSString     *CardNumber;
@property (strong, nonatomic) NSString     *IsDefault;

@end



@interface  AirlineCardReaponse  : BaseResponseModel

@property (strong, nonatomic) NSString      *UID;
@property (strong, nonatomic) NSString      *Airline;
@property (strong, nonatomic) NSString      *CardNumber;

//@property (assign, nonatomic) BOOL          unfold;                     //cell展开


@end

