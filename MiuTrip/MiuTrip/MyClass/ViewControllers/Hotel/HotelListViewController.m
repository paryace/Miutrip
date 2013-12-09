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
#import "HotelListBtnCellView.h"

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
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}


-(void)setSubviewFrame{
    
    _hotelListData = [[NSMutableArray alloc] init];
    _pageIndex = 1;
    
    UIImageView *title = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar.png"]];
    [title setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 40)];
    [self.contentView addSubview:title];
    
    _progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_progressView setHidesWhenStopped:NO];
    [_progressView setCenter:CGPointMake(self.view.frame.size.width /2.0, self.view.frame.size.height/2.0)];
    [_progressView startAnimating];
    [self.contentView addSubview:_progressView];
    
    [self searchHotels];
    
    
}

/**
 *  去掉等待页面
 */
-(void)removeProgressVie{
    [_progressView stopAnimating];
    [_progressView removeFromSuperview];
}


-(void)addHotelListViewWithData{
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    [tableview setTag:1001];
    [tableview setDataSource:self];
    [tableview setDelegate:self];
    tableview.allowsSelection = YES;
    tableview.sectionFooterHeight = 0;
    tableview.sectionHeaderHeight = 0;
    _pageIndex = 1;
    self.isOpen = NO;
    [self.contentView addSubview:tableview];
}


-(void) searchHotels{
    _request = [[SearchHotelsRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"SearchHotels"];
    
    _request.FeeType = [NSNumber numberWithInt:1];
    _request.ReserveType = @"1";
    _request.CityId = [NSNumber numberWithInt:448];
    _request.ComeDate = @"2013-12-22";
    _request.LeaveDate = @"2013-12-24";
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

-(void)requestDone:(BaseResponseModel *) response{
    if(response){
        SearchHotelsResponse *hotelListResponse = (SearchHotelsResponse*)response;
        
        NSArray *hotels = [hotelListResponse.Data objectForKey:@"Hotels"];
        [_hotelListData addObjectsFromArray:hotels];
        _totalPage = [[hotelListResponse.Data objectForKey:@"TotalPage"] integerValue];
        
        if(_pageIndex == 1){
            [self removeProgressVie];
            [self addHotelListViewWithData];
            return;
        }
        
        [self relaodData];
       
    }
}

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
    
    NSLog(@"cellForRowAtIndexPath.row=%d,section=%d",indexPath.row,indexPath.section);
    
    if(self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0){
        
        if(indexPath.row == 1){
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelBtn];
            HotelListBtnCellView *cellView = nil;
            
            if(cell){
                cellView = (HotelListBtnCellView*)cell;
            }else{
                cellView = [[HotelListBtnCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelBtn];
            }
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cellView;
        }else{
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelRoomsCell];        HotelListRoomCell *cellView = nil;
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
    UITableView *tableView = (UITableView*)[self.contentView viewWithTag:1001];
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
    
    [tableView beginUpdates];
	if (firstDoInsert)
    {   [tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[tableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"section=%d",indexPath.section);
    if(indexPath.section == _hotelListData.count - 1){
        
        [self loadMoreEvent:tableView indexPath:indexPath];
    }
    
    
}

-(void)loadMoreEvent:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    if (_pageIndex < _totalPage){
        _pageIndex ++;
        UITableViewCell *loadMoreCell = [tableView cellForRowAtIndexPath:indexPath];
        loadMoreCell.textLabel.text = @"正在加载中...";
        loadMoreCell.detailTextLabel.text = @"";
        [self loadMore];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

 // 加载更多数据，此处可以换成从远程服务器获取最新的_size条数据
-(void)loadMore
{
    _request.page = [NSNumber numberWithInt:_pageIndex];
    [self.requestManager sendRequest:_request];
}

 // 添加数据到当前TableView中去
-(void)relaodData
{
    UITableView *tableView = (UITableView*)[self.contentView viewWithTag:1001];
    
    [tableView reloadData];
//         // 添加到当前的数据源中
//        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:[data count]];
//         for(int ind =0;ind<[data count];ind++)
//            {
//                    NSIndexPath *newPath = [NSIndexPath indexPathForRow:[pagingCity indexOfObject:[data objectAtIndex:ind]] inSection:0];
//                    [insertIndexPaths addObject:newPath];
//              }
//        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//   
//     // 选到当前的行数
//       int begin = (_index-1)*_size;
//      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:begin inSection:0];
//      [self.tableView selectRowAtIndexPath:indexPath  animated:YES scrollPosition:UITableViewScrollPositionTop];
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
    [self addSubview:bookBtn];
}


@end


