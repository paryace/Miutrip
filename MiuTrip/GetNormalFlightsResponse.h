//
//  GetNormalFlightsResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetNormalFlightsResponse : BaseResponseModel

@property(strong, nonatomic) NSDictionary *flights;

@end

@interface DomesticFlightDataDTO : BaseResponseModel

@property(strong, nonatomic) NSNumber *OTAType;
@property(strong, nonatomic) NSString *AirlineCode;
@property(strong, nonatomic) NSString *APortCode;
@property(strong, nonatomic) NSString *APortBuilding;
@property(strong, nonatomic) NSString *ArriveCityCode;
@property(strong, nonatomic) NSString *ArriveDate;
@property(strong, nonatomic) NSString *ArriveTime;
@property(strong, nonatomic) NSNumber *BabyOilFee;
@property(strong, nonatomic) NSNumber *BabyStandardPrice;
@property(strong, nonatomic) NSNumber *BabyTax;
@property(strong, nonatomic) NSNumber *ChildOilFee;
@property(strong, nonatomic) NSNumber *ChildStandardPrice;
@property(strong, nonatomic) NSNumber *ChildTax;
@property(strong, nonatomic) NSNumber *ChildPrice;
@property(strong, nonatomic) NSNumber *AdultTax;
@property(strong, nonatomic) NSNumber *AdultPrice;
@property(strong, nonatomic) NSNumber *AdultStandardPrice;
@property(strong, nonatomic) NSNumber *Price;
@property(strong, nonatomic) NSNumber *StandardPrice;
@property(strong, nonatomic) NSNumber *OilFee;
@property(strong, nonatomic) NSNumber *Tax;
@property(strong, nonatomic) NSNumber *Rate;
@property(strong, nonatomic) NSString  *Class;
@property(strong, nonatomic) NSString  *DepartCityCode;
@property(strong, nonatomic) NSString  *CraftType;
@property(strong, nonatomic) NSString  *DPortBuilding;
@property(strong, nonatomic) NSString  *DportCode;
@property(strong, nonatomic) NSNumber  *IsLowestPrice;
@property(strong, nonatomic) NSString  *Flight;
@property(strong, nonatomic) NSString  *MealType;
@property(strong, nonatomic) NSString  *ProductSource;
@property(strong, nonatomic) NSNumber  *Quantity;
@property(strong, nonatomic) NSString  *Remarks;
@property(strong, nonatomic) NSNumber  *RouteIndex;
@property(strong, nonatomic) NSNumber  *StopTimes;
@property(strong, nonatomic) NSString  *SubClass;
@property(strong, nonatomic) NSString  *TakePffTime;
@property(strong, nonatomic) NSString  *TakeOffDate;
@property(strong, nonatomic) NSString  *Airline;
@property(strong, nonatomic) NSString  *Dairport;
@property(strong, nonatomic) NSString  *Aairport;
@property(strong, nonatomic) NSString  *HashMoreBase;
@property(strong, nonatomic) NSNumber  *HasMoreFlight;
@property(strong, nonatomic) NSDictionary *MoreFlights;
@property(strong, nonatomic) NSNumber  *IsShowMore;
@property(strong, nonatomic) NSString  *FlyTime;
@property(strong, nonatomic) NSString  *Guid;
@property(strong, nonatomic) NSString  *PassengerType;
@end

@interface AirlineDTO : BaseResponseModel

@property(strong, nonatomic) NSString *AirLine;
@property(strong, nonatomic) NSString *AirLineCode;
@property(strong, nonatomic) NSString *AirLineName;
@property(strong, nonatomic) NSString *ShortName;
@property(strong, nonatomic) NSString *Airport;
@property(strong, nonatomic) NSString *AirportName;
@property(strong, nonatomic) NSNumber *City;
@property(strong, nonatomic) NSString *AirportShortName;
@property(strong, nonatomic) NSString *AirportEnName;
@property(strong, nonatomic) NSString *CityName;

@end