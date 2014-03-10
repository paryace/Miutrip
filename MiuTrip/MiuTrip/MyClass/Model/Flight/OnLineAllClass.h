//
//  OnLineAllClass.h
//  MiuTrip
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponseModel.h"

@class DomesticFlightDataDTO;
@class RouteEntity;

@interface SearchFlightDTO : BaseResponseModel

@property (strong, nonatomic) NSArray       *DepartCity1;       //出发城市       string
@property (strong, nonatomic) NSArray       *ArriveCity1;       //数组第一个值为城市机场三字码,第二、三个值为城市名称 string
@property (strong, nonatomic) NSString      *DepartDate1;       //第一程出发日期
@property (strong, nonatomic) NSArray       *DepartCity2;       //第二出发城市    string
@property (strong, nonatomic) NSArray       *ArriveCity2;       //第二到达城市    string
@property (strong, nonatomic) NSString      *DepartDate2;       //第二出发日期
@property (strong, nonatomic) NSString      *ClassType;         //仓位类型
@property (strong, nonatomic) NSNumber      *PassengerQuantity; //乘客数量
@property (strong, nonatomic) NSString      *FeeType;           //费用类型       PUB:因公，OWN 因私
@property (strong, nonatomic) NSString      *BookingType;       //预定类型       self:为本人 ，other：为多人/他人
@property (strong, nonatomic) NSArray       *SendTicket;        //送票城市       数组第一个值为城市机场三字码,第二、三个值为城市名称
@property (strong, nonatomic) NSString      *Airline;           //航空公司
@property (strong, nonatomic) NSString      *PassengerType;     //乘机人类型
@property (strong, nonatomic) NSNumber      *RouteIndex;        //航程序号
@property (strong, nonatomic) NSString      *SearchType;        //航程类型       S:单程 M：多程 D:往返程
@property (strong, nonatomic) RouteEntity   *FirstRoute;        //第一程航班（直接取的是航班查询的对象，moreflight设为null）
@property (strong, nonatomic) RouteEntity   *SecondRoute;       //第二程

@end


@interface CraftTypeDTO : BaseResponseModel

@property (strong, nonatomic) NSString      *ID;            //机型ID
@property (strong, nonatomic) NSString      *Name;          //机型名称
@property (strong, nonatomic) NSString      *Scale;         //机型        0:暂无 1：小机型 2： 中机型 3：大型机
@property (strong, nonatomic) NSString      *Seats;         //座位数       <=0 暂无

@end

@interface AirlineDTO : BaseResponseModel

@property (strong, nonatomic) NSString      *AirLine;       //航空公司ID
@property (strong, nonatomic) NSString      *AirLineName;   //航空公司名称
@property (strong, nonatomic) NSString      *AirLineCode;   //航空公司首字母
@property (strong, nonatomic) NSString      *ShortName;     //航空公司短名
@property (strong, nonatomic) NSString      *AirportEnName; //机场英文名
@property (strong, nonatomic) NSString      *FlightClass;
@property (strong, nonatomic) NSString      *CityName;      //机场所在城市

@end


@interface TC_APIFlightInsuranceConfig : BaseResponseModel

@property (strong, nonatomic) NSString      *iCode;         //配置代码
@property (assign, nonatomic) NSInteger     iName;          //配置名称
@property (strong, nonatomic) NSString      *sPrice;        //建议价格
@property (strong, nonatomic) NSString      *rPrice;        //是否实时结算
@property (strong, nonatomic) NSString      *rTime;         //机场所在城市
@property (strong, nonatomic) NSString      *cTotal;        //保额


@end


@interface TC_APImInfo : BaseResponseModel

@property (strong, nonatomic) NSString      *mCode;         //配置代码
@property (assign, nonatomic) NSString      *mName;          //配置名称
@property (strong, nonatomic) NSString      *sPrice;        //建议价格
@property (strong, nonatomic) NSString      *rPrice;        //合作价格
@property (strong, nonatomic) NSString      *rTime;         //是否实时结算

@end

@interface StopItem : BaseResponseModel

@property (strong, nonatomic) NSString      *city;          //经停城市
@property (strong, nonatomic) NSString      *aTime;         //到达时间
@property (strong, nonatomic) NSString      *fTime;         //起飞时间

@end

@interface Rule : BaseResponseModel

@property (strong, nonatomic) NSString      *refund;        //退票规定
@property (strong, nonatomic) NSString      *cDate;         //改期规定
@property (strong, nonatomic) NSString      *upgrades;      //升舱规定
@property (strong, nonatomic) NSString      *transfer;      //签转规定
@property (strong, nonatomic) NSString      *rebate;        //返现

@end

@interface AirportDTO : BaseResponseModel

@property (strong, nonatomic) NSString      *Airport;       //机场三字码
@property (strong, nonatomic) NSString      *AirportName;   //机场全称
@property (strong, nonatomic) NSNumber      *City;           //机场城市ID    int
@property (strong, nonatomic) NSString      *AirportShortName;  //机场简称
@property (strong, nonatomic) NSString      *AirportEnName; //机场英文名
@property (strong, nonatomic) NSString      *CityName;      //机场所在城市

