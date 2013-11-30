//
//  RequestManager.h
//  MiuTrip
//
//  Created by apple on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "LoginInfoDTO.h"
#import "TravelLifeInfo.h"
#import "BookPassengersDTO.h"
#import "CorpServerCardDTO.h"
#import "CorpUserBaseInfoDTO.h"
#import "CorpPolicyDTO.h"
#import "CorpCostCenterDTO.h"
#import "MemberDeliverDTO.h"
#import "OnLineAllClass.h"

#pragma mark - 用户接口URL

#define     LogIn                       @"/account_1_0/login/api"                       //登录
#define     Logout                      @"/account_1_0/logout/api"                      //注销
#define     GetUserLoginInfo            @"/account_1_0/GetUserLoginInfo/api"            //获取登录信息
#define     GetTravelLifeInfo           @"/account_1_0/GetTravelLifeInfo/api"           //获取商旅生涯数据
#define     ChangePassword              @"/account_1_0/ChangePassword/api"              //修改密码
#define     GetContact                  @"/account_1_0/GetContact/api"                  //获取常用联系人
#define     DeleteMemberPassenger       @"/account_1_0/DeleteMemberPassenger/api"       //删除常用乘客
#define     GetCorpServerCardList       @"/account_1_0/GetCorpServerCardList/api"       //获取招待卡列表
#define     SearchPassengers            @"/account_1_0/SearchPassengers/api"            //搜索联系人
#define     GetCorpStaff                @"/account_1_0/GetCorpStaff/api"                //获取员工列表
#define     GetCorpUserBaseInfo         @"/account_1_0/GetCorpUserBaseInfo/api"         //获取公司基本信息
#define     GetCorpPolicy               @"/account_1_0/GetCorpPolicy/api"               //获取公司政策
#define     GetCorpCost                 @"/account_1_0/GetCorpCost/api"                 //获取企业消费中列表
#define     GetCorpInfo                 @"/account_1_0/GetCorpInfo/api"                 //获取公司信息
#define     GetMemberDeliverList        @"/account_1_0/GetMemberDeliverList/api"        //查询配送列表
#define     DeleteMemberDeliver         @"/account_1_0/DeleteMemberDeliver/api"         //删除配送信息
#define     DeleteDeliver               @"/account_1_0/DeleteDeliver/api"               //根据UID删除配送信息
#define     SavePassengerList           @"/account_1_0/SavePassengerList/api"           //保存常用乘机人/常用联系人

#pragma mark - 机票预订URL

#define     CancelOrder                 @"/flight/CancelOrder/api"                      //取消订单
#define     GetCraftType                @"/flight/GetCraftType/api"                     //获取机型信息
#define     GetAPIInsuranceConfig       @"/flight/GetAPIInsuranceConfig/api"            //获取保险配置信息
#define     GetAPIMailConfig            @"/flight/GetAPIMailConfig/api"                 //获取邮寄信息
#define     GetAPIStopInfo              @"/flight/GetAPIStopInfo/api"                   //获取保险配置信息
#define     GetAPIChangeRule            @"/flight/GetAPIChangeRule/api"                 //获取退改签信息
#define     GetAirport                  @"/flight/GetAirport/api"                       //获取机场信息
#define     GetCabin                    @"/flight/GetCabin/api"                         //获取仓位信息
#define     GetAllAirLine               @"/flight/GetAllAirLine/api"                    //获取所有航空公司
#define     GetAirportByCity            @"/flight/GetAirportByCity/api"                 //获取城市机场列表
#define     GetAirLine                  @"/flight/GetAirLine/api"                       //获取航班公司信息
#define     GetAllAirport               @"/flight/GetAllAirport/api"                    //获取机场信息
#define     GetOrder                    @"/flight/GetOrder/api"                         //获取订单信息
#define     GetNormalFlights            @"/flight/GetNormalFlights/api"                 //获取航班信息
#define     SaveOnlineOrder             @"/flight/SaveOnlineOrder/api"                  //保存Online 订单

@protocol RequestDelegate <NSObject>

