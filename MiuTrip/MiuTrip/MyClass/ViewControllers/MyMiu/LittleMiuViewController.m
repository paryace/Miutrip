//
//  LittleMiuViewController.m
//  MiuTrip
//
//  Created by pingguo on 13-12-10.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "LittleMiuViewController.h"
#import "LittleMiuDetail.h"
#import "LoginInfoDTO.h"
#import "CommonlyName.h"
#import "GetFlightOrderListRequest.h"
#import "GetHotelPendingOrdersRequest.h"
#import "GetHotelPendingOrdersResponse.h"

#import "HotelDetailViewController.h"
#import "HomeViewController.h"

#import "SaveSMSRequest.h"
#import "SaveSMSResponse.h"

#import "Utils.h"
@interface LittleMiuViewController ()

@property (strong , nonatomic) NSArray  *dataArray;
@property (strong , nonatomic) NSMutableArray  *mobileStringArray;

@end

@implementation LittleMiuViewController

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
        _dataSource = [NSMutableArray array];
        [self setSubviewFrame];
        [self getOrder];
    }
    return self;
}

#pragma mark - select other method
- (void)selectOtherDone:(NSArray*)params
{
    NSDictionary *mobile;
    NSMutableArray *m = [NSMutableArray arrayWithArray:params];
    NSMutableArray *errorObjectArray = [NSMutableArray array];
    for (NSDictionary *dic in m) {
        if ([[dic objectForKey:@"Mobilephone"] isKindOfClass:[NSNull class]] || [dic objectForKey:@"Mobilephone"] == nil) {
            [errorObjectArray addObject:dic];
        }
    }
    for (id object in errorObjectArray) {
        if ([m containsObject:object]) {
            [m removeObject:object];
        }
    }
    
    NSMutableArray *n = [[NSMutableArray alloc] init];
    for (int i = 0; i < [m count]; i++) {
        mobile = [[m objectAtIndex:i] objectForKey:@"Mobilephone"];
        NSString * string = [Utils NULLToEmpty:mobile];
        [n insertObject:string atIndex:i];
        _mobileStringArray = n;
    }
}

-(void)creatSelecetView{
    
    SelectOtherViewController *seleceView = [[SelectOtherViewController alloc] init];
    [seleceView setDelegate:self];
    [self.view addSubview:seleceView.view];
}

