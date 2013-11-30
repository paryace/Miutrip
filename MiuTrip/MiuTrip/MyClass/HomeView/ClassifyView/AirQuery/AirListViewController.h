//
//  AirListViewController.h
//  MiuTrip
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

#define             AirListViewCellHeight               70.0
#define             AirListViewSubjoinCellHeight        50.0

@protocol AirListHeadViewDelegate;

@interface AirListViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;

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

@end

@interface AirListViewSubjoinCell : UIView

@end