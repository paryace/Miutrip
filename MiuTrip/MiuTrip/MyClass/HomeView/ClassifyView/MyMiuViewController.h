//
//  MyMiuViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface MyMiuViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray            *dataSource;
@property (strong, nonatomic) UITableView               *theTableView;

@end
