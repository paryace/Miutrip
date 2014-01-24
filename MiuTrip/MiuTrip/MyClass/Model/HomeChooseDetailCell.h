//
//  HomeChooseDetailCell.h
//  MiuTrip
//
//  Created by pingguo on 14-1-15.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HotelChooseViewCellHeight       50

@interface HomeChooseDetailCell : UITableViewCell

@property (strong ,nonatomic) UILabel *userName;
@property (strong ,nonatomic) UILabel *cost;
@property (strong ,nonatomic) UILabel *policy;
@property (strong, nonatomic) UIView *viewItem;
@property (strong, nonatomic)UIButton *imageview;
@property (strong, nonatomic)UIImageView *arrow;

- (void)showItem:(NSDictionary *)dic;
@end
