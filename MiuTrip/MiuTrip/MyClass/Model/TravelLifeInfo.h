//
//  TravelLifeInfo.h
//  MiuTrip
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravelLifeInfo : NSObject

@property (strong, nonatomic) NSString      *UID;                       //用户ID
@property (strong, nonatomic) NSString      *Fli_FlightKM;              //里程数
@property (assign, nonatomic) NSInteger     Fli_FliCount;               //搭机次数
@property (assign, nonatomic) NSInteger     Hot_HotTotalCount;          //共计住过几家酒店
@property (assign, nonatomic) NSInteger     Hot_HotMostCount;           //住过最多的酒店次数
@property (assign, nonatomic) NSInteger     Hot_HotDayCount;            //共计多少晚
@property (strong, nonatomic) NSString      *Hot_HotName;               //酒店名称
@property (assign, nonatomic) CGFloat       Fli_FliTotalPrice;          //机票支出多少元
@property (assign, nonatomic) CGFloat       Fli_FliPrice;               //平均每张多少
@property (strong, nonatomic) NSString      *Fli_FliMostStutes;         //居多的舱位
@property (assign, nonatomic) CGFloat       Hot_HotTotalPrice;          //酒店支出多少钱
@property (assign, nonatomic) CGFloat       Hot_HotPrice;               //平均多少钱一晚
@property (strong, nonatomic) NSString      *Hot_HotStars;              //几星级居多
@property (assign, nonatomic) NSInteger     Hot_RC_Count;               //统计RC违规次数
@property (assign, nonatomic) NSInteger     Fli_province;               //去过多少个省
@property (assign, nonatomic) NSInteger     Fli_City;                   //去过多少个城市
@property (strong, nonatomic) NSString      *Fli_HotCityName;           //去过频率最高的城市
@property (assign, nonatomic) NSInteger     Fli_HotCityCount;           //去过频率最高城市的次数
@property (strong, nonatomic) NSString      *TimeSpan;                  //如：一年半内，几个月内 ，几天内

- (id)initWithData:(NSDictionary*)data;

@end
