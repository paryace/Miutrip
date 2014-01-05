//
//  HotelListRoomCell.h
//  MiuTrip
//
//  Created by stevencheng on 14-1-4.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelListRoomCell : UITableViewCell

@property (nonatomic,strong) UILabel *roomName;
@property (nonatomic,strong) UILabel *bedAndBreakfast;
@property (nonatomic,strong) UILabel *wifi;
@property (nonatomic,strong) UILabel *price;
@property (nonatomic,strong) UIViewController *viewController;

@property (nonatomic,assign) NSDictionary  *roomData;
@property (nonatomic,assign) NSString      *hotelName;
@property (nonatomic)       int            hotelId;

@end
