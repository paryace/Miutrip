//
//  HotelAndAirOrderViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@class HotelOrderDetail;
@class AirOrderDetail;

typedef NS_OPTIONS(NSInteger, OrderType){
    OrderTypeAir,
    OrderTypeHotel
};

@interface HotelAndAirOrderViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) HotelOrderDetail          *hotelOrder;
@property (strong, nonatomic) AirOrderDetail            *airOrder;

@property (strong, nonatomic) NSMutableArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;

@property (assign, nonatomic) OrderType                 orderType;

- (id)initWithOrderType:(OrderType)type;

@end
