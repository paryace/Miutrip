//
//  AirOrderDetailCell.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AirOrderDetail.h"
#import "CommonlyName.h"
#import "CustomBtn.h"

#define             AirOrderCellHeight              110.0
#define             AirOrderCellUnfoldHeight        (30 * 6 + 15 + AirOrderCellHeight - 10 + 50)
#define             AirOrderCellWidth               appFrame.size.width

#define             AirItemHeight                      (25 * 3 + 10)

@interface AirOrderDetailCell : UITableViewCell

@property (strong, nonatomic) UILabel               *mainDateLabel;                 //月/日
@property (strong, nonatomic) UILabel               *subDateLabel;                  //年份&week
@property (strong, nonatomic) UILabel               *timeLabel;                     //时间

@property (strong, nonatomic) UILabel               *routeLineLabel;                //始发地-目的地(省)
@property (strong, nonatomic) UILabel               *flightNumLabel;                //飞机班次

@property (strong, nonatomic) UILabel               *orderNumLabel;                 //订单号
@property (strong, nonatomic) UILabel               *orderStatusLabel;              //订单状态
@property (strong, nonatomic) UILabel               *startAndEndStation;            //起始站-终点站

@property (strong, nonatomic) UILabel               *ticketType;                    //作位类别&价格

@property (strong, nonatomic) UIView                *unfoldView;                    //展开页面
@property (strong, nonatomic) UILabel               *nameLabel;                     //联系人姓名
@property (strong, nonatomic) UILabel               *phoneLabel;                    //联系人电话

@property (strong, nonatomic) NSMutableArray        *itemArray;                     //item集合

@property (strong, nonatomic) CustomBtn             *cancleBtn;
@property (strong, nonatomic) CustomBtn             *doneBtn;


@property (strong, nonatomic) UIButton               *rightArrow;

//@property (strong, nonatomic) UIImageView               *rightArrow;
@property (strong, nonatomic) AirOrderDetail            *airDetail;

- (void)setViewContentWithParams:(NSDictionary*)params;

- (void)unfoldViewShow:(NSDictionary*)detail;


@end

