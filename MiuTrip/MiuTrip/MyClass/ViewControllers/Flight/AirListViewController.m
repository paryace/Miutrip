//
//  AirListViewController.m
//  MiuTrip
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "AirListViewController.h"
#import "OrderFillInViewController.h"
#import "GetNormalFlightsRequest.h"
#import "SqliteManager.h"
#import "CustomBtn.h"
#import "GetCorpPolicyRequest.h"
#import "SubmitFlightOrderRequest.h"

@interface AirListViewController ()

@property (strong, nonatomic) UILabel               *titleLabel;
@property (strong, nonatomic) UILabel               *detailLabel;
@property (strong, nonatomic) UIButton              *dateLabel;

@property (strong, nonatomic) NSMutableArray        *showDataSource;

@property (strong, nonatomic) GetCorpPolicyResponse *corpPolicy;

@property (strong, nonatomic) UILabel               *fltPolicyTitleLabel;

@property (strong, nonatomic) id                    currentPolicy;

@property (strong, nonatomic) NSMutableArray        *conformPolicies;

@property (strong, nonatomic) NSDate                *takeOffDate;       //format: yyyy-MM-dd HH:mm

@property (strong, nonatomic) TakeOffTimePickerViewController *takeOffTimeView;
@property (strong, nonatomic) PolicyIllegalReasonViewController *policyIllegalView;

@property (assign, nonatomic) BOOL                  haveReturn;

//@property (strong, nonatomic) DomesticFlightDataDTO *firstFlight;
//@property (strong, nonatomic) DomesticFlightDataDTO *secondFlight;

@property (strong, nonatomic) RouteEntity           *firstFlightData;
@property (strong, nonatomic) RouteEntity           *secondFlightData;

@end

@implementation AirListViewController

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
        _showDataSource = [NSMutableArray array];
        _conformPolicies = [NSMutableArray array];
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
        
        _takeOffTimeView = [[TakeOffTimePickerViewController alloc]init];
        [_takeOffTimeView setDelegate:self];
        [self.view addSubview:_takeOffTimeView.view];
        
        _policyIllegalView = [[PolicyIllegalReasonViewController alloc]init];
        [_policyIllegalView setDelegate:self];
        [self.view addSubview:_policyIllegalView.view];
    }
    return self;
}

- (id)currentPolicy
{
    if (!_policyData) {
        _currentPolicy = [UserDefaults shareUserDefault].loginInfo;
    }else{
        _currentPolicy = _policyData;
    }
    return _currentPolicy;
}

- (NSArray *)passengers
{
    if (!_passengers) {
        _passengers = @[[UserDefaults shareUserDefault].loginInfo];
    }
    
    return _passengers;
}

- (void)showViewContent
{
    if (!_corpPolicy) {
        [self getPassengerPolicy];
    }else{
        [self getAirListWithRequest:_getFlightsRequest];
    }
}

- (void)getAirListWithRequest:(BaseRequestModel*)request
{
    [_showDataSource removeAllObjects];
    [_theTableView reloadData];
    GetNormalFlightsRequest *flightsRequest = nil;
    if ([request isKindOfClass:[GetNormalFlightsRequest class]]) {
        flightsRequest = (GetNormalFlightsRequest*)request;
    }
    [_detailLabel setText:nil];
    [_titleLabel setText:[NSString stringWithFormat:@"%@ - %@",[[SqliteManager shareSqliteManager] getCityCNNameWithCityCode:flightsRequest.DepartCity],[[SqliteManager shareSqliteManager] getCityCNNameWithCityCode:flightsRequest.ArriveCity]]];
    [_dateLabel setTitle:[Utils formatDateWithString:flightsRequest.DepartDate startFormat:@"yyyy-MM-dd" endFormat:@"M月d日"] forState:UIControlStateNormal];
    [self.requestManager sendRequest:request];
}

- (void)getAirListDone:(GetNormalFlightsResponse*)response
{
    _dataSource = [NSMutableArray arrayWithArray:response.flights];
    if ([_dataSource count] != 0) {
        DomesticFlightDataDTO *flight = [_dataSource objectAtIndex:0];
        [UserDefaults shareUserDefault].OTAType = flight.OTAType;
    }
    
    _showDataSource = [NSMutableArray arrayWithArray:_dataSource];
    [self tableViewReloadData:_theTableView];
}

