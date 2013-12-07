//
//  HotelListViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface HotelListViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property int totalPage;
@property (nonatomic,copy) NSArray *hotelListData;


@property (nonatomic,copy) UIActivityIndicatorView *progressView;

@property BOOL isOpen;                                                  //是否有酒店展开显示房型
@property NSIndexPath *selectedIndex;                                   //展开的Index

@end
