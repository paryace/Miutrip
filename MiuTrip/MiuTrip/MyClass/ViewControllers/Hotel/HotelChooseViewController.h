//
//  HotelChooseViewController.h
//  MiuTrip
//
//  Created by pingguo on 14-1-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "HomeChooseDetailCell.h"
#import "HotelPassengerViewController.h"
#import "HotelSelectViewController.h"
#import "HotelAddViewController.h"
#import "HotelCompileViewController.h"
#define HotelChooseViewCellHeight       50


@interface HotelChooseViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate,HotelPassengerDelegate,HotelSelectDelegate,HotelAddDelegate>

@property (strong ,nonatomic) NSMutableArray *data;
@property (strong ,nonatomic) UITableView *theTableView;
@property (strong, nonatomic) UIView *contentview;
@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) HotelPassengerViewController *passenger;
@property (strong, nonatomic) HotelSelectViewController *hotelSelect;
@property (strong, nonatomic) UIButton *placeHolder;
@property BOOL show;
@end


