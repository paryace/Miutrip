//
//  AirListViewController.h
//  MiuTrip
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "FlightSiftViewController.h"

#define             AirListViewCellHeight               70.0
#define             AirListViewSubjoinCellHeight        50.0

@class    DomesticFlightDataDTO;
@class    CustomBtn;

@protocol AirListHeadViewDelegate;

@interface AirListViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,FlightSiftViewDelegate>

@property (strong, nonatomic) NSMutableArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;

- (void)getAirListWithRequest:(BaseRequestModel*)request;

@end

@interface AirListViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath               *indexPath;
@property (strong, nonatomic) UILabel                   *startTimeLb;           //起飞时间
@property (strong, nonatomic) UILabel                   *endTileLb;             //到达时间
@property (strong, nonatomic) UILabel                   *lineNumLb;             //航班次
@property (strong, nonatomic) UILabel                   *fromAndToLb;           //起始地&目的地
@property (strong, nonatomic) UILabel                   *recommonSeatTypeLb;    //推荐坐席类别
@property (strong, nonatomic) UILabel                   *virginiaTicketLb;      //余票
@property (strong, nonatomic) UILabel                   *ticketPriceLb;         //票价
@property (strong, nonatomic) UILabel                   *discountLb;            //折扣

- (void)unfoldViewShow:(DomesticFlightDataDTO*)params;
- (void)setViewContentWithParams:(DomesticFlightDataDTO *)params;

- (void)mainBtnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)mainBtnRemoveTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)subjoinBtnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)subjoinBtnRemoveTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@interface AirListViewSubjoinCell : UIView

@property (strong, nonatomic) CustomBtn         *doneBtn;

- (void)setViewContentWithParams:(DomesticFlightDataDTO*)flight;

@end

@interface AirListCustomBtn : UIButton

@property (strong, nonatomic) UIImageView   *subjoinImageView;

- (void)setSubjoinImage:(UIImage*)image;
- (void)setSubjoinHighlightedImage:(UIImage*)image;

- (void)setTitle:(NSString *)title;
- (void)setFont:(UIFont *)font;

@end