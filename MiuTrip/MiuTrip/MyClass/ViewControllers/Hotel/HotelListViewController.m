//
//  HotelListViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelListViewController.h"
#import "SearchHotelsRequest.h"
#import "SearchHotelsResponse.h"
#import "HotelListCellviewCell.h"

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
    
    [tableview setDataSource:self];
    [tableview setDelegate:self];
    tableview.allowsSelection = NO;
    [self.contentView addSubview:tableview];
}


-(void) searchHotels{
    SearchHotelsRequest *request = [[SearchHotelsRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"SearchHotels"];
    
    request.FeeType = [NSNumber numberWithInt:1];
    request.ReserveType = @"1";
    request.CityId = [NSNumber numberWithInt:448];
    request.ComeDate = @"2013-12-08";
    request.LeaveDate = @"2013-12-10";
    request.PriceLow = @"0";
    request.PriceHigh = @"10000";
    request.HotelName = @"";
    request.page = [NSNumber numberWithInt:1];
    request.pageSize = [NSNumber numberWithInt:20];
    request.SortBy = [NSNumber numberWithInt:6];
    request.Facility = @"";
    request.StarReted = @"";
    request.latitude = @"";
    request.longitude = @"";
    request.radius = [NSNumber numberWithInt:0];
    request.IsPrePay = [NSNumber numberWithBool:NO];
    
    [self.requestManager sendRequest:request];
}

-(void)requestDone:(BaseResponseModel *) response{
    if(response){
        SearchHotelsResponse *hotelListResponse = (SearchHotelsResponse*)response;
        _hotelListData = [hotelListResponse.Data objectForKey:@"Hotels"];
        _totalPage = [[hotelListResponse.Data objectForKey:@"TotalPage"] integerValue];
        
        [self removeProgressVie];
        [self addHotelListViewWithData];
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
    int row = indexPath.row;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [_hotelListData objectAtIndex:section];
    NSArray *rooms = [dic objectForKey:@"Rooms"];
    return rooms.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 72.0;
    }
    
    if(indexPath.row == 1){
        return 30.0;
    }
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotelCell = @"hotelCell";
    static NSString *hotelBtn = @"hotelbtn";
    static NSString *hotelRoom = @"hotelRoom";

    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelCell];
    
    HotelListCellviewCell *cellView = nil;
    if(cellView){
        cellView = (HotelListCellviewCell*)cell;
    }else{
        cellView = [[HotelListCellviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelCell];
    }
    
    NSDictionary *dic = [_hotelListData objectAtIndex:indexPath.section];
    [cellView.address setText:[dic objectForKey:@"address"]];
    [cellView.hotelName setText:[dic objectForKey:@"hotelName"]];
    NSString *str = [dic objectForKey:@"lowestPrice"];
    NSString *price = [NSString stringWithFormat:@"￥%@起",str];
    [cellView.price setText:price];
    NSString *comment = [NSString stringWithFormat:@"%@好评率 点评%d条",[dic objectForKey:@"score"],[[dic objectForKey:@"commentTotal"]integerValue]];
    [cellView.comment setText:comment];
    
    [cellView setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    return cellView;
}

@end
