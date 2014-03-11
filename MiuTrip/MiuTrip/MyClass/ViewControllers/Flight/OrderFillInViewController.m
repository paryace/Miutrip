//
//  OrderFillInViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-12-2.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "OrderFillInViewController.h"
#import "OrderResultViewController.h"
#import "BookPassengersDTO.h"
#import "GetNormalFlightsRequest.h"
#import "SubmitFlightOrderRequest.h"
#import "CommonlyNameViewController.h"
#import "AirListViewController.h"
#import "AppDelegate.h"
#import "GetFlightChangeRuleRequest.h"


@interface OrderFillInViewController ()

@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) UITableView           *theTableView;

@property (strong, nonatomic) PassengerListViewController *passengerListView;
@property (strong, nonatomic) GetCorpPolicyResponse *corpPolicy;

@property (strong, nonatomic) UIView                *subjoinView;

@property (strong, nonatomic) UILabel               *flightTimeLb1;          //起飞时间
@property (strong, nonatomic) UILabel               *fromAndToLb1;           //起始地&目的地
@property (strong, nonatomic) UILabel               *flightNumLb1;           //航班号
@property (strong, nonatomic) UILabel               *seatTypeLb1;            //舱位类型
@property (strong, nonatomic) UILabel               *priceLb1;               //价格

@property (strong, nonatomic) UILabel               *flightTimeLb2;          //起飞时间
@property (strong, nonatomic) UILabel               *fromAndToLb2;           //起始地&目的地
@property (strong, nonatomic) UILabel               *flightNumLb2;           //航班号
@property (strong, nonatomic) UILabel               *seatTypeLb2;            //舱位类型
@property (strong, nonatomic) UILabel               *priceLb2;               //价格

@property (strong, nonatomic) UILabel               *positionLb;            //乘机人职位
@property (strong, nonatomic) UILabel               *passengerNameLb;       //乘机人姓名

@property (strong, nonatomic) UITextField           *contactNameTf;         //联系人姓名
@property (strong, nonatomic) UITextField           *contactPhoneNumTf;     //联系人号码

@property (strong, nonatomic) UITextField           *postTypeTf;            //配送方式
@property (strong, nonatomic) UITextField           *postAddressTf;         //配送地址
@property (strong, nonatomic) UITextField           *payTypeTf;             //支付方式

@property (strong, nonatomic) UITextView            *detailTextTv;          //附加信息

@property (strong, nonatomic) OnlineContactDTO      *contact;

@property (strong, nonatomic) DomesticFlightDataDTO *firstFlight;
@property (strong, nonatomic) DomesticFlightDataDTO *secondFlight;
@property (strong, nonatomic) SubmitFlightOrderRequest *request;

@property (strong, nonatomic) NSMutableArray        *changeRules;
@property (strong, nonatomic) UILabel               *firstRuleLb;
@property (strong, nonatomic) UILabel               *secondRuleLb;

@end

@implementation OrderFillInViewController

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
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithRequest:(SubmitFlightOrderRequest *)request corpPolicy:(GetCorpPolicyResponse *)corpPolicy
{
    if (self = [super init]) {
        self.request = request;
        _corpPolicy = corpPolicy;
        //        self.flight = _request.Flights.FirstRoute.Flight;
        [self setSubviewFrame];
        [self getChangeRule];
    }
    return self;
}

#pragma mark - save order
- (void)saveOrder
{
    if ([self getOrderContent]) {
        BaseRequestModel *request = _request;
        //        _request.Flights.FirstRoute.Flight.Price =
        [self.requestManager sendRequest:request];
    }else{
        [[Model shareModel] showPromptText:@"请选择乘车人" model:YES];
    }
    
}

- (void)saveOrderDone:(SubmitFlightOrderResponse*)response
{
    OrderResultViewController *resultViewController = [[OrderResultViewController alloc]initWithParams:response];
    [self pushViewController:resultViewController transitionType:TransitionPush completionHandler:nil];
}