- (void)getOrder{
    [_dataSource removeAllObjects];
    GetFlightOrderListRequest *airRequest = [[GetFlightOrderListRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetOrderList"];
    
    airRequest.CorpID = @"22";
    airRequest.PageNumber = [NSNumber numberWithInt:1];
    airRequest.PageSize = [NSNumber numberWithInt:20];
    airRequest.NotTravel = [NSNumber numberWithBool:YES];
    airRequest.isCorpDelivery = [NSNumber numberWithBool:false];
    [self.requestManager sendRequest:airRequest];
    
    GetHotelPendingOrdersRequest *hotelRequest = [[GetHotelPendingOrdersRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetPendingOrders"];
    hotelRequest.NotTravel = [NSNumber numberWithBool:YES];
    [self.requestManager sendRequest:hotelRequest];
}

- (void)requestDone:(BaseResponseModel *)response{
    if ([response isKindOfClass:[GetFlightOrderListResponse class]]) {
        GetFlightOrderListResponse *orderResponse = (GetFlightOrderListResponse *)response;
        NSArray *orders = [orderResponse.orderLists objectForKey:@"Items"];
        for (NSDictionary *order in orders) {
            [order setValue:@"AirList" forKey:@"OrderType"];
            [order setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
        }
        [_dataSource addObjectsFromArray:orders];
    }
    else if ([response isKindOfClass:[GetHotelPendingOrdersResponse class]]) {
        GetHotelPendingOrdersResponse *orderResponse = (GetHotelPendingOrdersResponse *)response;
        NSArray *hotelOrders = orderResponse.Data;
        for (NSDictionary *hotelOrder in hotelOrders) {
            [hotelOrder setValue:@"HotelList" forKey:@"OrderType"];
            [hotelOrder setValue:[NSNumber numberWithBool:NO] forKey:@"unfold"];
        }
        [_dataSource addObjectsFromArray:hotelOrders];;
    }
    else if ([response isKindOfClass:[SaveSMSResponse class]]){
        //        SMS_SendResponse *sendResponse = (SMS_SendResponse * )response;
        //        NSLog(@"sjfajsdfjiosdfj:%@",sendResponse);
        //        sendResponse.Result = [NSNumber numberWithBool:YES];
        //        sendResponse.Count = [NSNumber numberWithInt:2];
        //        sendResponse.ErrorCode = @"错误";
        
    }
    
    [_dataSource sortUsingComparator:^(id value1, id value2){
        double dValue1;
        double dValue2;
        if ([[value1 objectForKey:@"OrderType"] isEqualToString:@"AirList"]) {
            dValue1 = [[Utils dateWithString:[[(NSArray *)[value1 objectForKey:@"Flts"] objectAtIndex:0] objectForKey:@"TakeOffTimeStr"] withFormat:@"yyyy-MM-dd HH:mm"] timeIntervalSince1970];
            //            dValue1 = (double)[[[value1 objectForKey:@"OperateTime"] substringWithRange:NSMakeRange(6, 10)] integerValue];
        }else if ([[value1 objectForKey:@"OrderType"] isEqualToString:@"HotelList"]){
            dValue1 = [[Utils dateWithString:[value1 objectForKey:@"ComeDate"] withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
        }else
            dValue1 = 0;
        
        if ([[value2 objectForKey:@"OrderType"] isEqualToString:@"AirList"]) {
            dValue2 = (double)[[[value2 objectForKey:@"OperateTime"] substringWithRange:NSMakeRange(6, 10)] integerValue];
        }else if ([[value2 objectForKey:@"OrderType"] isEqualToString:@"HotelList"]){
            dValue2 = [[Utils dateWithString:[value2 objectForKey:@"ComeDate"] withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
        }else{
            dValue2 = 0;
        }
        
        if (dValue1 > dValue2) {
            //            return NSOrderedDescending;
            return NSOrderedAscending;
        }else if (dValue1 < dValue2){
            //            return NSOrderedAscending;
            return NSOrderedDescending;
        }else
            return NSOrderedSame;
    }];
    [self.theTableView reloadData];
}

#pragma mark - the tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    NSDictionary *detail = [_dataSource objectAtIndex:indexPath.row];
    if ([[detail valueForKey:@"unfold"] boolValue]) {
        if ([[detail objectForKey:@"OrderType"] isEqualToString:@"AirList"]) {
            rowHeight = LittleMiuAirCellUnfoldHeight + LittleMiuItemHeight * [[detail objectForKey:@"FltPassengers"] count];
        }else if ([[detail objectForKey:@"OrderType"] isEqualToString:@"HotelList"]){
            rowHeight = LittleMiuHotelCellUnfoldHeight + LittleMiuItemHeight * [[detail objectForKey:@"Guests"] count];
        }
    }else
        rowHeight = LittleMiuCellHeight;
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *airOrderIdentifierStr = @"airCell";
    static NSString *hotelOrderIdentifierStr = @"hotelCell";
    
    NSMutableDictionary *detail = [_dataSource objectAtIndex:indexPath.row];
    UITableViewCell *cell = nil;
    if ([[detail objectForKey:@"OrderType"] isEqualToString:@"AirList"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:airOrderIdentifierStr];
        if (cell == nil) {
            cell = [[LittleMiuAirCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:airOrderIdentifierStr];
        }
        LittleMiuAirCell *airCell = (LittleMiuAirCell *)cell;
        airCell.viewController = self;
        [airCell setIndexPath:indexPath];
        [airCell setViewContentWithParams:detail];
        return cell;
        
    }else if ([[detail objectForKey:@"OrderType"] isEqualToString:@"HotelList"]){
        cell = [tableView dequeueReusableCellWithIdentifier:hotelOrderIdentifierStr];
        
        if (cell == nil) {
            cell = [[LittleMiuHotelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelOrderIdentifierStr];
        }
        LittleMiuHotelCell *hotelCell = (LittleMiuHotelCell*)cell;
        hotelCell.viewController = self;
        [hotelCell setIndexPath:indexPath];
        [hotelCell setViewContentWithParams:detail];
        hotelCell.hotelNearBtn.indexPath = indexPath;
        return hotelCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *detail = [_dataSource objectAtIndex:indexPath.row];
    BOOL unfold = [[detail valueForKey:@"unfold"] boolValue];
    [detail setValue:[NSNumber numberWithBool:!unfold] forKey:@"unfold"];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"贴心小觅"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
    
}

- (void)setSubjoinViewFrame
{
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake((self.contentView.frame.size.width - LittleMiuCellWidth)/2, controlYLength(self.topBar), LittleMiuCellWidth, self.contentView.frame.size.height - self.bottomBar.frame.size.height - 10 - controlYLength(self.topBar))];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.contentView addSubview:_theTableView];
}

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

-(void)pressLittleHotelBtn:(CustomBtn *) sender
{
    switch (sender.tag) {
        case 27:{
        
            break;
        }
        case 28:{
            NSLog(@"index = %d",sender.indexPath.row);
            NSDictionary *dict = [_dataSource objectAtIndex:sender.indexPath.row];
            [HotelDataCache sharedInstance].selectedHotelId = [[dict objectForKey:@"HotelId"] integerValue];
            
            HotelDetailViewController *hotelDetailView = [[HotelDetailViewController alloc] init];
            [self pushViewController:hotelDetailView transitionType:TransitionPush completionHandler:nil];
            
            break;
        }
        default:
            break;
    }
}

- (void)sendSMSWithIndexPath:(NSIndexPath*)indexPath{
    //  发送订单消息 SaveSMS 接口
    NSDictionary *sendMsg = [_dataSource objectAtIndex:indexPath.row];
    NSLog(@"sendMsg = %@",sendMsg);
    NSString *ordertype = [sendMsg objectForKey:@"OrderType"];
    
    NSString *orderid = nil;
    NSString *string = nil;
    NSMutableString *mobileString = nil;
    if ([ordertype  isEqual: @"HotelList"]) {
        mobileString = [sendMsg objectForKey:@"ContactMobile"];
        orderid = [sendMsg objectForKey:@"OrderID"];
        NSString *hotelname = [sendMsg objectForKey:@"HotelName"];
        NSString *amount = [sendMsg objectForKey:@"Amount"];
        NSString *roomtype = [sendMsg objectForKey:@"RoomTypeName"];
        NSDate *date = [Utils dateWithString:[sendMsg objectForKey:@"ComeDate"] withFormat:@"yyyy-MM-dd"];
        NSString *comedate = [Utils stringWithDate:date withFormat:@"MM月dd日"];
        
        NSArray *guests = [sendMsg objectForKey:@"Guests"];
        NSMutableString *username = [NSMutableString string];
        for (NSDictionary *user in guests) {
            [username appendString:[user objectForKey:@"UserName"]];
        }
        string = [NSString stringWithFormat:@"[觅优] %@ %@入住1间/夜%@保留至18:00，总价%@.00元，报%@入住，晚到或变更请及时致电4007286000转1。本次酒店供应商--",hotelname,comedate,roomtype,amount,username];
    }else if ([ordertype  isEqual: @"AirList"]){
        NSString *amount = [sendMsg objectForKey:@"Amount"];
        NSDictionary *fltdeliver = [sendMsg objectForKey:@"FltDeliver"];
        mobileString = [fltdeliver objectForKey:@"ContactMobile"];
        
        NSArray *fltpassengers = [sendMsg objectForKey:@"FltPassengers"];
        NSMutableString *passengerNames = [NSMutableString string];
        for (NSDictionary *passenger in fltpassengers) {
            [passengerNames appendString:[passenger objectForKey:@"PassengerName"]];
        }
        
        NSArray *flts = [sendMsg objectForKey:@"Flts"];
        NSString * airlinename= [NSMutableString string];
        NSString * time= [NSMutableString string];
        for (NSDictionary *data in flts) {
            orderid = [data objectForKey:@"OrderID"];
            airlinename = [data objectForKey:@"AirLineName"];
            time = [Utils formatDateWithString:[data objectForKey:@"TakeOffTimeStr"] startFormat:@"yyyy-MM-dd HH:mm" endFormat:@"MM月dd日 HH:mm"];
        }
        
        NSString *passengername = passengerNames;
        string = [NSString stringWithFormat:@"[觅优] %@%@起飞，总价%@.00元,报%@乘机，请按时乘机。本次机票供应商--",airlinename,time,amount,passengername];
    }
    
    int i;
    if ([ordertype  isEqual: @"AirList"]) {
        i = 1;
    }else if ([ordertype  isEqual: @"HotelList"]){
        i = 3;
    }else{
        i = 7;
    }
    
    if ([_mobileStringArray count] == 0) {
        SaveSMSRequest *sendRequest = [[SaveSMSRequest alloc]initWidthBusinessType:BUSINESS_COMMON methodName:@"SaveSMS"];
        
        sendRequest.SMSID = [NSNumber numberWithInt:3];
        sendRequest.IsSendNow = [NSNumber numberWithInt:1];
        sendRequest.BusinessType = [NSNumber numberWithInt:i];
        sendRequest.OrderID = orderid;
        sendRequest.Mobile = mobileString;
        sendRequest.SmsContent = string;
        sendRequest.AddCode = @"15618323344";
        sendRequest.Priority = [NSNumber numberWithInt:3];
        sendRequest.SendTime = nil;
        sendRequest.ScheduleTime = nil;
        sendRequest.Deadline = [Utils stringWithDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 *24] withFormat:@"yyyy-MM-dd"];
        sendRequest.Satatus = [NSString stringWithFormat:@"W"];
        sendRequest.TotalCount = [NSNumber numberWithInt:1];
        sendRequest. Retry = [NSNumber numberWithInt:3];
        sendRequest.Creater = [NSString stringWithFormat:@"why"];
        sendRequest.CreateTime = [Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
        sendRequest.Channel = nil;
        sendRequest.OperateTime = [Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
        sendRequest.ErrorCode = @"错误";
        
        [self.requestManager sendRequest:sendRequest];
    }
    for (NSString *mobileString in _mobileStringArray) {
        SaveSMSRequest *sendRequest = [[SaveSMSRequest alloc]initWidthBusinessType:BUSINESS_COMMON methodName:@"SaveSMS"];
        
        sendRequest.SMSID = [NSNumber numberWithInt:3];
        sendRequest.IsSendNow = [NSNumber numberWithInt:1];
        sendRequest.BusinessType = [NSNumber numberWithInt:i];
        sendRequest.OrderID = orderid;
        sendRequest.Mobile = mobileString;
        sendRequest.SmsContent = string;
        sendRequest.AddCode = @"15618323344";
        sendRequest.Priority = [NSNumber numberWithInt:3];
        sendRequest.SendTime = nil;
        sendRequest.ScheduleTime = nil;
        sendRequest.Deadline = [Utils stringWithDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 *24] withFormat:@"yyyy-MM-dd"];
        sendRequest.Satatus = [NSString stringWithFormat:@"W"];
        sendRequest.TotalCount = [NSNumber numberWithInt:1];
        sendRequest. Retry = [NSNumber numberWithInt:3];
        sendRequest.Creater = [NSString stringWithFormat:@"why"];
        sendRequest.CreateTime = [Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
        sendRequest.Channel = nil;
        sendRequest.OperateTime = [Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"];
        sendRequest.ErrorCode = @"错误";
        
        [self.requestManager sendRequest:sendRequest];
    }
    
}

@end

@interface LittleMiuAirCell ()

@property (strong, nonatomic) UIView        *unfoldView;

@end

@implementation LittleMiuAirCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _itemArray = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

- (void)pressAirLinkBtn:(UIButton *)sender
{
    UIImageView *imageView = (UIImageView *)[_unfoldView viewWithTag:8];
    [imageView setHighlighted:!imageView.highlighted];
    if (imageView.highlighted) {
        [self selectAirLinkBtn];
    }
}

- (void)pressAirOtherBtn:(UIButton *)sender
{
    UIImageView *imageView = (UIImageView *)[_unfoldView viewWithTag:9];
    [imageView setHighlighted:!imageView.highlighted];
    if (imageView.highlighted) {
        [self selectAirOtherBtn];
    }
}

-(void)selectAirOtherBtn
{
    if(_viewController){
        [_viewController creatSelecetView];
    }
}

-(void)selectAirLinkBtn
{
    if(_viewController){
        [_viewController creatSelecetView];
    }
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:color(clearColor)];
    
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, LittleMiuCellWidth - 20, LittleMiuCellHeight - 20)];
    [backGroundImageView setBackgroundColor:color(whiteColor)];
    [backGroundImageView setBorderColor:color(lightGrayColor) width:1];
    [backGroundImageView setAlpha:0.5];
    [backGroundImageView setTag:300];
    [backGroundImageView.layer setMasksToBounds:YES];
    [backGroundImageView.layer setCornerRadius:2.0];
    [self.contentView addSubview:backGroundImageView];
    
    UIImageView *titleBGImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, LittleMiuCellWidth - 20, 35)];
    [titleBGImage setBackgroundColor:color(colorWithRed:64.0/255.0 green:137.0/255.0 blue:211.0/255.0 alpha:1)];
    [titleBGImage.layer setMasksToBounds:YES];
    [titleBGImage.layer setCornerRadius:2.0];
    [self.contentView addSubview:titleBGImage];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setLocale:[NSLocale currentLocale]];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    
    _mainDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleBGImage.frame.origin.x + 10, titleBGImage.frame.origin.y, titleBGImage.frame.size.width/4 - 10, titleBGImage.frame.size.height)];
    [_mainDateLabel setBackgroundColor:color(clearColor)];
    [_mainDateLabel setTextAlignment:NSTextAlignmentLeft];
    [_mainDateLabel setTextColor:color(whiteColor)];
    [_mainDateLabel setText:[Utils stringWithDate:date withFormat:@"MM月dd日"]];
    [_mainDateLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.contentView addSubview:_mainDateLabel];
    
    _subDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_mainDateLabel), _mainDateLabel.frame.origin.y, _mainDateLabel.frame.size.width, _mainDateLabel.frame.size.height)];
    [_subDateLabel setBackgroundColor:color(clearColor)];
    [_subDateLabel setFont:[UIFont systemFontOfSize:12]];
    [_subDateLabel setAutoBreakLine:YES];
    [_subDateLabel setText:[NSString stringWithFormat:@"%@\n%@",[Utils stringWithDate:date withFormat:@"yyyy年"],[[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1]]];
    [_subDateLabel setTextColor:color(whiteColor)];
    [_subDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_subDateLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_subDateLabel), _mainDateLabel.frame.origin.y, titleBGImage.frame.size.width/2, _mainDateLabel.frame.size.height)];
    [_timeLabel setBackgroundColor:color(clearColor)];
    [_timeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_timeLabel setTextColor:color(whiteColor)];
    [_timeLabel setText:[Utils stringWithDate:date withFormat:@"HH:mm"]];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    _routeLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mainDateLabel.frame.origin.x, controlYLength(_mainDateLabel), LittleMiuCellWidth - _mainDateLabel.frame.origin.x * 2, (LittleMiuCellHeight - 25 - titleBGImage.frame.size.height)/2)];
    [_routeLineLabel setBackgroundColor:color(clearColor)];
    [_routeLineLabel setText:@"北京 - 上海"];
    [_routeLineLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_routeLineLabel];
    
    _flightNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_routeLineLabel.frame.origin.x, controlYLength(_routeLineLabel), _routeLineLabel.frame.size.width, _routeLineLabel.frame.size.height)];
    [_flightNumLabel setBackgroundColor:color(clearColor)];
    [_flightNumLabel setText:@"上海航空 FM2908"];
    [_flightNumLabel setTextColor:color(grayColor)];
    [_flightNumLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_flightNumLabel];
    
    _rightArrow = [[UIButton alloc]initWithFrame:CGRectMake(LittleMiuCellWidth - _routeLineLabel.frame.size.height * 2, _routeLineLabel.frame.origin.y, _routeLineLabel.frame.size.height * 2, _routeLineLabel.frame.size.height * 2)];
    [_rightArrow setFrame:CGRectMake(LittleMiuCellWidth - _routeLineLabel.frame.size.height * 2, _routeLineLabel.frame.origin.y, _routeLineLabel.frame.size.height * 2, _routeLineLabel.frame.size.height * 2)];
    [_rightArrow setBackgroundColor:color(clearColor)];
    [_rightArrow setTag:100];
    [_rightArrow setScaleX:0.25 scaleY:0.25];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_down", nil) forState:UIControlStateNormal];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_up", nil) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_rightArrow];
}

