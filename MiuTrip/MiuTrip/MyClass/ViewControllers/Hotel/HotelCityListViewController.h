//
//  HotelCityListViewController.h
//  MiuTrip
//
//  Created by chengxd on 14-2-15.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "AIMTableViewIndexBar.h"

@interface HotelCityListViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,AIMTableViewIndexBarDelegate>

@property (nonatomic,strong) NSMutableDictionary *citysData;
@property (nonatomic,strong) NSArray *sections;

@property (nonatomic,strong) AIMTableViewIndexBar *indexBar;
@property (nonatomic,strong) UITableView *tableView;

@end
