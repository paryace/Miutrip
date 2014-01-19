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

@interface AirListViewController ()

@property (strong, nonatomic) UILabel               *titleLabel;
@property (strong, nonatomic) UILabel               *detailLabel;
@property (strong, nonatomic) UIButton              *dateLabel;

@property (strong, nonatomic) NSMutableArray        *showDataSource;

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
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

- (void)getAirListWithRequest:(BaseRequestModel*)request
{
    GetNormalFlightsRequest *flightsRequest = nil;
    if ([request isKindOfClass:[GetNormalFlightsRequest class]]) {
        flightsRequest = (GetNormalFlightsRequest*)request;
    }
    [_titleLabel setText:[NSString stringWithFormat:@"%@ - %@",[[SqliteManager shareSqliteManager] getCityCNNameWithCityCode:flightsRequest.DepartCity],[[SqliteManager shareSqliteManager] getCityCNNameWithCityCode:flightsRequest.ArriveCity]]];
    [_dateLabel setTitle:[Utils formatDateWithString:flightsRequest.DepartDate startFormat:@"yyyy-MM-dd" endFormat:@"M月d日"] forState:UIControlStateNormal];
    [self.requestManager sendRequest:request];
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetNormalFlightsResponse class]]) {
        [self getAirListDone:(GetNormalFlightsResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

- (void)getAirListDone:(GetNormalFlightsResponse*)response
{
    _dataSource = [NSMutableArray arrayWithArray:response.flights];
    
    _showDataSource = [NSMutableArray arrayWithArray:_dataSource];
    [self tableViewReloadData:_theTableView];
}

- (void)tableViewReloadData:(UITableView*)tableView
{
//    NSInteger flightNum = 0;
    for (DomesticFlightDataDTO *flight in _showDataSource) {
//        flightNum ++;
        if (flight.MoreFlights != nil && ![flight.MoreFlights isKindOfClass:[NSNull class]]) {
//            flightNum += [flight.MoreFlights count];
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
    [_detailLabel setText:[NSString stringWithFormat:@"%d个航班",[_showDataSource count]]];
    [tableView reloadData];
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

    }
    
    DomesticFlightDataDTO *model = [_showDataSource objectAtIndex:indexPath.row];

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

- (void)pressMainBtn:(CustomBtn *)sender
{
    DomesticFlightDataDTO *flight = [_showDataSource objectAtIndex:sender.indexPath.row];
    OrderFillInViewController *orderFillInView = [[OrderFillInViewController alloc]initWithFlight:flight];
    [self pushViewController:orderFillInView transitionType:TransitionPush completionHandler:nil];
}

- (void)pressSubjoinBtn:(CustomBtn *)sender
{
    DomesticFlightDataDTO *mainFlight = [_showDataSource objectAtIndex:sender.indexPath.row];
    DomesticFlightDataDTO *flight = [mainFlight.MoreFlights objectAtIndex:(sender.tag - 200)];
    OrderFillInViewController *orderFillInView = [[OrderFillInViewController alloc]initWithFlight:flight];
    [self pushViewController:orderFillInView transitionType:TransitionPush completionHandler:nil];
}

- (void)checkOrderStatusWithFlightDTO:(DomesticFlightDataDTO*)flight
{
    
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(returnBtn) + 10, 0, self.topBar.frame.size.width/2 - 10 - controlXLength(returnBtn), self.topBar.frame.size.height/2)];
//    [_titleLabel setText:@"上海 - 北京"];
    [_titleLabel setAutoSize:YES];
    [_titleLabel setTextColor:color(whiteColor)];
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, controlYLength(_titleLabel), _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
    [_detailLabel setFont:[UIFont systemFontOfSize:13]];
    [_detailLabel setAutoSize:YES];
    [_detailLabel setTextColor:color(whiteColor)];
//    [_detailLabel setText:@"12个航班"];
    [self.view addSubview:_detailLabel];

    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn.titleLabel setAutoSize:YES];
    [prevBtn setImage:imageNameAndType(@"button_date-left", nil) forState:UIControlStateNormal];
    [prevBtn setFrame:CGRectMake(controlXLength(_titleLabel) + 10, 7.5, (self.topBar.frame.size.width/2 - 20)/5, self.topBar.frame.size.height - 15)];
    [self.view addSubview:prevBtn];
    
    _dateLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dateLabel setFrame:CGRectMake(controlXLength(prevBtn), prevBtn.frame.origin.y, prevBtn.frame.size.width * 3, prevBtn.frame.size.height)];
    [_dateLabel setBackgroundImage:imageNameAndType(@"bg_date", nil) forState:UIControlStateDisabled];
    [_dateLabel setEnabled:NO];
    [_dateLabel.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_dateLabel.titleLabel setAutoSize:YES];
    [_dateLabel.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateLabel.titleLabel setTextColor:color(whiteColor)];
    [_dateLabel setTitle:[Utils stringWithDate:[NSDate date] withFormat:@"MM月dd日"] forState:UIControlStateNormal];
    [self.view addSubview:_dateLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn.titleLabel setAutoSize:YES];
    [nextBtn setImage:imageNameAndType(@"button_date-right", nil) forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(controlXLength(_dateLabel), prevBtn.frame.origin.y, prevBtn.frame.size.width, prevBtn.frame.size.height)];
    [self.view addSubview:nextBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    AirListCustomBtn *dateCompareBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(10, 5 + controlYLength(self.topBar), self.view.frame.size.width/4, 30)];
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
    NSString *airCompanyStr = [params objectForKey:@"airCompany"];

    if (![seatTypeStr isEqualToString:@"不限"] || ![airCompanyStr isEqualToString:@"不限"]) {
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
        if (![airCompanyStr isEqualToString:@"不限"]) {
            for (DomesticFlightDataDTO *flight in _showDataSource) {
                if ([[flight.AirLine.ShortName uppercaseString] rangeOfString:airCompanyStr].length != 0) {
                    [elemArray addObject:flight];
                }
            }
            _showDataSource = elemArray;
        }
    }else{
        [_showDataSource addObjectsFromArray:_dataSource];
    }
    
    [self tableViewReloadData:_theTableView];
}

- (void)pressFilterBtn:(AirListCustomBtn*)sender
{
    FlightSiftViewController *viewController = [[FlightSiftViewController alloc]init];
    [viewController setDelegate:self];
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
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

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _startTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, AirListViewCellHeight/2 - 25, appFrame.size.width/5, 30)];
    [_startTimeLb setTextColor:color(colorWithRed:0.0 green:90.0/255.0 blue:180.0/255.0 alpha:1)];
    [_startTimeLb setTextAlignment:NSTextAlignmentCenter];
    [_startTimeLb setFont:[UIFont systemFontOfSize:17]];
    [_startTimeLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"HH:mm"]];
    [self.contentView addSubview:_startTimeLb];
    
    _endTileLb = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(_startTimeLb) - 10, _startTimeLb.frame.size.width, _startTimeLb.frame.size.height)];
    [_endTileLb setTextColor:color(darkGrayColor)];
    [_endTileLb setTextAlignment:NSTextAlignmentCenter];
    [_endTileLb setFont:[UIFont systemFontOfSize:12]];
    [_endTileLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"HH:mm"]];
    [self.contentView addSubview:_endTileLb];
    

    
    UIImageView *lineNumLeft = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_startTimeLb), 5, (AirListViewCellHeight - 10)/3, (AirListViewCellHeight - 10)/3)];
    [lineNumLeft setImage:imageNameAndType(@"logo_fm@2x", Nil)];
    [self.contentView addSubview:lineNumLeft];
    _lineNumLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(lineNumLeft), lineNumLeft.frame.origin.y, (appFrame.size.width - controlXLength(lineNumLeft))/2, lineNumLeft.frame.size.height)];
    [_lineNumLb setTextColor:color(darkGrayColor)];
    [_lineNumLb setFont:[UIFont systemFontOfSize:11]];
    [self.contentView addSubview:_lineNumLb];
    
    _fromAndToLb = [[UILabel alloc]initWithFrame:CGRectMake(lineNumLeft.frame.origin.x, controlYLength(lineNumLeft), _lineNumLb.frame.size.width + lineNumLeft.frame.size.width, _lineNumLb.frame.size.height)];
    [_fromAndToLb setFont:[UIFont systemFontOfSize:11]];
    [_fromAndToLb setAutoSize:YES];
    [self.contentView addSubview:_fromAndToLb];
    
    _recommonSeatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(_fromAndToLb.frame.origin.x, controlYLength(_fromAndToLb), _fromAndToLb.frame.size.width/2, _fromAndToLb.frame.size.height)];
    [_recommonSeatTypeLb setFont:[UIFont systemFontOfSize:11]];
    [_recommonSeatTypeLb setAutoSize:YES];
    [self.contentView addSubview:_recommonSeatTypeLb];
    
    _virginiaTicketLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_recommonSeatTypeLb), _recommonSeatTypeLb.frame.origin.y, _recommonSeatTypeLb.frame.size.width, _recommonSeatTypeLb.frame.size.height)];