- (void)setAirSubjoinViewFrameWithPrarams:(NSDictionary*)params
{
    UIView *prevView = [self.contentView viewWithTag:300];
    
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(prevView), LittleMiuCellWidth - 20, 0)];
    [_unfoldView setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_unfoldView];
    
    UIImageView *subjoinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _unfoldView.frame.size.width, 15)];
    [subjoinImageView setBackgroundColor:color(clearColor)];
    [subjoinImageView setImage:imageNameAndType(@"shadow", nil)];
    [_unfoldView addSubview:subjoinImageView];
    
    UIImageView *linkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autolog_normal"] highlightedImage:[UIImage imageNamed:@"autolog_select"]];
    linkImage.frame = CGRectMake(10, controlYLength(subjoinImageView), _unfoldView.frame.size.width/10-5, 25);
    [linkImage setTag:8];
    [_unfoldView addSubview:linkImage];
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(linkImage), controlYLength(subjoinImageView), _unfoldView.frame.size.width/4-2, 25)];
    
    linkLabel.text = @"发给联系人";
    [linkLabel setFont:[UIFont systemFontOfSize:14]];
    linkLabel.backgroundColor = [UIColor clearColor];
    [_unfoldView addSubview:linkLabel];
    
    UIButton *linkBtn = [[UIButton alloc] initWithFrame:CGRectMake(linkImage.frame.origin.x, controlYLength(subjoinImageView), linkImage.frame.size.width + linkLabel.frame.size.width, 25)];
    //passengerBtn.backgroundColor = [UIColor grayColor];
    [linkBtn setBackgroundColor:[UIColor clearColor]];
    [linkBtn addTarget:self action:@selector(pressAirLinkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:linkBtn];
    
    UIImageView *otherImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autolog_normal"] highlightedImage:[UIImage imageNamed:@"autolog_select"]];
    otherImage.frame = CGRectMake(controlXLength(linkBtn) + 10, controlYLength(subjoinImageView), _unfoldView.frame.size.width/10-5, 25);
    [otherImage setTag:9];
    [_unfoldView addSubview:otherImage];
    
    UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(otherImage), controlYLength(subjoinImageView), _unfoldView.frame.size.width/4-2, 25)];
    otherLabel.text = @"发给其他人";
    [otherLabel setFont:[UIFont systemFontOfSize:14]];
    otherLabel.backgroundColor = [UIColor clearColor];
    [_unfoldView addSubview:otherLabel];
    
    UIButton *otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(controlXLength(linkBtn), controlYLength(subjoinImageView), linkImage.frame.size.width + linkLabel.frame.size.width, 25)];
    [otherBtn setBackgroundColor:[UIColor clearColor]];
    [otherBtn addTarget:self action:@selector(pressAirOtherBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:otherBtn];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(linkBtn) + 10, _unfoldView.frame.size.width, 0.5)];
    [line setBackgroundColor:color(lightGrayColor)];
    [line setAlpha:0.5];
    [_unfoldView addSubview:line];
    
    [_itemArray removeAllObjects];
    NSArray *array = [params objectForKey:@"FltPassengers"];
    NSDictionary *dic = [params objectForKey:@"FltDeliver"];
    NSString *molbile = [dic objectForKey:@"ContactMobile"];
    for (int i = 0;i<[array count];i++) {
        NSDictionary *detail = [array objectAtIndex:i];
        [detail setValue:molbile forKey:@"Mobile"];
        UIView *view = [self createAirCellItemWithParams:detail frame:CGRectMake(line.frame.origin.x + 10, controlYLength(line) + LittleMiuItemHeight * i, linkBtn.frame.size.width, LittleMiuItemHeight)];
        [_unfoldView addSubview:view];
        [_itemArray addObject:view];
    }
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(line) + LittleMiuItemHeight * [array count], _unfoldView.frame.size.width, 0.5)];
    [line setBackgroundColor:color(lightGrayColor)];
    [line setAlpha:0.5];
    [_unfoldView addSubview:line];
    
    _cancleBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setBackgroundColor:color(clearColor)];
    [_cancleBtn setFrame:CGRectMake(_unfoldView.frame.size.width/(5 * 3), 10 + controlYLength(line), _unfoldView.frame.size.width * 2/5 - 20, 40)];
    [_cancleBtn setTitle:@"发送订单消息" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_cancleBtn addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [_cancleBtn setBackgroundImage:imageNameAndType(@"order_cancle", nil) forState:UIControlStateNormal];
    [_unfoldView addSubview:_cancleBtn];
    
    [_unfoldView setFrame:CGRectMake(_unfoldView.frame.origin.x, _unfoldView.frame.origin.y, _unfoldView.frame.size.width, controlYLength(_cancleBtn) + 10)];
    [_unfoldView setHidden:YES];
    
    UIImageView *unfoldBackImage = [[UIImageView alloc]initWithFrame:_unfoldView.bounds];
    [unfoldBackImage setBackgroundColor:color(colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1)];
    [unfoldBackImage setBorderColor:color(lightGrayColor) width:1];
    [unfoldBackImage setAlpha:0.5];
    [_unfoldView insertSubview:unfoldBackImage belowSubview:subjoinImageView];
}