@optional
#pragma mark - 用户接口
- (void)requestDone:(ASIHTTPRequest*)request;
- (void)requestError:(ASIHTTPRequest*)request;
- (void)logInDone;
- (void)logOutDone;
- (void)getUserLoginInfoDone:(LoginInfoDTO*)loginInfo;
- (void)getTravelLifeInfoDone:(TravelLifeInfo*)traveLifeInfo;
- (void)changePasswordDone;
- (void)getContactDone:(NSArray*)contacts;
- (void)deleteMemberPassengerDone;
- (void)getCorpServerCardListDone:(NSArray*)serverCardList;
- (void)searchPassengersDone:(NSArray*)passengersList;
- (void)getCorpStaffDone:(NSArray*)staffList;
- (void)getCorpUserBaseInfoDone:(CorpUserBaseInfoDTO*)corpUserBaseInfo;
- (void)getCorpPolicyDone:(CorpPolicyDTO*)corpPolicy;
- (void)getCorpCostDone:(CostCenterListDTO*)costCenterList;
- (void)getCorpInfoDone:(CorpInfo*)corpInfo;
- (void)getMemberDeliverListDone:(NSArray*)memberDeliverList;
- (void)deleteMemberDeliverDone;
- (void)deleteDeliverDone;
- (void)savePassengerList;

#pragma mark - 机票预订接口
- (void)cancelOrderDone;
- (void)GetCraftTypeDone:(CraftTypeDTO*)craftType;
- (void)GetAPIInsuranceConfigDone:(NSArray*)flightInsuranceConfigList;      //List<TC_APIFlightInsuranceConfig>
- (void)GetAPIMailConfigDone:(NSArray*)imInfoList;      //List<TC_APImInfo>
- (void)GetAPIStopInfoDone:(StopItem*)stopItem;
- (void)GetAPIChangeRuleDone:(Rule*)rule;
- (void)GetAirportDone:(AirportDTO*)airportInfo;
- (void)GetCabinDone:(CabinDTO*)cabin;
- (void)GetAllAirLineDone:(NSArray*)allAirline;         //List<AirlineDTO>
- (void)GetAirportByCityDone:(NSArray*)airPortList;     //List<AirportDTO>
- (void)GetAirLineDone:(AirlineDTO*)airlineInfo;
- (void)GetAllAirportDone:(NSArray*)allAirport;         //List<AirportDTO>
//- (void)GetOrderDone:(

@end


@interface RequestManager : NSObject

@property (strong, nonatomic) id <RequestDelegate>  delegate;

#pragma mark - 用户接口
//登录
- (void)logIn:(NSDictionary*)params;
//参数包含username、password

//注销
- (void)logOut;

//获取登录用户信息
- (void)getUserLoginInfo;
//参数包含uid:用户名

//获取商旅生涯数据
- (void)getTravelLifeInfo;

//修改密码
- (void)changePassword:(NSDictionary*)params;
//参数包含oldPassword、password

//获取常用联系人
- (void)getContact:(NSDictionary*)params;
//参数包含CorpID:公司ID

//删除常用旅客
- (void)deleteMemberPassenger:(NSDictionary*)params;
//参数包含passengerID:旅客ID              Int

//获取招待卡列表
- (void)getCorpServerCardList:(NSDictionary*)params;
//参数包含CorpID:公司ID

//接口名称:预订页/政策执行人页更多搜索
- (void)searchPassengers:(NSDictionary*)params;
//参数包含CorpID:公司ID、keys:搜索关键字

//获取员工列表
- (void)getCorpStaff:(NSDictionary*)params;
//参数包含CorpID:企业ID                   Int

//获取公司基本信息
- (void)getCorpUserBaseInfo:(NSDictionary*)params;
//参数包含username:用户ID

//获取公司政策
- (void)getCorpPolicy:(NSDictionary*)params;
//参数包含policyid:差旅规则ID              Int

//获取企业消费中列表
- (void)getCorpCost:(NSDictionary*)params;
//参数包含corpid:企业ID                   Int

//获取公司信息
- (void)getCorpInfo:(NSDictionary*)params;
//参数包含CorpID:公司ID

//查询配送列表
- (void)getMemberDeliverList:(NSDictionary*)params;
/**
 参数包含:
    uid:用户名
    name:配送名称、
    pagingOptions:翻页对象                                   PagingOptions
    FetchRecordCount:是否统计总条数(父元素名称pagingOptions)    BOOL
    PageNumber:页数(父元素名称pagingOptions)                  Int
    PageSize:单页条数(父元素名称pagingOptions)                 Int
 */

//删除配送信息
- (void)deleteMemberDeliver:(NSDictionary*)params;
//参数包含AddID:配送ID        Int

