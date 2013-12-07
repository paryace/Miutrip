//
//  SearchHotelsResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface SearchHotelsResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *hotelId;           //酒店ID
@property(strong,nonatomic) NSString *hotelName;         //酒店名字
@property(strong,nonatomic) NSString *lowestPrice;       //最低价
@property(strong,nonatomic) NSString *img;               //图片
@property(strong,nonatomic) NSString *address;           //地址
@property(strong,nonatomic) NSNumber *commentGood;       //好评数
@property(strong,nonatomic) NSNumber *commentTotal;      //总坪数
@property(strong,nonatomic) NSString *longitude;         //经度
@property(strong,nonatomic) NSString *latitude;          //维度
@property(strong,nonatomic) NSNumber *starRatedID;       //星级ID
@property(strong,nonatomic) NSString *starRatedName;     //星级名称
@property(strong,nonatomic) NSNumber *allRoomTypeCount;  //房型数
@property(strong,nonatomic) NSNumber *score;             //好评占比

@end

@interface Rooms : NSObject                               //房型列表

@property(strong,nonatomic) NSNumber *roomTypeId;        //房型ID
@property(strong,nonatomic) NSString *roomOTAType;       //房型ID来源
@property(strong,nonatomic) NSString *roomName;          //房型名字
@property(strong,nonatomic) NSNumber *bed;               //床型
@property(strong,nonatomic) NSNumber *adsl;              //宽带
@property(strong,nonatomic) NSNumber *bedWidth;          //床宽
@property(strong,nonatomic) NSNumber *area;              //面积
@property(strong,nonatomic) NSNumber *floor;             //楼层
@property(strong,nonatomic) NSNumber *owmBath;                //是否有卫浴
@property(strong,nonatomic) NSNumber *noSmoking;              //是否无烟
@property(strong,nonatomic) NSNumber *allowAddBed;            //是否允许加床
@property(strong,nonatomic) NSNumber *allowAddBedRemark;      //是否允许加床说明
@property(strong,nonatomic) NSString *adslDesc;          //宽带说明
@property(strong,nonatomic) NSString *addBedDesc;        //加床说明
@property(strong,nonatomic) NSNumber *noSmokingDesc;          //是否无烟说明
@property(strong,nonatomic) NSNumber *ownBAthDesc;            //是否有卫浴说明

@end


@interface PricePolicies : Rooms                     //价格政策

@property(strong,nonatomic) NSString *policyName;        //政策名字
@property(strong,nonatomic) NSString *avgPrice;          //该政策均价
@property(strong,nonatomic) NSString *baseprice;         //底价
@property(strong,nonatomic) NSString *OTAType;           //OTA类型
@property(strong,nonatomic) NSNumber *OTAPolicyID;       //OTA价格政策ID
@property(strong,nonatomic) NSNumber *advDays;           //提前预订天数
@property(strong,nonatomic) NSNumber *continuousDays;    //连住天数
@property(strong,nonatomic) NSNumber *continuousFreeDays;//连住赠送天数
@property(strong,nonatomic) NSString *continuousType;    //连住类型
@property(strong,nonatomic) NSString *bookingFlag;       //
@property(strong,nonatomic) NSString *guaranteeType;     //担保类型
@property(strong,nonatomic) NSNumber *guaranteeFlag;          //是否需要担保

@end

@interface  PriceInfos : PricePolicies

@property(strong,nonatomic) NSString *saleDate;          //日期
@property(strong,nonatomic) NSString *salePrice;         //卖价
@property(strong,nonatomic) NSString *breakfast;         //早餐
@property(strong,nonatomic) NSString *roomState;         //房态

@end