- (UIView*)createAirCellItemWithParams:(NSDictionary*)detail frame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:color(clearColor)];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, frame.size.width-10, (frame.size.height - 10))];
    [nameLabel setBackgroundColor:color(clearColor)];
    [nameLabel setText:[detail objectForKey:@"PassengerName"]];
    [nameLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:nameLabel];
    
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(nameLabel), nameLabel.frame.origin.y, frame.size.width, nameLabel.frame.size.height)];
    [phoneLabel setBackgroundColor:color(clearColor)];
    [phoneLabel setText:[detail objectForKey:@"Mobile"]];
    //    [phoneLabel setText:@"13855556666"];
    [phoneLabel setTextAlignment:NSTextAlignmentRight];
    [phoneLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:phoneLabel];
    
    return view;
}

- (void)unfoldViewShow:(NSDictionary*)detail
{
    BOOL unfold = [[detail valueForKey:@"unfold"] boolValue];
    if (unfold) {
        if (_unfoldView) {
            [_unfoldView removeFromSuperview];
        }
        [self setAirSubjoinViewFrameWithPrarams:detail];
    }
    
    [_rightArrow setHighlighted:unfold];
    [_unfoldView setHidden:!unfold];
}

- (void)setViewContentWithParams:(NSDictionary*)params
{
    [self unfoldViewShow:params];
    
    NSDictionary *flts = [(NSArray*)[params objectForKey:@"Flts"] objectAtIndex:0];
    [_mainDateLabel setText:[Utils formatDateWithString:[flts objectForKey:@"TakeOffTimeStr"] startFormat:@"yyyy-MM-dd HH:mm" endFormat:@"MM月dd日"]];
    NSString *yearString = [Utils formatDateWithString:[flts objectForKey:@"TakeOffTimeStr"] startFormat:@"yyyy-MM-dd HH:mm" endFormat:@"yyyy年"];
    NSString *timeString = [Utils formatDateWithString:[flts objectForKey:@"TakeOffTimeStr"] startFormat:@"yyyy-MM-dd HH:mm" endFormat:@"HH:mm"];
    
    NSDate *date = [Utils dateWithString:[flts objectForKey:@"TakeOffTimeStr"] withFormat:@"yyyy-MM-dd HH:mm"];
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
    NSString *dcityname = [flts objectForKey:@"DCityName"];
    NSString *acityname = [flts objectForKey:@"ACityName"];
    NSString *airLine = [flts objectForKey:@"AirLineName"];
    NSString *string  = [NSString stringWithFormat:@"%@ - %@",dcityname,acityname];
    NSString *stringSubDateLabel = [NSString stringWithFormat:@"%@\n%@",yearString,strWeek];
    
    [_flightNumLabel setText:airLine];
    [_subDateLabel setText:stringSubDateLabel];
    [_timeLabel setText:timeString];
    [_routeLineLabel setText:string];
    
}

