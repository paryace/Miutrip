//
//  SearchHotelsRequest.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseRequestModel.h"
#include "URLHelper.h"
@interface SearchHotelsRequest : BaseRequestModel

@property(strong,nonatomic) NSNumber *FeeType;          //费用类型(因公(1) 因私(2))
@property(strong,nonatomic) NSString *ReserveType;      //预订类型(为本人预订(1) 为多人预订(2))
@property(strong,nonatomic) NSNumber *CityId;           //城市ID
@property(strong,nonatomic) NSString *ComeDate;         //入住时间
@property(strong,nonatomic) NSString *LeaveDate;        //离店时间
@property(strong,nonatomic) NSString *PriceLow;         //低价
@property(strong,nonatomic) NSString *PriceHigh;        //高价
@property(strong,nonatomic) NSString *HotelName;        //酒店名称关键字
@property(strong,nonatomic) NSNumber *page;             //第几页
@property(strong,nonatomic) NSNumber *pageSize;         //每页条数(不大于10)
@property(strong,nonatomic) NSNumber *SortBy;           //排序类型
@property(strong,nonatomic) NSString *Facility;         //设施设备过滤
@property(strong,nonatomic) NSString *StarReted;        //星级过滤
@property(strong,nonatomic) NSNumber *IsPrePay;              //是否只查预付酒店
@property(strong,nonatomic) NSString *latitude;         //纬度
@property(strong,nonatomic) NSString *longitude;        //经度
@property(strong,nonatomic) NSNumber *radius;           //半径(有纬度、经度时比传)
@property(strong,nonatomic) NSString *HotelPostion;     //区名
@property(strong,nonatomic) NSNumber *HotelPostionId;   //区号


@end
