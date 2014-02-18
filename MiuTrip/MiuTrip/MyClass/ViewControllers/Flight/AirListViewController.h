//
//  AirListViewController.h
//  MiuTrip
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "FlightSiftViewController.h"
#import "TakeOffTimePickerViewController.h"
#import "PolicyIllegalReasonViewController.h"

#define             AirListViewCellHeight               70.0
#define             AirListViewSubjoinCellHeight        50.0

@class    DomesticFlightDataDTO;
@class    CustomBtn;
@class    GetNormalFlightsRequest;
@class    RouteEntity;

#define OrderBookForSelf        @"self"
#define OrderBookForOther       @"other"

#define FeeTypePUB              @"PUB"
#define FeeTypeOWN              @"OWN"

#define SearchTypeS             @"S"
#define SearchTypeM             @"M"
#define SearchTypeD             @"D"

@protocol AirListReturnTicketDelegate <NSObject>

- (void)returnTicketPickerFinished:(RouteEntity*)flightData;

@optional
- (void)returnTicketPickerCancel;

@end

@interface AirListViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,FlightSiftViewDelegate,UIAlertViewDelegate,TakeOffTimePickerDelegate,PolicyIllegalReasonDelegate,AirListReturnTicketDelegate>

@property (assign, nonatomic) id<AirListReturnTicketDelegate>delegate;
@property (strong, nonatomic) NSMutableArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;
@property (strong, nonatomic) NSArray                   *passengers;
@property (strong, nonatomic) id                        policyData;
@property (strong, nonatomic) GetNormalFlightsRequest   *getFlightsRequest;
@property (strong, nonatomic) GetNormalFlightsRequest   *getReturnFlightsRequest;
@property (strong, nonatomic) NSString                  *bookType;              //self   or   other
@property (strong, nonatomic) NSString                  *feeType;               //PUB    or   OWN
@property (strong, nonatomic) NSString                  *searchType;            //S单程   M多程    D往返

@property (assign, nonatomic) BOOL                      isReturnPickerController;

- (void)showViewContent;

@end

@interface AirListViewCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath               *indexPath;
@property (strong, nonatomic) UILabel                   *startTimeLb;           //起飞时间
@property (strong, nonatomic) UILabel                   *endTimeLb;             //到达时间
@property (strong, nonatomic) UILabel                   *lineNumLb;             //航班次
@property (strong, nonatomic) UILabel                   *fromAndToLb;           //起始地&目的地
@property (strong, nonatomic) UILabel                   *recommonSeatTypeLb;    //推荐坐席类别
@property (strong, nonatomic) UILabel                   *virginiaTicketLb;      //余票
@property (strong, nonatomic) UILabel                   *ticketPriceLb;         //票价
@property (strong, nonatomic) UILabel                   *discountLb;            //折扣
@property (assign, nonatomic) BOOL                      haveReturn;             //有返程票

- (void)unfoldViewShow:(DomesticFlightDataDTO*)params;
- (void)setViewContentWithParams:(DomesticFlightDataDTO *)params;

- (void)mainBtnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)mainBtnRemoveTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)subjoinBtnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
- (void)subjoinBtnRemoveTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

- (void)setConformLevel:(NSString*)level;
- (void)isShow:(BOOL)show;

@end

@interface AirListViewSubjoinCell : UIView

@property (strong, nonatomic) CustomBtn         *doneBtn;
@property (assign, nonatomic) BOOL              haveReturn;         //有返程票

- (void)setViewContentWithParams:(DomesticFlightDataDTO*)flight;

@end

@interface AirListCustomBtn : UIButton

@property (strong, nonatomic) UIImageView   *subjoinImageView;

- (void)setSubjoinImage:(UIImage*)image;
- (void)setSubjoinHighlightedImage:(UIImage*)image;

- (void)setTitle:(NSString *)title;
- (void)setFont:(UIFont *)font;

@end