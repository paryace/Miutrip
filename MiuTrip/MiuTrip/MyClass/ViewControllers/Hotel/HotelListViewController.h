//
//  HotelListViewController.h
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "SearchHotelsRequest.h"
#import "LoadMoreTableFooterView.h"
#import "RequestManager.h"

@interface HotelListViewController : UITableViewController<LoadMoreTableFooterDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,copy) SearchHotelsRequest *request;

//页数索引
@property int pageIndex;
//总页数
@property int totalPage;
//酒店列表数据
@property (nonatomic,copy) NSMutableArray *hotelListData;

//等待画面
@property (nonatomic,copy) UIActivityIndicatorView *progressView;

//是否有CELL展开
@property BOOL isOpen;

//当前展开的CELL
@property NSIndexPath *selectIndex;
@property (nonatomic,strong) RequestManager *requestManager;

@property (nonatomic,strong) LoadMoreTableFooterView *loadMoreFooterView;

@property BOOL reloading;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end

@interface HotelListRoomCell : UITableViewCell

@property (nonatomic,copy) UILabel *roomName;
@property (nonatomic,copy) UILabel *bedAndBreakfast;
@property (nonatomic,copy) UILabel *wifi;
@property (nonatomic,copy) UILabel *price;

@end