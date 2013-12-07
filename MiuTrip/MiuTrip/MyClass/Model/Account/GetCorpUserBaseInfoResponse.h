//
//  GetCorpUserBaseInfoResponse.h
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"


@interface GetCorpUserBaseInfoResponse : BaseResponseModel

@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (strong, nonatomic) NSNumber     *CorpID;                     //公司ID
@property (strong, nonatomic) NSString      *EmployeeID;                //雇员ID
@property (strong, nonatomic) NSNumber     *AccessLevel;                //权限级别：0出行者、1管理员
@property (strong, nonatomic) NSNumber     *AccessType;                 //角色：0演示账号、1正式账号、2测试账号
@property (strong, nonatomic) NSString      *UserName;                  //职员姓名
@property (strong, nonatomic) NSString      *LastName;                  //英文名字
@property (strong, nonatomic) NSString      *FirstName;                 //...
@property (strong, nonatomic) NSString      *MiddleName;                //...
@property (strong, nonatomic) NSString      *FullENName;                //英文全名
@property (strong, nonatomic) NSString      *Email;                     //邮箱
@property (strong, nonatomic) NSString      *Mobilephone;               //职员手机号
@property (strong, nonatomic) NSString      *Gender;                    //职员性别	M:男/F:女
@property (strong, nonatomic) NSString      *Country;                   //国籍
@property (strong, nonatomic) NSString      *Birthday;                  //职员生日  时间yyyy-MM-dd
@property (strong, nonatomic) NSString      *Status;                    //职员状态：0离职、1在职
@property (strong, nonatomic) NSString      *Position;                  //职员职位
@property (strong, nonatomic) NSNumber     *DeptID;                     //职员所在部门
@property (strong, nonatomic) NSNumber     *PolicyID;                   //差旅政策ID
@property (strong, nonatomic) NSNumber     *MileageRule;                //积分累计规则
@property (strong, nonatomic) NSNumber     *OrderForSelf;               //是否限为本人预订 0：否 1：是
@property (strong, nonatomic) NSNumber     *AgentRange;                 //代订范围：0：全部 1：制定范围
@property (strong, nonatomic) NSNumber     *DepLev;                     //组织级别
@property (strong, nonatomic) NSNumber     *PreDeptID;                  //所属部门ID
@property (strong, nonatomic) NSString      *DeptName;                  //部门名称
@property (strong, nonatomic) NSString      *DeptNameEn;                //部门英文名称
@property (strong, nonatomic) NSNumber     *IsServerCard;               //是否为服务卡    0:否/1:是
@property (strong, nonatomic) NSString      *LastLoginTime;             //最后登录时间
@property (strong, nonatomic) NSNumber     *ReportLimits;               //报表限制

@property (strong, nonatomic) NSMutableArray *IDCardList;               //身份卡列表	List<MemberIDCardDTO>
@property (strong, nonatomic) NSMutableArray *AirlineCardList;          //旅卡列表	List<AirlineCardDTO>


@end


@interface MemberIDCardResponse : BaseResponseModel


@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (strong, nonatomic) NSNumber     *CardType;                   //卡类型
@property (strong, nonatomic) NSString      *CardNumber;                //卡号
@property (strong, nonatomic) NSString      *IsDefault;                 //是否默认  T:是/F:否

@end


@interface AirlineCardResponse : BaseResponseModel

@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (strong, nonatomic) NSString      *AirLine;                   //航空公司
@property (strong, nonatomic) NSString      *CardNumber;                //卡号

@end

