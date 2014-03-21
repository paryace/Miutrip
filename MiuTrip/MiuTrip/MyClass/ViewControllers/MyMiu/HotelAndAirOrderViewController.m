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
#import "CancelHotelOrderRequest.h"
#import "CancelHotelOrderResponse.h"


@interface HotelAndAirOrderViewController ()
{
}
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
        CGFloat noteHeight = [UserDefaults shareUserDefault].airNoteHeigth;
        if ([[detail objectForKey:@"unfold"] boolValue]) {
            rowHeight = AirOrderCellUnfoldHeight + AirItemHeight * [(NSArray*)[detail objectForKey:@"FltPassengers"] count] +noteHeight;
        }else
            rowHeight = AirOrderCellHeight;
    }else if (_orderType == OrderTypeHotel){
        NSDictionary *detail = [_dataSource objectAtIndex:indexPath.row];
        if ([[detail objectForKey:@"unfold"] boolValue]) {
            rowHeight = HotelOrderCellUnfoldHeight + HotelItemHeight * [[detail objectForKey:@"Guests"] count];
        }else
            rowHeight = HotelOrderCellHeight;
    }
    else
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
       // AirNoteHeight = airCell.noteMsg_height;

        NSString *paysSID = [data objectForKey:@"PaySerialId"];
        
        NSLog(@"paySID %@",paysSID);
        
        NSNumber *statusCode = [data objectForKey:@"Status"];
        NSInteger statusNum = [statusCode integerValue];
