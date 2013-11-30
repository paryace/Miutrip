//
//  OnLineAllClass.h
//  MiuTrip
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchFlightDTO : NSObject

@property (strong, nonatomic) NSString          *DepartCity1;

@end


@interface CraftTypeDTO : NSObject

@property (strong, nonatomic) NSString      *ID;            //机型ID
@property (strong, nonatomic) NSString      *Name;          //机型名称
@property (strong, nonatomic) NSString      *Scale;         //机型        0:暂无 1：小机型 2： 中机型 3：大型机
@property (strong, nonatomic) NSString      *Seats;         //座位数       <=0 暂无

@end

@interface AirlineDTO : NSObject

@property (strong, nonatomic) NSString      *AirLine;       //航空公司ID
@property (strong, nonatomic) NSString      *AirLineName;   //航空公司名称
@property (strong, nonatomic) NSString      *AirLineCode;   //航空公司首字母
@property (strong, nonatomic) NSString      *ShortName;     //航空公司短名
@property (strong, nonatomic) NSString      *AirportEnName; //机场英文名
@property (strong, nonatomic) NSString      *CityName;      //机场所在城市

@end


@interface TC_APIFlightInsuranceConfig : NSObject

@property (strong, nonatomic) NSString      *iCode;         //配置代码
@property (assign, nonatomic) NSInteger     iName;          //配置名称
@property (strong, nonatomic) NSString      *sPrice;        //建议价格
@property (strong, nonatomic) NSString      *rPrice;        //是否实时结算
@property (strong, nonatomic) NSString      *rTime;         //机场所在城市
@property (strong, nonatomic) NSString      *cTotal;        //保额


@end


@interface TC_APImInfo : NSObject

@property (strong, nonatomic) NSString      *mCode;         //配置代码
@property (assign, nonatomic) NSInteger     mName;          //配置名称
@property (strong, nonatomic) NSString      *sPrice;        //建议价格
@property (strong, nonatomic) NSString      *rPrice;        //合作价格
@property (strong, nonatomic) NSString      *rTime;         //是否实时结算

@end

@interface StopItem : NSObject

@property (strong, nonatomic) NSString      *city;          //经停城市
@property (strong, nonatomic) NSString      *aTime;         //到达时间
@property (strong, nonatomic) NSString      *fTime;         //起飞时间

@end

@interface Rule : NSObject

@property (strong, nonatomic) NSString      *refund;        //退票规定
@property (strong, nonatomic) NSString      *cDate;         //改期规定
@property (strong, nonatomic) NSString      *upgrades;      //升舱规定
@property (strong, nonatomic) NSString      *transfer;      //签转规定
@property (strong, nonatomic) NSString      *rebate;        //返现

@end

@interface AirportDTO : NSObject

@property (strong, nonatomic) NSString      *Airport;       //机场三字码
@property (strong, nonatomic) NSString      *AirportName;   //机场全称
@property (assign, nonatomic) NSInteger     City;           //机场城市ID
@property (strong, nonatomic) NSString      *AirportShortName;  //机场简称
@property (strong, nonatomic) NSString      *AirportEnName; //机场英文名
@property (strong, nonatomic) NSString      *CityName;      //机场所在城市

@end

@interface CabinDTO : NSObject

@property (strong, nonatomic) NSString      *ID;            //子舱位类型
@property (strong, nonatomic) NSString      *BaseID;        //基准仓位类型

@end