- (void)requestDone:(BaseResponseModel *)response
{
    
    if ([response isKindOfClass:[SubmitFlightOrderResponse class]]){
        [self saveOrderDone:(SubmitFlightOrderResponse*)response];
    }else if ([response isKindOfClass:[GetFlightChangeRuleResponse class]]){
        [self getChangeRuleDone:(GetFlightChangeRuleResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    //do request failed handle
}

#pragma mark - get order content method
- (BOOL)getOrderContent
{
    BOOL success = YES;
    
    
    [self getPassengerFromDataSource];
    [self getOrderDetail];
    
    if ([_request.Passengers count] == 0) {
        [[Model shareModel] showPromptText:@"请选择乘车人" model:YES];
        return NO;
    }
    if (![self getContact]) {
        return NO;
        
    }
    
    return success;
}

- (void)getPassengerFromDataSource
{
    _request.Passengers = [OnlinePassengersDTO getOnlinePassengersWithData:_dataSource];
    NSString *bookingType = OrderBookForSelf;
    if ([_dataSource count] != 0) {
        if ([_dataSource count] > 1) {
            bookingType = OrderBookForOther;
        }else{
            id object = [_dataSource objectAtIndex:0];
            if ([object isKindOfClass:[GetLoginUserInfoResponse class]]) {
                GetLoginUserInfoResponse *logInfo = object;
                if ([logInfo.UID isEqualToString:[UserDefaults shareUserDefault].loginInfo.UID]) {
                    bookingType = OrderBookForSelf;
                }else{
                    bookingType = OrderBookForOther;
                }
            }else if ([object isKindOfClass:[BookPassengersResponse class]]){
                BookPassengersResponse *passenger = object;
                if ([passenger.CorpUID isEqualToString:[UserDefaults shareUserDefault].loginInfo.UID]) {
                    bookingType = OrderBookForSelf;
                }else{
                    bookingType = OrderBookForOther;
                }
            }
        }
        
    }
    
    [_request.Flights setBookingType:bookingType];
}

- (BOOL)getContact
{
    BOOL success = YES;
    OnlineContactDTO *contact = nil;
    contact = [OnlineContactDTO getOnlineContactWithData:_contact];
    
    if ([Utils textIsEmpty:_contactPhoneNumTf.text]) {
        [[Model shareModel] showPromptText:@"联系人电话不能为空" model:YES];
        return NO;
    }else{
        contact.Mobilephone = _contactPhoneNumTf.text;
    }
    
    if (success) {
        [_request setContacts:contact];
    }
    
    return success;
}

- (void)getOrderDetail
{
    _request.Addition = [Utils NULLToEmpty:_detailTextTv.text];
}

- (BOOL)getPayType
{
    BOOL success = YES;
    _request.PayType = @"第三方支付";
    return success;
}

- (void)getSendTicket
{
    
}

#pragma mark - get flight change rule
- (void)getChangeRule
{
    [self addLoadingView];
    if (!_changeRules) {
        _changeRules = [NSMutableArray array];
    }
    [_changeRules removeAllObjects];
    
    DomesticFlightDataDTO *flight = self.firstFlight;
    GetFlightChangeRuleRequest *request = [[GetFlightChangeRuleRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetAPIChangeRule"];
    [request setGuid:flight.Guid];
    [request setFNo:flight.Flight];
    [request setRoom:flight.Class];
    [request setPType:[NSNumber numberWithInteger:0]];
    [request setOTAType:[UserDefaults shareUserDefault].OTAType];
    [request setCorpId:[UserDefaults shareUserDefault].loginInfo.CorpID];
    [self.requestManager sendRequest:request];
}

- (void)getChangeRuleDone:(GetFlightChangeRuleResponse*)response
{
    [_changeRules addObject:response];
    if ([_changeRules count] != 2 && self.secondFlight) {
        DomesticFlightDataDTO *flight = self.secondFlight;
        GetFlightChangeRuleRequest *request = [[GetFlightChangeRuleRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetAPIChangeRule"];
        [request setGuid:flight.Guid];
        [request setFNo:flight.Flight];
        [request setRoom:flight.Class];
        [request setPType:[NSNumber numberWithInteger:0]];
        [request setOTAType:[UserDefaults shareUserDefault].OTAType];
        [request setCorpId:[UserDefaults shareUserDefault].loginInfo.CorpID];
        [self.requestManager sendRequest:request];
        return;
    }
    [self removeLoadingView];
    [self setSubjoinViewFrame];
}

#pragma mark - tableview handle
- (void)tableViewReloadData:(UITableView*)tableView
{
    if ([_dataSource count] != 0) {
        [tableView setFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, OrderFillCellHeight * [_dataSource count])];
    }else{
        [tableView setHidden:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OrderFillCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    OrderFillInViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == Nil) {
        cell = [[OrderFillInViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    id object = [_dataSource objectAtIndex:indexPath.row];
    [cell setContentWithParams:object];
    [cell setInsuranceWithCorpPolicy:_corpPolicy];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (DomesticFlightDataDTO *)firstFlight
{
    if (_request.Flights.FirstRoute.Flight) {
        _firstFlight = _request.Flights.FirstRoute.Flight;
    }else{
        _firstFlight = nil;
    }
    return _firstFlight;
}

- (DomesticFlightDataDTO *)secondFlight
{
    if (_request.Flights.SecondRoute.Flight) {
        _secondFlight = _request.Flights.SecondRoute.Flight;
    }else{
        _secondFlight = nil;
    }
    
    return _secondFlight;
}

- (void)setRequest:(SubmitFlightOrderRequest *)request
{
    if (_request != request) {
        _request = request;
    }
    _dataSource = [NSMutableArray arrayWithArray:request.Passengers];
}

- (void)setPassengers:(NSArray *)passengers
{
    if (_passengers != passengers) {
        _passengers = passengers;
    }
    _dataSource = [NSMutableArray arrayWithArray:passengers];
    [self reloadTableViewData];
}

- (void)setPolicyExecutor:(id)policyexecutor
{
    if (_policyExecutor != policyexecutor) {
        _policyExecutor = policyexecutor;
    }
    [self setContact:policyexecutor];
    SEL selector = NSSelectorFromString(@"UserName");
    NSString *policyName = nil;
    if ([policyexecutor respondsToSelector:selector]) {
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        policyName = [policyexecutor performSelector:selector];
    }
    [_passengerNameLb setText:policyName];
}

- (void)setContact:(id)contact
{
    OnlineContactDTO *onlineContact = [OnlineContactDTO getOnlineContactWithData:contact];
    _contact = onlineContact;
    [_contactNameTf setText:onlineContact.UserName];
    if (![Utils textIsEmpty:onlineContact.Mobilephone]) {
        [_contactPhoneNumTf setText:onlineContact.Mobilephone];
    }else{
        [_contactPhoneNumTf setText:nil];
        [_contactPhoneNumTf setEnabled:YES];
    }
}


- (void)reloadTableViewData
{
    UIView *addPassengersBackgroundView = [self.contentView viewWithTag:200];
    if (addPassengersBackgroundView) {
        UIView *pressToSelectBtn = [addPassengersBackgroundView viewWithTag:201];
        BOOL showPassengers = NO;
        if ([_dataSource count] != 0) {
            if (!_theTableView) {
                _theTableView = [[UITableView alloc]initWithFrame:pressToSelectBtn.frame];
                [_theTableView setDelegate:self];
                [_theTableView setDataSource:self];
                [_theTableView setScrollEnabled:NO];
                [_theTableView setBackgroundColor:color(clearColor)];
                [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [addPassengersBackgroundView addSubview:_theTableView];
            }
            showPassengers = YES;
        }
        [_theTableView setHidden:!showPassengers];
        [pressToSelectBtn setHidden:showPassengers];
        CGFloat tableViewHeight = showPassengers?OrderFillCellHeight * [_dataSource count]:(pressToSelectBtn.frame.size.height + 10);
        [UIView animateWithDuration:0.25
                         animations:^{
                             [_theTableView setFrame:CGRectMake(_theTableView.frame.origin.x, _theTableView.frame.origin.y, _theTableView.frame.size.width, tableViewHeight)];
                             [addPassengersBackgroundView setFrame:CGRectMake(addPassengersBackgroundView.frame.origin.x, addPassengersBackgroundView.frame.origin.y, addPassengersBackgroundView.frame.size.width, controlYLength(_theTableView))];
                             [_subjoinView setFrame:CGRectMake(_subjoinView.frame.origin.x, controlYLength(addPassengersBackgroundView), _subjoinView.frame.size.width, _subjoinView.frame.size.height)];
                         }completion:^(BOOL finished){
                             [_theTableView reloadData];
                             [self.contentView resetContentSize];
                         }];
        
    }
}

#pragma mark - select passenger delegate method
- (void)selectDone:(NSMutableArray*)array
{
    _dataSource = array;
    [self getPassengerFromDataSource];
    
    [self reloadTableViewData];
}



#pragma mark - edit passenger
- (void)editPassenger:(UIButton*)sender
{
    switch (sender.tag) {
        case 201:{
            if (!_passengerListView) {
                _passengerListView = [[PassengerListViewController alloc]init];
                [_passengerListView setDelegate:self];
            }
            [_passengerListView setSelectedPassengers:_dataSource];
            
            [self pushViewController:_passengerListView transitionType:TransitionPush completionHandler:nil];
            break;
        }
        case 400:{
            [_dataSource removeAllObjects];
            _request.Passengers = nil;
            [self reloadTableViewData];
            break;
        }case 401:{
            if (!_passengerListView) {
                _passengerListView = [[PassengerListViewController alloc]init];
                [_passengerListView setDelegate:self];
            }
            [_passengerListView setSelectedPassengers:_dataSource];
            
            [self pushViewController:_passengerListView transitionType:TransitionPush completionHandler:nil];
            break;
        }
        default:
            break;
    }
}

#pragma mark - select contact
- (void)selectContact:(UIButton*)sender
{
    CommonlyNameViewController *viewController = [[CommonlyNameViewController alloc]init];
    [viewController setDelegate:self];
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:^{
        [viewController getContact];
    }];
}

- (void)contactSelectDone:(id)contact
{
    self.contact = [OnlineContactDTO getOnlineContactWithData:contact];
}

#pragma mark - select post type
- (void)selectPostType:(UIButton*)sender
{
    PostTypeViewController *viewController = [[PostTypeViewController alloc]init];
    [viewController setDelegate:self];
    [viewController setPolicyExecutor:_policyExecutor];
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
}

- (void)selectPostDone:(DeliveryTypeDTO*)delivery mailCode:(TC_APImInfo*)postType address:(NSString *)address
{
    [_postAddressTf setText:address];
    
    [_request setMailCode:[NSNumber numberWithInteger:[postType.mCode integerValue]]];
    
    [_request setDeliveryType:delivery];
    
    [_postTypeTf setText:[NSString stringWithFormat:@"%@(%@)",postType.mName,postType.rPrice]];
    //    _postAddressTf setText:<#(NSString *)#>
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"填写订单"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    //    [self setSubjoinViewFrame];
}


#pragma mark --在view将要显示的时候判断:为个人   为多人

- (void)checkEditContactBtnState
{
    UIView *view = (UIView *)[self.contentView viewWithTag:200];
    UIButton *clear = (UIButton *)[view viewWithTag:400];
    UIButton *add = (UIButton *)[view viewWithTag:401];
    
    if ([_request.Flights.BookingType isEqualToString:OrderBookForSelf]) {
        clear.hidden = YES;
        add.hidden = YES;
    }else{
        clear.hidden = NO;
        add.hidden = NO;
    }
}


- (void)setSubjoinViewFrame
{
    UILabel *baseInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, controlYLength(self.topBar), self.contentView.frame.size.width - 20, 30)];
    [baseInfoLabel setBackgroundColor:color(clearColor)];
    [baseInfoLabel setText:@"基本信息"];
    [baseInfoLabel setTextColor:color(colorWithRed:130.0/255.0 green:140.0/255.0 blue:170.0/255.0 alpha:1)];
    [baseInfoLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:baseInfoLabel];
    
    UIView *baseInfoBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(5, controlYLength(baseInfoLabel), self.contentView.frame.size.width - 10, 50)];
    [baseInfoBackgroundView setBackgroundColor:color(whiteColor)];
    [baseInfoBackgroundView setCornerRadius:2.5];
    [baseInfoBackgroundView setBorderColor:color(lightGrayColor) width:0.5];
    [baseInfoBackgroundView setShaowColor:baseInfoBackgroundView.backgroundColor offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [self.contentView addSubview:baseInfoBackgroundView];
    
    UILabel *airLineInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, baseInfoBackgroundView.frame.size.width - 20, 25)];
    [airLineInfo setText:@"航班信息"];
    [airLineInfo setBackgroundColor:color(clearColor)];
    [airLineInfo setTextColor:color(grayColor)];
    [airLineInfo setFont:[UIFont systemFontOfSize:12]];
    [baseInfoBackgroundView addSubview:airLineInfo];
    
    _flightTimeLb1 = [[UILabel alloc]initWithFrame:CGRectMake(airLineInfo.frame.origin.x, controlYLength(airLineInfo), airLineInfo.frame.size.width/3, airLineInfo.frame.size.height)];
    [_flightTimeLb1 setFont:[UIFont systemFontOfSize:13]];
    [_flightTimeLb1 setAutoSize:YES];
    [_flightTimeLb1 setBackgroundColor:color(clearColor)];
    [_flightTimeLb1 setText:[NSString stringWithFormat:@"%@",self.firstFlight.TakeOffDate]];
    [baseInfoBackgroundView addSubview:_flightTimeLb1];
    
    _fromAndToLb1 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_flightTimeLb1), _flightTimeLb1.frame.origin.y, baseInfoBackgroundView.frame.size.width - controlXLength(_flightTimeLb1), _flightTimeLb1.frame.size.height)];
    [_fromAndToLb1 setFont:[UIFont systemFontOfSize:14]];
    [_fromAndToLb1 setAutoSize:YES];
    [_fromAndToLb1 setBackgroundColor:color(clearColor)];
    [_fromAndToLb1 setText:[NSString stringWithFormat:@"%@ - %@",self.firstFlight.Dairport.AirportName,self.firstFlight.Aairport.AirportName]];
    [baseInfoBackgroundView addSubview:_fromAndToLb1];
    
    _flightNumLb1 = [[UILabel alloc]initWithFrame:CGRectMake(_flightTimeLb1.frame.origin.x, controlYLength(_flightTimeLb1), _flightTimeLb1.frame.size.width, _flightTimeLb1.frame.size.height)];
    [_flightNumLb1 setFont:[UIFont systemFontOfSize:12]];
    [_flightNumLb1 setAutoSize:YES];
    [_flightNumLb1 setBackgroundColor:color(clearColor)];
    [_flightNumLb1 setText:[NSString stringWithFormat:@"%@ %@",self.firstFlight.AirLine.ShortName,self.firstFlight.Flight]];
    [_flightNumLb1 setTextColor:color(grayColor)];
    [baseInfoBackgroundView addSubview:_flightNumLb1];
    
    _seatTypeLb1 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_flightNumLb1), _flightNumLb1.frame.origin.y, _flightNumLb1.frame.size.width, _flightNumLb1.frame.size.height)];
    [_seatTypeLb1 setFont:[UIFont systemFontOfSize:12]];
    [_seatTypeLb1 setAutoSize:YES];
    [_seatTypeLb1 setBackgroundColor:color(clearColor)];
    [_seatTypeLb1 setText:self.firstFlight.Class];
    [_seatTypeLb1 setTextAlignment:NSTextAlignmentCenter];
    [_seatTypeLb1 setTextColor:color(grayColor)];
    [baseInfoBackgroundView addSubview:_seatTypeLb1];
    
    _priceLb1 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_seatTypeLb1), _seatTypeLb1.frame.origin.y, _seatTypeLb1.frame.size.width, _seatTypeLb1.frame.size.height)];
    [_priceLb1 setFont:[UIFont systemFontOfSize:12]];
    [_priceLb1 setBackgroundColor:color(clearColor)];
    [_priceLb1 setText:[NSString stringWithFormat:@"¥%@",self.firstFlight.Price]];
    [_priceLb1 setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [baseInfoBackgroundView addSubview:_priceLb1];
    
    [baseInfoBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(10, controlYLength(_priceLb1), baseInfoBackgroundView.frame.size.width - 20, 0.5)];
    
    NSString *firstRuleStr = [NSString stringWithFormat:@"基建费:%@\n燃油费:%@",self.firstFlight.Tax,self.firstFlight.OilFee];
    NSString *firstChangeRuleFormat = [[_changeRules objectAtIndex:0] description];
    if (firstChangeRuleFormat) {
        firstRuleStr = [firstRuleStr stringByAppendingFormat:@"\n%@",firstChangeRuleFormat];
    }
    
    CGFloat firstRuleLbHeight = [Utils heightForWidth:baseInfoBackgroundView.frame.size.width - airLineInfo.frame.origin.x*2 text:firstRuleStr font:[UIFont systemFontOfSize:13]];
    _firstRuleLb = [[UILabel alloc]initWithFrame:CGRectMake(airLineInfo.frame.origin.x, controlYLength(_priceLb1) + 10, baseInfoBackgroundView.frame.size.width - airLineInfo.frame.origin.x*2, firstRuleLbHeight)];
    [_firstRuleLb setBackgroundColor:color(clearColor)];
    [_firstRuleLb setAutoBreakLine:YES];
    [_firstRuleLb setText:firstRuleStr];
    [_firstRuleLb setFont: [UIFont systemFontOfSize:13]];
    [baseInfoBackgroundView addSubview:_firstRuleLb];
    
    if (_request.Flights.SecondRoute) {
        
        [baseInfoBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(10, controlYLength(_firstRuleLb) + 5, baseInfoBackgroundView.frame.size.width - 20, 0.5)];
        
        _flightTimeLb2 = [[UILabel alloc]initWithFrame:CGRectMake(_flightTimeLb1.frame.origin.x, controlYLength(_firstRuleLb) + 10, _flightTimeLb1.frame.size.width, _flightTimeLb1.frame.size.height)];
        [_flightTimeLb2 setFont:[UIFont systemFontOfSize:13]];
        [_flightTimeLb2 setAutoSize:YES];
        [_flightTimeLb2 setBackgroundColor:color(clearColor)];
        [_flightTimeLb2 setText:[NSString stringWithFormat:@"%@",self.secondFlight.TakeOffDate]];
        [baseInfoBackgroundView addSubview:_flightTimeLb2];
        
        _fromAndToLb2 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_flightTimeLb2), _flightTimeLb2.frame.origin.y, _fromAndToLb1.frame.size.width, _fromAndToLb1.frame.size.height)];
        [_fromAndToLb2 setFont:[UIFont systemFontOfSize:14]];
        [_fromAndToLb2 setAutoSize:YES];
        [_fromAndToLb2 setBackgroundColor:color(clearColor)];
        [_fromAndToLb2 setText:[NSString stringWithFormat:@"%@ - %@",self.secondFlight.Dairport.AirportName,self.secondFlight.Aairport.AirportName]];
        [baseInfoBackgroundView addSubview:_fromAndToLb2];
        
        _flightNumLb2 = [[UILabel alloc]initWithFrame:CGRectMake(_flightTimeLb2.frame.origin.x, controlYLength(_flightTimeLb2), _flightNumLb1.frame.size.width, _flightNumLb1.frame.size.height)];
        [_flightNumLb2 setFont:[UIFont systemFontOfSize:12]];
        [_flightNumLb2 setAutoSize:YES];
        [_flightNumLb2 setBackgroundColor:color(clearColor)];
        [_flightNumLb2 setText:[NSString stringWithFormat:@"%@ %@",self.secondFlight.AirLine.ShortName,self.secondFlight.Flight]];
        [_flightNumLb2 setTextColor:color(grayColor)];
        [baseInfoBackgroundView addSubview:_flightNumLb2];
        
        _seatTypeLb2 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_flightNumLb2), _flightNumLb2.frame.origin.y, _seatTypeLb1.frame.size.width, _seatTypeLb1.frame.size.height)];
        [_seatTypeLb2 setFont:[UIFont systemFontOfSize:12]];
        [_seatTypeLb2 setAutoSize:YES];
        [_seatTypeLb2 setBackgroundColor:color(clearColor)];
        [_seatTypeLb2 setText:self.secondFlight.Class];
        [_seatTypeLb2 setTextAlignment:NSTextAlignmentCenter];
        [_seatTypeLb2 setTextColor:color(grayColor)];
        [baseInfoBackgroundView addSubview:_seatTypeLb2];
        
        _priceLb2 = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_seatTypeLb2), _seatTypeLb2.frame.origin.y, _priceLb1.frame.size.width, _priceLb1.frame.size.height)];
        [_priceLb2 setFont:[UIFont systemFontOfSize:12]];
        [_priceLb2 setBackgroundColor:color(clearColor)];
        [_priceLb2 setText:[NSString stringWithFormat:@"¥%@",self.secondFlight.Price]];
        [_priceLb2 setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
        [baseInfoBackgroundView addSubview:_priceLb2];
        
        [baseInfoBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(10, controlYLength(_priceLb2), baseInfoBackgroundView.frame.size.width - 20, 0.5)];
        
        NSString *secondRuleStr = [NSString stringWithFormat:@"基建费:%@\n燃油费:%@",self.secondFlight.Tax,self.secondFlight.OilFee];
        NSString *secondChangeRuleFormat = [[_changeRules objectAtIndex:1] description];
        if (secondChangeRuleFormat) {
            secondRuleStr = [secondRuleStr stringByAppendingFormat:@"\n%@",secondChangeRuleFormat];
        }
        
        CGFloat secondRuleLbHeight = [Utils heightForWidth:_firstRuleLb.frame.size.width text:secondRuleStr font:[UIFont systemFontOfSize:13]];
        _secondRuleLb = [[UILabel alloc]initWithFrame:CGRectMake(_firstRuleLb.frame.origin.x, controlYLength(_priceLb2) + 5, _firstRuleLb.frame.size.width, secondRuleLbHeight)];
        [_secondRuleLb setBackgroundColor:color(clearColor)];
        [_secondRuleLb setAutoBreakLine:YES];
        [_secondRuleLb setText:secondRuleStr];
        [_secondRuleLb setFont: [UIFont systemFontOfSize:13]];
        [baseInfoBackgroundView addSubview:_secondRuleLb];
        
    }
    
    [baseInfoBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(10, controlYLength((_secondRuleLb?_secondRuleLb:_firstRuleLb)) + 5, baseInfoBackgroundView.frame.size.width - 20, 0.5)];
    
    _positionLb = [[UILabel alloc]initWithFrame:CGRectMake(_flightNumLb1.frame.origin.x, controlYLength((_secondRuleLb?_secondRuleLb:_firstRuleLb)) + 10, baseInfoBackgroundView.frame.size.width, _flightNumLb1.frame.size.height)];
    [_positionLb setTextColor:color(grayColor)];
    [_positionLb setFont:[UIFont systemFontOfSize:12]];
    [_positionLb setText:@"政策执行人"];
    [_positionLb setBackgroundColor:color(clearColor)];
    [baseInfoBackgroundView addSubview:_positionLb];
    
    _passengerNameLb = [[UILabel alloc]initWithFrame:CGRectMake(_positionLb.frame.origin.x, controlYLength(_positionLb), _positionLb.frame.size.width, _positionLb.frame.size.height)];
    [_passengerNameLb setFont:[UIFont systemFontOfSize:13]];
    [_passengerNameLb setBackgroundColor:color(clearColor)];
    [baseInfoBackgroundView addSubview:_passengerNameLb];
    
    [baseInfoBackgroundView setFrame:CGRectMake(baseInfoBackgroundView.frame.origin.x, baseInfoBackgroundView.frame.origin.y, baseInfoBackgroundView.frame.size.width, controlYLength(_passengerNameLb))];
    
    UILabel *fillInPassengerLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseInfoLabel.frame.origin.x, controlYLength(baseInfoBackgroundView), baseInfoLabel.frame.size.width, baseInfoLabel.frame.size.height)];
    [fillInPassengerLabel setFont:baseInfoLabel.font];
    [fillInPassengerLabel setBackgroundColor:color(clearColor)];
    [fillInPassengerLabel setTextColor:baseInfoLabel.textColor];
    [fillInPassengerLabel setText:@"添加乘客"];
    [self.contentView addSubview:fillInPassengerLabel];
    
    UIView *addPassengersBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(baseInfoBackgroundView.frame.origin.x, controlYLength(fillInPassengerLabel), baseInfoBackgroundView.frame.size.width, 0)];
    [addPassengersBackgroundView setBackgroundColor:color(whiteColor)];
    [addPassengersBackgroundView setCornerRadius:2.5];
    [addPassengersBackgroundView setShaowColor:color(lightGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [addPassengersBackgroundView setBorderColor:color(lightGrayColor) width:0.5];
    [addPassengersBackgroundView setTag:200];
    [self.contentView addSubview:addPassengersBackgroundView];
    
    UILabel *selectedPassengerLabel = [[UILabel alloc]initWithFrame:CGRectMake(_passengerNameLb.frame.origin.x, 0, (addPassengersBackgroundView.frame.size.width - 20) * 2/3, _passengerNameLb.frame.size.height)];
    [selectedPassengerLabel setFont:[UIFont systemFontOfSize:13]];
    [selectedPassengerLabel setTextColor:color(grayColor)];
    [selectedPassengerLabel setText:@"已选乘客"];
    [selectedPassengerLabel setBackgroundColor:color(clearColor)];
    [addPassengersBackgroundView addSubview:selectedPassengerLabel];
    
    UIButton *clearPassengerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearPassengerBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearPassengerBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [clearPassengerBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [clearPassengerBtn setFrame:CGRectMake(controlXLength(selectedPassengerLabel), selectedPassengerLabel.frame.origin.y, selectedPassengerLabel.frame.size.width/4, selectedPassengerLabel.frame.size.height)];
#pragma mark --为个人订票时需要隐藏的"清空按钮" tag
    [clearPassengerBtn setTag:400];
    [clearPassengerBtn addTarget:self action:@selector(editPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [addPassengersBackgroundView addSubview:clearPassengerBtn];
    
    UIButton *addPassengerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPassengerBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addPassengerBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [addPassengerBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [addPassengerBtn setFrame:CGRectMake(controlXLength(clearPassengerBtn), clearPassengerBtn.frame.origin.y, clearPassengerBtn.frame.size.width, clearPassengerBtn.frame.size.height)];
#pragma mark --为个人订票时需要隐藏的"新增按钮" tag
    [addPassengerBtn setTag:401];
    [addPassengerBtn addTarget:self action:@selector(editPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [addPassengersBackgroundView addSubview:addPassengerBtn];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(selectedPassengerLabel.frame.origin.x, controlYLength(selectedPassengerLabel), (controlXLength(addPassengerBtn) - selectedPassengerLabel.frame.origin.x)/5, 30)];
    [nameLabel setBackgroundColor:color(clearColor)];
    [nameLabel setText:@"姓名"];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [addPassengersBackgroundView addSubview:nameLabel];
    
    UILabel *IDCardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(nameLabel), nameLabel.frame.origin.y, nameLabel.frame.size.width * 3, nameLabel.frame.size.height)];
    [IDCardNumLabel setBackgroundColor:color(clearColor)];
    [IDCardNumLabel setText:@"证件号码"];
    [IDCardNumLabel setTextAlignment:NSTextAlignmentCenter];
    [IDCardNumLabel setFont:[UIFont systemFontOfSize:13]];
    [addPassengersBackgroundView addSubview:IDCardNumLabel];
    
    UILabel *insuranceLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(IDCardNumLabel), nameLabel.frame.origin.y, nameLabel.frame.size.width, nameLabel.frame.size.height)];
    [insuranceLabel setBackgroundColor:color(clearColor)];
    [insuranceLabel setText:@"购买保险"];
    [insuranceLabel setTextAlignment:NSTextAlignmentCenter];
    [insuranceLabel setFont:[UIFont systemFontOfSize:13]];
    [addPassengersBackgroundView addSubview:insuranceLabel];
    
    UIButton *pressToSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pressToSelectBtn setFrame:CGRectMake(selectedPassengerLabel.frame.origin.x, controlYLength(nameLabel), controlXLength(addPassengerBtn) - selectedPassengerLabel.frame.origin.x, 40)];
    [pressToSelectBtn setBackgroundColor:color(colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1)];
    [pressToSelectBtn setTitle:@"点击进入姓名库选择" forState:UIControlStateNormal];
    [pressToSelectBtn setTitleColor:color(lightGrayColor) forState:UIControlStateNormal];
    [pressToSelectBtn setTitleColor:color(darkGrayColor) forState:UIControlStateHighlighted];
    [pressToSelectBtn setCornerRadius:2.5];
    [pressToSelectBtn setTag:201];
    [pressToSelectBtn setBorderColor:color(darkGrayColor) width:0.5];
    [pressToSelectBtn setShaowColor:color(darkGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [pressToSelectBtn addTarget:self action:@selector(editPassenger:) forControlEvents:UIControlEventTouchUpInside];
    [addPassengersBackgroundView addSubview:pressToSelectBtn];
    
    [addPassengersBackgroundView setFrame:CGRectMake(addPassengersBackgroundView.frame.origin.x, addPassengersBackgroundView.frame.origin.y, addPassengersBackgroundView.frame.size.width, controlYLength(pressToSelectBtn) + 10)];
    
    _subjoinView = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(addPassengersBackgroundView), self.contentView.frame.size.width, 0)];
    [self.contentView addSubview:_subjoinView];
    
    UILabel *selectContactLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, _subjoinView.frame.size.width - 30, 25)];
    [selectContactLabel setFont:baseInfoLabel.font];
    [selectContactLabel setBackgroundColor:color(clearColor)];
    [selectContactLabel setTextColor:baseInfoLabel.textColor];
    [selectContactLabel setText:@"选择联系人"];
    [_subjoinView addSubview:selectContactLabel];
    
    UIView *selectContactBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(addPassengersBackgroundView.frame.origin.x, controlYLength(selectContactLabel), addPassengersBackgroundView.frame.size.width, 0)];
    [selectContactBackgroundView setBackgroundColor:color(whiteColor)];
    [selectContactBackgroundView setCornerRadius:2.5];
    [selectContactBackgroundView setShaowColor:color(lightGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [selectContactBackgroundView setBorderColor:color(lightGrayColor) width:0.5];
    [_subjoinView addSubview:selectContactBackgroundView];
    
    UILabel *contactNameLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, selectContactBackgroundView.frame.size.width/4, 40)];
    [contactNameLeft setFont:[UIFont systemFontOfSize:13]];
    [contactNameLeft setTextColor:color(grayColor)];
    [contactNameLeft setText:@"姓名"];
    [contactNameLeft setBackgroundColor:color(clearColor)];
    _contactNameTf = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, selectContactBackgroundView.frame.size.width - contactNameLeft.frame.size.height - 10, contactNameLeft.frame.size.height)];
    [_contactNameTf setFont:[UIFont systemFontOfSize:13]];
    [_contactNameTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_contactNameTf setLeftView:contactNameLeft];
    [_contactNameTf setLeftViewMode:UITextFieldViewModeAlways];
    [_contactNameTf setText:_request.Contacts.UserName];
    [_contactNameTf setDelegate:self];
    [_contactNameTf setEnabled:NO];
    [selectContactBackgroundView addSubview:_contactNameTf];
    
    [selectContactBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_contactNameTf), selectContactBackgroundView.frame.size.width - contactNameLeft.frame.size.height, 0.5)];
    
    UILabel *contactPhoneNumleft = [[UILabel alloc]initWithFrame:contactNameLeft.bounds];
    [contactPhoneNumleft setFont:contactNameLeft.font];
    [contactPhoneNumleft setTextColor:contactNameLeft.textColor];
    [contactPhoneNumleft setText:@"手机"];
    [contactPhoneNumleft setBackgroundColor:color(clearColor)];
    _contactPhoneNumTf = [[UITextField alloc]initWithFrame:CGRectMake(_contactNameTf.frame.origin.x, controlYLength(_contactNameTf), _contactNameTf.frame.size.width, _contactNameTf.frame.size.height)];
    [_contactPhoneNumTf setFont:_contactNameTf.font];
    [_contactPhoneNumTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_contactPhoneNumTf setLeftView:contactPhoneNumleft];
    [_contactPhoneNumTf setLeftViewMode:UITextFieldViewModeAlways];
    if (_request.Contacts.Mobilephone) {
        [_contactPhoneNumTf setText:_request.Contacts.Mobilephone];
    }
    [_contactPhoneNumTf setDelegate:self];
    //    [_contactPhoneNumTf setEnabled:NO];
    [selectContactBackgroundView addSubview:_contactPhoneNumTf];
    
    [selectContactBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(controlXLength(contactNameLeft), 0, 0.5, controlYLength(_contactPhoneNumTf))];
    [selectContactBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(controlXLength(_contactPhoneNumTf), 0, 0.5, controlYLength(_contactPhoneNumTf))];
    
    UIButton *selectContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectContactBtn setFrame:CGRectMake(controlXLength(_contactNameTf), 0, _contactPhoneNumTf.frame.size.height, controlYLength(_contactPhoneNumTf))];
    [selectContactBtn addTarget:self action:@selector(selectContact:) forControlEvents:UIControlEventTouchUpInside];
    [selectContactBackgroundView addSubview:selectContactBtn];
    UIImageView *selectContactRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 15)];
    [selectContactRightArrow setImage:imageNameAndType(@"arrow", Nil)];
    [selectContactRightArrow setCenter:selectContactBtn.center];
    [selectContactBackgroundView addSubview:selectContactRightArrow];
    
    [selectContactBackgroundView setFrame:CGRectMake(selectContactBackgroundView.frame.origin.x, selectContactBackgroundView.frame.origin.y, selectContactBackgroundView.frame.size.width, controlYLength(_contactPhoneNumTf))];
    
    UILabel *postAndPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseInfoLabel.frame.origin.x, controlYLength(selectContactBackgroundView), baseInfoLabel.frame.size.width, baseInfoLabel.frame.size.height)];
    [postAndPayLabel setFont:baseInfoLabel.font];
    [postAndPayLabel setTextColor:baseInfoLabel.textColor];
    [postAndPayLabel setText:@"配送与支付"];
    [postAndPayLabel setBackgroundColor:color(clearColor)];
    [_subjoinView addSubview:postAndPayLabel];
    
    UIView *postAndPayBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(selectContactBackgroundView.frame.origin.x, controlYLength(postAndPayLabel), selectContactBackgroundView.frame.size.width, 0)];
    [postAndPayBackgroundView setBackgroundColor:color(whiteColor)];
    [postAndPayBackgroundView setCornerRadius:2.5];
    [postAndPayBackgroundView setShaowColor:color(lightGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [postAndPayBackgroundView setBorderColor:color(lightGrayColor) width:0.5];
    [_subjoinView addSubview:postAndPayBackgroundView];
    
    UILabel *postTypeLeft = [[UILabel alloc]initWithFrame:contactNameLeft.bounds];
    [postTypeLeft setTextColor:contactNameLeft.textColor];
    [postTypeLeft setText:@"配送方式"];
    [postTypeLeft setBackgroundColor:color(clearColor)];
    [postTypeLeft setFont:contactNameLeft.font];
    //    UIImageView *postTypeRight = [[UIImageView alloc]initWithImage:imageNameAndType(@"arrow", Nil)];
    //    [postTypeRight setFrame:CGRectMake(0, 0, 10, 15)];
    //    [postTypeRight setCenter:CGPointMake(selectContactRightArrow.center.x, postTypeLeft.center.y)];
    _postTypeTf = [[UITextField alloc]initWithFrame:CGRectMake(_contactNameTf.frame.origin.x, 0, _contactNameTf.frame.size.width, _contactNameTf.frame.size.height)];
    [_postTypeTf setFont:_contactNameTf.font];
    [_postTypeTf setText:@"无需"];
    [_postTypeTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_postTypeTf setLeftView:postTypeLeft];
    [_postTypeTf setLeftViewMode:UITextFieldViewModeAlways];
    [_postTypeTf setEnabled:NO];
    [postAndPayBackgroundView addSubview:_postTypeTf];
    
    [postAndPayBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_postTypeTf), postAndPayBackgroundView.frame.size.width - _postTypeTf.frame.size.height, 0.5)];
    [postAndPayBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(controlXLength(_postTypeTf), 0, 0.5, _postTypeTf.frame.size.height * 2)];
    
    UILabel *postAddressLeft = [[UILabel alloc]initWithFrame:contactNameLeft.bounds];
    [postAddressLeft setTextColor:contactNameLeft.textColor];
    [postAddressLeft setText:@"配送地址"];
    [postAddressLeft setBackgroundColor:color(clearColor)];
    [postAddressLeft setFont:contactNameLeft.font];
    _postAddressTf = [[UITextField alloc]initWithFrame:CGRectMake(_contactNameTf.frame.origin.x, controlYLength(_postTypeTf), _contactNameTf.frame.size.width, _contactNameTf.frame.size.height)];
    [_postAddressTf setFont:_contactNameTf.font];
    [_postAddressTf setText:@"无需"];
    [_postAddressTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_postAddressTf setLeftView:postAddressLeft];
    [_postAddressTf setLeftViewMode:UITextFieldViewModeAlways];
    [_postAddressTf setEnabled:NO];
    [postAndPayBackgroundView addSubview:_postAddressTf];
    
    UIButton *selectPostTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPostTypeBtn setFrame:CGRectMake(controlXLength(_postAddressTf), 0, selectContactBtn.frame.size.width, selectContactBtn.frame.size.height)];
    [selectPostTypeBtn addTarget:self action:@selector(selectPostType:) forControlEvents:UIControlEventTouchUpInside];
    [postAndPayBackgroundView addSubview:selectPostTypeBtn];
    UIImageView *selectPostTypeRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 15)];
    [selectPostTypeRightArrow setImage:imageNameAndType(@"arrow", Nil)];
    [selectPostTypeRightArrow setCenter:selectContactBtn.center];
    [postAndPayBackgroundView addSubview:selectPostTypeRightArrow];
    
    [postAndPayBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_postAddressTf), postAndPayBackgroundView.frame.size.width, 0.5)];
    
    UILabel *payTypeLeft = [[UILabel alloc]initWithFrame:postTypeLeft.bounds];
    [payTypeLeft setFont:postTypeLeft.font];
    [payTypeLeft setText:@"支付方式"];
    [payTypeLeft setBackgroundColor:color(clearColor)];
    [payTypeLeft setTextColor:postTypeLeft.textColor];
    _payTypeTf = [[UITextField alloc]initWithFrame:CGRectMake(_postTypeTf.frame.origin.x, controlYLength(_postAddressTf), postAndPayBackgroundView.frame.size.width - _postTypeTf.frame.origin.x, _postTypeTf.frame.size.height)];
    [_payTypeTf setFont:_contactNameTf.font];
    [_payTypeTf setText:@"银联支付"];
    [_payTypeTf setLeftView:payTypeLeft];
    [_payTypeTf setEnabled:NO];
    [_payTypeTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_payTypeTf setLeftViewMode:UITextFieldViewModeAlways];
    [postAndPayBackgroundView addSubview:_payTypeTf];
    
    [postAndPayBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(controlXLength(postTypeLeft), 0, 0.5, controlYLength(_payTypeTf))];
    [postAndPayBackgroundView setFrame:CGRectMake(postAndPayBackgroundView.frame.origin.x, postAndPayBackgroundView.frame.origin.y, postAndPayBackgroundView.frame.size.width, controlYLength(_payTypeTf))];
    
    UILabel *subjoinTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseInfoLabel.frame.origin.x, controlYLength(postAndPayBackgroundView), baseInfoLabel.frame.size.width, baseInfoLabel.frame.size.height)];
    [subjoinTextLabel setFont:baseInfoLabel.font];
    [subjoinTextLabel setTextColor:baseInfoLabel.textColor];
    [subjoinTextLabel setText:@"附加信息"];
    [subjoinTextLabel setBackgroundColor:color(clearColor)];
    [_subjoinView addSubview:subjoinTextLabel];
    
    UIView *subjoinTextBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(postAndPayBackgroundView.frame.origin.x, controlYLength(subjoinTextLabel), postAndPayBackgroundView.frame.size.width, 0)];
    [subjoinTextBackgroundView setBackgroundColor:color(whiteColor)];
    [subjoinTextBackgroundView setCornerRadius:2.5];
    [subjoinTextBackgroundView setShaowColor:color(lightGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [subjoinTextBackgroundView setBorderColor:color(lightGrayColor) width:0.5];
    [_subjoinView addSubview:subjoinTextBackgroundView];
    
    _detailTextTv = [[UITextView alloc]initWithFrame:CGRectMake(_postTypeTf.frame.origin.x, 0, _postTypeTf.frame.size.width, 80)];
    [_detailTextTv setText:@"附加信息"];
    [subjoinTextBackgroundView addSubview:_detailTextTv];
    
    [subjoinTextBackgroundView setFrame:CGRectMake(subjoinTextBackgroundView.frame.origin.x, subjoinTextBackgroundView.frame.origin.y, subjoinTextBackgroundView.frame.size.width, controlYLength(_detailTextTv))];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(self.contentView.frame.size.width/6, controlYLength(subjoinTextBackgroundView) + 10, self.contentView.frame.size.width * 2/3, 40)];
    [nextBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(pressNextBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_subjoinView addSubview:nextBtn];
    
    [_subjoinView setFrame:CGRectMake(_subjoinView.frame.origin.x, _subjoinView.frame.origin.y, _subjoinView.frame.size.width, controlYLength(nextBtn) + 10)];
    [self.contentView resetContentSize];
    
    NSLog(@"setSubjoinViewFrame");
    
    [self setPolicyExecutor:self.policyExecutor];
    [self setPassengers:self.passengers];
    [self checkEditContactBtnState];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)pressNextBtn:(UIButton*)sender
{
    [self saveOrder];
}

- (BOOL)clearKeyBoard
{
    BOOL canResignFirstResponder = NO;
    if ([_detailTextTv isFirstResponder]) {
        [_detailTextTv resignFirstResponder];
        canResignFirstResponder = YES;
    }
    return canResignFirstResponder;
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

@interface OrderFillInViewCell ()

@property (strong, nonatomic) UILabel       *nameLb;
@property (strong, nonatomic) UILabel       *cardNumLb;
@property (strong, nonatomic) UILabel       *insuranceLb;

@end

@implementation OrderFillInViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, OrderFillCellWidth/5, OrderFillCellHeight)];
    [_nameLb setFont:[UIFont systemFontOfSize:13]];
    [_nameLb setBackgroundColor:color(clearColor)];
    [_nameLb setTextAlignment:NSTextAlignmentCenter];
    [_nameLb setAutoSize:YES];
    [self.contentView addSubview:_nameLb];
    
    _cardNumLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_nameLb), _nameLb.frame.origin.y, OrderFillCellWidth * 3/5, _nameLb.frame.size.height)];
    [_cardNumLb setFont:[UIFont systemFontOfSize:13]];
    [_cardNumLb setAutoSize:YES];
    [_cardNumLb setBackgroundColor:color(clearColor)];
    [_cardNumLb setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_cardNumLb];
    
    _insuranceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_cardNumLb), _nameLb.frame.origin.y, _nameLb.frame.size.width, _nameLb.frame.size.height)];
    [_insuranceLb setFont:[UIFont systemFontOfSize:13]];
    [_insuranceLb setBackgroundColor:color(clearColor)];
    [_insuranceLb setTextAlignment:NSTextAlignmentCenter];
    [_insuranceLb setAutoSize:YES];
    [self.contentView addSubview:_insuranceLb];
    
    //    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [editBtn setFrame:CGRectMake(controlXLength(_cardNumLb), _cardNumLb.frame.origin.y, _cardNumLb.frame.size.height, _cardNumLb.frame.size.height)];
    //    [editBtn setImage:imageNameAndType(@"button_bj", Nil) forState:UIControlStateNormal];
    //    [self.contentView addSubview:editBtn];
    //    [editBtn setScaleX:0.65 scaleY:0.65];
}

- (void)setContentWithParams:(NSObject *)param
{
    if ([param isKindOfClass:[BookPassengersResponse class]]) {
        BookPassengersResponse *passenger = (BookPassengersResponse*)param;
        [_nameLb setText:passenger.UserName];
        [_cardNumLb setText:[NSString stringWithFormat:@"%@",[passenger getDefaultIDCard].CardNumber]];
    }else if ([param isKindOfClass:[GetLoginUserInfoResponse class]]){
        GetLoginUserInfoResponse *userInfo = (GetLoginUserInfoResponse*)param;
        [_nameLb setText:userInfo.UserName];
        [_cardNumLb setText:[NSString stringWithFormat:@"%@",[userInfo getDefaultIDCard].CardNumber]];
    }
}

- (void)setInsuranceWithCorpPolicy:(GetCorpPolicyResponse*)corpPolicy
{
    NSString *insurance = @"允许";
    if (![corpPolicy.Insurance isEqualToString:@"T"]) {
        insurance = [NSString stringWithFormat:@"不%@",insurance];
    }
    [_insuranceLb setText:insurance];
}

@end