- (void)getPassengerPolicy
{
    SEL selector = NSSelectorFromString(@"PolicyID");
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id value = [self.currentPolicy performSelector:selector];
    
    if (value) {
        GetCorpPolicyRequest *request = [[GetCorpPolicyRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpPolicy"];
        
        NSError *error = nil;
        if ([request validateValue:&value forKey:@"PolicyID" error:&error]) {
            [request setPolicyid:value];
        }
        
        [self.requestManager sendRequest:request];
    }else{
        [[Model shareModel]showPromptText:@"沒有政策執行人." model:YES];
    }
    
}

- (void)getPassengerPolicyDone:(GetCorpPolicyResponse*)response
{
    [response getObjects];
    _corpPolicy = response;
    [self showViewContent];
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetNormalFlightsResponse class]]) {
        [self getAirListDone:(GetNormalFlightsResponse*)response];
    }else if ([response isKindOfClass:[GetCorpPolicyResponse class]]){
        [self getPassengerPolicyDone:(GetCorpPolicyResponse*)response];
    }else if ([response isKindOfClass:[SubmitFlightOrderResponse class]]){
        [self submitFlightOrderDone:(SubmitFlightOrderResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}


- (void)tableViewReloadData:(UITableView*)tableView
{
    [_conformPolicies removeAllObjects];
    for (DomesticFlightDataDTO *flight in _showDataSource) {
        if (flight.MoreFlights != nil && ![flight.MoreFlights isKindOfClass:[NSNull class]]) {
            [flight.MoreFlights sortUsingComparator:^(DomesticFlightDataDTO *value1, DomesticFlightDataDTO *value2){
                if ([value1.Price floatValue] < [value2.Price floatValue]) {
                    return NSOrderedAscending;
                }else if ([value1.Price floatValue] > [value2.Price floatValue]){
                    return NSOrderedDescending;
                }else{
                    return NSOrderedSame;
                }
                return 0;
            }];
        }
    }
    
    [self showSubjoinView];
    if ([_feeType isEqualToString:FeeTypePUB]) {
        [self markConformPolicy];
    }
    
    tableView.scrollsToTop = YES;
    [tableView reloadData];
}

- (void)markConformPolicy
{
    [_conformPolicies removeAllObjects];
    for (DomesticFlightDataDTO *flight in _showDataSource) {
        if (_getFlightsRequest.DepartTime) {
            NSDate *flightDate = [Utils dateWithString:[flight.TakeOffDate stringByAppendingFormat:@" %@",flight.TakeOffTime] withFormat:@"yyyy-MM-dd HH:mm"];
            if ([flightDate timeIntervalSince1970] >= [self.takeOffDate timeIntervalSince1970] - [_corpPolicy.PreMinute integerValue] * 60 && [flightDate timeIntervalSince1970] <= [self.takeOffDate timeIntervalSince1970] + [_corpPolicy.PreMinute integerValue] * 60) {
                [flight setConformLevel:@"T"];
                [_conformPolicies addObject:flight];
            }else{
                [flight setConformLevel:@"F"];
            }
        }else {
            [flight setConformLevel:@"F"];
        }
    }
    
    if ([_conformPolicies count] != 0) {
        DomesticFlightDataDTO *cheapestFlight = [_conformPolicies objectAtIndex:0];
        
        for (int i = [_conformPolicies count] - 1; i>=0; i--) {
            DomesticFlightDataDTO *object = [_conformPolicies objectAtIndex:i];
            cheapestFlight = [cheapestFlight.Price floatValue] < [object.Price floatValue]?cheapestFlight:object;
            
            if ([_showDataSource containsObject:object]) {
                [_showDataSource bringObjectToFront:object];
            }
        }
        
        if (cheapestFlight) {
            [cheapestFlight setConformLevel:@"B"];
        }
        
        for (DomesticFlightDataDTO *flight in _conformPolicies) {
            if ([flight.Price floatValue] == [cheapestFlight.Price floatValue]) {
                [flight setConformLevel:@"B"];
            }
        }
    }
}

#pragma mark - tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DomesticFlightDataDTO *model = [_showDataSource objectAtIndex:indexPath.row];
    if ([model.unfold boolValue]) {
        if (model.MoreFlights == nil || [model.MoreFlights isKindOfClass:[NSNull class]]) {
            return AirListViewCellHeight;
        }else
            return AirListViewCellHeight + AirListViewSubjoinCellHeight * [model.MoreFlights count];
    }else
        return AirListViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    AirListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == Nil) {
        cell = [[AirListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
        [cell setHaveReturn:self.haveReturn];
        
    }
    
    DomesticFlightDataDTO *model = [_showDataSource objectAtIndex:indexPath.row];
    
    [cell setConformLevel:model.conformLevel];
    
    [cell unfoldViewShow:model];
    
    [cell mainBtnRemoveTarget:self action:NULL forControlEvents:0];
    [cell mainBtnAddTarget:self action:@selector(pressMainBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell subjoinBtnRemoveTarget:self action:NULL forControlEvents:0];
    [cell subjoinBtnAddTarget:self action:@selector(pressSubjoinBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DomesticFlightDataDTO *model = [_showDataSource objectAtIndex:indexPath.row];
    if (model.MoreFlights == nil || [model.MoreFlights isKindOfClass:[NSNull class]]) {
        [[Model shareModel] showPromptText:@"没有更多仓位" model:NO];
        return;
    }
    BOOL unfold = [model.unfold boolValue];
    model.unfold = [NSNumber numberWithBool:!unfold];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark --点击预定按钮

- (void)pressMainBtn:(CustomBtn *)sender
{
    DomesticFlightDataDTO *flight = [_showDataSource objectAtIndex:sender.indexPath.row];
    
    if ([self checkOrderStatusWithCorpPolicy:flight withObject:sender]) {
        
        if (self.isReturnPickerController) {
            [self popViewControllerTransitionType:TransitionNone completionHandler:^{
                NSDictionary *flightData = [NSDictionary dictionaryWithObjectsAndKeys:
                                            flight,          @"flight",
                                            nil];
                [self.delegate returnTicketPickerFinished:[self getRouteEntityWithData:flightData]];
            }];
        }else if (self.haveReturn){
            NSDictionary *flightData = [NSDictionary dictionaryWithObjectsAndKeys:
                                        flight,         @"flight",
                                        nil];
            _firstFlightData = [self getRouteEntityWithData:flightData];
            AirListViewController *airListView = [[AirListViewController alloc]init];
            [airListView setDelegate:self];
            [airListView setIsReturnPickerController:YES];
            [airListView setBookType:[self bookType]];
            [airListView setGetFlightsRequest:self.getReturnFlightsRequest];
            [airListView setPolicyData:[self currentPolicy]];
            [self pushViewController:airListView transitionType:TransitionPush completionHandler:^{
                [airListView showViewContent];
            }];
        }else{
            NSDictionary *flightData = [NSDictionary dictionaryWithObjectsAndKeys:
                                        flight,         @"flight",
                                        nil];
            _firstFlightData = [self getRouteEntityWithData:flightData];
            [self goToOrderFillView];
        }
    }
}

- (void)pressSubjoinBtn:(CustomBtn *)sender
{
    DomesticFlightDataDTO *mainFlight = [_showDataSource objectAtIndex:sender.indexPath.row];
    DomesticFlightDataDTO *flight = [mainFlight.MoreFlights objectAtIndex:(sender.tag - 200)];
    if ([self checkOrderStatusWithCorpPolicy:flight withObject:sender]) {
        if (self.isReturnPickerController) {
            [self popViewControllerTransitionType:TransitionNone completionHandler:^{
                NSDictionary *flightData = [NSDictionary dictionaryWithObjectsAndKeys:
                                            flight,          @"flight",
                                            nil];
                [self.delegate returnTicketPickerFinished:[self getRouteEntityWithData:flightData]];
            }];
        }else if (self.haveReturn){
            NSDictionary *flightData = [NSDictionary dictionaryWithObjectsAndKeys:
                                        flight,         @"flight",
                                        nil];
            _firstFlightData = [self getRouteEntityWithData:flightData];
            AirListViewController *airListView = [[AirListViewController alloc]init];
            [airListView setDelegate:self];
            [airListView setIsReturnPickerController:YES];
            [airListView setBookType:[self bookType]];
            [airListView setGetFlightsRequest:self.getReturnFlightsRequest];
            [airListView setPolicyData:[self currentPolicy]];
            [self pushViewController:airListView transitionType:TransitionPush completionHandler:^{
                [airListView showViewContent];
            }];
        }else{
            NSDictionary *flightData = [NSDictionary dictionaryWithObjectsAndKeys:
                                        flight,         @"flight",
                                        nil];
            _firstFlightData = [self getRouteEntityWithData:flightData];
            [self goToOrderFillView];
        };
    }
}

- (void)goToOrderFillView
{
    SubmitFlightOrderRequest *request = [self getSaveOrderRequest];
    if (_secondFlightData) {
        request.Flights.SecondRoute = _secondFlightData;
        DomesticFlightDataDTO *firstFlight = _secondFlightData.Flight;
        
        NSString *DcityAportCode = firstFlight.Dairport.Airport;
        NSString *DcityName      = firstFlight.Dairport.CityName;
        request.Flights.DepartCity2       = [NSArray arrayWithObjects:DcityAportCode,DcityName,DcityName, nil];
        
        NSString *AcityAportCode = firstFlight.Aairport.Airport;
        NSString *AcityName      = firstFlight.Aairport.CityName;
        request.Flights.ArriveCity2       = [NSArray arrayWithObjects:AcityAportCode,AcityName,AcityName, nil];
        
        request.Flights.DepartDate2 = firstFlight.TakeOffDate;
    }
    [request setPassengers:[self getPassengers]];
    OrderFillInViewController *orderFillInView = [[OrderFillInViewController alloc]initWithRequest:request corpPolicy:_corpPolicy];
    [orderFillInView setPassengers:self.passengers];
    [orderFillInView setPolicyExecutor:[self currentPolicy]];
    [self pushViewController:orderFillInView transitionType:TransitionPush completionHandler:^{
//        [self.requestManager sendRequest:request];
    }];
}

- (BOOL)checkOrderStatusWithCorpPolicy:(DomesticFlightDataDTO*)flight withObject:(id)object
{
    BOOL conformPolicy = NO;
    NSDate *flightDate = [Utils dateWithString:[flight.TakeOffDate stringByAppendingFormat:@" %@",flight.TakeOffTime] withFormat:@"yyyy-MM-dd HH:mm"];
    if ([flightDate timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) {
        [[Model shareModel] showPromptText:@"不能订购今天以前的票" model:YES];
        return NO;
    }else{
        if ([_feeType isEqualToString:FeeTypeOWN]) {
            conformPolicy = YES;
            return conformPolicy;
        }else if ([flightDate timeIntervalSince1970] >= [self.takeOffDate timeIntervalSince1970] - [_corpPolicy.PreMinute integerValue] * 60 && [flightDate timeIntervalSince1970] <= [self.takeOffDate timeIntervalSince1970] + [_corpPolicy.PreMinute integerValue] * 60) {
            conformPolicy = NO;
            
            for (DomesticFlightDataDTO *flight in _conformPolicies) {
                if ([flight.conformLevel isEqualToString:@"B"]) {
                    [_policyIllegalView setFlight:flight];
                }
            }
            
            PolicyIllegalType illegalType = PolicyIllegalNone;
            
            NSDate *prevOrderDate = [Utils dateWithString:[Utils stringWithDate:[[NSDate date] dateByAddingTimeInterval:3 * 24 * 60 * 60] withFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];
            if ([[Utils dateWithString:flight.TakeOffDate withFormat:@"yyyy-MM-dd"] timeIntervalSince1970] < [prevOrderDate timeIntervalSince1970]) {
                illegalType = PolicyIllegalDate;
            }
            
            if (![flight.conformLevel isEqualToString:@"B"]) {
                if (illegalType == PolicyIllegalDate) {
                    illegalType = PolicyIllegalDateAndPrice;
                }else{
                    illegalType = PolicyIllegalPrice;
                }
            }
            if (illegalType == PolicyIllegalNone){
                conformPolicy = YES;
            }else{
                [_policyIllegalView fireWithIllegalType:illegalType corpPolicy:_corpPolicy];
            }
        }else{
            NSString *prevDate = [Utils stringWithDate:[self.takeOffDate dateByAddingTimeInterval:-60 * 60] withFormat:@"HH:mm"];
            NSString *nextDate = [Utils stringWithDate:[self.takeOffDate dateByAddingTimeInterval:60 * 60] withFormat:@"HH:mm"];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"您选择的出发时间为%@,根据贵公司差旅政策规定,您必须选择出发时间为%@-%@范围内的航班.请修改航班或出发时间.",_getFlightsRequest.DepartTime, prevDate, nextDate] delegate:self cancelButtonTitle:@"返回重选" otherButtonTitles:@"修改出发时间", nil];
            [alertView setTag:999];
            [alertView show];
        }
    }
    
    return conformPolicy;
}

- (RouteEntity*)getRouteEntityWithData:(NSDictionary*)data
{
    RouteEntity *routeEntity = [[RouteEntity alloc]init];
    ReasonCodeDTO *PreBookReasonCodeN = [data objectForKey:@"PreBookReasonCodeN"];
    ReasonCodeDTO *FltPricelReasonCodeN = [data objectForKey:@"FltPricelReasonCodeN"];
    DomesticFlightDataDTO *flight = [data objectForKey:@"flight"];
    if (PreBookReasonCodeN) {
        routeEntity.RCofDays = [NSString stringWithFormat:@"%@",PreBookReasonCodeN.RID];
        routeEntity.RCofDaysCode = PreBookReasonCodeN.ReasonCode;
    }if (FltPricelReasonCodeN) {
        routeEntity.RCofPrice = [NSString stringWithFormat:@"%@",FltPricelReasonCodeN.RID];
        routeEntity.RCofPriceCode = FltPricelReasonCodeN.ReasonCode;
    }
    if (!flight) {
        [[Model shareModel]showPromptText:@"未找到航班信息" model:YES];
        return nil;
    }
    routeEntity.Flight = flight;
    routeEntity.Flight.MoreFlights = nil;
    routeEntity.LowestPrice = [self getCheapestFlight].Price;
    
    return routeEntity;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %d",buttonIndex);
    switch (buttonIndex) {
        case 1:{
            [_takeOffTimeView fire];
            break;
        }
        default:
            break;
    }
}

#pragma mark - airlist order return ticket handle
- (void)returnTicketPickerFinished:(RouteEntity*)flightData
{
    _secondFlightData = flightData;
    [self goToOrderFillView];
}

- (void)returnTicketPickerCancel
{
    
}

#pragma mark - takeoff time picker handle
- (void)takeOffTimePickerFinished:(NSString*)time
{
    [_getFlightsRequest setDepartTime:time];
    [self tableViewReloadData:_theTableView];
}

- (void)takeOffTimePickerCancel
{
    [self tableViewReloadData:_theTableView];
}

#pragma mark - policy illegal reason picker handle
- (void)PolicyIllegalReasonPickerFinished:(NSDictionary*)RCData
{
    //    DomesticFlightDataDTO *flight = [RCData objectForKey:@"flight"];
    if (self.isReturnPickerController) {
        [self popViewControllerTransitionType:TransitionNone completionHandler:^{
            [self.delegate returnTicketPickerFinished:[self getRouteEntityWithData:RCData]];
        }];
    }else if (self.haveReturn){
        _firstFlightData = [self getRouteEntityWithData:RCData];
        AirListViewController *airListView = [[AirListViewController alloc]init];
        [airListView setDelegate:self];
        [airListView setIsReturnPickerController:YES];
        [airListView setBookType:[self bookType]];
        [airListView setGetFlightsRequest:self.getReturnFlightsRequest];
        [airListView setPolicyData:[self currentPolicy]];
        [self pushViewController:airListView transitionType:TransitionPush completionHandler:^{
            [airListView showViewContent];
        }];
    }else{
        _firstFlightData = [self getRouteEntityWithData:RCData];
        [self goToOrderFillView];
    }
}

- (void)PolicyIllegalReasonPickerCancel
{
    
}

- (void)submitFlightOrderDone:(SubmitFlightOrderResponse*)response
{
    
}

- (DomesticFlightDataDTO*)getCheapestFlight
{
    DomesticFlightDataDTO *flight = nil;
    for (DomesticFlightDataDTO *object in _conformPolicies) {
        if ([object.conformLevel isEqualToString:@"B"]) {
            flight = object;
            break;
        }
    }
    return flight;
}

- (SubmitFlightOrderRequest*)getSaveOrderRequest
{
    SubmitFlightOrderRequest *request = [[SubmitFlightOrderRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"SaveOnlineOrder"];
    request.DeliveryType.IsNeed = [NSNumber numberWithBool:0];
    request.DeliveryType.Province = [NSNumber numberWithInt:0];
    
#define ZERO [NSNumber numberWithInt:0]
    
    request.DeliveryType.AddID = ZERO;
    request.DeliveryType.Address = @"0";
    request.DeliveryType.RecipientName = @"0";
    request.DeliveryType.ZipCode = @"0";
    request.DeliveryType.City   = ZERO;
    request.DeliveryType.Canton = ZERO;
    
    DomesticFlightDataDTO *firstFlight = _firstFlightData.Flight;
    
    NSString *DcityAportCode = firstFlight.Dairport.Airport;
    NSString *DcityName      = firstFlight.Dairport.CityName;
    request.Flights.DepartCity1       = [NSArray arrayWithObjects:DcityAportCode,DcityName,DcityName, nil];
    
    NSString *AcityAportCode = firstFlight.Aairport.Airport;
    NSString *AcityName      = firstFlight.Aairport.CityName;
    request.Flights.ArriveCity1       = [NSArray arrayWithObjects:AcityAportCode,AcityName,AcityName, nil];
    
    request.Flights.DepartDate1 = firstFlight.TakeOffDate;
    
    request.Flights.ClassType = firstFlight.Class;
    
    request.Flights.PassengerQuantity = [NSNumber numberWithInt:[[self getPassengers] count]];
    
    request.Flights.FeeType = _feeType;
    
    request.Flights.BookingType = _bookType;
    
    request.Flights.SearchType = _searchType;
    
    request.Flights.Airline = firstFlight.AirLine.AirLine;
    
    request.Flights.PassengerType = firstFlight.PassengerType;
    
    request.Flights.RouteIndex = firstFlight.RouteIndex;
        
    request.Flights.FirstRoute = _firstFlightData;
    
    
//    request.Contacts = [OnlineContactDTO getOnlineContactWithData:[self currentPolicy]];
//    request.Contacts.UserName = @"马宏亮";
//    request.Contacts.Mobilephone = @"15000609705";
//    request.Contacts.ConfirmType = [NSNumber numberWithInt:0];
    
    request.PayType = @"第三方支付";
    request.Addition = @"";
    
    id policyData = [self currentPolicy];
    NSArray *keys = @[@"UID",@"PolicyID",@"PolicyUID"];
    for (NSString *key in keys) {
        NSString *conformKey = nil;
        if ([policyData isKindOfClass:[BookPassengersResponse class]]) {
            if ([key isEqualToString:@"UID"]) {
                conformKey = @"CorpUID";
            }else if ([key isEqualToString:@"PolicyUID"]){
                conformKey = @"CorpUID";
            }
        }
        SEL selector = NSSelectorFromString(conformKey?conformKey:key);
        if ([policyData respondsToSelector:selector]) {
            id value = [policyData performSelector:selector];
            NSError *error;
            if ([request validateValue:&value forKey:key error:&error]) {
                [request setValue:value forKey:key];
            }
        }
        
    }
    
    //    request.UID  = [UserDefaults shareUserDefault].loginInfo.UID;//[UserDefaults shareUserDefault].loginInfo.UID;
    //    request.CorpID = [[UserDefaults shareUserDefault].loginInfo.CorpID stringValue];
    //    request.PolicyID = [[UserDefaults shareUserDefault].loginInfo.PolicyID stringValue];
    //    request.PolicyUID = [UserDefaults shareUserDefault].loginInfo.UID;
    request.CorpID = [NSString stringWithFormat:@"%@",self.corpPolicy.CorpID];
    request.ServerFrom = deviceId;
    request.MailCode = [NSNumber numberWithInteger:0];
    
    return request;
}

- (NSArray*)getPassengers
{
    NSArray *onlinePassengers = [OnlinePassengersDTO getOnlinePassengersWithData:self.passengers];
    
    return onlinePassengers;
}

- (BOOL)haveReturn
{
    if (_getReturnFlightsRequest) {
        _haveReturn = YES;
    }else{
        _haveReturn = NO;
    }
    return _haveReturn;
}

- (void)changeTakeOffDate:(UIButton*)sender
{
    NSString *year = [Utils formatDateWithString:_getFlightsRequest.DepartDate startFormat:@"yyyy-MM-dd" endFormat:@"yyyy"];
    NSDate *takeOffDate = [Utils dateWithString:_dateLabel.titleLabel.text withFormat:@"MM月dd日"];

    switch (sender.tag) {
        case 300:{
            takeOffDate = [takeOffDate dateByAddingTimeInterval:-24 * 60 * 60];
            break;
        }case 301:{
            takeOffDate = [takeOffDate dateByAddingTimeInterval:24 * 60 * 60];
            break;
        }
        default:
            break;
    }
    NSString *monthAndDay = [NSString stringWithFormat:@"-%@",[Utils stringWithDate:takeOffDate withFormat:@"MM-dd"]];
    year = [year stringByAppendingString:monthAndDay];
    
    if ([[Utils dateWithString:year withFormat:@"yyyy-MM-dd"] timeIntervalSince1970] < [[NSDate date] timeIntervalSince1970]) {
        [[Model shareModel] showPromptText:@"不能订购今天以前的票" model:YES];
        return;
    }
    [_getFlightsRequest setDepartDate:year];
    [self getAirListWithRequest:_getFlightsRequest];
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(returnBtn) + 10, 0, self.topBar.frame.size.width/2 - 10 - controlXLength(returnBtn), self.topBar.frame.size.height/2)];
    [_titleLabel setAutoSize:YES];
    [_titleLabel setTextColor:color(whiteColor)];
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, controlYLength(_titleLabel), _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
    [_detailLabel setFont:[UIFont systemFontOfSize:13]];
    [_detailLabel setAutoSize:YES];
    [_detailLabel setTextColor:color(whiteColor)];
    [self.view addSubview:_detailLabel];
    
    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn.titleLabel setAutoSize:YES];
    [prevBtn setImage:imageNameAndType(@"button_date-left", nil) forState:UIControlStateNormal];
    [prevBtn setFrame:CGRectMake(controlXLength(_titleLabel) + 10, 7.5, (self.topBar.frame.size.width/2 - 20)/5, self.topBar.frame.size.height - 15)];
    [prevBtn setTag:300];
    [prevBtn addTarget:self action:@selector(changeTakeOffDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prevBtn];
    
    _dateLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dateLabel setFrame:CGRectMake(controlXLength(prevBtn), prevBtn.frame.origin.y, prevBtn.frame.size.width * 3, prevBtn.frame.size.height)];
    [_dateLabel setBackgroundImage:imageNameAndType(@"bg_date", nil) forState:UIControlStateDisabled];
    [_dateLabel setEnabled:NO];
    [_dateLabel.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_dateLabel.titleLabel setAutoSize:YES];
    [_dateLabel.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateLabel.titleLabel setTextColor:color(whiteColor)];
    [self.view addSubview:_dateLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn.titleLabel setAutoSize:YES];
    [nextBtn setImage:imageNameAndType(@"button_date-right", nil) forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(controlXLength(_dateLabel), prevBtn.frame.origin.y, prevBtn.frame.size.width, prevBtn.frame.size.height)];
    [nextBtn setTag:301];
    [nextBtn addTarget:self action:@selector(changeTakeOffDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)showSubjoinView
{
    if (!_fltPolicyTitleLabel) {
        [self setSubjoinViewFrame];
    }
    
    [_detailLabel setText:[NSString stringWithFormat:@"%d个航班",[_showDataSource count]]];
    BOOL insurance = [_corpPolicy.Insurance isEqualToString:@"T"];
    BOOL isFltDiscountRC = [_corpPolicy.IsFltDiscountRC isEqualToString:@"T"];
    [_fltPolicyTitleLabel setText:[NSString stringWithFormat:@"%@:提前%@天预订,出发时间前后%@分钟内最低价航班%@,%@允许买保险.",_corpPolicy.PolicyName,_corpPolicy.FltPreBookDays,_corpPolicy.PreMinute,isFltDiscountRC?[NSString stringWithFormat:@",%@折以下航班",_corpPolicy.FltDiscountRC]:@",无折扣限制",insurance?@"":@"不"]];
}

- (void)setSubjoinViewFrame
{
    
    CGFloat fliPolicyHeight = [Utils heightForWidth:self.view.frame.size.width - 20 text:_corpPolicy.FltPolicyTitle font:[UIFont systemFontOfSize:13]] > 35?[Utils heightForWidth:self.view.frame.size.width - 20 text:_corpPolicy.FltPolicyTitle font:[UIFont systemFontOfSize:13]]:35;
    _fltPolicyTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar), self.view.frame.size.width - 20, fliPolicyHeight)];
    [_fltPolicyTitleLabel setBackgroundColor:color(clearColor)];
    [_fltPolicyTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [_fltPolicyTitleLabel setFont:[UIFont systemFontOfSize:13]];
    [_fltPolicyTitleLabel setNumberOfLines:0];
    [_fltPolicyTitleLabel setAutoBreakLine:YES];
    [_fltPolicyTitleLabel setTextColor:color(colorWithRed:50.0/255.0 green:70.0/255.0 blue:140.0/255.0 alpha:1)];
    [self.view addSubview:_fltPolicyTitleLabel];
    
    UIView *titleBtnBG = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(_fltPolicyTitleLabel), self.view.frame.size.width, 40)];
    [titleBtnBG setBackgroundColor:color(whiteColor)];
    [self.view addSubview:titleBtnBG];
    
    AirListCustomBtn *dateCompareBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(10, 5 + controlYLength(_fltPolicyTitleLabel), self.view.frame.size.width/4, 30)];
    [dateCompareBtn setTitle:@"时间"];
    [dateCompareBtn setBackgroundImage:imageNameAndType(@"button_style2", nil) forState:UIControlStateNormal];
    [dateCompareBtn setSubjoinImage:imageNameAndType(@"icon_arrow1", nil)];
    [dateCompareBtn setSubjoinHighlightedImage:imageNameAndType(@"icon_arrow2", nil)];
    [dateCompareBtn addTarget:self action:@selector(pressDateCompareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateCompareBtn];
    
    AirListCustomBtn *priceCompareBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(controlXLength(dateCompareBtn) + 10, dateCompareBtn.frame.origin.y, dateCompareBtn.frame.size.width, dateCompareBtn.frame.size.height)];
    [priceCompareBtn setTitle:@"价格"];
    [priceCompareBtn setBackgroundImage:imageNameAndType(@"button_style1", nil) forState:UIControlStateNormal];
    [priceCompareBtn setSubjoinImage:imageNameAndType(@"icon_arrow1", nil)];
    [priceCompareBtn setSubjoinHighlightedImage:imageNameAndType(@"icon_arrow2", nil)];
    [priceCompareBtn addTarget:self action:@selector(pressPriceCompareBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:priceCompareBtn];
    
    AirListCustomBtn *filterBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(self.view.frame.size.width - controlXLength(dateCompareBtn), dateCompareBtn.frame.origin.y, dateCompareBtn.frame.size.width, dateCompareBtn.frame.size.height)];
    [filterBtn setTitle:@"筛选"];
    [filterBtn setBackgroundImage:imageNameAndType(@"button_style1", nil) forState:UIControlStateNormal];
    [filterBtn setSubjoinImage:imageNameAndType(@"icon_screening", nil)];
    //[dateCompareBtn setSubjoinHighlightedImage:imageNameAndType(@"icon_screening", nil)];
    [filterBtn addTarget:self action:@selector(pressFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterBtn];
    
    UIImageView *titleImage = [self createLineWithParam:imageNameAndType(@"shadow", nil) frame:CGRectMake(0, controlYLength(dateCompareBtn) + 5, self.contentView.frame.size.width, 15)];
    [titleImage setBackgroundColor:color(whiteColor)];
    [self.view addSubview:titleImage];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(titleImage), self.contentView.frame.size.width, self.contentView.frame.size.height - 40 - controlYLength(titleImage))];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setDataSource:self];
    [_theTableView setDelegate:self];
    [self.contentView addSubview:_theTableView];
}

