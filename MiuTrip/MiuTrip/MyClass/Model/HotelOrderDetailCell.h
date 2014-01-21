//
//  HotelOrderDetailCell.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotelOrderDetail.h"
#import "CommonlyName.h"
#import "CustomBtn.h"

#define             HotelOrderCellHeight                110.0
#define             HotelOrderCellUnfoldHeight          (30 * 6 + 15 + AirOrderCellHeight - 10 + 50)
#define             HotelOrderCellWidth                 appFrame.size.width

#define             HotelItemHeight                      (25 * 3 + 10)

@interface HotelOrderDetailCell : UITableViewCell


@property (strong, nonatomic) UILabel               *mainDateLabel;                 //月/日
@property (strong, nonatomic) UILabel               *subDateLabel;                  //年份&week
@property (strong, nonatomic) UILabel               *timeLabel;                     //时间

@property (strong, nonatomic) UILabel               *hotelName;                     //酒店名称&房间类型
@property (strong, nonatomic) UILabel               *location;                      //酒店位置

@property (strong, nonatomic) UILabel               *orderNumLabel;                 //订单号
@property (strong, nonatomic) UILabel               *orderStatusLabel;              //订单状态
@property (strong, nonatomic) UILabel               *payType;                       //支付类型

@property (strong, nonatomic) UILabel               *orderType;                     //房间数&入住时间&价格

@property (strong, nonatomic) UIView                *unfoldView;                    //展开页面
@property (strong, nonatomic) UILabel               *nameLabel;                     //联系人姓名
@property (strong, nonatomic) UILabel               *phoneLabel;                    //联系人电话

@property (strong, nonatomic) NSMutableArray        *itemArray;                     //item集合

@property (strong, nonatomic) CustomBtn             *cancleBtn;
@property (strong, nonatomic) CustomBtn             *doneBtn;


@property (strong, nonatomic) UIButton               *rightArrow;

//@property (strong, nonatomic) UIImageView               *rightArrow;
@property (strong, nonatomic) HotelOrderDetail          *hotelDetail;

- (void)setViewContentWithParams:(NSDictionary*)params;

- (void)unfoldViewShow:(NSDictionary*)detail;
@end
