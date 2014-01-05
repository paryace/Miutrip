//
//  HotelListViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelListViewController.h"
#import "SearchHotelsResponse.h"
#import "HotelListCellviewCell.h"
#import "HotelCommentViewController.h"
#import "HotelDetailViewController.h"
#import "HotelOrderViewController.h"
#import "HotelMapViewControler.h"
#import "Utils.h"
#import "HotelListBtnCellView.h"
#import "HotelListRoomCell.h"

@interface HotelListViewController ()

@end

@implementation HotelListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self.view setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}


-(void)setSubviewFrame{
    
    _hotelListData = [[NSMutableArray alloc] init];
    _pageIndex = 1;
    _isFiltered = NO;
    _currentSortType = SORT_BY_RECOMMEND;
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mapBtn setTitleColor:color(whiteColor) forState:UIControlStateNormal];
    [mapBtn setTitleColor:color(grayColor) forState:UIControlStateHighlighted];
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    mapBtn.showsTouchWhenHighlighted = YES;
    mapBtn.frame = CGRectMake(self.contentView.frame.size.width - 40, 10, 30, 20);
    [mapBtn addTarget:self action:@selector(mapBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTitleWithTitle:@"上海" withRightView:mapBtn];
    
    [self addLoadingView];
    
    [self searchHotels];
}

-(void)mapBtnPressed:(UIButton *) sender{
    HotelMapViewControler *viewController = [[HotelMapViewControler alloc] initWithType:0 withData:_hotelListData];
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
}