#pragma mark - compare handle
- (void)pressDateCompareBtn:(AirListCustomBtn*)sender
{
    NSComparator comparator;
    if (sender.subjoinImageView.highlighted) {
        
        comparator = ^(DomesticFlightDataDTO *value1,DomesticFlightDataDTO *value2){
            NSDate *prevDate = [Utils dateWithString:[value1.TakeOffDate stringByAppendingFormat:@" %@",value1.TakeOffTime] withFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *nextDate = [Utils dateWithString:[value2.TakeOffDate stringByAppendingFormat:@" %@",value2.TakeOffTime] withFormat:@"yyyy-MM-dd HH:mm"];
            if ([prevDate timeIntervalSince1970] < [nextDate timeIntervalSince1970]) {
                return NSOrderedAscending;
            }else if ([prevDate timeIntervalSince1970] > [nextDate timeIntervalSince1970]){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
            return 0;
        };
    }else{
        comparator = ^(DomesticFlightDataDTO *value1,DomesticFlightDataDTO *value2){
            NSDate *prevDate = [Utils dateWithString:[value1.TakeOffDate stringByAppendingFormat:@" %@",value1.TakeOffTime] withFormat:@"yyyy-MM-dd HH:mm"];
            NSDate *nextDate = [Utils dateWithString:[value2.TakeOffDate stringByAppendingFormat:@" %@",value2.TakeOffTime] withFormat:@"yyyy-MM-dd HH:mm"];
            if ([prevDate timeIntervalSince1970] < [nextDate timeIntervalSince1970]) {
                return NSOrderedDescending;
            }else if ([prevDate timeIntervalSince1970] > [nextDate timeIntervalSince1970]){
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
            return 0;
        };
    }
    [_showDataSource sortUsingComparator:comparator];
    [self tableViewReloadData:_theTableView];
}

- (void)pressPriceCompareBtn:(AirListCustomBtn*)sender
{
    NSComparator comparator;
    if (sender.subjoinImageView.highlighted) {
        comparator = ^(DomesticFlightDataDTO *value1, DomesticFlightDataDTO *value2){
            if ([value1.Price floatValue] < [value2.Price floatValue]) {
                return NSOrderedAscending;
            }else if ([value1.Price floatValue] > [value2.Price floatValue]){
                return NSOrderedDescending;
            }else{
                return NSOrderedSame;
            }
            return 0;
        };
    }else{
        comparator = ^(DomesticFlightDataDTO *value1, DomesticFlightDataDTO *value2){
            if ([value1.Price floatValue] < [value2.Price floatValue]) {
                return NSOrderedDescending;
            }else if ([value1.Price floatValue] > [value2.Price floatValue]){
                return NSOrderedAscending;
            }else{
                return NSOrderedSame;
            }
            return 0;
        };
    }
    [_showDataSource sortUsingComparator:comparator];
    [self tableViewReloadData:_theTableView];
}

- (void)siftDone:(NSDictionary *)params
{
    NSString *seatTypeStr = [params objectForKey:@"seatType"];
    NSArray *airCompanyStr = [params objectForKey:@"airCompany"];
    
    if (![seatTypeStr isEqualToString:@"不限"] || ![airCompanyStr containsObject:@"不限"]) {
        [_showDataSource removeAllObjects];
        
        if (![seatTypeStr isEqualToString:@"不限"]) {
            for (DomesticFlightDataDTO *flight in _dataSource) {
                if ([[flight.Class uppercaseString] rangeOfString:[seatTypeStr uppercaseString]].length != 0) {
                    [_showDataSource addObject:flight];
                }
            }
        }else{
            [_showDataSource addObjectsFromArray:_dataSource];
        }
        NSMutableArray *elemArray = [NSMutableArray array];
        if (![airCompanyStr containsObject:@"不限"]) {
            
         
                for (NSUInteger i = 0; i < [airCompanyStr count]; i++) {
                    
                    NSString *airCompanyName = [airCompanyStr objectAtIndex:i];
                    
                    for (DomesticFlightDataDTO *flight in _showDataSource) {
                        
                        if ( [flight.AirLine.ShortName isEqualToString:airCompanyName]){
                            
                            [elemArray addObject:flight];
                        }
                    }
                    
                }
            
            _showDataSource = elemArray;
        }
    }else{
        [_showDataSource addObjectsFromArray:_dataSource];
    }
    
    [self tableViewReloadData:_theTableView];
}


#pragma mark --点击筛选按钮

- (void)pressFilterBtn:(AirListCustomBtn*)sender
{
    FlightSiftViewController *viewController = [[FlightSiftViewController alloc]init];
    [viewController setDelegate:self];
    
#pragma mark --本次查询的航空公司名字(不重复)
    for (NSUInteger i = 0;i <  _dataSource.count; i++) {
        DomesticFlightDataDTO *flight = [_dataSource objectAtIndex:i];
        NSString *airLineName = flight.AirLine.ShortName;
        
        if ( ![viewController.airCompanyBtnArray containsObject:airLineName] ){
            [viewController.airCompanyBtnArray addObject:airLineName];
        }
    }
 
    
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
}

- (NSDate *)takeOffDate
{
    NSMutableString *dateString = [NSMutableString stringWithString:_getFlightsRequest.DepartDate];
    if (_getFlightsRequest.DepartTime) {
        [dateString appendFormat:@" %@",_getFlightsRequest.DepartTime];
    }
    
    return [Utils dateWithString:dateString withFormat:@"yyyy-MM-dd HH:mm"];
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

@end

@interface AirListViewCell ()

@property (strong, nonatomic) UILabel           *haveMoreFlightsLb;
@property (strong, nonatomic) UIView            *unfoldView;
@property (assign, nonatomic) BOOL              *haveMoreFlights;

@property (strong, nonatomic) NSMutableArray    *subjoinBtnArray;

@property (strong, nonatomic) UILabel           *cheapestLb;
@property (strong, nonatomic) UIImageView       *lineNumLeft;

@end

@implementation AirListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _haveMoreFlights = NO;
        _subjoinBtnArray = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

- (void)mainBtnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *mainBtn = (UIButton*)[self.contentView viewWithTag:100];
    [mainBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)mainBtnRemoveTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UIButton *mainBtn = (UIButton*)[self.contentView viewWithTag:100];
    [mainBtn removeTarget:target action:action forControlEvents:controlEvents];
}

- (void)subjoinBtnAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    for (UIButton *btn in _subjoinBtnArray) {
        [btn addTarget:target action:action forControlEvents:controlEvents];
    }
}

- (void)subjoinBtnRemoveTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    for (UIButton *btn in _subjoinBtnArray) {
        [btn removeTarget:target action:action forControlEvents:controlEvents];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    if (_indexPath != indexPath) {
        _indexPath = indexPath;
    }
    CustomBtn *mainBtn = (CustomBtn*)[self.contentView viewWithTag:100];
    [mainBtn setIndexPath:indexPath];
    for (CustomBtn *btn in _subjoinBtnArray) {
        [btn setIndexPath:indexPath];
    }
}

- (void)setConformLevel:(NSString*)level
{
    [self isCheapest:NO];
    if ([level isEqualToString:@"T"]) {
        [self setBackgroundColor:color(colorWithRed:250.0/255.0 green:240.0/255.0 blue:210.0/255.0 alpha:1)];
    }else if ([level isEqualToString:@"B"]){
        [self setBackgroundColor:color(yellowColor)];
        [self isCheapest:YES];
    }else if ([level isEqualToString:@"F"]){
        [self setBackgroundColor:color(clearColor)];
    }
}

- (void)isCheapest:(BOOL)cheapest
{
    [_cheapestLb setHidden:!cheapest];
}

- (void)isShow:(BOOL)show
{
    UIView *doneBtn = [self.contentView viewWithTag:100];
    [doneBtn setHidden:show];
    [self isCheapest:YES];
    if (show) {
        [_cheapestLb setFrame:CGRectMake(_cheapestLb.frame.origin.x, (AirListViewCellHeight/2)- (_cheapestLb.frame.size.height/2), _cheapestLb.frame.size.width, _cheapestLb.frame.size.height)];
    }else{
        [_cheapestLb setFrame:CGRectMake(_cheapestLb.frame.origin.x, AirListViewCellHeight/2 - 35, _cheapestLb.frame.size.width, _cheapestLb.frame.size.height)];
    }
}

- (void)setHaveReturn:(BOOL)haveReturn
{
    CustomBtn *doneBtn = (CustomBtn*)[self.contentView viewWithTag:100];
    _haveReturn = haveReturn;
    if (_haveReturn) {
        [doneBtn setTitle:@"预订返程" forState:UIControlStateNormal];
    }else{
        [doneBtn setTitle:@"预订" forState:UIControlStateNormal];
    }
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _startTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, AirListViewCellHeight/2 - 25, appFrame.size.width/5, 30)];
    [_startTimeLb setTextColor:color(colorWithRed:0.0 green:90.0/255.0 blue:180.0/255.0 alpha:1)];
    [_startTimeLb setTextAlignment:NSTextAlignmentCenter];
    [_startTimeLb setFont:[UIFont systemFontOfSize:17]];
    [_startTimeLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"HH:mm"]];
    [_startTimeLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_startTimeLb];
    
    _endTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(_startTimeLb) - 10, _startTimeLb.frame.size.width, _startTimeLb.frame.size.height)];
    [_endTimeLb setTextColor:color(darkGrayColor)];
    [_endTimeLb setTextAlignment:NSTextAlignmentCenter];
    [_endTimeLb setFont:[UIFont systemFontOfSize:12]];
    [_endTimeLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"HH:mm"]];
    [_endTimeLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_endTimeLb];
    
    _lineNumLeft = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_startTimeLb), 5, (AirListViewCellHeight - 10)/3, (AirListViewCellHeight - 10)/3)];
    [_lineNumLeft setImage:imageNameAndType(@"logo_fm@2x", Nil)];
    [_lineNumLeft setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_lineNumLeft];
    _lineNumLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_lineNumLeft), _lineNumLeft.frame.origin.y, (appFrame.size.width - controlXLength(_lineNumLeft))/2, _lineNumLeft.frame.size.height)];
    [_lineNumLb setTextColor:color(darkGrayColor)];
    [_lineNumLb setFont:[UIFont systemFontOfSize:11]];
    [_lineNumLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_lineNumLb];
    
    _fromAndToLb = [[UILabel alloc]initWithFrame:CGRectMake(_lineNumLeft.frame.origin.x, controlYLength(_lineNumLeft), _lineNumLb.frame.size.width + _lineNumLeft.frame.size.width, _lineNumLb.frame.size.height)];
    [_fromAndToLb setFont:[UIFont systemFontOfSize:11]];
    [_fromAndToLb setAutoSize:YES];
    [_fromAndToLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_fromAndToLb];
    
    _recommonSeatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(_fromAndToLb.frame.origin.x, controlYLength(_fromAndToLb), _fromAndToLb.frame.size.width/2, _fromAndToLb.frame.size.height)];
    [_recommonSeatTypeLb setFont:[UIFont systemFontOfSize:11]];
    [_recommonSeatTypeLb setAutoSize:YES];
    [_recommonSeatTypeLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_recommonSeatTypeLb];
    
    _virginiaTicketLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_recommonSeatTypeLb), _recommonSeatTypeLb.frame.origin.y, _recommonSeatTypeLb.frame.size.width, _recommonSeatTypeLb.frame.size.height)];
    //    [_virginiaTicketLb setTextAlignment:NSTextAlignmentRight];
    [_virginiaTicketLb setFont:[UIFont systemFontOfSize:12]];
    [_virginiaTicketLb setTextColor:color(darkGrayColor)];
    [_virginiaTicketLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_virginiaTicketLb];
    
    _ticketPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_fromAndToLb), _lineNumLb.center.y, (appFrame.size.width - controlXLength(_fromAndToLb))*2/5, _fromAndToLb.frame.size.height)];
    [_ticketPriceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_ticketPriceLb setFont:[UIFont systemFontOfSize:12]];
    [_ticketPriceLb setTextAlignment:NSTextAlignmentCenter];
    [_ticketPriceLb setAutoSize:YES];
    [_ticketPriceLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_ticketPriceLb];
    
    _discountLb = [[UILabel alloc]initWithFrame:CGRectMake(_ticketPriceLb.frame.origin.x, controlYLength(_ticketPriceLb), _ticketPriceLb.frame.size.width, _ticketPriceLb.frame.size.height)];
    [_discountLb setTextColor:color(grayColor)];
    [_discountLb setFont:[UIFont systemFontOfSize:12]];
    [_discountLb setTextAlignment:NSTextAlignmentCenter];
    [_discountLb setAutoSize:YES];
    [_discountLb setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_discountLb];
    
    _cheapestLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_ticketPriceLb), AirListViewCellHeight/2 - 35, appFrame.size.width - controlXLength(_ticketPriceLb), 25)];
    [_cheapestLb setTextColor:color(redColor)];
    [_cheapestLb setText:@"最便宜"];
    [_cheapestLb setTextAlignment:NSTextAlignmentCenter];
    [_cheapestLb setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_cheapestLb];
    
    CustomBtn *doneBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(_cheapestLb.frame.origin.x, AirListViewCellHeight/2 - 20, _cheapestLb.frame.size.width, 40)];
    [doneBtn setTitle:@"预定" forState:UIControlStateNormal];
    [doneBtn setTag:100];
    [doneBtn.titleLabel setAutoSize:YES];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [doneBtn setBounds:CGRectMake(0, 0, doneBtn.frame.size.width * 0.7, doneBtn.frame.size.height * 0.7)];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [doneBtn setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:doneBtn ];
    
    _haveMoreFlightsLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_discountLb), controlYLength(doneBtn), appFrame.size.width - controlXLength(_discountLb), AirListViewCellHeight - controlYLength(doneBtn))];
    [_haveMoreFlightsLb setBackgroundColor:color(clearColor)];
    [_haveMoreFlightsLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_haveMoreFlightsLb setTextAlignment:NSTextAlignmentCenter];
    [_haveMoreFlightsLb setFont:[UIFont systemFontOfSize:11]];
    [_haveMoreFlightsLb setAutoSize:YES];
    [self.contentView addSubview:_haveMoreFlightsLb];
}