/*
     "1--创建待支付 2---出票中 3--已出票
     4--驳回  5--已取消"
*/
        if (statusNum == 1) {
            airCell.doneBtn.hidden = NO;
            airCell.cancleBtn.hidden = NO;
        }else
        {
            airCell.doneBtn.hidden = YES;
            airCell.cancleBtn.hidden = YES;
        }
        
        [airCell.doneBtn addTarget:self action:@selector(doneOrder:) forControlEvents:UIControlEventTouchUpInside];
        [airCell.cancleBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:UIControlEventTouchUpInside];

        [airCell.cancleBtn setTag:111];
        airCell.doneBtn.indexPath = indexPath;
        airCell.cancleBtn.indexPath = indexPath;
        
    }else if (_orderType == OrderTypeHotel){

        HotelOrderDetailCell *hotelCell = (HotelOrderDetailCell*)cell;
        
        NSDictionary *data = [_dataSource objectAtIndex:indexPath.row];
        
        NSString *hotelName = [data objectForKey:@"HotelName"];
        NSString *roomTypeName = [data objectForKey:@"RoomTypeName"];
        NSString *string = [NSString stringWithFormat:@"%@ %@",hotelName,roomTypeName];
        hotelCell.hotelName.text = string;
        
        NSString *hotelAddress = [data objectForKey:@"HotelAddress"];
        NSString *hotelString = [NSString stringWithFormat:@"%@",hotelAddress];
        hotelCell.location.text = hotelString;
        
        //根据字符串转换成一种时间格式
        NSString *comeData = [data objectForKey:@"ComeDate"];
        NSDateFormatter *comeFormatter = [[NSDateFormatter alloc] init];
        [comeFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [comeFormatter dateFromString:comeData];
        //NSLog(@"%@",date);
        
        NSDateFormatter * weekAndDayFormatter = [[NSDateFormatter alloc]init];
        //指定月日的输出的格式
        [weekAndDayFormatter setDateFormat:@"MM月dd日"];
        NSString *weekAndDayString= [weekAndDayFormatter stringFromDate:date];
        
        NSDateFormatter * yearFormatter = [[NSDateFormatter alloc]init];
        //指定年的输出的格式
        [yearFormatter setDateFormat:@"yyyy"];
        NSString *yearString= [yearFormatter stringFromDate:date];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit |
        NSMonthCalendarUnit |
        NSDayCalendarUnit |
        NSWeekdayCalendarUnit |
        NSHourCalendarUnit |
        NSMinuteCalendarUnit |
        NSSecondCalendarUnit;
        
        comps = [calendar components:unitFlags fromDate:date];
        int week = [comps weekday];
        NSString *strWeek = [self getCreateTime:week];
        NSString *stringSubDateLabel = [NSString stringWithFormat:@"%@年\n%@",yearString,strWeek];
        hotelCell.subDateLabel.text = stringSubDateLabel;
        hotelCell.mainDateLabel.text = weekAndDayString;
        //NSLog(@"week is:%@",strWeek);
        
        [hotelCell unfoldViewShow:data];
        
        //获取订单状态
        NSNumber *status = [data objectForKey:@"Status"];
        NSInteger statusNumber = [status integerValue];
        
        if (statusNumber == 2 || statusNumber == 4 || statusNumber == 5 || statusNumber == 7 || statusNumber == 8 || statusNumber == 9 || statusNumber == 10) {
            hotelCell.cancleBtn.hidden = YES;
            hotelCell.doneBtn.hidden = YES;
        }else{
            hotelCell.cancleBtn.enabled = YES;
            hotelCell.doneBtn.enabled = YES;
            [hotelCell.cancleBtn addTarget:self action:@selector(cancelHotelOrder:) forControlEvents:UIControlEventTouchUpInside];
            [hotelCell.doneBtn addTarget:self action:@selector(doneHotelOrder:) forControlEvents:UIControlEventTouchUpInside];
            hotelCell.cancleBtn.tag = 222;
            hotelCell.doneBtn.tag = 222;
            hotelCell.cancleBtn.indexPath = indexPath;
            hotelCell.doneBtn.indexPath = indexPath;
        }
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
        NSDictionary *detail = [_dataSource objectAtIndex:indexPath.row];
        BOOL unfold = [[detail objectForKey:@"unfold"] boolValue];
        [detail setValue:[NSNumber numberWithBool:!unfold] forKey:@"unfold"];
        HotelOrderDetailCell *cell = (HotelOrderDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell unfoldViewShow:detail];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
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
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self getOrder];
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
//    [self addLoadingView];

    if (_orderType == OrderTypeAir){
        NSLog(@"ninininin");
        _airRequest = [[GetFlightOrderListRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetOrderList"];
        //            _airRequest.OrderID = @"F000000258";
        //            _airRequest.UID = @"00100052";
        _airRequest.CorpID = @"22";
        _airRequest.PageNumber = [NSNumber numberWithInt:1];
        _airRequest.PageSize = [NSNumber numberWithInt:NSIntegerMax];
        _airRequest.NotTravel = [NSNumber numberWithBool:false];
        _airRequest.isCorpDelivery = [NSNumber numberWithBool:false];
        [self.requestManager sendRequest:_airRequest];
    }
    if (_orderType == OrderTypeHotel){
        _hotelRequest = [[GetOrderRequest alloc]initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetOrders"];
        
        //_hotelRequest.OrderID = @"H131217000112";
        _hotelRequest.Page=[NSNumber numberWithInt:1];
        _hotelRequest.PageSize=[NSNumber numberWithInt:10];
        _hotelRequest.Status = [NSNumber numberWithInt:0];
        [self.requestManager sendRequest:_hotelRequest];
    }
    
}

- (void)requestDone:(BaseResponseModel *)response{
    NSLog(@"hhhhhh");
    [self removeLoadingView];
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
            
            NSString *result = [NSString stringWithFormat:@"订单取消成功"];
            [[Model shareModel]showPromptText:result model:NO];
            [_theTableView reloadData];
        }
        
        
    }
    if (_orderType == OrderTypeHotel) {
        if (response) {
            if ([response isKindOfClass:[CancelHotelOrderResponse class]]) {
                //CancelHotelOrderResponse *responseC = (CancelHotelOrderResponse *) response;
                
                NSString *result = [NSString stringWithFormat:@"订单取消成功"];
                [[Model shareModel]showPromptText:result model:NO];
                [_theTableView reloadData];
                
            }else if ([response isKindOfClass:[GetOrderResponse class]]){
                GetOrderResponse *orderResponse = (GetOrderResponse *)response;
                NSArray *hotelOrder = orderResponse.Data;
                
                for (NSDictionary *order in hotelOrder) {
                    [order setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
                }
                _dataSource = hotelOrder;
                
                if (_pageIndex==1) {
                    [self removeProgressView];
                }
                [self setSubjoinViewFrame];

            }
        }
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    NSLog(@"error = %@",errorMsg);
}


#pragma mark 机票 支付订单
- (void)doneOrder:(CustomBtn *)done
{
    NSArray *array = [[_dataSource reverseObjectEnumerator] allObjects];
    NSDictionary *data = [array objectAtIndex:done.indexPath.row];
    NSString * paysSID = [data objectForKey:@"PaySerialId"];
    NSLog(@"----%@",paysSID);
    if ([paysSID isKindOfClass:[NSNull class]]) {
        
    }else
    {
        [UPPayPlugin startPay:paysSID sysProvide:nil spId:nil mode:@"00" viewController:self delegate:self];

    }
}

- (void)UPPayPluginResult:(NSString *)result
{
    
}

- (void)cancelOrder:(CustomBtn *)cancel{
    [[Model shareModel] showPromptText:@"取消发送中... ..." model:NO];
    NSArray *array = [[_dataSource reverseObjectEnumerator] allObjects];
    NSDictionary *data = [array objectAtIndex:cancel.indexPath.row];
    NSString *supOrderNumber = [data objectForKey:@"SUPOrderID"];
    
    NSDictionary *flts = [[data objectForKey:@"Flts"] objectAtIndex:0];
    NSString *orderNumber = [flts objectForKey:@"OrderID"];
    
    NSNumber *orderType = [data objectForKey:@"OrderType"];
    
    CancelFlightOrderRequest *cancelOrder = [[CancelFlightOrderRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"CancelOrder"];
    cancelOrder.SelfOrderID = orderNumber;
    cancelOrder.OTAOrderID = supOrderNumber;
    cancelOrder.reason = @"1";
    cancelOrder.oTAType = orderType;//[NSNumber numberWithInt:3];
    [self.requestManager sendRequest:cancelOrder];
    cancel.enabled = NO;
}

- (void)cancelHotelOrder:(CustomBtn *)btn
{
    NSInteger index = btn.indexPath.row;
    NSDictionary *orderDic = [_dataSource objectAtIndex:index];
    //获取订单号
    NSString *orderId = [orderDic objectForKey:@"OrderID"];
    [[Model shareModel]showPromptText:@"正在取消订单..." model:NO];
    CancelHotelOrderRequest *cancelHotelOrder = [[CancelHotelOrderRequest alloc]initWidthBusinessType:BUSINESS_HOTEL methodName:@"CancelOrder"];
    cancelHotelOrder.OrderID = orderId;
    cancelHotelOrder.ReasonID = [NSNumber numberWithInt:1];
    
    [self.requestManager sendRequest:cancelHotelOrder];
    btn.enabled = NO;
}

- (void)doneHotelOrder:(CustomBtn *)done
{
    NSDictionary *dic = [_dataSource objectAtIndex:done.indexPath.row];
    NSString *spID = [dic objectForKey:@"PaySerialId"];
    [UPPayPlugin startPay:spID sysProvide:nil spId:nil mode:@"00" viewController:self delegate:self];
    
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