-(void)addTableView{
    
    int width = self.contentView.frame.size.width;
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, width, 35)];
    [filterView setBackgroundColor:color(whiteColor)];
    
    //推荐排序
    width = width - 20;
    UIButton *miuRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
    [miuRecommend setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [miuRecommend setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [miuRecommend setHighlighted:YES];
    [miuRecommend setShowsTouchWhenHighlighted:NO];
    [miuRecommend setTitle:@"觅优推荐" forState:UIControlStateNormal];
    [miuRecommend setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [miuRecommend.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [miuRecommend setFrame:CGRectMake(5, 1, width/3, 33)];
    [miuRecommend setTag:101];
    [miuRecommend addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:miuRecommend];
    
    
    //价格排序
    UIButton *price = [UIButton buttonWithType:UIButtonTypeCustom];
    [price setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [price setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [price setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [price setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [price setFrame:CGRectMake(10+width/3, 1, width/3, 33)];
    [price setTag:102];
    
    int btnWidth = width/3;
    int left = (btnWidth - 50)/2;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 28, 33)];
    [lable setBackgroundColor:color(clearColor)];
    [lable setText:@"价格"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:color(blackColor)];
    [price addSubview:lable];
    
    _priceArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"]];
    [_priceArrow setFrame:CGRectMake(left+30, 6, 20, 20)];
    [price addSubview:_priceArrow];
    [price addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:price];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [filterBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [filterBtn setFrame:CGRectMake(15+width/3*2, 1,width/3, 33)];
    [filterBtn setTag:103];
    [filterBtn addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    left = (btnWidth - 58)/2;
    lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 28, 33)];
    [lable setText:@"筛选"];
    [lable setBackgroundColor:color(clearColor)];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:color(blackColor)];
    [filterBtn addSubview:lable];
    
    UIImageView *filterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_filter"]];
    [filterImage setFrame:CGRectMake(left+28, 6, 30, 20)];
    [filterBtn addSubview:filterImage];
    [filterView addSubview:filterBtn];
    

    [self.contentView addSubview:filterView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, self.contentView.frame.size.width, self.contentView.frame.size.height-80)];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    [self.contentView addSubview:self.tableView];
    
    [self addPullToRefreshFooter];
}

-(void)reloading
{
    [self.tableView removeFromSuperview];
    [self addLoadingView];
}

-(void)reAddTabaleView
{
    [self removeLoadingView];
    [self.contentView addSubview:self.tableView];
}

-(void)filteBtnPressed:(UIButton*)sender
{
    switch (sender.tag) {
        case 101:
            [self sortByRecommend];
            break;
        case 102:
            [self sortByPrice];
            break;
        case 103:
            break;
        default:
            break;
    }
}

-(void)sortByRecommend
{
    if(_currentSortType == SORT_BY_RECOMMEND){
        return;
    }
    [self reloading];
    [self searchHotelsBySort:6];
}

-(void)sortByPrice
{
    if(_currentSortType == SORT_BY_RECOMMEND){
        _currentSortType = SORT_BY_PRICE_DOWN;
    }else if(_currentSortType == SORT_BY_PRICE_DOWN){
        _currentSortType = SORT_BY_PRICE_UP;
    }else{
         _currentSortType = SORT_BY_PRICE_DOWN;
    }
    [self reloading];
    if(_currentSortType == SORT_BY_PRICE_UP){
        [self searchHotelsBySort:1];
    }else{
        [self searchHotelsBySort:2];
    }
    
}


-(void)searchHotelsBySort:(int)sortType{
    
    _request.SortBy = [NSNumber numberWithInt:sortType];
    _pageIndex = 1;
    _request.page =[NSNumber numberWithInt:1];
    [self.requestManager sendRequest:_request];
}

-(void)searchHotels{
    _request = [[SearchHotelsRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"SearchHotels"];
    
    _request.FeeType = [NSNumber numberWithInt:1];
    _request.ReserveType = @"1";
    _request.CityId = [NSNumber numberWithInt:448];
    _request.ComeDate = @"2014-01-07";
    _request.LeaveDate = @"2014-01-08";
    _request.PriceLow = @"0";
    _request.PriceHigh = @"10000";
    _request.HotelName = @"";
    _request.page = [NSNumber numberWithInt:_pageIndex];
    _request.pageSize = [NSNumber numberWithInt:10];
    _request.SortBy = [NSNumber numberWithInt:6];
    _request.Facility = @"";
    _request.StarReted = @"";
    _request.latitude = @"";
    _request.longitude = @"";
    _request.radius = [NSNumber numberWithInt:0];
    _request.IsPrePay = [NSNumber numberWithBool:YES];
    
    [self.requestManager sendRequest:_request];
}

/**
 *  请求成功
 *
 *  @param response
 */
-(void)requestDone:(BaseResponseModel *) response{
    if(response){
        SearchHotelsResponse *hotelListResponse = (SearchHotelsResponse*)response;
        
        NSArray *hotels = [hotelListResponse.Data objectForKey:@"Hotels"];
        [_hotelListData addObjectsFromArray:hotels];
        _totalPage = [[hotelListResponse.Data objectForKey:@"TotalPage"] integerValue];
        
        if(_pageIndex == 1){
            [self removeLoadingView];
            if(self.tableView){
                [self reAddTabaleView];
            }else{
                [self addTableView];
            }
        }
        [self stopLoading];
        [self.tableView reloadData];
        self.hasMore = YES;
    }
}

/**
 *  请求失败
 *
 *  @param errorCode 错误代码
 *  @param errorMsg  错误消息
 */
-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"error = %@",errorMsg);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_hotelListData count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(_isOpen && self.selectIndex.section == section){
        NSDictionary *dic = [_hotelListData objectAtIndex:section];
        NSArray *rooms = [dic objectForKey:@"Rooms"];
        return rooms.count + 2;
    }
    
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_isOpen){
        if(indexPath.row == 1){
            return 30;
        }
        if(indexPath.row > 1){
            return 40;
        }
        
    }
    
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotelCell = @"hotelCell";
    static NSString *hotelBtn = @"hotelbtn";
    static NSString *hotelRoomsCell = @"hotelRoomsCell";
    
    NSDictionary *dic = [_hotelListData objectAtIndex:indexPath.section];
    
    if(self.isOpen && self.selectIndex.section == indexPath.section&&indexPath.row!=0){
        
        if(indexPath.row == 1){
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelBtn];
            HotelListBtnCellView *cellView = nil;
            
            if(cell){
                cellView = (HotelListBtnCellView*)cell;
            }else{
                cellView = [[HotelListBtnCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelBtn hasMapBtn:YES];
            }
            cellView.hotelData = dic;
            cellView.hotelId = [[dic objectForKey:@"hotelId"] integerValue];
            cellView.viewController = self;
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cellView;
        }else{
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelRoomsCell];
            HotelListRoomCell *cellView = nil;
            if(cell){
                cellView = (HotelListRoomCell*)cell;
            }else{
                cellView = [[HotelListRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelRoomsCell];
            }
            
            NSArray *rooms = [dic objectForKey:@"Rooms"];
            NSDictionary *roomDic = [rooms objectAtIndex:indexPath.row - 2];
            NSArray *pricePolicies = [roomDic objectForKey:@"PricePolicies"];
            NSDictionary *priceDic = [pricePolicies objectAtIndex:0];
            NSArray *priceInfos = [priceDic objectForKey:@"PriceInfos"];
            NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
   
            cellView.roomData = roomDic;
            cellView.hotelId = [[dic objectForKey:@"hotelId"] intValue];
            cellView.hotelName = [dic objectForKey:@"hotelName"];
            cellView.roomName.text = [roomDic objectForKey:@"roomName"];
            
            NSString *bed = [roomDic objectForKey:@"bed"];
            NSString *breakfast = [NSString stringWithFormat:@"%@早餐",[roomPriceDic objectForKey:@"Breakfast"]];
            NSString *bb = [NSString stringWithFormat:@"%@\n%@",bed,breakfast];
            
            cellView.bedAndBreakfast.text = bb;
            
            int wifiInt = [[roomDic objectForKey:@"adsl"] integerValue];
            if(wifiInt == 1){
                cellView.wifi.text = @"宽带免费";
            }else{
                cellView.wifi.text = @"";
            }
            cellView.viewController = self;
            cellView.price.text = [NSString stringWithFormat:@"￥%@",[roomPriceDic objectForKey:@"SalePrice"]];
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cellView;
        }

        
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelCell];
        HotelListCellviewCell *cellView = nil;
        if(cellView){
            cellView = (HotelListCellviewCell*)cell;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cellView.hotelImage];
        }else{
            cellView = [[HotelListCellviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelCell];
        }
        
        [cellView.address setText:[dic objectForKey:@"address"]];
        [cellView.hotelName setText:[dic objectForKey:@"hotelName"]];
        NSString *str = [dic objectForKey:@"lowestPrice"];
        NSString *price = [NSString stringWithFormat:@"￥%@起",str];
        [cellView.price setText:price];
        NSString *comment = [NSString stringWithFormat:@"%@好评率 点评%d条",[dic objectForKey:@"score"],[[dic objectForKey:@"commentTotal"]integerValue]];
        [cellView.comment setText:comment];
        cellView.hotelImage.imageURL = [NSURL URLWithString:[dic objectForKey:@"img"]];
        
        [cellView setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cellView;

    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
//    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:self.selectIndex];
//    [cell changeArrowWithUp:firstDoInsert];
    
   
    
    int section = self.selectIndex.section;
    NSDictionary *dic = [_hotelListData objectAtIndex:section];
    NSArray *rooms = [dic objectForKey:@"Rooms"];
    int contentCount = [rooms count] + 1;
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSLog(@"i=%d,section=%d",i,section);
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
    
    [self.tableView beginUpdates];
	if (firstDoInsert)
    {   [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[self.tableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

// 加载更多数据，此处可以换成从远程服务器获取最新的_size条数据
-(void)loadMore
{
    if(_pageIndex == _totalPage){
       
        self.hasMore = NO;
        [self stopLoading];
        return;
    }
    
    _pageIndex ++;
    _request.page = [NSNumber numberWithInt:_pageIndex];
    [self.requestManager sendRequest:_request];


}

- (void)refresh {
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:2.0];
}

@end
