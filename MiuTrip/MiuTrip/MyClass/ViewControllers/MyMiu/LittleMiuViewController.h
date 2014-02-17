//
//  LittleMiuViewController.h
//  MiuTrip
//
//  Created by pingguo on 13-12-14.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "CustomBtn.h"

#define             LittleMiuCellHeight                110.0

#define             LittleMiuAirCellUnfoldHeight          (30 * 3 + LittleMiuCellHeight + 20)
#define             LittleMiuHotelCellUnfoldHeight          (30 * 6 + 15 + LittleMiuCellHeight + 5)

#define             LittleMiuCellWidth                 appFrame.size.width

//#define             LittleMiuItemHeight                      (25 * 3 + 10)
#define             LittleMiuItemHeight                      40

@class HotelOrderDetail;
@class AirOrderDetail;
@class LittleMiuDetail;

@protocol SelectOtherDelegate <NSObject>

- (void)selectOtherDone:(NSArray*)params;

@end


@interface LittleMiuViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,SelectOtherDelegate>

@property (strong, nonatomic) HotelOrderDetail          *hotelOrder;
@property (strong, nonatomic) AirOrderDetail            *airOrder;

@property (strong, nonatomic) NSMutableArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;

@property (assign, nonatomic) NSInteger  data;

@end


#define   ContactItemHeight    30;
@interface SelectOtherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>

@property (assign, nonatomic) id<SelectOtherDelegate> delegate;
@end

@interface SelectOtherCell : UITableViewCell

@property(strong, nonatomic)  UILabel  *userName;
@property(strong, nonatomic)  UILabel  *mobilePhone;

- (void)setViewContentWithParams:(NSDictionary*)params;

- (void)setRightImageHighlighted:(BOOL)highlighted;

@end


@interface LittleMiuAirCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath   *indexPath;

@property (strong, nonatomic) UILabel       *mainDateLabel;
@property (strong, nonatomic) UILabel       *subDateLabel;
@property (strong, nonatomic) UILabel       *timeLabel;
@property (strong, nonatomic) UILabel       *routeLineLabel;
@property (strong, nonatomic) UILabel       *flightNumLabel;
@property (strong, nonatomic) UIButton      *rightArrow;

@property (strong, nonatomic) CustomBtn             *cancleBtn;
@property (strong, nonatomic) CustomBtn             *doneBtn;

@property (strong, nonatomic) NSMutableArray        *itemArray;                     //item集合

@property (assign, nonatomic) LittleMiuViewController      *viewController;
- (void)setViewContentWithParams:(NSDictionary*)params;

@end

@interface LittleMiuHotelCell : UITableViewCell

@property (strong, nonatomic) NSIndexPath   *indexPath;

@property (strong, nonatomic) UILabel       *mainDateLabel;
@property (strong, nonatomic) UILabel       *subDateLabel;
@property (strong, nonatomic) UILabel       *timeLabel;
@property (strong, nonatomic) UILabel       *hotelName;                     //酒店名称&房间类型
@property (strong, nonatomic) UILabel       *location;                      //酒店位置
@property (strong, nonatomic) UIButton      *rightArrow;

@property (strong, nonatomic) UIView        *unfoldView;
@property (strong, nonatomic) NSMutableArray        *itemArray;                     //item集合

@property (strong, nonatomic) CustomBtn             *cancleBtn;
@property (strong, nonatomic) CustomBtn             *doneBtn;

@property (strong, nonatomic) CustomBtn      *hotelNearBtn;
@property (strong, nonatomic) UIButton      *currentPlaceToHotelBtn;
@property (strong, nonatomic) UIButton      *otherBtn;
@property (assign, nonatomic) LittleMiuViewController      *viewController;

@property (strong ,nonatomic) UILabel  *nameLabel;
@property (strong ,nonatomic) UILabel  *phoneLabel;
- (void)setViewContentWithParams:(NSDictionary*)params;

@end