//    [_virginiaTicketLb setTextAlignment:NSTextAlignmentRight];
    [_virginiaTicketLb setFont:[UIFont systemFontOfSize:12]];
    [_virginiaTicketLb setTextColor:color(darkGrayColor)];
    [self.contentView addSubview:_virginiaTicketLb];
    
    _ticketPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_fromAndToLb), _lineNumLb.center.y, (appFrame.size.width - controlXLength(_fromAndToLb))*2/5, _fromAndToLb.frame.size.height)];
    [_ticketPriceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_ticketPriceLb setFont:[UIFont systemFontOfSize:12]];
    [_ticketPriceLb setTextAlignment:NSTextAlignmentCenter];
    [_ticketPriceLb setAutoSize:YES];
    [self.contentView addSubview:_ticketPriceLb];
    
    _discountLb = [[UILabel alloc]initWithFrame:CGRectMake(_ticketPriceLb.frame.origin.x, controlYLength(_ticketPriceLb), _ticketPriceLb.frame.size.width, _ticketPriceLb.frame.size.height)];
    [_discountLb setTextColor:color(grayColor)];
    [_discountLb setFont:[UIFont systemFontOfSize:12]];
    [_discountLb setTextAlignment:NSTextAlignmentCenter];
    [_discountLb setAutoSize:YES];
    [self.contentView addSubview:_discountLb];
    
    CustomBtn *doneBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(controlXLength(_ticketPriceLb), AirListViewCellHeight/2 - 20, appFrame.size.width - controlXLength(_ticketPriceLb), 40)];
    [doneBtn setTitle:@"预定" forState:UIControlStateNormal];
    [doneBtn setTag:100];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [doneBtn setBounds:CGRectMake(0, 0, doneBtn.frame.size.width * 0.7, doneBtn.frame.size.height * 0.7)];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
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
        [_subjoinBtnArray addObject:subjoinCell.doneBtn];
        [subjoinCell setViewContentWithParams:flight];
        [_unfoldView addSubview:subjoinCell];
    }
}

- (void)setViewContentWithParams:(DomesticFlightDataDTO *)params
{
    [_startTimeLb setText:params.TakeOffTime];
    [_endTileLb setText:params.ArriveTime];
    [_lineNumLb setText:[NSString stringWithFormat:@"%@ %@",params.AirLine.ShortName,params.Flight]];
    [_fromAndToLb setText:[NSString stringWithFormat:@"%@ - %@",params.Dairport.AirportName,params.Aairport.AirportName]];
    [_recommonSeatTypeLb setText:[NSString stringWithFormat:@"%@/%@",params.Class,params.AirLine.FlightClass]];
    [_virginiaTicketLb setText:[NSString stringWithFormat:@"剩%@张",params.Quantity]];
    [_ticketPriceLb setText:[NSString stringWithFormat:@"¥%.2f",[params.Price floatValue]]];
    [_discountLb setText:[NSString stringWithFormat:@"%.2f折",[params.Rate floatValue]]];
    
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
    [_discountLb setText:[NSString stringWithFormat:@"%.2f折",[flight.Rate floatValue]]];
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