- (void)createUnfoldViewWithParams:(DomesticFlightDataDTO*)param
{
    if (_unfoldView) {
        if (_unfoldView.superview) {
            [_unfoldView removeFromSuperview];
        }
        _unfoldView = nil;
    }
    if ([param.MoreFlights isKindOfClass:[NSNull class]] || param.MoreFlights == nil) {
        [[Model shareModel] showPromptText:@"没有更多仓位" model:YES];
        return;
    }
    NSInteger moreFlightsNum = [param.MoreFlights count];
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(0, AirListViewCellHeight, appFrame.size.width, AirListViewSubjoinCellHeight * moreFlightsNum)];
    [_unfoldView setBackgroundColor:color(colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1)];
    [_subjoinBtnArray removeAllObjects];
    for (int i = 0;i<moreFlightsNum;i++) {
        DomesticFlightDataDTO *flight = [param.MoreFlights objectAtIndex:i];
        AirListViewSubjoinCell *subjoinCell = [[AirListViewSubjoinCell alloc]initWithFrame:CGRectMake(0, AirListViewSubjoinCellHeight * i, appFrame.size.width, AirListViewSubjoinCellHeight)];
        [subjoinCell.doneBtn setTag:(200 + i)];
        [subjoinCell setHaveReturn:_haveReturn];
        [_subjoinBtnArray addObject:subjoinCell.doneBtn];
        [subjoinCell setViewContentWithParams:flight];
        [_unfoldView addSubview:subjoinCell];
    }
}

