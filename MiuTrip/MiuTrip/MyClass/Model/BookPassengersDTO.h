//
//  BookPassengersDTO.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookPassengersDTO : NSObject

@property (strong, nonatomic) NSString      *UniqueID;                  //唯一Id（为PassengerID和CorpUID 组合）

@property (assign, nonatomic) NSInteger     PassengerID;                //旅客ID
@property (strong, nonatomic) NSString      *CorpUID;                   //公司用户ID
@property (assign, nonatomic) BOOL          IsEmoloyee;                 //是否雇员
@property (assign, nonatomic) BOOL          IsServer;                   //是否服务
@property (strong, nonatomic) NSString      *UserName;                  //职员姓名
@property (strong, nonatomic) NSString      *LastName;                  //英文名字
@property (strong, nonatomic) NSString      *FirstName;                 //...
@property (strong, nonatomic) NSString      *MiddleName;                //...
@property (strong, nonatomic) NSString      *FullENName;                //英文全名
@property (strong, nonatomic) NSString      *Gender;                    //职员性别	M:男/F:女
@property (strong, nonatomic) NSString      *Mobilephone;               //职员手机号
@property (strong, nonatomic) NSString      *Email;                     //邮箱
@property (assign, nonatomic) NSInteger     DeptID;                     //部门ID
@property (strong, nonatomic) NSString      *DeptName;                  //部门名称
@property (strong, nonatomic) NSString      *DeptNameEn;                //部门英文名称
@property (strong, nonatomic) NSString      *PolicyID;                  //政策ID
@property (strong, nonatomic) NSString      *PolicyName;                //政策名称
@property (assign, nonatomic) NSInteger     PreMinute;                  //Reason Code检测时间段前分钟数
@property (assign, nonatomic) NSInteger     LastMinute;                 //Reason Code检测时间段后分钟数
@property (assign, nonatomic) NSInteger     FltPreBookDays;             //是否需要国内机票提前预订Reason Code T/F
@property (assign, nonatomic) NSInteger     IntlFltPreBookDays;         //国内机票提前预订天数
@property (assign, nonatomic) CGFloat       HtlAmountLimtMax;           //酒店预订标准上限
@property (strong, nonatomic) NSString      *EmployeeID;                //雇员ID
@property (strong, nonatomic) NSString      *HotelPolicyTitle;          //酒店政策主题
@property (strong, nonatomic) NSString      *FlightPolicyTitle;         //飞机票政策主题
@property (strong, nonatomic) NSString      *Country;                   //国籍
@property (strong, nonatomic) NSString      *Birthday;                  //职员生日          时间yyyy-MM-dd
@property (strong, nonatomic) NSString      *Status;                    //职员状态：0离职、1在职
@property (strong, nonatomic) NSString      *Position;                  //职员职位
@property (assign, nonatomic) NSInteger     AgentRange;                 //代订范围：0：全部 1：制定范围
@property (assign, nonatomic) NSInteger     DepLev;                     //组织级别
@property (assign, nonatomic) NSInteger     PreDeptID;                  //所属部门ID
@property (assign, nonatomic) NSInteger     IsServerCard;               //是否为服务卡    0:否/1:是

@property (strong, nonatomic) NSMutableArray *IDCardList;               //身份卡列表	List<MemberIDCardDTO>
@property (strong, nonatomic) NSMutableArray *AirlineCardList;          //旅卡列表	List<AirlineCardDTO>

@property (strong, nonatomic) NSString      *Telephone;                 //电话
@property (strong, nonatomic) NSString      *Fax;                       //传真
@property (strong, nonatomic) NSString      *ContactConfirmType;        //联系确认方式    可为空
@property (assign, nonatomic) NSInteger     CorpID;                     //企业ID
@property (assign, nonatomic) NSInteger     AccessLevel;                //权限级别：0出行者、1管理员
@property (assign, nonatomic) NSInteger     AccessType;                 //角色：0演示账号、1正式账号、2测试账号
@property (assign, nonatomic) NSInteger     MileageRule;                //积分累计规则
@property (assign, nonatomic) NSInteger     OrderForSelf;               //是否限为本人预订 0：否 1：是

@property (assign, nonatomic) BOOL          unfold;                     //cell展开

+ (NSArray*)getListWithData:(NSArray*)data;
- (id)initWithParams:(NSDictionary*)params;

@end

@interface MemberIDCardDTO : NSObject

@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (assign, nonatomic) NSInteger     CardType;                   //卡类型
@property (strong, nonatomic) NSString      *CardNumber;                //卡号
@property (strong, nonatomic) NSString      *IsDefault;                 //是否默认  T:是/F:否

@end

@interface AirlineCardList : NSObject

@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (strong, nonatomic) NSString      *AirLine;                   //航空公司
@property (strong, nonatomic) NSString      *CardNumber;                //卡号

@end