//
//  HotelSelectedDetailCell.h
//  MiuTrip
//
//  Created by pingguo on 14-1-15.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelSelectedDetailCell : UITableViewCell

@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *UID;
@property (strong, nonatomic) UILabel *deptName;

@property (assign, nonatomic) BOOL    leftImageHighlighted;

@end