//根据UID删除配送信息
- (void)deleteDeliver:(NSDictionary*)params;
//参数包含AddID:配送ID        Int

//保存常用乘机人/常用联系人
- (void)savePassengerList:(NSDictionary*)params;
/**
 参数包含:
    Passengers:出行人列表--
    PassengerID:旅客ID     Int
    CorpUID:公司用户ID
    IsEmoloyee:是否雇员     BOOL
    IsServer:是否服务       BOOL
    UserName:职员姓名
    LastName:英文姓名
    FirstName:英文姓名
    MiddleName:英文姓名
    Email:邮箱
    Country:国籍
    Birthday:职员生日
 
    IDCardList:身份卡列表--
    UID:用户ID
    CardType:证件类型       Int
    CardNumber:证件号码
    IsDefault:是否默认      T/F
    Telephone:电话号码
    Fax:传真
    ContactConfirmType:联系确认方式
    Mobilephone:手机号
 
    Type:联系人类型          0:常用乘机人 1:常用联系人
 */

#pragma mark - 机票接口
//取消订单
- (void)cancelOrder:(NSDictionary*)params;
/**参数包含:
    SelfOrderID:觅优订单号
    OTAOrderID:OTA订单号
    reason:取消原因
    oTAType:渠道类型    
            "int(
                Ctrip = 1,
                Mango = 2,
                TongCheng = 3)目前只支持同城 3"
 */

//接口名称：获取机型信息
- (void)getCraftType:(NSDictionary*)params;
//参数包含:   id:机型ID

//接口名称：获取保险配置信息
- (void)getAPIInsuranceConfig:(NSDictionary*)params;
//参数包含:     oTAType:OTA 类型      int

//接口名称：获取邮寄信息
- (void)getAPIMailConfig:(NSDictionary*)params;
//参数包含:     oTAType:OTA 类型      int

//接口名称：获取保险配置信息
- (void)getAPIStopInfo:(NSDictionary*)params;
/**
 参数包含:
    oa	StopInfo_Request	起飞机场三字码
    aa	StopInfo_Request	抵达机场三字码
    fNo	StopInfo_Request	航班号
    fDate	StopInfo_Request	起飞日期
 */

//接口名称：获取退改签信息
- (void)getAPIChangeRule:(NSDictionary*)params;
/**
 参数包含:
    guid	GetFlightChangeRule_Request	 航班GUID
    fNo	GetFlightChangeRule_Request	航班号
    room	GetFlightChangeRule_Request	舱位
    pType	GetFlightChangeRule_Request	政策类型                    int   默认传0即可
    oTAType	GetFlightChangeRule_Request	为航班对象里面的OTAType 字段  int
 */

//接口名称：获取机场信息
- (void)getAirport:(NSDictionary*)params;
//参数包含:     id		机场三字码

//接口名称：获取仓位信息
- (void)getCabin:(NSDictionary*)params;
//参数包含:     id		机型ID

//接口名称：获取所有航空公司
- (void)getAllAirLine;

//接口名称：获取城市机场列表
- (void)getAirportByCity:(NSDictionary*)params;
//参数包含:     city		城市ID

//接口名称：获取航班公司信息
- (void)getAirLine:(NSDictionary*)params;
//参数包含:     id		航空公司ID

//接口名称：获取机场信息
- (void)getAllAirport;

//接口名称：获取订单信息
- (void)getOrder:(NSDictionary*)params;
//参数包含:     OrderID		订单号

//接口名称：获取航班信息
- (void)getNormalFlights:(NSDictionary*)params;
/**
 参数包含:
    DepartCity		出发城市                    FltSearchReqDTO
    ClassNo         舱位                      FltSearchReqDTO
    ArriveCity		到达城市                    FltSearchReqDTO
    DepartDate		去程日期                    FltSearchReqDTO
    ArriveDate		到达日期                    FltSearchReqDTO
    ArriveTime		到达时间（暂时没用）          FltSearchReqDTO
    AirLine         航空公司                    FltSearchReqDTO
    FlightWay		航程类型                    FltSearchReqDTO
    FlightSource		OTA类型               FltSearchReqDTO
    SendTicketCity		送票城市                FltSearchReqDTO
    PassengerType		年龄类型                FltSearchReqDTO
 */

//接口名称：保存Online 订单
- (void)saveOnlineOrder:(NSDictionary*)params;
/**参数包含:
    见接口文档:机票预定接口-SaveOnlineOrder
 */
@end
