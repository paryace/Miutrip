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

#define             AirOrderCellHeight              110.0
#define             AirOrderCellUnfoldHeight        (30 * 6 + 15 + AirOrderCellHeight - 10 + 50)
#define             AirOrderCellWidth               appFrame.size.width

#define             AirItemHeight                      (25 * 3 + 10)

@interface AirOrderDetailCell : UITableViewCell

@property (strong, nonatomic) UIImageView               *rightArrow;
@property (strong, nonatomic) AirOrderDetail            *airDetail;

- (void)setViewContentWithParams:(AirOrderDetail*)params;

- (void)unfoldViewShow:(BOOL)show;

@end