- (void)setViewContentWithParams:(DomesticFlightDataDTO *)params
{
    NSString *imageName = [NSString stringWithFormat:@"logo_%@",[params.AirlineCode lowercaseString]];
    [_lineNumLeft setImage:imageNameAndType(imageName, nil)];
    
    [_startTimeLb setText:params.TakeOffTime];
    [_endTimeLb setText:params.ArriveTime];
    [_lineNumLb setText:[NSString stringWithFormat:@"%@ %@",params.AirLine.ShortName,params.Flight]];
    [_fromAndToLb setText:[NSString stringWithFormat:@"%@ - %@",params.Dairport.AirportName,params.Aairport.AirportName]];
    [_recommonSeatTypeLb setText:[NSString stringWithFormat:@"%@/%@",params.Class,params.AirLine.FlightClass]];
    [_virginiaTicketLb setText:[NSString stringWithFormat:@"剩%@张",params.Quantity]];
    [_ticketPriceLb setText:[NSString stringWithFormat:@"¥%.2f",[params.Price floatValue]]];
    [_discountLb setText:[NSString stringWithFormat:@"%@",([params.Rate floatValue]) != 10.0f?[NSString stringWithFormat:@"%.2f折",[params.Rate floatValue]]:@"全价"]];
    
}

- (void)unfoldViewShow:(DomesticFlightDataDTO*)params
{
    BOOL haveMoreFlights = NO;
    if (params.MoreFlights != nil && ![params.MoreFlights isKindOfClass:[NSNull class]]) {
        haveMoreFlights = YES;
    }
    if (haveMoreFlights) {
        [_haveMoreFlightsLb setText:@"查看更多仓位"];
    }else
        [_haveMoreFlightsLb setText:nil];
    if ([params.unfold boolValue]) {
        if (_unfoldView.superview) {
            [_unfoldView removeFromSuperview];
        }
        [self createUnfoldViewWithParams:params];
        [self.contentView addSubview:_unfoldView];
    }else{
        if (_unfoldView.superview) {
            [_unfoldView removeFromSuperview];
        }
    }
    [self setViewContentWithParams:params];
}

