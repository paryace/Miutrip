//
//  HotelSelectViewController.h
//  MiuTrip
//
//  Created by pingguo on 14-1-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol HotelSelectDelegate <NSObject>

@optional
- (void)getparamsByArray:(NSArray*)array;

@end

@interface HotelSelectViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>

@property (strong, nonatomic) id<HotelSelectDelegate> delegate;
@property (strong, nonatomic) UITableView *thetableView;
@property (strong, nonatomic) NSArray *dataSource;
@property (strong, nonatomic) NSMutableArray *btnArray;
@property (strong, nonatomic) NSMutableArray *array;

@end