- (NSString*)getCreateTime:(int)week{
    NSString *nstr;
    if (week == 1) {
        nstr = @"星期日";
    } else if(week == 2){
        nstr = @"星期一";
    }else if(week == 3){
        nstr = @"星期二";
    }else if (week == 4){
        nstr = @"星期三";
    }else if (week == 5){
        nstr = @"星期四";
    }else if (week == 6){
        nstr = @"星期五";
    }else if (week == 7){
        nstr = @"星期六";
    }
    return nstr;
}

- (void)sendSMS
{
    if(_viewController){
        [_viewController sendSMSWithIndexPath:self.indexPath];
    }
}

@end

@implementation LittleMiuHotelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _itemArray = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:color(clearColor)];
    
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, LittleMiuCellWidth - 20, LittleMiuCellHeight - 20)];
    [backGroundImageView setBackgroundColor:color(whiteColor)];
    [backGroundImageView setBorderColor:color(lightGrayColor) width:1];
    [backGroundImageView setAlpha:0.5];
    [backGroundImageView setTag:300];
    [backGroundImageView.layer setMasksToBounds:YES];
    [backGroundImageView.layer setCornerRadius:2.0];
    [self.contentView addSubview:backGroundImageView];
    
    UIImageView *titleBGImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, LittleMiuCellWidth - 20, 35)];
    [titleBGImage setBackgroundColor:color(colorWithRed:241.0/255.0 green:122.0/255.0 blue:90.0/255.0 alpha:1)];
    [titleBGImage.layer setMasksToBounds:YES];
    [titleBGImage.layer setCornerRadius:2.0];
    [self.contentView addSubview:titleBGImage];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    
    _mainDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleBGImage.frame.origin.x + 10, titleBGImage.frame.origin.y, titleBGImage.frame.size.width/4 - 10, titleBGImage.frame.size.height)];
    [_mainDateLabel setBackgroundColor:color(clearColor)];
    [_mainDateLabel setTextAlignment:NSTextAlignmentLeft];
    [_mainDateLabel setTextColor:color(whiteColor)];
    [_mainDateLabel setText:[Utils stringWithDate:date withFormat:@"MM月dd日"]];
    [_mainDateLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.contentView addSubview:_mainDateLabel];
    
    _subDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_mainDateLabel), _mainDateLabel.frame.origin.y, _mainDateLabel.frame.size.width, _mainDateLabel.frame.size.height)];
    [_subDateLabel setBackgroundColor:color(clearColor)];
    [_subDateLabel setFont:[UIFont systemFontOfSize:12]];
    [_subDateLabel setAutoBreakLine:YES];
    [_subDateLabel setText:[NSString stringWithFormat:@"%@\n%@",[Utils stringWithDate:date withFormat:@"yyyy年"],[[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1]]];
    [_subDateLabel setTextColor:color(whiteColor)];
    [_subDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_subDateLabel];
    
    //    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_subDateLabel), _mainDateLabel.frame.origin.y, titleBGImage.frame.size.width/2, _mainDateLabel.frame.size.height)];
    //    [_timeLabel setBackgroundColor:color(clearColor)];
    //    [_timeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    //    [_timeLabel setTextColor:color(whiteColor)];
    //    [_timeLabel setText:[Utils stringWithDate:date withFormat:@"HH:mm"]];
    //    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    //    [self.contentView addSubview:_timeLabel];
    
    _hotelName = [[UILabel alloc]initWithFrame:CGRectMake(_mainDateLabel.frame.origin.x, controlYLength(_mainDateLabel), LittleMiuCellWidth - _mainDateLabel.frame.origin.x * 2, (LittleMiuCellHeight - 25 - titleBGImage.frame.size.height)/2)];
    [_hotelName setBackgroundColor:color(clearColor)];
    [_hotelName setText:@"北京万豪酒店 行政豪华房"];
    [_hotelName setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_hotelName];
    
    _location = [[UILabel alloc]initWithFrame:CGRectMake(_hotelName.frame.origin.x, controlYLength(_hotelName), _hotelName.frame.size.width, _hotelName.frame.size.height)];
    [_location setBackgroundColor:color(clearColor)];
    [_location setText:@"海淀区区车站东路265号"];
    [_location setTextColor:color(grayColor)];
    [_location setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_location];
    
    _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightArrow setFrame:CGRectMake(LittleMiuCellWidth - _hotelName.frame.size.height * 2, _hotelName.frame.origin.y, _hotelName.frame.size.height * 2, _hotelName.frame.size.height * 2)];
    [_rightArrow setBackgroundColor:color(clearColor)];
    [_rightArrow setTag:100];
    [_rightArrow setScaleX:0.25 scaleY:0.25];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_down", nil) forState:UIControlStateNormal];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_up", nil) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_rightArrow];
}

