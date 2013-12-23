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
#import "HotelOrderDetail.h"
#import "HotelDetailViewController.h"
#import "HotelOrderViewController.h"

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
    
    [self addTitleWithTitle:@"上海"];
    
    [self addLoadingView];
    
    [self searchHotels];
}

-(void)addTableView{
    
    int width = self.contentView.frame.size.width;
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, width, 35)];
    [filterView setBackgroundColor:color(whiteColor)];
    
    width = width - 20;
    UIButton *miuRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
    [miuRecommend setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [miuRecommend setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [miuRecommend setHighlighted:YES];
    [miuRecommend setShowsTouchWhenHighlighted:NO];
    [miuRecommend setTitle:@"觅优推荐" forState:UIControlStateNormal];
    [miuRecommend setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [miuRecommend.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [miuRecommend setFrame:CGRectMake(5, 1, width/3, 33)];
    [miuRecommend setTag:101];
    [miuRecommend addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:miuRecommend];
    
    UIButton *price = [UIButton buttonWithType:UIButtonTypeCustom];
    [price setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [price setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [price setTitle:@"价格" forState:UIControlStateNormal];
    [price setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [price.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [price setFrame:CGRectMake(10+width/3, 1, width/3, 33)];
    [price setTag:102];
    [price addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:price];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [filterBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [filterBtn setFrame:CGRectMake(15+width/3*2, 1,width/3, 33)];
    [filterBtn setTag:103];
    [filterBtn addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    _request.ComeDate = @"2013-12-28";
    _request.LeaveDate = @"2013-12-29";
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
    _request.IsPrePay = [NSNumber numberWithBool:NO];
    
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
    
    if(self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0){
        
        if(indexPath.row == 1){
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelBtn];
            HotelListBtnCellView *cellView = nil;
            
            if(cell){
                cellView = (HotelListBtnCellView*)cell;
            }else{
                cellView = [[HotelListBtnCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelBtn];
            }
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

@implementation HotelListRoomCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    //房型名称
    _roomName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 30)];
    [_roomName setFont:[UIFont systemFontOfSize:13]];
    [_roomName setTextColor:color(blackColor)];
    [_roomName setNumberOfLines:2];
    [self addSubview:_roomName];
    
    //床型，早餐
    _bedAndBreakfast = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 50, 30)];
    [_bedAndBreakfast setFont:[UIFont systemFontOfSize:10]];
    [_bedAndBreakfast setTextColor:color(blackColor)];
    [_bedAndBreakfast setNumberOfLines:2];
    [self addSubview:_bedAndBreakfast];
    
    //WIFI
    _wifi = [[UILabel alloc] initWithFrame:CGRectMake(153, 13, 42, 14)];
    [_wifi setFont:[UIFont systemFontOfSize:10]];
    [_wifi setTextColor:color(blackColor)];
    [self addSubview:_wifi];
    
    //price
    _price = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 85, 13, 40, 14)];
    [_price setFont:[UIFont systemFontOfSize:12]];
    [_price setTextColor:PriceColor];
    [self addSubview:_price];
    
    //预定按钮
    UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookBtn setBackgroundColor:color(brownColor)];
    [bookBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [bookBtn.titleLabel setTextColor:color(blackColor)];
    [bookBtn setTitle:@"预定" forState:UIControlStateNormal];
    [bookBtn setFrame:CGRectMake(self.frame.size.width - 38, 8, 30, 24)];
    [bookBtn addTarget:self action:@selector(bookBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bookBtn];
}

-(void)bookBtnPressed:(UIButton *)sender{
    
    HotelOrderViewController *orderViewController = [[HotelOrderViewController alloc] init];
    [_viewController.navigationController pushViewController:orderViewController animated:YES];
}

@end

@implementation HotelListBtnCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    
    float topMargin = 3;
    
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel_list_shadow.png"]];
    shadow.frame = CGRectMake(0, 0, self.frame.size.width, 15);
    [self addSubview:shadow];
    
    
    //酒店详情
    UIButton *hotelDetail  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelDetail setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelDetail setTag:1001];
    [hotelDetail setTitle:@"酒店详情" forState:UIControlStateNormal];
    [hotelDetail setTitleColor:BlueColor forState:UIControlStateNormal];
     hotelDetail.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelDetail setFrame:CGRectMake(0, topMargin, self.frame.size.width/3, 27)];
    [hotelDetail addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hotelDetail];
    
    //icon
    UIImageView *detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_detail"]];
    detailImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelDetail addSubview:detailImage];
    
    //箭头
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow1.frame = CGRectMake(hotelDetail.frame.size.width - 18, 7, 8, 12);
    [hotelDetail addSubview:arrow1];
    
    
    //酒店位置
    UIButton *hotelLocal  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelLocal setTag:1002];
    [hotelLocal setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelLocal setTitle:@"酒店位置" forState:UIControlStateNormal];
    [hotelLocal setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelLocal.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelLocal setFrame:CGRectMake(self.frame.size.width/3, topMargin, self.frame.size.width/3, 27)];
    [self addSubview:hotelLocal];
    
    
    //icon
    UIImageView *localImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_local"]];
    localImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelLocal addSubview:localImage];
    
    //箭头
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow2.frame = CGRectMake(hotelLocal.frame.size.width - 18, 7, 8, 12);
    [hotelLocal addSubview:arrow2];
    
    //评论
    UIButton *hotelcomments  = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelcomments setTag:1003];
    [hotelcomments setBackgroundImage:[UIImage imageNamed:@"hotel_list_btn_bg.png"] forState:UIControlStateNormal];
    [hotelcomments setTitle:@"酒店评论" forState:UIControlStateNormal];
    [hotelcomments setTitleColor:BlueColor forState:UIControlStateNormal];
    hotelcomments.titleLabel.font = [UIFont systemFontOfSize: 13];
    [hotelcomments setFrame:CGRectMake((self.frame.size.width/3)*2, topMargin, self.frame.size.width/3, 27)];
    [hotelcomments addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hotelcomments];
    
    //icon
    UIImageView *commentImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_hotel_comment"]];
    commentImage.frame = CGRectMake(6, 4, 19, 18);
    [hotelcomments addSubview:commentImage];
    
    //箭头
    UIImageView *arrow3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow3.frame = CGRectMake(hotelcomments.frame.size.width - 18, 7, 8, 12);
    [hotelcomments addSubview:arrow3];
    
    //竖线1
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width)/3-0.6, 1, 0.6, 29)];
    [line1 setBackgroundColor:color(lightGrayColor)];
    [self addSubview:line1];
    
    //竖线2
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width)/3*2-0.6, 1, 0.6, 29)];
    [line2 setBackgroundColor:color(lightGrayColor)];
    [self addSubview:line2];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)buttonPressed:(UIButton *)sender{
    switch(sender.tag){
        case 1001:
            [self goHotelDetail];
            break;
        case 1002:
            break;
        case 1003:
            [self goHotelComments];
            break;
    }
}

-(void)goHotelDetail{
    [HotelOrderDetail sharedInstance].selectedHotelId = _hotelId;
    HotelDetailViewController *viewController = [[HotelDetailViewController alloc] init];
    [_viewController.navigationController pushViewController:viewController animated:YES];
}

-(void)goHotelComments{
    [HotelOrderDetail sharedInstance].selectedHotelId = _hotelId;
    HotelCommentViewController *viewController = [[HotelCommentViewController alloc] init];
    [_viewController.navigationController pushViewController:viewController animated:YES];
}

@end
