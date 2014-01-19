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
#import "HotelDataCache.h"
#import "PullRefreshTableViewController.h"

typedef NS_ENUM(NSInteger, ListSortType)
{
    SORT_BY_RECOMMEND = 0,
    SORT_BY_PRICE_UP = 1,
    SORT_BY_PRICE_DOWN = 2
};


@interface HotelListViewController : PullRefreshTableViewController

@property (nonatomic,copy) SearchHotelsRequest *request;

@property (nonatomic) BOOL  hasPriceRc;

//页数索引
@property (nonatomic)  int pageIndex;
//总页数
@property (nonatomic)  int totalPage;
//酒店列表数据
@property (nonatomic,copy) NSMutableArray *hotelListData;

//是否有CELL展开
@property BOOL isOpen;

//当前展开的CELL
@property NSIndexPath *selectIndex;

@property (nonatomic) BOOL isFiltered;
@property (nonatomic) ListSortType currentSortType;
@property (nonatomic,strong) UIImageView *priceArrow;

@end