- (void)setHotelSubjoinViewFrameWithPrarams:(NSDictionary*)params
{
    UIView *prevView = [self.contentView viewWithTag:300];
    
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(prevView), LittleMiuCellWidth - 20, 0)];
    [_unfoldView setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_unfoldView];
    
    UIImageView *subjoinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _unfoldView.frame.size.width, 15)];
    [subjoinImageView setBackgroundColor:color(clearColor)];
    [subjoinImageView setImage:imageNameAndType(@"shadow", nil)];
    [_unfoldView addSubview:subjoinImageView];
    
    UIImageView *linkImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autolog_normal"] highlightedImage:[UIImage imageNamed:@"autolog_select"]];
    linkImage.frame = CGRectMake(10, controlYLength(subjoinImageView), _unfoldView.frame.size.width/10-5, 25);
    [linkImage setTag:10];
    [_unfoldView addSubview:linkImage];
    
    UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(linkImage), controlYLength(subjoinImageView), _unfoldView.frame.size.width/4-2, 25)];
    
    linkLabel.text = @"发给联系人";
    [linkLabel setFont:[UIFont systemFontOfSize:14]];
    linkLabel.backgroundColor = [UIColor clearColor];
    [_unfoldView addSubview:linkLabel];
    
    UIButton *linkBtn = [[UIButton alloc] initWithFrame:CGRectMake(linkImage.frame.origin.x, controlYLength(subjoinImageView), linkImage.frame.size.width + linkLabel.frame.size.width, 25)];
    [linkBtn setBackgroundColor:[UIColor clearColor]];
    [linkBtn addTarget:self action:@selector(pressHotelLinkBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:linkBtn];
    
    UIImageView *otherImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autolog_normal"] highlightedImage:[UIImage imageNamed:@"autolog_select"]];
    otherImage.frame = CGRectMake(controlXLength(linkBtn) + 10, controlYLength(subjoinImageView), _unfoldView.frame.size.width/10-5, 25);
    [otherImage setTag:11];
    [_unfoldView addSubview:otherImage];
    
    UILabel *otherLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(otherImage), controlYLength(subjoinImageView), _unfoldView.frame.size.width/4-2, 25)];
    otherLabel.text = @"发给其他人";
    [otherLabel setFont:[UIFont systemFontOfSize:14]];
    otherLabel.backgroundColor = [UIColor clearColor];
    [_unfoldView addSubview:otherLabel];
    
    //    UIButton *
    _otherBtn = [[UIButton alloc] initWithFrame:CGRectMake(controlXLength(linkBtn), controlYLength(subjoinImageView), linkImage.frame.size.width + linkLabel.frame.size.width, 25)];
    [_otherBtn setBackgroundColor:[UIColor clearColor]];
    [_otherBtn addTarget:self action:@selector(pressHotelOtherBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:_otherBtn];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(linkBtn) + 10, _unfoldView.frame.size.width, 0.5)];
    [line setBackgroundColor:color(lightGrayColor)];
    [line setAlpha:0.5];
    [_unfoldView addSubview:line];
    
    [_itemArray removeAllObjects];
    NSArray *array = [params objectForKey:@"Guests"];
    NSString *mobile = [params objectForKey:@"ContactMobile"];
    for (int i = 0;i<[array count];i++) {
        NSDictionary *detail = [array objectAtIndex:i];
        [detail setValue:mobile forKey:@"Mobile"];
        UIView *view = [self createHotelCellItemWithParams:detail frame:CGRectMake(line.frame.origin.x+10, controlYLength(line) + LittleMiuItemHeight * i, linkBtn.frame.size.width, LittleMiuItemHeight)];
        [_unfoldView addSubview:view];
        [_itemArray addObject:view];
    }
    
    line = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(line) + LittleMiuItemHeight * [array count], _unfoldView.frame.size.width, 0.5)];
    [line setBackgroundColor:color(lightGrayColor)];
    [line setAlpha:0.5];
    [_unfoldView addSubview:line];
    
    _cancleBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setBackgroundColor:color(clearColor)];
    [_cancleBtn setFrame:CGRectMake(_unfoldView.frame.size.width/(5 * 3), 10 + controlYLength(line), _unfoldView.frame.size.width * 2/5 - 20, 40)];
    [_cancleBtn setTitle:@"发送订单消息" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_cancleBtn setBackgroundImage:imageNameAndType(@"order_cancle", nil) forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(sendSMS) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:_cancleBtn];
    
    _doneBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_doneBtn setBackgroundColor:color(clearColor)];
    [_doneBtn setFrame:CGRectMake(controlXLength(_cancleBtn)+10, _cancleBtn.frame.origin.y, _unfoldView.frame.size.width * 2/5 - 20, 40-1)];
    [_doneBtn setTitle:@"支付订单" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_doneBtn setBackgroundImage:imageNameAndType(@"order_done", nil) forState:UIControlStateNormal];
    [_unfoldView addSubview:_doneBtn];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(_cancleBtn)+10, _unfoldView.frame.size.width, 0.5)];
    [line1 setBackgroundColor:color(lightGrayColor)];
    [line1 setAlpha:0.5];
    [_unfoldView addSubview:line1];
    
    UIImageView *mapImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_jd"]];
    [mapImageView setFrame:CGRectMake(line1.frame.origin.x+10, controlYLength(line1)+10, 20, 20)];
    [_unfoldView addSubview:mapImageView];
    
    UILabel *mapLabel=[[UILabel alloc]init];
    [mapLabel setFrame:CGRectMake(controlXLength(mapImageView)+5, mapImageView.frame.origin.y, _unfoldView.frame.size.width/4, mapImageView.frame.size.height)];
    [mapLabel setBackgroundColor:color(clearColor)];
    [mapLabel setText:@"地图来帮觅"];
    [mapLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [mapLabel setTextColor:color(colorWithRed:241.0/255.0 green:122.0/255.0 blue:90.0/255.0 alpha:1)];
    [_unfoldView addSubview:mapLabel];
    
    //UIButton *
    _currentPlaceToHotelBtn = [[UIButton alloc]initWithFrame:CGRectMake(mapImageView.frame.origin.x, controlYLength(mapImageView)+5, mapImageView.frame.size.width+mapLabel.frame.size.width+10, mapImageView.frame.size.height*2.5)];
    [_currentPlaceToHotelBtn setImage:[UIImage imageNamed:@"bg_wt"] forState:UIControlStateNormal];
    _currentPlaceToHotelBtn.layer.cornerRadius = 5;
    [_currentPlaceToHotelBtn setTag:27];
    [_currentPlaceToHotelBtn addTarget:self action:@selector(pressToHotelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:_currentPlaceToHotelBtn];
    
    
    UILabel *currentPlaceToHotelLabelUp = [[UILabel alloc]initWithFrame:CGRectMake(_currentPlaceToHotelBtn.frame.origin.x+8, _currentPlaceToHotelBtn.frame.origin.y+8 , _currentPlaceToHotelBtn.frame.size.width*2/3, (_currentPlaceToHotelBtn.frame.size.height-15)/2)];
    [currentPlaceToHotelLabelUp setBackgroundColor:color(clearColor)];
    [currentPlaceToHotelLabelUp setText:@"当前位置"];
    [currentPlaceToHotelLabelUp setTextColor:[UIColor whiteColor]];
    [currentPlaceToHotelLabelUp setFont:[UIFont boldSystemFontOfSize:13]];
    [_unfoldView addSubview:currentPlaceToHotelLabelUp];
    
    UILabel *currentPlaceToHotelLabelDown = [[UILabel alloc]initWithFrame:CGRectMake(_currentPlaceToHotelBtn.frame.origin.x+8, controlYLength(currentPlaceToHotelLabelUp), _currentPlaceToHotelBtn.frame.size.width*2/3+10, (_currentPlaceToHotelBtn.frame.size.height-15)/2)];
    [currentPlaceToHotelLabelDown setBackgroundColor:color(clearColor)];
    [currentPlaceToHotelLabelDown setText:@"怎么去酒店"];
    [currentPlaceToHotelLabelDown setTextColor:[UIColor whiteColor]];
    [currentPlaceToHotelLabelDown setFont:[UIFont boldSystemFontOfSize:13]];
    [_unfoldView addSubview:currentPlaceToHotelLabelDown];
    
    //    UIButton *
    _hotelNearBtn = [[CustomBtn alloc]initWithFrame:CGRectMake(controlXLength(_currentPlaceToHotelBtn) +10, controlYLength(mapImageView)+5, mapImageView.frame.size.width+mapLabel.frame.size.width+10, mapImageView.frame.size.height*2.5)];
    [_hotelNearBtn setImage:[UIImage imageNamed:@"bg_wt2"] forState:UIControlStateNormal];
    _hotelNearBtn.layer.cornerRadius = 5;
    [_hotelNearBtn setTag:28];
    [_hotelNearBtn addTarget:self action:@selector(pressHotelAroundBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_unfoldView addSubview:_hotelNearBtn];
    
    UILabel *hotelNearLabel=[[UILabel alloc]initWithFrame:CGRectMake(_hotelNearBtn.frame.origin.x+10, _hotelNearBtn.frame.origin.y+5, _hotelNearBtn.frame.size.width, _hotelNearBtn.frame.size.height-10)];
    [hotelNearLabel setText:@"酒店周边信息"];
    [hotelNearLabel setBackgroundColor:color(clearColor)];
    [hotelNearLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [hotelNearLabel setTextColor:[UIColor whiteColor]];
    [_unfoldView addSubview:hotelNearLabel];
    
    [_unfoldView setFrame:CGRectMake(_unfoldView.frame.origin.x, _unfoldView.frame.origin.y, _unfoldView.frame.size.width, controlYLength(_currentPlaceToHotelBtn) + 10)];
    [_unfoldView setHidden:YES];
    
    UIImageView *unfoldBackImage = [[UIImageView alloc]initWithFrame:_unfoldView.bounds];
    [unfoldBackImage setBackgroundColor:color(colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1)];
    [unfoldBackImage setBorderColor:color(lightGrayColor) width:1];
    [unfoldBackImage setAlpha:0.5];
    [_unfoldView insertSubview:unfoldBackImage belowSubview:subjoinImageView];
    
}

- (UIView*)createHotelCellItemWithParams:(NSDictionary*)detail frame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:color(clearColor)];
    
    //   UILabel *
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, frame.size.width-10, (frame.size.height - 10))];
    [_nameLabel setBackgroundColor:color(clearColor)];
    [_nameLabel setText:[detail objectForKey:@"UserName"]];
    //[nameLabel setText:@"苗可欣"];
    [_nameLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:_nameLabel];
    
    //    UILabel *
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_nameLabel), _nameLabel.frame.origin.y, frame.size.width, _nameLabel.frame.size.height)];
    [_phoneLabel setBackgroundColor:color(clearColor)];
    [_phoneLabel setText:[detail objectForKey:@"Mobile"]];
    //    [_phoneLabel setText:@"13855556666"];
    [_phoneLabel setTextAlignment:NSTextAlignmentRight];
    [_phoneLabel setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:_phoneLabel];
    
    return view;
}

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"t_line", nil)];
    return line;
}

