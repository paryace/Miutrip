//
//  GetHotelRoomsMultiResponse.h
//  MiuTrip
//
//  Created by pingguo on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseResponseModel.h"

@interface GetHotelRoomsMultiResponse : BaseResponseModel

@property(strong,nonatomic) NSNumber *hotelId;           //酒店ID
@property(strong,nonatomic) NSString *hotelName;         //酒店名字
@property(strong,nonatomic) NSString *lowestPrice;       //最低价
@property(strong,nonatomic) NSString *img;               //图片
@property(strong,nonatomic) NSString *address;           //地址
@property(strong,nonatomic) NSNumber *commentGood;       //好评数
@property(strong,nonatomic) NSNumber *commentTotal;      //总坪数
@property(strong,nonatomic) NSString *longitude;         //经度
@property(strong,nonatomic) NSString *latitude;          //维度
@property(strong,nonatomic) NSNumber *starRatedId;       //星级ID
@property(strong,nonatomic) NSString *starRatedName;     //星级名称
@property(strong,nonatomic) NSNumber *AllRoomTypeCount;  //房型数
@property(strong,nonatomic) NSNumber *score;             //好评占比
@property(strong, nonatomic)NSString *Rooms;
@end

@interface Rooms : BaseResponseModel                               //房型列表

@property(strong,nonatomic) NSNumber *roomTypeId;        //房型ID
@property(strong,nonatomic) NSString *RoomOTAType;       //房型ID来源
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
@property(strong,nonatomic) NSNumber *ownBathDesc;            //是否有卫浴说明
@property(strong, nonatomic) NSString *PricePolicies;

@end


@interface PricePolicies : BaseResponseModel                      //价格政策

@property(strong,nonatomic) NSString *PolicyName;        //政策名字
@property(strong,nonatomic) NSString *AvgPrice;          //该政策均价
@property(strong,nonatomic) NSString *Baseprice;         //底价
@property(strong,nonatomic) NSString *OTAType;           //OTA类型
@property(strong,nonatomic) NSNumber *OTAPolicyID;       //OTA价格政策ID
@property(strong,nonatomic) NSNumber *AdvDays;           //提前预订天数
@property(strong,nonatomic) NSNumber *ContinuousDays;    //连住天数
@property(strong,nonatomic) NSNumber *ContinuousFreeDays;//连住赠送天数
@property(strong,nonatomic) NSString *ContinuousType;    //连住类型
@property(strong,nonatomic) NSString *BookingFlag;       //
@property(strong,nonatomic) NSString *GuaranteeType;     //担保类型
@property(strong,nonatomic) NSNumber *GuaranteeFlag;          //是否需要担保
@property(strong, nonatomic) NSString *PriceInfos;

@end

@interface  PriceInfos : BaseResponseModel

@property(strong,nonatomic) NSString *SaleDate;          //日期
@property(strong,nonatomic) NSString *SalePrice;         //卖价
@property(strong,nonatomic) NSString *Breakfast;         //早餐
@property(strong,nonatomic) NSString *RoomState;         //房态


@end