@end

@interface AirListViewSubjoinCell ()

@property (strong, nonatomic) UILabel           *seatTypeLb;            //舱位类型
@property (strong, nonatomic) UILabel           *virginiaTicketLb;      //余票
@property (strong, nonatomic) UILabel           *priceLb;               //价格
@property (strong, nonatomic) UILabel           *discountLb;            //折扣

@end

@implementation AirListViewSubjoinCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    _seatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(appFrame.size.width/5, 0, appFrame.size.width/5, AirListViewSubjoinCellHeight/2)];
    [_seatTypeLb setFont:[UIFont systemFontOfSize:12]];
    [_seatTypeLb setAutoSize:YES];
    [_seatTypeLb setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_seatTypeLb];
    
    _virginiaTicketLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_seatTypeLb), _seatTypeLb.frame.origin.y, _seatTypeLb.frame.size.width, _seatTypeLb.frame.size.height)];
    [_virginiaTicketLb setTextAlignment:NSTextAlignmentCenter];
    [_virginiaTicketLb setFont:[UIFont systemFontOfSize:12]];
    [_virginiaTicketLb setAutoSize:YES];
    [_virginiaTicketLb setTextColor:color(grayColor)];
    [self addSubview:_virginiaTicketLb];
    
    _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_virginiaTicketLb), _virginiaTicketLb.frame.origin.y, _virginiaTicketLb.frame.size.width, _virginiaTicketLb.frame.size.height)];
    [_priceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_priceLb setTextAlignment:NSTextAlignmentCenter];
    [_priceLb setFont:[UIFont systemFontOfSize:12]];
    [_priceLb setAutoSize:YES];
    [self addSubview:_priceLb];
    
    _discountLb = [[UILabel alloc]initWithFrame:CGRectMake(_priceLb.frame.origin.x, controlYLength(_priceLb), _seatTypeLb.frame.size.width, _seatTypeLb.frame.size.height)];
    [_discountLb setTextAlignment:NSTextAlignmentCenter];
    [_discountLb setFont:[UIFont systemFontOfSize:12]];
    [_discountLb setAutoSize:YES];
    [_discountLb setTextColor:color(grayColor)];
    [self addSubview:_discountLb];
    
    
    _doneBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_doneBtn setFrame:CGRectMake(controlXLength(_priceLb), AirListViewSubjoinCellHeight/2 - 20, _priceLb.frame.size.width, 40)];
    [_doneBtn setTitle:@"预定" forState:UIControlStateNormal];
    [_doneBtn.titleLabel setAutoSize:YES];
    [_doneBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [_doneBtn setBounds:CGRectMake(0, 0, _doneBtn.frame.size.width * 0.7, _doneBtn.frame.size.height * 0.7)];
    [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_doneBtn];
}