- (void)unfoldViewShow:(NSDictionary*)detail
{
    BOOL unfold = [[detail valueForKey:@"unfold"] boolValue];
    if (unfold) {
        if (_unfoldView) {
            [_unfoldView removeFromSuperview];
        }
        
        [self setHotelSubjoinViewFrameWithPrarams:detail];
    }
    [_rightArrow setHighlighted:unfold];
    [_unfoldView setHidden:!unfold];
}

- (void)setViewContentWithParams:(NSDictionary*)params
{
    [self unfoldViewShow:params];
    
    [_mainDateLabel setText:[Utils formatDateWithString:[params objectForKey:@"ComeDate"] startFormat:@"yyyy-MM-dd" endFormat:@"MM月dd日"]];
    NSString *yearString = [Utils formatDateWithString:[params objectForKey:@"ComeDate"] startFormat:@"yyyy-MM-dd" endFormat:@"yyyy年"];
    NSDate *date = [Utils dateWithString:[params objectForKey:@"ComeDate"] withFormat:@"yyyy-MM-dd"];
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
    NSString *stringSubDateLabel = [NSString stringWithFormat:@"%@\n%@",yearString,strWeek];
    [_subDateLabel setText:stringSubDateLabel];
    
    NSString *hotelName = [params objectForKey:@"HotelName"];
    NSString *roomTypeName = [params objectForKey:@"RoomTypeName"];
    NSString *string = [NSString stringWithFormat:@"%@ %@",hotelName,roomTypeName];
    _hotelName.text = string;
    
    NSString *hotelAddress = [params objectForKey:@"HotelAddress"];
    NSString *hotelString = [NSString stringWithFormat:@"%@",hotelAddress];
    _location.text = hotelString;
    
}

- (NSString*)getCreateTime:(int)week{
    NSString *nstr;
    if (week == 1) {
        nstr = @"星期日";
    } else if(week == 2){
        nstr = @"星期一";
    }else if(week == 3){
        nstr = @"星期二";
    }else if (week == 4){
        nstr = @"星期三";
    }else if (week == 5){
        nstr = @"星期四";
    }else if (week == 6){
        nstr = @"星期五";
    }else if (week == 7){
        nstr = @"星期六";
    }
    return nstr;
}

- (void)pressHotelLinkBtn:(UIButton *)sender
{
    UIImageView *imageView = (UIImageView *)[_unfoldView viewWithTag:10];
    [imageView setHighlighted:!imageView.highlighted];
    if (imageView.highlighted) {
        [self selectHotelLinkBtn];
    }
}

