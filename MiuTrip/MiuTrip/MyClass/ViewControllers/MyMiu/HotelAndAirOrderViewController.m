//
//  HotelAndAirOrderViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelAndAirOrderViewController.h"
#import "HotelOrderDetail.h"
#import "AirOrderDetail.h"
#import "AirOrderDetailCell.h"
#import "HotelOrderDetailCell.h"
#import "GetFlightOrderListResponse.h"
#import "GetFlightOrderListRequest.h"
#import "GetOrderResponse.h"
#import "CancelFlightOrderRequest.h"
#import "CancelFlightOrderResponse.h"
#import "Model.h"
@interface HotelAndAirOrderViewController ()

@end

@implementation HotelAndAirOrderViewController

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
        [self getOrder];
        [self.view setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithOrderType:(OrderType)type
{
    if (self = [super init]) {
        
        _orderType = type;
        [self.view setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - the tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    if (_orderType == OrderTypeAir) {
        NSArray *datasource = [[_dataSource reverseObjectEnumerator]allObjects];
        NSDictionary *detail = [datasource objectAtIndex:indexPath.row];
        NSLog(@"unfold = %d",[[detail objectForKey:@"unfold"] boolValue]);
        
        if ([[detail objectForKey:@"unfold"] boolValue]) {
            rowHeight = AirOrderCellUnfoldHeight + AirItemHeight * [(NSArray*)[detail objectForKey:@"FltPassengers"] count];
        }else
            rowHeight = AirOrderCellHeight;
    }else if (_orderType == OrderTypeHotel){
        HotelOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        if (detail.unfold) {
            rowHeight = HotelOrderCellUnfoldHeight + HotelItemHeight * [detail.passengers count];
        }else
            rowHeight = HotelOrderCellHeight;
    }else
        rowHeight = 0;
    
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        if (_orderType == OrderTypeAir) {
            cell = [[AirOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
            
            cell.tag = indexPath.row;
        }else if (_orderType == OrderTypeHotel){
            cell = [[HotelOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
            cell.tag = indexPath.row;
        }
        
    }
    if (_orderType == OrderTypeAir) {
        AirOrderDetailCell *airCell = (AirOrderDetailCell*)cell;
        NSArray *datasource =[[_dataSource reverseObjectEnumerator] allObjects];
        NSDictionary *data = [datasource objectAtIndex:indexPath.row];
        NSDictionary *flts = [(NSArray*)[data objectForKey:@"Flts"] objectAtIndex:0];
        NSString *dcityname = [flts objectForKey:@"DCityName"];
        NSString *acityname = [flts objectForKey:@"ACityName"];
        NSString *airline = [flts objectForKey:@"AirLineName"];
        NSString *createTime = [data objectForKey:@"CreateTime"];
        //        NSLog(@"-------------%@",createTime);
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        //        [formatter setDateStyle:NSDateFormatterLongStyle];
        //        [formatter setDateFormat:@"MMM dd, yyyy hh:mmaa"];
        //        NSDate *date = [formatter dateFromString:createTime];
        //        NSLog(@"===========%@",date);
        NSDate *date = [self timeForString:createTime];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
        int month = [components month];
        int day = [components day];
        int year= [components year];
        int week = [components weekday];
        int hour = [components hour];
        int min = [components minute];
        
        NSString *string  = [NSString stringWithFormat:@"%@ - %@",dcityname,acityname];
        NSString *monday = [NSString stringWithFormat:@"%d月%d日",month,day];
        NSString *yandw = [NSString stringWithFormat:@"%d年\n%@",year,[self getCreateTime:week]];
        NSString *handm = [NSString stringWithFormat:@"%d:%d",hour,min];
        airCell.flightNumLabel.text =airline;
        airCell.routeLineLabel.text = string;
        airCell.mainDateLabel.text = monday;
        airCell.subDateLabel.text = yandw;
        airCell.timeLabel.text = handm;
        
        [airCell unfoldViewShow:data];
        [airCell.cancleBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [airCell.cancleBtn setTag:111];
        
    }else if (_orderType == OrderTypeHotel){
        //        HotelOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        //        HotelOrderDetailCell *hotelCell = (HotelOrderDetailCell*)cell;
        //        [hotelCell setHotelDetail:detail];
        //        [hotelCell unfoldViewShow:detail.unfold];
        //        [hotelCell setViewContentWithParams:detail];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_orderType == OrderTypeAir) {
        NSArray *datasource = [[_dataSource reverseObjectEnumerator]allObjects];
        NSDictionary *detail = [datasource objectAtIndex:indexPath.row];
        BOOL unfold = [[detail objectForKey:@"unfold"] boolValue];
        [detail setValue:[NSNumber numberWithBool:!unfold] forKey:@"unfold"];
        AirOrderDetailCell *cell = (AirOrderDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell unfoldViewShow:detail];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }else if (_orderType == OrderTypeHotel){
        //        HotelOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        //        detail.unfold = !detailx.unfold;
        //
        //        HotelOrderDetailCell *cell = (HotelOrderDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        //        [cell.rightArrow setHighlighted:detail.unfold];
        //        [cell unfoldViewShow:detail.unfold];
        //        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - view init
- (void)setSubviewFrame
{
    _pageIndex = 1;
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    if (_orderType == OrderTypeAir) {
        [self setTitle:@"机票订单"];
        [self addProgressView];
    }else if (_orderType == OrderTypeHotel){
        [self setTitle:@"酒店订单"];
        [self addProgressView];
        
    }
    [self getOrder];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    
}

- (void)addProgressView{
    _progressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_progressView setHidesWhenStopped:NO];
    [_progressView setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [_progressView startAnimating];
    [self.view addSubview:_progressView];
}

- (void)removeProgressView{
    [_progressView stopAnimating];
    [_progressView removeFromSuperview];
}

- (void)getOrder{
    if (_orderType == OrderTypeAir){
        NSLog(@"ninininin");
        _airRequest = [[GetFlightOrderListRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetOrderList"];
        //            _airRequest.OrderID = @"F000000258";
        //            _airRequest.UID = @"00100052";
        _airRequest.CorpID = @"22";
        _airRequest.PageNumber = [NSNumber numberWithInt:1];
        _airRequest.PageSize = [NSNumber numberWithInt:10];
        _airRequest.NotTravel = [NSNumber numberWithBool:false];
        _airRequest.isCorpDelivery = [NSNumber numberWithBool:false];
        [self.requestManager sendRequest:_airRequest];
    }
    if (_orderType == OrderTypeHotel){
        _hotelRequest = [[GetOrderRequest alloc]initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetOrders"];
        _hotelRequest.OrderID = @"H131217000112";
        _hotelRequest.Page=[NSNumber numberWithInt:1];
        _hotelRequest.PageSize=[NSNumber numberWithInt:10];
        _hotelRequest.Status = [NSNumber numberWithInt:1];
        [self.requestManager sendRequest:_hotelRequest];
        NSLog(@"bkjbkjbj");
    }
    
}

- (void)requestDone:(BaseResponseModel *)response{
    NSLog(@"hhhhhh");
    if (_orderType == OrderTypeAir) {
        if ([response isKindOfClass:[GetFlightOrderListResponse class]]) {
            NSLog(@"g=========et");
            GetFlightOrderListResponse *orderResponse = (GetFlightOrderListResponse *)response;
            NSArray *orders = [orderResponse.orderLists objectForKey:@"Items"];
            for (NSDictionary *order in orders) {
                [order setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
            }
            _dataSource = orders;
            if (_pageIndex==1) {
                [self removeProgressView];
            }
            [self setSubjoinViewFrame];
            
        }else if ([response isKindOfClass:[CancelFlightOrderResponse class]]) {
            
            NSLog(@"============");
            CancelFlightOrderResponse *cancelFlight = (CancelFlightOrderResponse*)response;
            //                NSArray *cancelDetail = cancelFlight.Data;
            NSLog(@"-----------------");
            
        }
        
        
    }
    if (_orderType == OrderTypeHotel) {
        if (response) {
            GetOrderResponse *orderResponse = (GetOrderResponse *)response;
            NSArray *orders = [orderResponse.Data objectForKey:@"Orders"];
            for (NSDictionary *order in orders) {
                [order setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
            }
            _dataSource = orders;
            // [_dataSource addObjectsFromArray:order];
            _totalPage = [[orderResponse.Data objectForKey:@"TotalPage"] integerValue];
            
            if (_pageIndex==1) {
                [self removeProgressView];
            }
            //            [self stopLoading];
            //            [self.theTableView reloadData];
            //            self.hasMore = YES;
        }
    }
    
    
    
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    NSLog(@"error = %@",errorMsg);
}
- (void)setSubjoinViewFrame
{
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake((self.contentView.frame.size.width - AirOrderCellWidth)/2, controlYLength(self.topBar), AirOrderCellWidth, self.contentView.frame.size.height - self.bottomBar.frame.size.height - 10 - controlYLength(self.topBar))];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.contentView addSubview:_theTableView];
}

- (void)cancelOrder{
    [[Model shareModel] showPromptText:@"取消发送中... ..." model:NO];
    CancelFlightOrderRequest *cancelOrder = [[CancelFlightOrderRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"CancelOrder"];
    cancelOrder.SelfOrderID = @"F000000390";
    cancelOrder.OTAOrderID = @"66752752";
    cancelOrder.reason = @"test";
    cancelOrder.oTAType = [NSNumber numberWithInt:3];
    [self.requestManager sendRequest:cancelOrder];
}

- (NSDate *)timeForString:(NSString *)string {
    NSMutableString *timeString = [[NSMutableString alloc] initWithString:string];
    [timeString setString:[timeString stringByReplacingOccurrencesOfString:@"/Date(" withString:@""]];
    [timeString setString:[timeString stringByReplacingOccurrencesOfString:@")/" withString:@""]];
    [timeString setString:[timeString substringToIndex:timeString.length - 3]];
    return [NSDate dateWithTimeIntervalSince1970:[timeString longLongValue]];
}


- (NSString*)getCreateTime:(int)week{
    NSString *nstr;
    if (week == 1) {
        nstr = @"星期日";
    } else if(week ==2){
        nstr = @"星期一";
    }else if(week ==3){
        nstr = @"星期二";
    }else if (week ==4){
        nstr = @"星期三";
    }else if (week ==5){
        nstr = @"星期四";
    }else if (week ==6){
        nstr =@"星期五";
    }else if (week ==7){
        nstr = @"星期六";
    }
    return nstr;
}

//- (void)
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
