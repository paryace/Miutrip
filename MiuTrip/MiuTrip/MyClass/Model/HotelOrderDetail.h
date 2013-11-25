//
//  HotelOrderDetail.h
//  MiuTrip
//
//  Created by SuperAdmin on 11/14/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelOrderDetail : NSObject

@property (assign, nonatomic) NSInteger                 *goal;                  //1:因公 2:因私
@property (assign, nonatomic) NSInteger                 *queryType;             //1:为自己 2:为他人/多人
@property (assign, nonatomic) NSInteger                 *payType;               //1:现付 2:预付

@property (strong, nonatomic) NSString                  *goalCity;              //目标城市
@property (strong, nonatomic) NSString                  *checkInDate;           //入住时间
@property (strong, nonatomic) NSString                  *leaveDate;             //离店时间
//1:不限  2:0~150  3:151~300  4:301~450  5:451~600  6:600以上
@property (assign, nonatomic) NSInteger                 priceRange;             //价格区间

@property (strong, nonatomic) NSString                  *hotelLocation;         //酒店位置
@property (strong, nonatomic) NSString                  *hotelName;             //酒店名字

@property (strong, nonatomic) NSArray                   *passengers;            //联系人


@property (strong, nonatomic) NSString                  *orderNum;              //订单号
@property (assign, nonatomic) NSInteger                 orderStatus;            //订单状态
@property (assign, nonatomic) NSInteger                 returnOrderPayType;     //订单列表支付类型
@property (assign, nonatomic) NSInteger                 orderType;              //房间数&入住时间&价格

@property (strong, nonatomic) NSString                  *name;
@property (strong, nonatomic) NSString                  *phoneNum;

@property (assign, nonatomic) BOOL                      unfold;

+ (NSArray*)getCommonDataWithNum:(NSInteger)num;

@end