- (void)pressHotelOtherBtn:(UIButton *)sender
{
    UIImageView *imageView = (UIImageView *)[_unfoldView viewWithTag:11];
    [imageView setHighlighted:!imageView.highlighted];
    if (imageView.highlighted) {
        [self selectHotelOtherBtn];
    }
}

- (void)sendSMS
{
    if(_viewController){
        [_viewController sendSMSWithIndexPath:self.indexPath];
    }
}

- (void)pressToHotelBtn:(CustomBtn *)sender
{
    if(_viewController){
        [_viewController pressLittleHotelBtn:sender];
    }
}

- (void)pressHotelAroundBtn:(CustomBtn *)sender
{
    if(_viewController){
        [_viewController pressLittleHotelBtn:sender];
    }
}

-(void)selectHotelOtherBtn
{
    if(_viewController){
        [_viewController creatSelecetView];
    }
}

-(void)selectHotelLinkBtn
{
    if(_viewController){
        [_viewController creatSelecetView];
    }
}

@end

#import "RequestManager.h"
#import "GetContactRequest.h"
#import "GetContactResponse.h"


#import "GetCorpStaffRequest.h"
#import "GetCorpStaffResponse.h"

@interface SelectOtherViewController ()

@property (strong, nonatomic) UITableView   *theTableView;
@property (strong, nonatomic) NSMutableArray       *dataSource;
@property (strong , nonatomic) NSMutableArray      *dataArray;

@property (strong, nonatomic) RequestManager *requestManager;

@end

@implementation SelectOtherViewController

- (id)init
{
    if (self = [super init]) {
        _dataArray = [NSMutableArray array];
        _requestManager = [[RequestManager alloc]init];
        [_requestManager setDelegate:self];
        
        UIImageView *backGroundView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        [backGroundView setBackgroundColor:color(blackColor)];
        [backGroundView setAlpha:0.40];
        [self.view addSubview:backGroundView];
        [self.view setBackgroundColor:[UIColor clearColor]];
        [self setSubjoinViewFrame];
        
        //        [self getStaff];
        [self getContact];////////////////////////////////////////////////////////////////////////////
    }
    return self;
}

- (void)setSubjoinViewFrame
{
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 80, self.view.frame.size.width-80, self.view.frame.size.height-170)];
    [bgView setBackgroundColor:color(whiteColor)];
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    bgView.layer.cornerRadius = 6.0;
    [self.view addSubview:bgView];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(bgView.frame.origin.x,bgView.frame.origin.y,bgView.frame.size.width,bgView.frame.size.height-40)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setBackgroundColor:[UIColor clearColor]];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.view addSubview:_theTableView];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(_theTableView.frame.origin.x, controlYLength(_theTableView), _theTableView.frame.size.width/2, 40)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:imageNameAndType(@"order_cancle", nil) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(pressSelectSureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(controlXLength(sureBtn), sureBtn.frame.origin.y, sureBtn.frame.size.width, sureBtn.frame.size.height)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:imageNameAndType(@"order_cancle", nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(pressSelectCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}


//- (void)getStaff{
//    GetCorpStaffRequest *staffRequest = [[GetCorpStaffRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpStaff"];
//    staffRequest.CorpID = [NSNumber numberWithInt:10];
//    [self.requestManager sendRequest:staffRequest];
//}

- (void)getContact{
    GetContactRequest *contactRequest = [[GetContactRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    contactRequest.CorpID = [NSNumber numberWithInt:22];
    [self.requestManager sendRequest:contactRequest];
}

- (void)requestDone:(BaseResponseModel *)response{
    if ([response isKindOfClass:[GetContactResponse class]]) {
        GetContactResponse *contactRespone = (GetContactResponse *)response;
        NSLog(@"result = %@",contactRespone.result);
        
        _dataSource = [NSMutableArray arrayWithArray:contactRespone.result];
        NSLog(@"contactRespone = %@",_dataSource);
        [_theTableView reloadData];
    }
    //    if ([response isKindOfClass:[GetCorpStaffResponse class]]) {
    //        GetCorpStaffResponse *staffRespone = (GetCorpStaffResponse *)response;
    //        NSLog(@"customers = %@",staffRespone.customers);
    //
    //        _dataSource = [NSMutableArray arrayWithArray:staffRespone.customers];
    //        NSLog(@"staffRespone = %@",_dataSource);
    //        [_theTableView reloadData];
    //    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"errorMsg = %@",errorMsg);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 40;
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *selectOtherIdentifierStr = @"selectOtherCell";
    
    SelectOtherCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:selectOtherIdentifierStr];
    if (cell == nil) {
        cell = [[SelectOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectOtherIdentifierStr];
    }
    NSMutableDictionary *detail = [_dataSource objectAtIndex:indexPath.row];
    [cell setViewContentWithParams:detail];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectOtherCell *cell = (SelectOtherCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSObject *selectObject = [_dataSource objectAtIndex:indexPath.row];
    if ([_dataArray containsObject:selectObject]) {
        [_dataArray removeObject:selectObject];
        [cell setRightImageHighlighted:NO];
    }else{
        [_dataArray addObject:selectObject];
        [cell setRightImageHighlighted:YES];
    }
}

-(void) pressSelectSureBtn:(UIButton *)sender
{
    self.view.hidden = YES;
    [self.delegate selectOtherDone:_dataArray];
}

-(void) pressSelectCancelBtn:(UIButton *)sender
{
    self.view.hidden = YES;
}

@end


@interface SelectOtherCell ()

@end

@implementation SelectOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:color(clearColor)];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, (appFrame.size.width - 50)/4-10, 40)];
    [_userName setFont:[UIFont systemFontOfSize:12]];
    [_userName setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_userName];
    
    _mobilePhone = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_userName),_userName.frame.origin.y, _userName.frame.size.width*2+20, _userName.frame.size.height)];
    [_mobilePhone setBackgroundColor:color(clearColor)];
    [_mobilePhone setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_mobilePhone];
    
    UIImageView *selectImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autolog_normal"] highlightedImage:[UIImage imageNamed:@"autolog_select"]];
    selectImage.frame = CGRectMake(controlXLength(_mobilePhone)+5, _mobilePhone.frame.origin.y+10, _mobilePhone.frame.size.height-18, _mobilePhone.frame.size.height-18);
    [selectImage setTag:77];
    [self.contentView addSubview:selectImage];
}

- (void)setViewContentWithParams:(NSDictionary*)params
{
    [_userName setText:[params objectForKey:@"UserName"]];
    [_mobilePhone setText:[NSString stringWithFormat:@"电话 : %@",[params objectForKey:@"Mobilephone"]]];
}

- (void)setRightImageHighlighted:(BOOL)highlighted
{
    UIImageView *imageView = (UIImageView *)[self.contentView viewWithTag:77];
    [imageView setHighlighted:highlighted];
}

@end