- (void)setViewContentWithParams:(DomesticFlightDataDTO*)flight
{
    [_seatTypeLb setText:flight.Class];
    [_virginiaTicketLb setText:[NSString stringWithFormat:@"剩%@张",flight.Quantity]];
    [_priceLb setText:[NSString stringWithFormat:@"¥%.2f",[flight.Price floatValue]]];
    [_discountLb setText:[NSString stringWithFormat:@"%@",([flight.Rate floatValue]) != 10.0f?[NSString stringWithFormat:@"%.2f折",[flight.Rate floatValue]]:@"全价"]];
}

- (void)setHaveReturn:(BOOL)haveReturn
{
    _haveReturn = haveReturn;
    if (haveReturn) {
        [_doneBtn setTitle:@"预订返程" forState:UIControlStateNormal];
    }else{
        [_doneBtn setTitle:@"预订" forState:UIControlStateNormal];
    }
}

- (void)pressDoneBtn:(UIButton*)sender
{
    NSLog(@"done");
}

@end

@interface AirListCustomBtn ()

@property (strong, nonatomic) UILabel       *textLabel;

@end

@implementation AirListCustomBtn

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 2/3, self.frame.size.height)];
    [_textLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_textLabel];
    
    _subjoinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_textLabel) - 5, _textLabel.frame.origin.y, _textLabel.frame.size.height, _textLabel.frame.size.height)];
    [_subjoinImageView setBackgroundColor:color(clearColor)];
    [self addSubview:_subjoinImageView];
    
    [_subjoinImageView setScaleX:0.7 scaleY:0.7];
    self.highlighted = _subjoinImageView.highlighted;
    
    [self addTarget:self action:@selector(pressSelf:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressSelf:(UIButton*)sender
{
    [_subjoinImageView setHighlighted:!_subjoinImageView.highlighted];
    self.highlighted = _subjoinImageView.highlighted;
}

- (void)setSubjoinImage:(UIImage *)image
{
    [_subjoinImageView setImage:image];
}

- (void)setSubjoinHighlightedImage:(UIImage*)image
{
    [_subjoinImageView setHighlightedImage:image];
}

- (void)setTitle:(NSString *)title
{
    [_textLabel setText:title];
}

- (void)setFont:(UIFont *)font
{
    [_textLabel setFont:font];
}

@end
