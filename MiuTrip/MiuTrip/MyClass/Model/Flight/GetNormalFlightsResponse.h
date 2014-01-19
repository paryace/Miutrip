//
//  GetNormalFlightsResponse.h
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"
#import "OnLineAllClass.h"

@class DomesticFlightDataDTO;

@interface GetNormalFlightsResponse : BaseResponseModel

@property (strong, nonatomic) NSArray           *flights;           //List<DomesticFlightDataDTO>

@end

@interface DomesticFlightDataDTO : BaseResponseModel

@property (strong, nonatomic) NSNumber          *OTAType;               //产品来源      int
@property (strong, nonatomic) NSString          *AirlineCode;           //航空公司
@property (strong, nonatomic) NSString          *APortBuilding;         //到达机场航站楼
@property (strong, nonatomic) NSString          *APortCode;             //到达机场Code
@property (strong, nonatomic) NSString          *ArriveCityCode;        //到达城市Code 目前和机场三字码一样
@property (strong, nonatomic) NSString          *ArriveDate;            //到达日期
@property (strong, nonatomic) NSString          *ArriveTime;            //到达时间
@property (strong, nonatomic) NSString          *BabyOilFee;            //婴儿燃油费
@property (strong, nonatomic) NSString          *BabyStandardPrice;     //婴儿基准价
@property (strong, nonatomic) NSString          *BabyTax;               //婴儿基建费
@property (strong, nonatomic) NSNumber          *BabyPrice;             //婴儿价格          float
@property (strong, nonatomic) NSNumber          *ChildOilFee;           //儿童燃油费         float
@property (strong, nonatomic) NSNumber          *ChildStandardPrice;    //儿童基准价格       float
@property (strong, nonatomic) NSNumber          *ChildTax;              //儿童基建费         float
@property (strong, nonatomic) NSNumber          *ChildPrice;            //儿童价格          float
@property (strong, nonatomic) NSNumber          *AdultOilFee;           //成人燃油费         float
@property (strong, nonatomic) NSNumber          *AdultTax;              //成人基建费         float
@property (strong, nonatomic) NSNumber          *AdultPrice;            //成人价格          float
@property (strong, nonatomic) NSNumber          *AdultStandardPrice;    //成人基准价         float
@property (strong, nonatomic) NSNumber          *Price;                 //售价              float
@property (strong, nonatomic) NSNumber          *StandardPrice;         //标准价格          float
@property (strong, nonatomic) NSNumber          *OilFee;                //燃油费            float
@property (strong, nonatomic) NSNumber          *Tax;                   //基建费           float
@property (strong, nonatomic) NSNumber          *Rate;                  //折扣比例          float
@property (strong, nonatomic) NSString          *Class;                 //仓位
@property (strong, nonatomic) NSString          *CraftType;             //机型
@property (strong, nonatomic) NSString          *DepartCityCode;        //出发城市Code,目前跟机场三字码相同
@property (strong, nonatomic) NSString          *DPortBuilding;         //出发机场航站楼
@property (strong, nonatomic) NSString          *DPortCode;             //出发机场三字码
@property (strong, nonatomic) NSString          *Flight;                //航班号
@property (strong, nonatomic) NSNumber          *IsLowestPrice;         //是否最低价         bool
@property (strong, nonatomic) NSString          *MealType;              //航班餐食
@property (strong, nonatomic) NSString          *ProductSource;         //产品来源
@property (strong, nonatomic) NSNumber          *Quantity;              //剩余票量          int
@property (strong, nonatomic) NSString          *Remarks;               //航班备注
@property (strong, nonatomic) NSNumber          *RouteIndex;            //航程索引          int
@property (strong, nonatomic) NSNumber          *StopTimes;             //经停次数          int
@property (strong, nonatomic) NSString          *SubClass;              //子舱
@property (strong, nonatomic) NSString          *TakeOffTime;           //起飞时间
@property (strong, nonatomic) NSString          *TakeOffDate;           //起飞日期
@property (strong, nonatomic) NSNumber          *IsShowMore;            //是否显示子舱位       bool
@property (strong, nonatomic) NSString          *FlyTime;               //飞行时间
@property (strong, nonatomic) NSString          *Guid;                  //航班查询GUID
@property (strong, nonatomic) NSString          *PassengerType;         //乘客类型


@property (strong, nonatomic) AirlineDTO        *AirLine;               //航空公司信息
@property (strong, nonatomic) AirportDTO        *Dairport;              //起飞机场信息
@property (strong, nonatomic) AirportDTO        *Aairport;              //起飞机场信息

@property (strong, nonatomic) NSMutableArray    *MoreFlights;           //子仓位列表         List<DomesticFlightDataDTO>

@property (assign, nonatomic) NSNumber          *unfold;                //cell展开          bool

@end
