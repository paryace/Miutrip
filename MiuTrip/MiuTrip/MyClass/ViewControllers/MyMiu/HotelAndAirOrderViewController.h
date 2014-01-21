//
//  HotelAndAirOrderViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "GetFlightOrderListRequest.h"
#import "GetOrderRequest.h"

@class HotelOrderDetail;
@class AirOrderDetail;

typedef NS_OPTIONS(NSInteger, OrderType){
    OrderTypeAir,
    OrderTypeHotel
};

@interface HotelAndAirOrderViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>

@property (strong, nonatomic) GetFlightOrderListRequest     *airRequest;
@property (strong, nonatomic) GetOrderRequest     *hotelRequest;
@property (strong, nonatomic) NSArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;
@property (strong, nonatomic) UIActivityIndicatorView   *progressView;
@property (assign, nonatomic) OrderType                 orderType;

@property int totalPage;
@property int pageIndex;

- (id)initWithOrderType:(OrderType)type;

@end