@end

@interface CabinDTO : BaseResponseModel

@property (strong, nonatomic) NSString      *ID;            //子舱位类型
@property (strong, nonatomic) NSString      *BaseID;        //基准仓位类型

@end

@interface RouteEntity : BaseResponseModel

@property (strong, nonatomic) NSArray               *SendTicket;        //送票城市      string
@property (strong, nonatomic) NSString              *RCofDays;          //提前RC ID
@property (strong, nonatomic) NSString              *RCofDaysCode;      //提前RC
@property (strong, nonatomic) NSString              *RCofPrice;         //提前RC ID
@property (strong, nonatomic) NSString              *RCofPriceCode;     //提前RC
@property (strong, nonatomic) NSString              *RCofRate;          //折扣RC ID
@property (strong, nonatomic) NSString              *RCofRateCode;      //折扣RC
@property (strong, nonatomic) NSNumber              *LowestPrice;       //航段最低价     float
@property (strong, nonatomic) DomesticFlightDataDTO *Flight;            //航班信息

@end
@interface SOSubmitDTO : BaseResponseModel

@property(strong, nonatomic) NSString *payType;
@property(strong, nonatomic) NSString *DeliveryType;
@property(strong, nonatomic) NSDictionary *Passengers;
@property(strong, nonatomic) NSString *Addition;
@property(strong, nonatomic) NSString *Contacts;
@property(strong, nonatomic) NSString *UID;
@property(strong, nonatomic) NSString *CorpID;
@property(strong, nonatomic) NSString *PolicyID;
@property(strong, nonatomic) NSString *PolicyUID;
@property(strong, nonatomic) NSString *ServerFrom;
@property(strong, nonatomic) NSNumber *MailCode;

@end

@interface DeliveryTypeDTO : BaseResponseModel

@property (strong, nonatomic) NSNumber       *IsNeed;        //是否需要行程单      0: 不需要配送/普通配送 1 ：定期配送
@property (strong, nonatomic) NSNumber       *Province;      //省份ID
@property (strong, nonatomic) NSNumber       *City;          //城市ID
@property (strong, nonatomic) NSNumber       *Canton;        //区域ID
@property (strong, nonatomic) NSString       *Address;       //详细地址
@property (strong, nonatomic) NSString       *ZipCode;       //邮编
@property (strong, nonatomic) NSString       *RecipientName; //收件人
@property (strong, nonatomic) NSNumber       *AddID;         //配送记录ID
@property (strong, nonatomic) NSString       *Tel;           //联系电话

@end

@interface OnlinePassengersDTO : BaseResponseModel

@property (strong, nonatomic) NSNumber      *PassengerID;        //乘机人ID    int
@property (strong, nonatomic) NSString      *Name;               //乘机人姓名
@property (strong, nonatomic) NSNumber      *AgeType;            //年龄类型    int	     "1：成人 2：儿童 3：婴儿"
@property (strong, nonatomic) NSString      *BirthDate;          //出生日期    DateTime   身份证不需要填生日
@property (strong, nonatomic) NSNumber      *Gender;             //性别        int        0:女 1：男
@property (strong, nonatomic) NSNumber      *CardType;           //证型件类     int
/*
 0：身份证
 1：护照
 2：军官证
 3：回乡证
 4：港澳通行证
 5：台胞证
 9：其他
 */

@property (strong, nonatomic) NSString      *CardNumber;           //证件号码
@property (strong, nonatomic) NSNumber      *InsuranceType;        //保险类型
@property (strong, nonatomic) NSNumber      *InsuranceNum;         //保险数量
@property (strong, nonatomic) NSString      *InsuranceUnitPrice;   //保险单价
@property (strong, nonatomic) NSString      *NationalityName;      //国籍名称
@property (strong, nonatomic) NSString      *NationalityCode;      //国籍CODE
@property (strong, nonatomic) NSString      *CorpUID;              //会员ID
@property (strong, nonatomic) NSArray       *CostCenters;          //成本中心   List<CostCenterItem>

+ (NSArray*)getOnlinePassengersWithData:(NSArray*)data;

@end

@interface CostCenteritem : BaseResponseModel

@property(strong, nonatomic) NSString *CcID;
@property(strong, nonatomic) NSString *CcValue;
@property(strong, nonatomic) NSNumber *CcIndex;

@end

@interface OnlineContactDTO : BaseResponseModel

@property(strong, nonatomic) NSString *ContactID;
@property(strong, nonatomic) NSString *UserName;
@property(strong, nonatomic) NSString *Mobilephone;
@property(strong, nonatomic) NSString *Fax;
@property(strong, nonatomic) NSString *Email;
@property(strong, nonatomic) NSNumber *ConfirmType;

+ (OnlineContactDTO*)getOnlineContactWithData:(id)data;

@end
