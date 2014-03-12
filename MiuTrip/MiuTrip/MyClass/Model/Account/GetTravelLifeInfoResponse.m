//
//  GetTravelLifeInfoResponse.m
//  MiuTrip
//
//  Created by Y on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetTravelLifeInfoResponse.h"
#import "Utils.h"

@implementation GetTravelLifeInfoResponse

- (NSString*)flightLevelDetail
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"您%@飞行了%@公里,搭乘%@次飞机;",_TimeSpan,_Fli_FlightKM,_Fli_FliCount];
    
    return description;
}

- (NSString*)arrivePlaceDetail
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"您%@去过%@个省份,%@个城市;",_TimeSpan,_Fli_province,_Fli_City];
    if (![Utils textIsEmpty:_Fli_HotCityName]) {
        [description appendFormat:@"\n其中%@去过%@次,是您商务出行高发地哦",_Fli_HotCityName,_Fli_HotCityCount];
    }
    return description;
}

- (NSString*)checkedInHotelDetail
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"您%@住过%@家酒店;",_TimeSpan,_Hot_HotTotalCount];
    if (![Utils textIsEmpty:_Hot_HotName]) {
        [description appendFormat:@"\n其中%@住过%@次共%@晚,情有独钟!",_Hot_HotName,_Hot_HotTotalCount,_Hot_HotDayCount];
    }
    
    return description;
}
- (NSString*)expenseDetail
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"您%@:\n机票支出%@元,平均%@/张",_TimeSpan,_Fli_FliTotalPrice,_Fli_FliPrice];
    if (![Utils textIsEmpty:_Fli_FliMostStutes]) {
        [description appendFormat:@",%@居多;",_Fli_FliMostStutes];
    }else{
        [description appendFormat:@";"];
    }
    [description appendFormat:@"\n酒店支出%@元,平均%@元/间夜",_Hot_HotTotalPrice,_Hot_HotPrice];
    if (![Utils textIsEmpty:_Hot_HotStars]) {
        [description appendFormat:@",%@星级为主;",_Hot_HotStars];
    }else{
        [description appendFormat:@";"];
    }
    
    return description;
}

- (NSString*)tripCareerDetail
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"您%@:\n机票预订完全合规,好同志!",_TimeSpan];
    if ([_Hot_RC_Count integerValue] == 0) {
        [description appendFormat:@"\n酒店预订完全合规,好同志!"];
    }else{
        [description appendFormat:@"\n酒店预订有%@次RC,小心老板有意见哦!",_Hot_RC_Count];
    }
    
    return description;
}

@end


//@property (nonatomic,strong) NSString *UID;
//@property (nonatomic,strong) NSString *Fli_FlightKM;
//
//@property (nonatomic,strong) NSNumber *Fli_FliCount;
//@property (nonatomic,strong) NSNumber *Hot_HotTotalCount;
//@property (nonatomic,strong) NSNumber *Hot_HotMostCount;
//@property (nonatomic,strong) NSNumber *Hot_HotDayCount;
//
//@property (nonatomic,strong) NSString *Hot_HotName;
//
//@property (nonatomic,strong) NSNumber *Fli_FliTotalPrice;
//@property (nonatomic,strong) NSNumber *Fli_FliPrice;
//
//@property (nonatomic,strong) NSString *Fli_FliMostStutes;
//
//@property (nonatomic,strong) NSNumber *Hot_HotTotalPrice;
//@property (nonatomic,strong) NSNumber *Hot_HotPrice;
//
//@property (nonatomic,strong) NSString *Hot_HotStars;
//
//@property (nonatomic,strong) NSNumber *Hot_RC_Count;
//@property (nonatomic,strong) NSNumber *Fli_province;
//@property (nonatomic,strong) NSNumber *Fli_City;
//
//@property (nonatomic,strong) NSString *Fli_HotCityName;
//
//@property (nonatomic,strong) NSNumber *Fli_HotCityCount;
//
//@property (nonatomic,strong) NSString *TimeSpan;
