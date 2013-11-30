//
//  CorpUserBaseInfoDTO.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CorpInfo;

@interface CorpUserBaseInfoDTO : NSObject

@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (assign, nonatomic) NSInteger     CorpID;                     //公司ID
@property (strong, nonatomic) NSString      *EmployeeID;                //雇员ID
@property (assign, nonatomic) NSInteger     AccessLevel;                //权限级别：0出行者、1管理员
@property (assign, nonatomic) NSInteger     AccessType;                 //角色：0演示账号、1正式账号、2测试账号
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
@property (assign, nonatomic) NSInteger     DeptID;                     //职员所在部门
@property (assign, nonatomic) NSInteger     PolicyID;                   //差旅政策ID
@property (assign, nonatomic) NSInteger     MileageRule;                //积分累计规则
@property (assign, nonatomic) NSInteger     OrderForSelf;               //是否限为本人预订 0：否 1：是
@property (assign, nonatomic) NSInteger     AgentRange;                 //代订范围：0：全部 1：制定范围
@property (assign, nonatomic) NSInteger     DepLev;                     //组织级别
@property (assign, nonatomic) NSInteger     PreDeptID;                  //所属部门ID
@property (strong, nonatomic) NSString      *DeptName;                  //部门名称
@property (strong, nonatomic) NSString      *DeptNameEn;                //部门英文名称
@property (assign, nonatomic) NSInteger     IsServerCard;               //是否为服务卡    0:否/1:是
@property (strong, nonatomic) NSString      *LastLoginTime;             //最后登录时间
@property (assign, nonatomic) NSInteger     ReportLimits;               //报表限制

@property (strong, nonatomic) NSMutableArray *IDCardList;               //身份卡列表	List<MemberIDCardDTO>
@property (strong, nonatomic) NSMutableArray *AirlineCardList;          //旅卡列表	List<AirlineCardDTO>

@end

@interface CorpInfo : NSObject

@property (strong, nonatomic) NSString      *CorpName;                  //公司名称
@property (strong, nonatomic) NSString      *CorpNameEn;                //公司英文名
@property (strong, nonatomic) NSString      *CorpShortName;             //公司简短名
@property (assign, nonatomic) NSInteger     NeedDelivery;               //是否需要定期配送      0：否 1：是
@property (assign, nonatomic) NSInteger     NeedStrictDelivery;         //是否限制定期配送      0：否 1：是

@property (strong, nonatomic) NSMutableArray *Corp_AddressList;         //定期配送地址列表	List<Corp_AddressDTO>

@end

@interface Corp_AddressDTO : NSObject

@property (strong, nonatomic) NSString      *ID;                        //配送地址记录id
@property (strong, nonatomic) NSString      *CreateUser;                //创建人
@property (strong, nonatomic) NSString      *RecipientName;             //收件人
@property (strong, nonatomic) NSString      *ProvinceId;                //省id
@property (strong, nonatomic) NSString      *ProvinceName;              //省
@property (strong, nonatomic) NSString      *CityId;                    //城市id
@property (strong, nonatomic) NSString      *CityName;                  //城市名称
@property (strong, nonatomic) NSString      *CantonId;                  //区域Id
@property (strong, nonatomic) NSString      *CantonName;                //区域
@property (strong, nonatomic) NSString      *Address;                   //地址
@property (strong, nonatomic) NSString      *ZipCode;                   //邮编
@property (strong, nonatomic) NSString      *Tel;                       //电话
@property (strong, nonatomic) NSString      *Mobile;                    //手机

@end














