//
//  HotelOrderDetailCell.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#define             HotelOrderCellHeight                110.0
#define             HotelOrderCellUnfoldHeight          (30 * 6 + 15 + AirOrderCellHeight - 10 + 50)
#define             HotelOrderCellWidth                 appFrame.size.width

#define             HotelItemHeight                      (25 * 3 + 10)

@interface HotelOrderDetailCell : UITableViewCell

@property (strong, nonatomic) UIImageView               *rightArrow;

- (void)unfoldViewShow:(BOOL)show;
@end
