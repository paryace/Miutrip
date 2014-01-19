//
//  HomeViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "HomeViewController.h"
#import "AirOrderDetail.h"
#import "HotelAndAirOrderViewController.h"
#import "TripCareerViewController.h"
#import "CommonlyNameViewController.h"
#import "SettingViewController.h"
#import "AirListViewController.h"
#import "HotelListViewController.h"
#import "ImageAndTextTilteView.h"
#import "LoginUserInfoRequest.h"
#import "LoginUserInfoResponse.h"
#import "GetLoginUserInfoRequest.h"
#import "LoginInfoDTO.h"
#import "HotelListViewController.h"
#import "HotelCantonViewController.h"
#import "DateSelectViewController.h"
#import "LogoutRequest.h"
#import "GetNormalFlightsRequest.h"

#import "SelectPassengerViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) UIView                *viewPageHotel;
@property (strong, nonatomic) UIView                *viewPageAir;
@property (strong, nonatomic) UIView                *viewPageMiu;

@property (strong, nonatomic) NSMutableArray        *btnArray;
@property (strong, nonatomic) CityPickerViewController *cityPickerView;
@property (strong, nonatomic) UIControl             *responseControl;

@property (strong, nonatomic) DatePickerViewController *datePickerView;

#pragma mark - hotel control
@property (strong, nonatomic) UILabel              *cityNameTf;            //cover btn tag         500
@property (strong, nonatomic) CustomDateTextField   *checkInTimeTf;         //cover btn tag         501
@property (strong, nonatomic) CustomDateTextField   *leaveTimeTf;           //cover btn tag         502
@property (strong, nonatomic) UITextField           *priceRangeTf;          //cover btn tag         503
@property (strong, nonatomic) UITextField           *hotelLocationTf;       //cover btn tag         504
@property (strong, nonatomic) UITextField           *hotelNameTf;

//done btn tag  550 ; voice btn tag 551

#pragma mark - air control
@property (strong, nonatomic) UIButton              *fromCity;              //起始地   cover btn tag  700
@property (strong, nonatomic) UIButton              *toCity;                //目的地   cover btn tag  701
@property (strong, nonatomic) CustomDateTextField   *startDateTf;           //出发日期 cover btn tag  702
@property (strong, nonatomic) UITextField           *startTime;             //出发时间 cover btn tag  703
@property (strong, nonatomic) CustomDateTextField   *returnDateTf;          //返回日期 cover btn tag  802
@property (strong, nonatomic) UITextField           *returnTime;            //返回时间 cover btn tag  803
@property (strong, nonatomic) UITextField           *sendAddressTf;         //送票地点 cover btn tag  704
@property (strong, nonatomic) UITextField           *airLineCompanyTf;      //航空公司 cover btn tag  705
@property (strong, nonatomic) UITextField           *passengerNumTf;        //乘客数   cover btn tag  706
@property (strong, nonatomic) UITextField           *seatLevelTf;           //舱位等级 cover btn tag  707


@property (strong, nonatomic) CityDTO               *airOrderFromCity;           //出发城市
@property (strong, nonatomic) CityDTO               *airOrderToCity;             //到达城市


@property (assign, nonatomic) BOOL                  moreViewUnfold;

//done btn tag  750 ; voice btn tag 751

@end

@implementation HomeViewController

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
        _moreViewUnfold = NO;
        [self.contentView setUserInteractionEnabled:YES];
        [self.contentView setBackgroundColor:color(colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1)];
        _btnArray = [NSMutableArray array];
        [self setSubviewFrame];
        _cityPickerView = [[CityPickerViewController alloc]init];
        [_cityPickerView setDelegate:self];
        [self.view addSubview:_cityPickerView.view];
        _datePickerView = [[DatePickerViewController alloc]init];
        [_datePickerView setDelegate:self];
        [self.view addSubview:_datePickerView.view];
    }
    return self;
}

#pragma mark - location handle
-(void)startLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.delegate = self;
    locationManager.distanceFilter=1000.0f;
    //启动位置更新
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if(newLocation){
        [HotelDataCache sharedInstance].lat = newLocation.coordinate.latitude;
        [HotelDataCache sharedInstance].lng = newLocation.coordinate.longitude;
    }else{
        if(oldLocation){
            [HotelDataCache sharedInstance].lat = oldLocation.coordinate.latitude;
            [HotelDataCache sharedInstance].lng = oldLocation.coordinate.longitude;
        }
    }
}

- (void)logOff:(UIButton*)sender
{
    LogoutRequest *request = [[LogoutRequest alloc]initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"logout"];
    [self.requestManager sendRequest:request];
}

#pragma mark - request handle
-(void) getLoginUserInfo{
    GetLoginUserInfoRequest *request = [[GetLoginUserInfoRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetUserLoginInfo"];
    [self.requestManager sendRequest:request];
}

-(void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[LogoutResponse class]]) {
        [self logOutDone:(LogoutResponse*)response];
    }else if ([response isKindOfClass:[GetLoginUserInfoResponse class]]){
        [self getUserLoginInfoDone:(GetLoginUserInfoResponse*)response];
    }
}


- (void)logOutDone:(LogoutResponse*)response
{
    [[Model shareModel] showPromptText:@"注销成功" model:YES];
    [[UserDefaults shareUserDefault]clearDefaults];
    [self popToMainViewControllerTransitionType:TransitionPush completionHandler:nil];
}

- (void)getUserLoginInfoDone:(GetLoginUserInfoResponse*)loginInfo
{
    [UserDefaults shareUserDefault].loginInfo = loginInfo;
    [_userName setText:loginInfo.UserName];
    [_position setText:[Utils nilToEmpty:loginInfo.DeptName]];
    [_company setText:[Utils nilToEmpty:loginInfo.CorpName]];
}


- (void)logOutDone
{
    [[Model shareModel] showPromptText:@"注销成功" model:YES];
    [self popToMainViewControllerTransitionType:TransitionPush completionHandler:nil];
}

- (void)requestError:(ASIHTTPRequest *)request
{
    [self popToMainViewControllerTransitionType:TransitionPush completionHandler:nil];
}


#pragma mark - city picker handle
- (void)cityPickerFinished:(CityDTO *)city
{
    [self control:_responseControl setTitle:city.CityName];
    if (_responseControl == _fromCity) {
        _airOrderFromCity = city;
    }else if (_responseControl == _toCity){
        _airOrderToCity   = city;
    }
}

- (void)cityPickerCancel
{
    
}

- (void)control:(UIControl*)control setTitle:(NSString*)title
{
    if ([control isKindOfClass:[UILabel class]] || [control isKindOfClass:[UITextField class]] || [control isKindOfClass:[UITextView class]]) {
        [control performSelector:@selector(setText:) withObject:title];
    }else if ([control isKindOfClass:[UIButton class]]){
        UIButton *btnControl = (UIButton*)control;
        [btnControl setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - date picker handle
- (void)datePickerFinished:(NSDate*)date
{
    if ([_responseControl isMemberOfClass:[UITextField class]]) {
        [self control:_responseControl setTitle:[Utils stringWithDate:date withFormat:@"HH:mm"]];
    }else if ([_responseControl isMemberOfClass:[CustomDateTextField class]]){
        [self control:_responseControl setTitle:[Utils stringWithDate:date withFormat:@"yyyy-MM-dd"]];
    }
}

- (void)datePickerCancel
{
    
}

- (void)pressSubitem:(UIButton*)sender
{
    NSLog(@"------viewController pressSubitem--------->");
}

- (void)pressSegment:(UISegmentedControl*)segmentedControl
{
    NSInteger selectIndex = segmentedControl.selectedSegmentIndex + 200;
    for (UIButton *btn in _btnArray) {
        [btn setHighlighted:(btn.tag == selectIndex)];
    }
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:{
            if (!_viewPageHotel) {
                [self createItemHotel];
            }
            if (!_viewPageHotel.superview) {
                [self.contentView addSubview:_viewPageHotel];
            }if (_viewPageAir.superview) {
                [_viewPageAir removeFromSuperview];
            }if (_viewPageMiu.superview) {
                [_viewPageMiu removeFromSuperview];
            }

            break;
        }case 1:{
            if (!_viewPageAir) {
                [self createItemAir];
            }
            if (!_viewPageAir.superview) {
                [self.contentView addSubview:_viewPageAir];
            }if (_viewPageHotel.superview) {
                [_viewPageHotel removeFromSuperview];
            }if (_viewPageMiu.superview) {
                [_viewPageMiu removeFromSuperview];
            }

            break;
        }case 2:{
            if (!_viewPageMiu) {
                [self createItemMiu];
            }
            if (!_viewPageMiu.superview) {
                [self.contentView addSubview:_viewPageMiu];
            }if (_viewPageHotel.superview) {
                [_viewPageHotel removeFromSuperview];
            }if (_viewPageAir.superview) {
                [_viewPageAir removeFromSuperview];
            }

            break;
        }
        default:
            break;
    }
    [self.contentView resetContentSize];
}

- (void)HomeCustomBtnUnfold:(BOOL)unfold
{

    UISegmentedControl *segmentedControl = (UISegmentedControl*)[self.view viewWithTag:10000];

    NSInteger selectIndex = segmentedControl.selectedSegmentIndex;
    UIView *responderView = nil;
    if (selectIndex == 0) {
        responderView = _viewPageHotel;
    }else if (selectIndex == 1){
        responderView = _viewPageAir;
    }
    HomeCustomBtn *customBtn = (HomeCustomBtn*)[responderView viewWithTag:300];

    if (unfold) {
        [customBtn setFrame:CGRectMake(customBtn.frame.origin.x, customBtn.frame.origin.y, customBtn.frame.size.width, 90)];
    }else{
        [customBtn setFrame:CGRectMake(customBtn.frame.origin.x, customBtn.frame.origin.y, customBtn.frame.size.width, 60)];
    }
    UIView *view = [responderView viewWithTag:600];
    [UIView animateWithDuration:0.25
                     animations:^{
                         [view setFrame:CGRectMake(view.frame.origin.x, controlYLength(customBtn)+2, view.frame.size.width, view.frame.size.height)];
                     }completion:^(BOOL finished){
                         [responderView setFrame:CGRectMake(responderView.frame.origin.x, responderView.frame.origin.y, responderView.frame.size.width, controlYLength(view))];
                         [self.contentView resetContentSize];
                     }];
   }


- (void)setSubviewFrame
{
    //[self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    
    [self setTopBarBackGroundImage:imageNameAndType(@"top_bg", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"home_return", nil) forState:UIControlStateDisabled];
    [returnBtn setFrame:CGRectMake(0, 0, 70, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [returnBtn setEnabled:NO];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setImage:imageNameAndType(@"logoff_normal", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"logoff_press", nil) forState:UIControlStateHighlighted];
    [rightBtn setFrame:CGRectMake(self.view.frame.size.width - 55, 0, 55, self.topBar.frame.size.height)];
    [rightBtn addTarget:self action:@selector(logOff:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    _userName = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(returnBtn) + 15, returnBtn.frame.origin.y + 2.5, appFrame.size.width/2 - controlXLength(returnBtn) - 15, (self.topBar.frame.size.height - 5)/2)];
    [_userName setBackgroundColor:color(clearColor)];
    [_userName setFont:[UIFont boldSystemFontOfSize:14]];
    [_userName setTextColor:color(whiteColor)];
    [_userName setText:[UserDefaults shareUserDefault].loginInfo.UserName];
    [self.view addSubview:_userName];
    
    _position = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_userName), _userName.frame.origin.y, _userName.frame.size.width, _userName.frame.size.height)];
    [_position setBackgroundColor:color(clearColor)];
    [_position setFont:[UIFont systemFontOfSize:12]];
    [_position setTextColor:color(whiteColor)];
    [_position setText:[UserDefaults shareUserDefault].loginInfo.DeptName];
    [self.view addSubview:_position];
    
    _company = [[UILabel alloc]initWithFrame:CGRectMake(_userName.frame.origin.x, controlYLength(_userName), _userName.frame.size.width * 2, _userName.frame.size.height)];
    [_company setBackgroundColor:color(clearColor)];
    [_company setFont:[UIFont systemFontOfSize:12]];
    [_company setTextColor:color(whiteColor)];
    [_company setAutoSize:YES];
    [_company setText:[UserDefaults shareUserDefault].loginInfo.CorpName];
    [self.view addSubview:_company];
    
    UIButton *inlandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inlandBtn setFrame:CGRectMake(0, controlYLength(self.topBar) - 1, self.view.frame.size.width/3, self.topBar.frame.size.height - 5)];
    [inlandBtn setTag:200];
    [_btnArray addObject:inlandBtn];
    [inlandBtn setBackgroundColor:color(clearColor)];
    [inlandBtn setBackgroundImage:imageNameAndType(@"subitem_normal", nil) forState:UIControlStateNormal];
    [inlandBtn setBackgroundImage:imageNameAndType(@"subitem_press", nil) forState:UIControlStateHighlighted];
    [inlandBtn setImage:imageNameAndType(@"inland_normal", nil) forState:UIControlStateNormal];
    [inlandBtn setImage:imageNameAndType(@"inland_press", nil) forState:UIControlStateHighlighted];
    [inlandBtn addTarget:self action:@selector(pressSubitem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inlandBtn];
    
    UIButton *airBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [airBtn setFrame:CGRectMake(controlXLength(inlandBtn), inlandBtn.frame.origin.y, inlandBtn.frame.size.width, inlandBtn.frame.size.height)];
    [airBtn setTag:201];
    [_btnArray addObject:airBtn];
    [airBtn setBackgroundColor:color(clearColor)];
    [airBtn setBackgroundImage:imageNameAndType(@"subitem_normal", nil) forState:UIControlStateNormal];
    [airBtn setBackgroundImage:imageNameAndType(@"subitem_press", nil) forState:UIControlStateHighlighted];
    [airBtn setImage:imageNameAndType(@"air_normal", nil) forState:UIControlStateNormal];
    [airBtn setImage:imageNameAndType(@"air_press", nil) forState:UIControlStateHighlighted];
    [airBtn addTarget:self action:@selector(pressSubitem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:airBtn];
    
    UIButton *myMiuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [myMiuBtn setFrame:CGRectMake(controlXLength(airBtn), inlandBtn.frame.origin.y, inlandBtn.frame.size.width, inlandBtn.frame.size.height)];
    [myMiuBtn setTag:202];
    [_btnArray addObject:myMiuBtn];
    [myMiuBtn setBackgroundColor:color(clearColor)];
    [myMiuBtn setBackgroundImage:imageNameAndType(@"subitem_normal", nil) forState:UIControlStateNormal];
    [myMiuBtn setBackgroundImage:imageNameAndType(@"subitem_press", nil) forState:UIControlStateHighlighted];
    [myMiuBtn setImage:imageNameAndType(@"mymiu_normal", nil) forState:UIControlStateNormal];
    [myMiuBtn setImage:imageNameAndType(@"mymiu_press", nil) forState:UIControlStateHighlighted];
    [myMiuBtn addTarget:self action:@selector(pressSubitem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myMiuBtn];
    
    NSMutableArray *segmentedItems = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        NSString *item = [NSString stringWithFormat:@"%d",i];
        [segmentedItems addObject:item];
    }
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedItems];
    [segmentedControl setBackgroundColor:color(clearColor)];
    [segmentedControl setTag:10000];
    [segmentedControl setFrame:CGRectMake(0, airBtn.frame.origin.y, self.view.frame.size.width, airBtn.frame.size.height)];
    [segmentedControl addTarget:self action:@selector(pressSegment:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setBackgroundColor:color(clearColor)];
    [segmentedControl setAlpha:0.1];
    [self.view addSubview:segmentedControl];
    
    [self getLoginUserInfo];
   
    [self setSubjoinViewFrame];

    if (![UserDefaults shareUserDefault].loginInfo) {
//        [self.requestManager getUserLoginInfo];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    [super touchesEnded:touches withEvent:event];
}

- (void)setSubjoinViewFrame
{
    switch ([UserDefaults shareUserDefault].launchPage) {
        case 0:{
            [self createItemHotel];
            [self.contentView addSubview:_viewPageHotel];
            break;
        }case 1:{
            [self createItemAir];
            [self.contentView addSubview:_viewPageAir];
            break;
        }case 2:{
            [self createItemMiu];
            [self.contentView addSubview:_viewPageMiu];
            break;
        }
        default:
            break;
    }
    UISegmentedControl *segmentedControl = (UISegmentedControl*)[self.view viewWithTag:10000];
    [segmentedControl setSelectedSegmentIndex:[UserDefaults shareUserDefault].launchPage];

    UIButton *btn = [_btnArray objectAtIndex:[UserDefaults shareUserDefault].launchPage];
    [btn setHighlighted:YES];
    
    [self.contentView resetContentSize];
}

#pragma mark - hotel item method
- (void)createItemHotel
{
    if (!_viewPageHotel) {
        UIView *segmentedControl = [self.view viewWithTag:10000];
        
        CGRect frame = CGRectMake(0, controlYLength(segmentedControl), self.view.frame.size.width, self.view.frame.size.height);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        
        HotelDataCache *data = [HotelDataCache sharedInstance];
        
        HotelSearchView *hotelSearchView = [[HotelSearchView alloc] initWidthFrame:CGRectMake(0, 0, self.view.frame.size.width, 0) widthdata:data];
        [hotelSearchView setBackgroundColor:color(clearColor)];
        hotelSearchView.tag = 2001;
        
        UIButton *searchBtn = (UIButton *)[hotelSearchView viewWithTag:550];
        [searchBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *priceRange = (UIButton *)[hotelSearchView viewWithTag:504];
        [priceRange addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *hotelCantonBtn = (UIButton *)[hotelSearchView viewWithTag:505];
        [hotelCantonBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *checkIndate = (UIButton *)[hotelSearchView viewWithTag:502];
        [checkIndate addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *checkOutdate = (UIButton *)[hotelSearchView viewWithTag:503];
        [checkOutdate addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        HomeCustomBtn *customBtn = [[HomeCustomBtn alloc]initWithParams:data];
        [customBtn setFrame:CGRectMake(0, 0, appFrame.size.width, 60)];
        [customBtn setBackgroundColor:color(clearColor)];
        [customBtn setTag:300];
        [customBtn setDelegate:self];
        [hotelSearchView addSubview:customBtn];

        [scrollView setContentSize:CGSizeMake(frame.size.width, frame.size.height)];
        scrollView.bounces = NO;
        scrollView.scrollsToTop = NO;
        scrollView.directionalLockEnabled = YES;
        
        [scrollView addSubview:hotelSearchView];
        _viewPageHotel = scrollView;
    }
}



- (void)pressHotelItemBtn:(UIButton*)sender
{
    switch (sender.tag) {
        case 550:
            [self gotoHotelList];
            break;
        case 504:
            [self showPriceRangeDialog];
            break;
        case 505:
            [self gotoHotelCantonViewController];
            break;
        case 502:
            [self selectDateWithType:CHECK_IN_DATE];
            break;
        case 503:
            [self selectDateWithType:CHECK_OUT_DATE];
            break;

        default:
            break;
    }
}

-(void)gotoHotelCantonViewController
{
    HotelCantonViewController *viewController = [[HotelCantonViewController alloc] init];
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)showPriceRangeDialog
{
    [self showPopupListWithTitle:@"价格范围" withType:HOTEL_PRICE_RANGE withData:[HotelDataCache sharedInstance].priceRangeArray];
}

-(void)selectDateWithType:(DateSelectType)type
{
    NSDate *date = [HotelDataCache sharedInstance].checkInDate;
    if(type == CHECK_OUT_DATE){
        date = [HotelDataCache sharedInstance].checkOutDate;
    }
    DateSelectViewController * hotelListView  = [[DateSelectViewController alloc] initWithSelectedDate:date type:type];
    [self.navigationController pushViewController:hotelListView animated:NO];
    CATransition *transition = [Utils getAnimation:TransitionPush subType:DirectionRight];
    [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
}


-(void)gotoHotelList
{
    HotelListViewController * hotelListView  = [[HotelListViewController alloc] init];
    [self.navigationController pushViewController:hotelListView animated:NO];
    CATransition *transition = [Utils getAnimation:TransitionPush subType:DirectionRight];
    [self.navigationController.view.layer addAnimation:transition forKey:@"viewtransition"];
}


- (UIImageView*)createLineWithFrame:(CGRect)frame
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    [imageView setBackgroundColor:color(lightGrayColor)];
    return imageView;
}

#pragma mark - air item method
- (void)createItemAir
{
    if (!_viewPageAir) {
        UIView *segmentedControl = [self.view viewWithTag:10000];
        
        _viewPageAir = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(segmentedControl), self.view.frame.size.width, 0)];
        [_viewPageAir setBackgroundColor:color(clearColor)];
        
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, - 1.5, self.view.frame.size.width, 15)];
        [titleImage setBackgroundColor:color(clearColor)];
        [titleImage setImage:imageNameAndType(@"shadow", nil)];
        [_viewPageAir addSubview:titleImage];
        
        HomeCustomBtn *customBtn = [[HomeCustomBtn alloc]initWithParams:[[AirOrderDetail alloc]init]];
        [customBtn setFrame:CGRectMake(0, controlYLength(titleImage), appFrame.size.width, 60)];
        [customBtn setBackgroundColor:color(clearColor)];
        [customBtn setTag:300];
        [customBtn setDelegate:self];
        [_viewPageAir addSubview:customBtn];
        
        [_viewPageAir setFrame:CGRectMake(_viewPageAir.frame.origin.x, _viewPageAir.frame.origin.y, _viewPageAir.frame.size.width, controlYLength(customBtn))];
        
        UIView *pageAirBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(customBtn) + 10, _viewPageAir.frame.size.width, 0)];
        [pageAirBottomView setBackgroundColor:color(clearColor)];
        [pageAirBottomView setUserInteractionEnabled:YES];
        [pageAirBottomView setTag:600];
        [_viewPageAir addSubview:pageAirBottomView];
        
        CustomStatusBtn *startImage = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(10, 0, 80, 25)];
        [startImage setImage:imageNameAndType(@"air_from_icon", nil) selectedImage:nil];
        [startImage setLeftViewScaleX:0.7 scaleY:0.7];
        [startImage setEnabled:NO];
        [startImage setDetail:@"出发"];
        [startImage setTextColor:color(grayColor)];
        [pageAirBottomView addSubview:startImage];
        
        CustomStatusBtn *endImage = [[CustomStatusBtn alloc]initWithFrame:CGRectMake(pageAirBottomView.frame.size.width - controlXLength(startImage), startImage.frame.origin.y, startImage.frame.size.width, startImage.frame.size.height)];
        [endImage setImage:imageNameAndType(@"air_arr_icon", nil) selectedImage:nil];
        [endImage setLeftViewScaleX:0.7 scaleY:0.7];
        [endImage setEnabled:NO];
        [endImage setDetail:@"到达"];
        [endImage setTextColor:color(grayColor)];
        [pageAirBottomView addSubview:endImage];
        
        _fromCity = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fromCity setBackgroundColor:color(whiteColor)];
        [_fromCity setBorderColor:color(lightGrayColor) width:1.0];
        [_fromCity setCornerRadius:5];
        [_fromCity setFrame:CGRectMake(10, controlYLength(startImage), (pageAirBottomView.frame.size.width - 20 - 10 - 40)/2, 40)];
        [_fromCity setTag:700];
        //[_fromCity setTitle:@"上海" forState:UIControlStateNormal];
        [_fromCity setTitleColor:color(blackColor) forState:UIControlStateNormal];
        [_fromCity setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_fromCity setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_fromCity addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:_fromCity];
        
        UIButton *exchangeFromAndTo = [UIButton buttonWithType:UIButtonTypeCustom];
        [exchangeFromAndTo setFrame:CGRectMake(controlXLength(_fromCity) + 5, _fromCity.frame.origin.y, _fromCity.frame.size.height, _fromCity.frame.size.height)];
        [exchangeFromAndTo setImage:imageNameAndType(@"air_exchange", nil) forState:UIControlStateNormal];
        [exchangeFromAndTo addTarget:self action:@selector(pressExchangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:exchangeFromAndTo];
        
        _toCity = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toCity setBackgroundColor:color(whiteColor)];
        [_toCity setBorderColor:color(lightGrayColor) width:1.0];
        [_toCity setCornerRadius:5];
        [_toCity setFrame:CGRectMake(controlXLength(exchangeFromAndTo) + 5, _fromCity.frame.origin.y, _fromCity.frame.size.width, _fromCity.frame.size.height)];
        [_toCity setTag:701];
        //[_toCity setTitle:@"北京" forState:UIControlStateNormal];
        [_toCity setTitleColor:color(blackColor) forState:UIControlStateNormal];
        [_toCity setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_toCity setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_toCity addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:_toCity];
        
        UIImageView *topItemBG = [[UIImageView alloc]initWithFrame:CGRectMake(_fromCity.frame.origin.x, controlYLength(_fromCity) + 10, pageAirBottomView.frame.size.width - _fromCity.frame.origin.x * 2, _fromCity.frame.size.height * 4)];
        [topItemBG setBackgroundColor:color(whiteColor)];
        [topItemBG setBorderColor:color(lightGrayColor) width:1.0];
        [topItemBG setCornerRadius:5.0];
        [topItemBG setAlpha:0.5];
        [pageAirBottomView addSubview:topItemBG];
        
        UIImageView *startDateImage = [[UIImageView alloc]initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y, 40, 40)];
        [startDateImage setBackgroundColor:color(clearColor)];
        [startDateImage setImage:imageNameAndType(@"query_checkIn", nil)];
        [pageAirBottomView addSubview:startDateImage];
        
        _startDateTf = [[CustomDateTextField alloc]initWithFrame:CGRectMake(controlXLength(startDateImage), startDateImage.frame.origin.y, controlXLength(topItemBG) - controlXLength(startDateImage), startDateImage.frame.size.height)];
        //        [_startDateTf setWeek:[[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1]];
        [_startDateTf setLeftPlaceholder:@"出发日期"];
        //        [_startDateTf setYear:[NSString stringWithFormat:@"%@年",[Utils stringWithDate:date withFormat:@"yyyy"]]];
        //        [_startDateTf setMonthAndDay:[NSString stringWithFormat:@"%@",[Utils stringWithDate:date withFormat:@"MM月dd日"]]];
        [pageAirBottomView addSubview:_startDateTf];
        UIImageView *startDateRightImage = [[UIImageView alloc]initWithFrame:CGRectMake(_startDateTf.frame.size.width - _startDateTf.frame.size.height, 0, _startDateTf.frame.size.height, _startDateTf.frame.size.height)];
        [startDateRightImage setImage:imageNameAndType(@"arrow", nil)];
        [startDateRightImage setScaleX:0.2 scaleY:0.3];
        [_startDateTf addSubview:startDateRightImage];
        UIButton *startDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startDateBtn setFrame:_startDateTf.frame];
        [startDateBtn setTag:702];
        [startDateBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:startDateBtn];
        
        [pageAirBottomView addSubview:[self createLineWithParam:color(lightGrayColor) frame:CGRectMake(startDateImage.frame.origin.x, controlYLength(_startDateTf), topItemBG.frame.size.width, 1)]];
        
        UIImageView *startTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(startDateImage.frame.origin.x, controlYLength(startDateImage), startDateImage.frame.size.width, startDateImage.frame.size.height)];
        [startTimeImage setBackgroundColor:color(clearColor)];
        [startTimeImage setImage:imageNameAndType(@"query_time", nil)];
        [pageAirBottomView addSubview:startTimeImage];
        
        UILabel *startTimeLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (topItemBG.frame.size.width - startTimeImage.frame.size.width)/3, startTimeImage.frame.size.height)];
        [startTimeLeft setBackgroundColor:color(clearColor)];
        [startTimeLeft setTextColor:color(darkGrayColor)];
        [startTimeLeft setText:@"出发时间"];
        [startTimeLeft setFont:[UIFont systemFontOfSize:13]];
        _startTime = [[UITextField alloc]initWithFrame:CGRectMake(_startDateTf.frame.origin.x, controlYLength(startDateImage), _startDateTf.frame.size.width, _startDateTf.frame.size.height)];
        [_startTime setBackgroundColor:color(clearColor)];
        [_startTime setLeftView:startTimeLeft];
        [_startTime setLeftViewMode:UITextFieldViewModeAlways];
        [_startTime setFont:[UIFont boldSystemFontOfSize:15]];
        [pageAirBottomView addSubview:_startTime];
        UIImageView *startTimeRightImage = [[UIImageView alloc]initWithFrame:startDateRightImage.frame];
        [startTimeRightImage setImage:imageNameAndType(@"arrow", nil)];
        [_startTime addSubview:startTimeRightImage];
        UIButton *startTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startTimeBtn setFrame:_startTime.frame];
        [startTimeBtn setTag:703];
        [startTimeBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:startTimeBtn];
        
        [pageAirBottomView addSubview:[self createLineWithParam:color(lightGrayColor) frame:CGRectMake(startDateImage.frame.origin.x, controlYLength(_startTime), topItemBG.frame.size.width, 1)]];
        
        UIImageView *returnDateImage = [[UIImageView alloc]initWithFrame:CGRectMake(startDateImage.frame.origin.x, controlYLength(startTimeImage), startDateImage.frame.size.width, startDateImage.frame.size.height)];
        [returnDateImage setBackgroundColor:color(clearColor)];
        [returnDateImage setImage:imageNameAndType(@"query_checkIn", nil)];
        [pageAirBottomView addSubview:returnDateImage];
        
        _returnDateTf = [[CustomDateTextField alloc]initWithFrame:CGRectMake(controlXLength(returnDateImage), returnDateImage.frame.origin.y, _startDateTf.frame.size.width, _startDateTf.frame.size.height)];
        //        [_startDateTf setWeek:[[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1]];
        [_returnDateTf setLeftPlaceholder:@"返回日期"];
        //        [_startDateTf setYear:[NSString stringWithFormat:@"%@年",[Utils stringWithDate:date withFormat:@"yyyy"]]];
        //        [_startDateTf setMonthAndDay:[NSString stringWithFormat:@"%@",[Utils stringWithDate:date withFormat:@"MM月dd日"]]];
        [pageAirBottomView addSubview:_returnDateTf];
        UIImageView *returnDateRightImage = [[UIImageView alloc]initWithFrame:startDateRightImage.frame];
        [returnDateRightImage setImage:imageNameAndType(@"arrow", nil)];
        [_returnDateTf addSubview:returnDateRightImage];
        UIButton *returnDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnDateBtn setFrame:_returnDateTf.frame];
        [returnDateBtn setTag:802];
        [returnDateBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:returnDateBtn];
        
        [pageAirBottomView addSubview:[self createLineWithParam:color(lightGrayColor) frame:CGRectMake(startDateImage.frame.origin.x, controlYLength(_returnDateTf), topItemBG.frame.size.width, 1)]];
        
        UIImageView *returnTimeImage = [[UIImageView alloc]initWithFrame:CGRectMake(startDateImage.frame.origin.x, controlYLength(returnDateBtn), startDateImage.frame.size.width, startDateImage.frame.size.height)];
        [returnTimeImage setBackgroundColor:color(clearColor)];
        [returnTimeImage setImage:imageNameAndType(@"query_time", nil)];
        [pageAirBottomView addSubview:returnTimeImage];
        
        UILabel *returnTimeLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (topItemBG.frame.size.width - startTimeImage.frame.size.width)/3, startTimeImage.frame.size.height)];
        [returnTimeLeft setBackgroundColor:color(clearColor)];
        [returnTimeLeft setTextColor:color(darkGrayColor)];
        [returnTimeLeft setText:@"返回时间"];
        [returnTimeLeft setFont:[UIFont systemFontOfSize:13]];
        _returnTime = [[UITextField alloc]initWithFrame:CGRectMake(_returnDateTf.frame.origin.x, controlYLength(_returnDateTf), _returnDateTf.frame.size.width, _returnDateTf.frame.size.height)];
        [_returnTime setBackgroundColor:color(clearColor)];
        [_returnTime setLeftView:returnTimeLeft];
        [_returnTime setLeftViewMode:UITextFieldViewModeAlways];
        [_returnTime setFont:[UIFont boldSystemFontOfSize:15]];
        [pageAirBottomView addSubview:_returnTime];
        UIImageView *returnTimeRightImage = [[UIImageView alloc]initWithFrame:startDateRightImage.frame];
        [returnTimeRightImage setImage:imageNameAndType(@"arrow", nil)];
        [_returnTime addSubview:returnTimeRightImage];
        UIButton *returnTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnTimeBtn setFrame:_returnTime.frame];
        [returnTimeBtn setTag:803];
        [returnTimeBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:returnTimeBtn];
        
        [startTimeImage setScaleX:0.5 scaleY:0.5];
        [returnTimeImage setScaleX:0.5 scaleY:0.5];
        
        UILabel *moreConditionLabel = [[UILabel alloc]initWithFrame:CGRectMake(startTimeImage.frame.origin.x, controlYLength(topItemBG), 65, startTimeImage.frame.size.height)];
        [moreConditionLabel setFont:[UIFont systemFontOfSize:13]];
        [moreConditionLabel setTextAlignment:NSTextAlignmentRight];
        [moreConditionLabel setText:@"更多条件"];
        [pageAirBottomView addSubview:moreConditionLabel];
        
        UIImageView *moreConditionImage = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(moreConditionLabel), moreConditionLabel.frame.origin.y, moreConditionLabel.frame.size.height, moreConditionLabel.frame.size.height)];
        [moreConditionImage setFrame:CGRectMake(controlXLength(moreConditionLabel), moreConditionLabel.frame.origin.y, moreConditionLabel.frame.size.height, moreConditionLabel.frame.size.height)];
        [pageAirBottomView addSubview:moreConditionImage];
        
        UIButton *moreConditionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreConditionBtn setFrame:CGRectMake(moreConditionLabel.frame.origin.x, moreConditionLabel.frame.origin.y, controlXLength(moreConditionImage) - moreConditionLabel.frame.origin.x, moreConditionLabel.frame.size.height)];
        [moreConditionLabel setTag:790];
        [moreConditionBtn addTarget:self action:@selector(pressMoreConditionBtn:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:moreConditionBtn];
        
        UIView *moreConditionView = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(moreConditionBtn), pageAirBottomView.frame.size.width, 0)];
        [moreConditionView setTag:791];
        [pageAirBottomView addSubview:moreConditionView];
        
        UIImageView *moreLeftItem = [[UIImageView alloc]initWithFrame:CGRectMake(topItemBG.frame.origin.x, 0, topItemBG.frame.size.width/2 - topItemBG.frame.origin.x, moreConditionLabel.frame.size.height * 2)];
        [moreLeftItem setCornerRadius:5];
        [moreLeftItem setBorderColor:color(lightGrayColor) width:1];
        [moreLeftItem setBackgroundColor:color(whiteColor)];
        [moreLeftItem setAlpha:0.5];
        [moreConditionView addSubview:moreLeftItem];
        
        UILabel *sendAddressLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, moreLeftItem.frame.size.width/3, moreConditionLabel.frame.size.height)];
        [sendAddressLeft setTextColor:color(darkGrayColor)];
        [sendAddressLeft setText:@"送票"];
        [sendAddressLeft setFont:[UIFont systemFontOfSize:12]];
        [sendAddressLeft setTextAlignment:NSTextAlignmentCenter];
        _sendAddressTf = [[UITextField alloc]initWithFrame:CGRectMake(moreLeftItem.frame.origin.x, moreLeftItem.frame.origin.y, moreLeftItem.frame.size.width, sendAddressLeft.frame.size.height)];
        [_sendAddressTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_sendAddressTf setLeftView:sendAddressLeft];
        [_sendAddressTf setLeftViewMode:UITextFieldViewModeAlways];
        [_sendAddressTf setPlaceholder:@"地址"];
        [moreConditionView addSubview:_sendAddressTf];
        UIButton *sendAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendAddressBtn setTag:704];
        [sendAddressBtn setFrame:_sendAddressTf.frame];
        [sendAddressBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [moreConditionView addSubview:sendAddressBtn];
        
        [moreConditionView createLineWithParam:color(lightGrayColor) frame:CGRectMake(moreLeftItem.frame.origin.x, controlYLength(sendAddressBtn), moreLeftItem.frame.size.width, 1)];
        
        UILabel *passengerNumLeft = [[UILabel alloc]initWithFrame:sendAddressLeft.bounds];
        [passengerNumLeft setTextColor:color(darkGrayColor)];
        [passengerNumLeft setText:@"乘客"];
        [passengerNumLeft setFont:[UIFont systemFontOfSize:12]];
        [passengerNumLeft setTextAlignment:NSTextAlignmentCenter];
        _passengerNumTf = [[UITextField alloc]initWithFrame:CGRectMake(_sendAddressTf.frame.origin.x, controlYLength(_sendAddressTf), _sendAddressTf.frame.size.width, _sendAddressTf.frame.size.height)];
        [_passengerNumTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_passengerNumTf setLeftView:passengerNumLeft];
        [_passengerNumTf setLeftViewMode:UITextFieldViewModeAlways];
        [_passengerNumTf setPlaceholder:@"数量"];
        [moreConditionView addSubview:_passengerNumTf];
        UIButton *passengerNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [passengerNumBtn setTag:706];
        [passengerNumBtn setFrame:_passengerNumTf.frame];
        [passengerNumBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [moreConditionView addSubview:passengerNumBtn];
        
        UIImageView *moreRightItem = [[UIImageView alloc]initWithFrame:CGRectMake(topItemBG.frame.origin.x * 2 + controlXLength(moreLeftItem), moreLeftItem.frame.origin.y, moreLeftItem.frame.size.width, moreLeftItem.frame.size.height)];
        [moreRightItem setCornerRadius:5];
        [moreRightItem setBorderColor:color(lightGrayColor) width:1];
        [moreRightItem setBackgroundColor:color(whiteColor)];
        [moreRightItem setAlpha:0.5];
        [moreConditionView addSubview:moreRightItem];
        
        UILabel *airLineCompanyLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, moreRightItem.frame.size.width/2, sendAddressLeft.frame.size.height)];
        [airLineCompanyLeft setTextColor:color(darkGrayColor)];
        [airLineCompanyLeft setText:@"航空公司"];
        [airLineCompanyLeft setFont:[UIFont systemFontOfSize:12]];
        [airLineCompanyLeft setTextAlignment:NSTextAlignmentCenter];
        _airLineCompanyTf = [[UITextField alloc]initWithFrame:CGRectMake(moreRightItem.frame.origin.x, moreRightItem.frame.origin.y, _sendAddressTf.frame.size.width, _sendAddressTf.frame.size.height)];
        [_airLineCompanyTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_airLineCompanyTf setLeftView:airLineCompanyLeft];
        [_airLineCompanyTf setLeftViewMode:UITextFieldViewModeAlways];
        [_airLineCompanyTf setPlaceholder:@"不限"];
        [moreConditionView addSubview:_airLineCompanyTf];
        UIButton *airLineCompanyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [airLineCompanyBtn setTag:705];
        [airLineCompanyBtn setFrame:_airLineCompanyTf.frame];
        [airLineCompanyBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [moreConditionView addSubview:airLineCompanyBtn];
        
        [moreConditionView createLineWithParam:color(lightGrayColor) frame:CGRectMake(moreRightItem.frame.origin.x, controlYLength(airLineCompanyBtn), moreRightItem.frame.size.width, 1)];
        
        UILabel *seatLevelLeft = [[UILabel alloc]initWithFrame:airLineCompanyLeft.bounds];
        [seatLevelLeft setTextColor:color(darkGrayColor)];
        [seatLevelLeft setText:@"舱位等级"];
        [seatLevelLeft setFont:[UIFont systemFontOfSize:12]];
        [seatLevelLeft setTextAlignment:NSTextAlignmentCenter];
        _seatLevelTf = [[UITextField alloc]initWithFrame:CGRectMake(_airLineCompanyTf.frame.origin.x, controlYLength(_airLineCompanyTf), _airLineCompanyTf.frame.size.width, _airLineCompanyTf.frame.size.height)];
        [_seatLevelTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_seatLevelTf setLeftView:seatLevelLeft];
        [_seatLevelTf setLeftViewMode:UITextFieldViewModeAlways];
        [_seatLevelTf setPlaceholder:@"不限"];
        [moreConditionView addSubview:_seatLevelTf];
        UIButton *seatLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [seatLevelBtn setTag:707];
        [seatLevelBtn setFrame:_seatLevelTf.frame];
        [seatLevelBtn addTarget:self action:@selector(pressAirItemBtn:) forControlEvents:UIControlEventTouchUpInside];
        [moreConditionView addSubview:seatLevelBtn];
        
        [moreConditionView.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
        
        [moreConditionView setFrame:CGRectMake(moreConditionView.frame.origin.x, moreConditionView.frame.origin.y, moreConditionView.frame.size.width, controlYLength(_seatLevelTf))];
        [moreConditionView setScaleX:1 scaleY:0.1];
        [moreConditionView setHidden:YES];
        _moreViewUnfold = NO;
        
        UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [queryBtn setImage:imageNameAndType(@"hotel_done_nromal", nil)
            highlightImage:imageNameAndType(@"hotel_done_press", nil)
                  forState:ButtonImageStateBottom];
        [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
        [queryBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
        [queryBtn setFrame:CGRectMake(pageAirBottomView.frame.size.width/6, controlYLength(moreConditionView) + 15, pageAirBottomView.frame.size.width * 2/3 - 50, 45)];
        [queryBtn setTag:750];
        [queryBtn addTarget:self action:@selector(pressAirItemDone:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:queryBtn];
        UIImageView *shakeImage = [[UIImageView alloc]initWithFrame:CGRectMake(queryBtn.frame.size.height/2, 0, queryBtn.frame.size.height, queryBtn.frame.size.height)];
        [shakeImage setImage:imageNameAndType(@"shake", nil)];
        [queryBtn addSubview:shakeImage];
        [shakeImage setBounds:CGRectMake(0, 0, shakeImage.frame.size.width * 0.7, shakeImage.frame.size.height * 0.7)];
        
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [voiceBtn setFrame:CGRectMake(controlXLength(queryBtn) + 5, queryBtn.frame.origin.y, queryBtn.frame.size.height, queryBtn.frame.size.height)];
        [voiceBtn setTag:751];
        [voiceBtn setImage:imageNameAndType(@"voice_btn_normal", nil) highlightImage:imageNameAndType(@"voice_btn_press", nil) forState:ButtonImageStateBottom];
        [voiceBtn addTarget:self action:@selector(pressAirItemDone:) forControlEvents:UIControlEventTouchUpInside];
        [pageAirBottomView addSubview:voiceBtn];
        
        [pageAirBottomView setFrame:CGRectMake(pageAirBottomView.frame.origin.x,
                                               pageAirBottomView.frame.origin.y,
                                               pageAirBottomView.frame.size.width,
                                               controlYLength(queryBtn))];
        
        [_viewPageAir setFrame:CGRectMake(_viewPageAir.frame.origin.x,
                                          _viewPageAir.frame.origin.y,
                                          _viewPageAir.frame.size.width,
                                          controlYLength(pageAirBottomView))];
        
    }
}

- (void)pressExchangeBtn:(UIButton*)sender
{
    UIButton *fromCity = _fromCity;
    UIButton *toCity   = _toCity;
    CGRect fromFrame = _fromCity.frame;
    CGRect toFrame   = _toCity.frame;
    NSInteger fromTag = _fromCity.tag;
    NSInteger toTag = _toCity.tag;
    CityDTO *elemCiy = nil;
    elemCiy = _airOrderFromCity;
    _airOrderFromCity = _airOrderToCity;
    _airOrderToCity = elemCiy;
    [UIView animateWithDuration:0.25
                     animations:^{
                         [_fromCity setFrame:toFrame];
                         [_toCity setFrame:fromFrame];
                     }completion:^(BOOL finished){
                         _fromCity = toCity;
                         _toCity   = fromCity;
                         _fromCity.tag = toTag;
                         _toCity.tag = fromTag;
                     }];
}

- (void)pressAirItemBtn:(UIButton*)sender
{
    NSLog(@"air tag = %d",sender.tag);
    switch (sender.tag) {
        case 700:{
            _responseControl = (UIButton*)[_viewPageAir viewWithTag:700];
            [_cityPickerView fire];
            break;
        }case 701:{
            _responseControl = (UIButton*)[_viewPageAir viewWithTag:701];
            [_cityPickerView fire];
            break;
        }case 702:{
            _responseControl = _startDateTf;
            [_datePickerView setDatePickerMode:UIDatePickerModeDate];
            [_datePickerView fire];
            break;
        }case 703:{
            _responseControl = _startTime;
            [_datePickerView setDatePickerMode:UIDatePickerModeTime];
            [_datePickerView fire];
            break;
        }case 704:{
            
            break;
        }case 705:{
            
            break;
        }case 706:{
            
            break;
        }case 707:{
            
            break;
        }
        default:
            break;
    }
}

- (void)pressAirItemDone:(UIButton*)sender
{
    NSLog(@"btn tag = %d",sender.tag);
    HomeCustomBtn *customBtn = (HomeCustomBtn*)[_viewPageAir viewWithTag:300];
    NSLog(@"goal title = %@,query title = %@,pay title = %@",customBtn.goalTitle,customBtn.queryTypeTitle,customBtn.payTypeTitle);
    switch (sender.tag) {
        case 750:{
            if ([customBtn.queryTypeTitle isEqualToString:@"为他人/多人"]) {
                SelectPassengerViewController *passengerSelectView = [[SelectPassengerViewController alloc]init];
                [self pushViewController:passengerSelectView transitionType:TransitionPush completionHandler:nil];
            }else{
                GetNormalFlightsRequest *request = [self getNormalFlightsRequest];
                AirListViewController *airListView = [[AirListViewController alloc]init];
                [self pushViewController:airListView transitionType:TransitionPush completionHandler:^{
                    [airListView getAirListWithRequest:request];
                }];
            }
            
            
            break;
        }case 751:{
            
            break;
        }
        default:
            break;
    }
}


- (GetNormalFlightsRequest*)getNormalFlightsRequest
{
    GetNormalFlightsRequest *request = [[GetNormalFlightsRequest alloc]initWidthBusinessType:BUSINESS_FLIGHT methodName:@"GetNormalFlights"];
    [request setDepartCity:_airOrderFromCity.CityRequestParams];
    [request setArriveCity:_airOrderToCity.CityRequestParams];
    NSString *departDate = [Utils stringWithDate:[Utils dateWithString:_startDateTf.year withFormat:@"yyyy年"] withFormat:@"yyyy"];
    departDate = [departDate stringByAppendingFormat:@"-%@",[Utils stringWithDate:[Utils dateWithString:_startDateTf.text withFormat:@"MM月dd日"] withFormat:@"MM-dd"]];
    NSLog(@"date = %@",departDate);
    [request setDepartDate:departDate];
    
    return request;
}

- (void)pressMoreConditionBtn:(UIButton*)sender
{
    NSLog(@"tag = %d",sender.tag);
    _moreViewUnfold = !_moreViewUnfold;
    UIView *responderView = [_viewPageAir viewWithTag:600];
    UIView *moreConditionView = [responderView viewWithTag:791];
    UIButton *queryBtn = (UIButton*)[responderView viewWithTag:750];
    UIButton *voiceBtn = (UIButton*)[responderView viewWithTag:751];
    if (_moreViewUnfold) {
        [moreConditionView setHidden:NO];
        [UIView animateWithDuration:0.25
                         animations:^{
                             [moreConditionView setScaleX:1 scaleY:10];
                             [queryBtn setFrame:CGRectMake(queryBtn.frame.origin.x, controlYLength(moreConditionView) + 15, queryBtn.frame.size.width, queryBtn.frame.size.height)];
                             [voiceBtn setFrame:CGRectMake(voiceBtn.frame.origin.x, controlYLength(moreConditionView) + 15, voiceBtn.frame.size.width, voiceBtn.frame.size.height)];
                         }completion:^(BOOL finished){
                             [responderView setFrame:CGRectMake(responderView.frame.origin.x,
                                                                responderView.frame.origin.y,
                                                                responderView.frame.size.width,
                                                                controlYLength(queryBtn))];
                             
                             [_viewPageAir setFrame:CGRectMake(_viewPageAir.frame.origin.x,
                                                               _viewPageAir.frame.origin.y,
                                                               _viewPageAir.frame.size.width,
                                                               controlYLength(responderView))];
                             [self.contentView resetContentSize];
                         }];
    }else{
        [UIView animateWithDuration:0.25
                         animations:^{
                             [moreConditionView setScaleX:1 scaleY:0.1];
                             [queryBtn setFrame:CGRectMake(queryBtn.frame.origin.x, moreConditionView.frame.origin.y + 15, queryBtn.frame.size.width, queryBtn.frame.size.height)];
                             [voiceBtn setFrame:CGRectMake(voiceBtn.frame.origin.x, moreConditionView.frame.origin.y + 15, voiceBtn.frame.size.width, voiceBtn.frame.size.height)];
                         }completion:^(BOOL finished){
                             [moreConditionView setHidden:YES];
                             [responderView setFrame:CGRectMake(responderView.frame.origin.x,
                                                                responderView.frame.origin.y,
                                                                responderView.frame.size.width,
                                                                controlYLength(queryBtn))];
                             
                             [_viewPageAir setFrame:CGRectMake(_viewPageAir.frame.origin.x,
                                                               _viewPageAir.frame.origin.y,
                                                               _viewPageAir.frame.size.width,
                                                               controlYLength(responderView))];
                             [self.contentView resetContentSize];
                         }];
    }
}

#pragma mark - my miu item method
- (void)createItemMiu
{
    if (!_viewPageMiu) {
        UIView *segmentedControl = [self.view viewWithTag:10000];
        _viewPageMiu = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(segmentedControl), self.view.frame.size.width, 0)];
        [_viewPageMiu setBackgroundColor:color(clearColor)];
        
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, - 1.5, self.view.frame.size.width, 15)];
        [titleImage setBackgroundColor:color(clearColor)];
        [titleImage setImage:imageNameAndType(@"shadow", nil)];
        [_viewPageMiu addSubview:titleImage];
        
        NSDictionary *airParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"机票订单",                         @"title",
                                   nil];
        UIButton *airOrderBtn = [self createButtonItemWithImage:imageNameAndType(@"home_item1_top", nil) highlightImage:imageNameAndType(@"home_item1_bottom", nil) withParams:airParams];
        [airOrderBtn setFrame:CGRectMake(10, controlYLength(titleImage), (self.view.frame.size.width - 30)/2, ((self.view.frame.size.width - 30)/2)*2/3)];
        [airOrderBtn setTag:400];
        [airOrderBtn addTarget:self action:@selector(pressItem3Btn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPageMiu addSubview:airOrderBtn];
        
        NSDictionary *hotelOrderParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"酒店订单",                         @"title",
                                          nil];
        UIButton *hotelOrderBtn = [self createButtonItemWithImage:imageNameAndType(@"home_item2_top", nil) highlightImage:imageNameAndType(@"home_item2_bottom", nil) withParams:hotelOrderParams];
        [hotelOrderBtn setFrame:CGRectMake(controlXLength(airOrderBtn) + 10, airOrderBtn.frame.origin.y, airOrderBtn.frame.size.width, airOrderBtn.frame.size.height)];
        [hotelOrderBtn setTag:401];
        [hotelOrderBtn addTarget:self action:@selector(pressItem3Btn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPageMiu addSubview:hotelOrderBtn];
        
        NSDictionary *tradeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"商旅生涯",                         @"title",
                                     nil];
        UIButton *tradeBtn = [self createButtonItemWithImage:imageNameAndType(@"home_item3_top", nil) highlightImage:imageNameAndType(@"home_item3_bottom", nil) withParams:tradeParams];
        [tradeBtn setFrame:CGRectMake(airOrderBtn.frame.origin.x, controlYLength(airOrderBtn) + 10, airOrderBtn.frame.size.width, airOrderBtn.frame.size.height)];
        [tradeBtn setTag:402];
        [tradeBtn addTarget:self action:@selector(pressItem3Btn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPageMiu addSubview:tradeBtn];
        
        NSDictionary *littleMiuParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                         @"贴心小觅",                         @"title",
                                         nil];
        UIButton *littleMiuBtn = [self createButtonItemWithImage:imageNameAndType(@"home_item4_top", nil) highlightImage:imageNameAndType(@"home_item4_bottom", nil) withParams:littleMiuParams];
        [littleMiuBtn setFrame:CGRectMake(hotelOrderBtn.frame.origin.x, tradeBtn.frame.origin.y, airOrderBtn.frame.size.width, airOrderBtn.frame.size.height)];
        [littleMiuBtn setTag:403];
        [littleMiuBtn addTarget:self action:@selector(pressItem3Btn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPageMiu addSubview:littleMiuBtn];
        
        NSDictionary *commonNameParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"常用姓名",                         @"title",
                                          nil];
        UIButton *commonNameBtn = [self createButtonItemWithImage:imageNameAndType(@"home_item5_top", nil) highlightImage:imageNameAndType(@"home_item5_bottom", nil) withParams:commonNameParams];
        [commonNameBtn setFrame:CGRectMake(airOrderBtn.frame.origin.x, controlYLength(tradeBtn) + 10, airOrderBtn.frame.size.width, airOrderBtn.frame.size.height)];
        [commonNameBtn setTag:404];
        [commonNameBtn addTarget:self action:@selector(pressItem3Btn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPageMiu addSubview:commonNameBtn];
        
        NSDictionary *settingParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                       @"系统设置",                         @"title",
                                       nil];
        UIButton *settingBtn = [self createButtonItemWithImage:imageNameAndType(@"home_item6_top", nil) highlightImage:imageNameAndType(@"home_item6_bottom", nil) withParams:settingParams];
        [settingBtn setFrame:CGRectMake(hotelOrderBtn.frame.origin.x, commonNameBtn.frame.origin.y, airOrderBtn.frame.size.width, airOrderBtn.frame.size.height)];
        [settingBtn setTag:405];
        [settingBtn addTarget:self action:@selector(pressItem3Btn:) forControlEvents:UIControlEventTouchUpInside];
        [_viewPageMiu addSubview:settingBtn];
        
        BaseContentView *newsDetailView = [[BaseContentView alloc]initWithFrame:CGRectMake(airOrderBtn.frame.origin.x, controlYLength(commonNameBtn) + 10, controlXLength(settingBtn) - commonNameBtn.frame.origin.x, 65)];
        [newsDetailView setBackgroundColor:color(clearColor)];
        [newsDetailView setSuperResponder:self];
        UIImageView *newsItem1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, newsDetailView.frame.size.width, newsDetailView.frame.size.height)];
        [newsItem1 setBackgroundColor:color(clearColor)];
        [newsItem1 setImage:imageNameAndType(@"home_news_1", nil)];
        [newsDetailView addSubview:newsItem1];
        [_viewPageMiu addSubview:newsDetailView];
        
        [_viewPageMiu setFrame:CGRectMake(_viewPageMiu.frame.origin.x, _viewPageMiu.frame.origin.y, _viewPageMiu.frame.size.width, controlYLength(newsDetailView))];
    }
}

- (void)pressItem3Btn:(UIButton*)sender
{
    switch (sender.tag) {
        case 400:{
            HotelAndAirOrderViewController *hotelOrderView = [[HotelAndAirOrderViewController alloc]initWithOrderType:OrderTypeAir];
            [self pushViewController:hotelOrderView transitionType:TransitionPush completionHandler:nil];
            break;
        }case 401:{
            HotelAndAirOrderViewController *hotelOrderView = [[HotelAndAirOrderViewController alloc]initWithOrderType:OrderTypeHotel];
            [self pushViewController:hotelOrderView transitionType:TransitionPush completionHandler:nil];
            break;
        }case 402:{
            TripCareerViewController *tripCareerView = [[TripCareerViewController alloc]init];
            [self pushViewController:tripCareerView transitionType:TransitionPush completionHandler:^{
//                [tripCareerView.requestManager getTravelLifeInfo];
            }];
            break;
        }case 403:{
            
            break;
        }case 404:{
            CommonlyNameViewController *commonlyNameView = [[CommonlyNameViewController alloc]init];
            [self pushViewController:commonlyNameView transitionType:TransitionPush completionHandler:^{
                [commonlyNameView setSubjoinViewFrame];
            }];
            break;
        }case 405:{
            SettingViewController *settimgView = [[SettingViewController alloc]init];
            [self pushViewController:settimgView transitionType:TransitionPush completionHandler:^{
                [settimgView setSubjoinViewFrame];
            }];
            break;
        }
        default:
            break;
    }
}

- (UIButton*)createButtonItemWithImage:(UIImage*)image highlightImage:(UIImage*)highLightImage withParams:(NSDictionary*)params
{
    NSString *title = [params objectForKey:@"title"];
    NSArray  *elems = [params objectForKey:@"elems"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:color(clearColor)];
    [btn setFrame:CGRectMake(0, 0, (self.view.frame.size.width - 30)/2, ((self.view.frame.size.width - 30)/2)*2/3)];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateSelected];
    [btn setBackgroundImage:highLightImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highLightImage forState:UIControlStateSelected];
    
    for (int i = 0; i<[elems count]; i++) {
        NSString *elem1 = [elems objectAtIndex:i];
        UILabel *detailLeftLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, (btn.frame.size.width * 4/(2*5)) - 5, btn.frame.size.height/5)];
        [detailLeftLabel setBackgroundColor:color(clearColor)];
        [detailLeftLabel setFont:[UIFont systemFontOfSize:12]];
        [detailLeftLabel setTextColor:color(whiteColor)];
        [detailLeftLabel setText:elem1];
        [detailLeftLabel setAutoSize:YES];
        [btn addSubview:detailLeftLabel];
        
        if ([params objectForKey:elem1]) {
            UILabel *detailRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(detailLeftLabel), detailLeftLabel.frame.origin.y, detailLeftLabel.frame.size.width/4, detailLeftLabel.frame.size.height)];
            [detailRightLabel setBackgroundColor:color(clearColor)];
            [detailRightLabel setFont:[UIFont systemFontOfSize:14]];
            [detailRightLabel setTextColor:color(whiteColor)];
            [detailRightLabel setText:[params objectForKey:elem1]];
            [detailRightLabel setAutoSize:YES];
            [btn addSubview:detailRightLabel];
        }
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, btn.frame.size.height * 4/5 - 4, btn.frame.size.width - 20, btn.frame.size.height/5)];
    [titleLabel setBackgroundColor:color(clearColor)];
    [titleLabel setFont:[UIFont systemFontOfSize:13]];
    [titleLabel setTextColor:color(whiteColor)];
    [titleLabel setTextAlignment:NSTextAlignmentRight];
    [titleLabel setAutoSize:YES];
    [titleLabel setText:title];
    [btn addSubview:titleLabel];
    
    return btn;
}

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    
}


- (BOOL)clearKeyBoard
{
    BOOL canResignFirstResponder = NO;
    if ([_hotelNameTf isFirstResponder]) {
        [_hotelNameTf resignFirstResponder];
        canResignFirstResponder = YES;
    }
    return canResignFirstResponder;
}

- (void)showPopupListWithTitle:(NSString*)title withType:(popupListType)type withData:(NSArray *)data{
    
    CGFloat xWidth = self.contentView.bounds.size.width - 20.0f;
    CGFloat yHeight = 240;
    CGFloat yOffset = (self.contentView.bounds.size.height - yHeight)/2.0f;
    _popupListData = data;
    _popListType = type;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = YES;
    [poplistview setTitle:title];
    [poplistview show];

}

#pragma mark - UIPopoverListViewDataSource
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier];
    
    int row = indexPath.row;
    cell.textLabel.text = [_popupListData objectAtIndex:row];
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return _popupListData.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    if(_popListType == HOTEL_PRICE_RANGE){
        
        HotelSearchView *hotelSearchView = (HotelSearchView *)[self.contentView viewWithTag:2001];
        [hotelSearchView setPriceRange:[_popupListData objectAtIndex:indexPath.row]];

    }
   
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    HotelSearchView *hotelSearchView = (HotelSearchView*)[self.contentView viewWithTag:2001];
    [hotelSearchView setHotelCanton:[HotelDataCache sharedInstance].queryCantonName];
    [hotelSearchView updateDate];
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

@interface HomeCustomBtn ()

@property (strong, nonatomic) HotelDataCache        *hotelDetail;
@property (strong, nonatomic) AirOrderDetail        *airDetail;

@property (strong, nonatomic) BtnItem               *goalBtn;
@property (strong, nonatomic) BtnItem               *queryTypeBtn;
@property (strong, nonatomic) BtnItem               *payTypeBtn;


@end

@implementation HomeCustomBtn

- (id)initWithParams:(NSObject*)params
{
    if (self = [super init]) {
         _airDetail = (AirOrderDetail*)params;
        [self setSubviewFrame];
    }
    return self;
}

- (void)pressTitleBtn:(UIButton*)sender
{
    switch (sender.tag) {
        case 100:{
            [_goalBtn unfoldViewShow];
            break;
        }case 101:{
            [_queryTypeBtn unfoldViewShow];
            break;
        }case 102:{
            [_payTypeBtn unfoldViewShow];
            break;
        }
        default:
            break;
    }
}

// BtnItemBtn delegate method
- (void)BtnItemUnfold
{
    _unfold = _goalBtn.unfold | _queryTypeBtn.unfold | _payTypeBtn.unfold;
    
    [self reloadBtnStatus];
    
    [self.delegate HomeCustomBtnUnfold:_unfold];
}

- (void)reloadBtnStatus
{
    if ([_goalBtn.selectBtn.titleLabel.text isEqualToString:@"因私"]) {
        [_queryTypeBtn.selectBtn.titleLabel setText:@"为自己"];
        [_queryTypeBtn.titleBtn setEnabled:NO];
    }else{
        [_queryTypeBtn.titleBtn setEnabled:YES];
    }
}

- (void)pressSelectBtn:(UIButton*)sender
{
    NSLog(@"------------->");
}

- (NSString *)goalTitle
{
    return _goalBtn.selectBtn.titleLabel.text;
}

- (NSString *)queryTypeTitle
{
    return _queryTypeBtn.selectBtn.titleLabel.text;
}

- (NSString *)payTypeTitle
{
    return _payTypeBtn.selectBtn.titleLabel.text;
}

- (void)setSubviewFrame
{
    NSArray *goalSubitems  = nil;
    NSArray *querySubitems = nil;
    NSArray *paySubitems   = nil;
    if (_hotelDetail) {
        goalSubitems = @[@"因公",@"因私"];
        querySubitems = @[@"为自己",@"为他人/多人"];
        paySubitems = @[@"现付",@"预付"];
    }else if (_airDetail){
        goalSubitems = @[@"因公",@"因私"];
        querySubitems = @[@"为自己",@"为他人/多人"];
        paySubitems = @[@"单程",@"往返"];
    }
    NSDictionary *goalParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"出行目的",                        @"title",
                                goalSubitems,                      @"params",
                                nil];
    _goalBtn = [[BtnItem alloc]initWithParams:goalParams];
    [_goalBtn.titleBtn setTag:100];
    [_goalBtn.selectBtn setTag:200];
    [_goalBtn setDelegate:self];
    [_goalBtn.titleBtn addTarget:self action:@selector(pressTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_goalBtn.selectBtn addTarget:self action:@selector(pressSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_goalBtn setFrame:CGRectMake(5, 0, (appFrame.size.width - 20)/3, 90)];
    [self addSubview:_goalBtn];
    
    NSDictionary *queryTypeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"预定类型",                     @"title",
                                querySubitems,                  @"params",
                                nil];
    _queryTypeBtn = [[BtnItem alloc]initWithParams:queryTypeParams];
    [_queryTypeBtn.titleBtn setTag:101];
    [_queryTypeBtn.selectBtn setTag:201];
    [_queryTypeBtn setDelegate:self];
    [_queryTypeBtn.titleBtn addTarget:self action:@selector(pressTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_queryTypeBtn.selectBtn addTarget:self action:@selector(pressSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_queryTypeBtn setFrame:CGRectMake(controlXLength(_goalBtn) + 5, 0, _goalBtn.frame.size.width, _goalBtn.frame.size.height)];
    [self addSubview:_queryTypeBtn];
    
    NSDictionary *payTypeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                _hotelDetail?@"支付类型":@"预订类型",      @"title",
                                paySubitems,                            @"params",
                                nil];
    _payTypeBtn = [[BtnItem alloc]initWithParams:payTypeParams];
    [_payTypeBtn.titleBtn setTag:102];
    [_payTypeBtn.selectBtn setTag:202];
    [_payTypeBtn setDelegate:self];
    [_payTypeBtn.titleBtn addTarget:self action:@selector(pressTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_payTypeBtn.selectBtn addTarget:self action:@selector(pressSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_payTypeBtn setFrame:CGRectMake(controlXLength(_queryTypeBtn) + 5, 0, _goalBtn.frame.size.width, _goalBtn.frame.size.height)];
    [self addSubview:_payTypeBtn];
    
    [self reloadBtnStatus];
}

@end

@interface BtnItem ()

@property (strong, nonatomic) NSDictionary          *params;

@property (strong, nonatomic) UIView                *unfoldView;

@end

@implementation BtnItem

- (id)initWithParams:(NSDictionary*)params
{
    if (self = [super init]) {
        [self setBackgroundColor:color(clearColor)];
        _params = params;
        _unfold = NO;
        [self setSubviewFrame];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5];
}

- (void)setSubviewFrame
{
    NSArray *items = [_params objectForKey:@"params"];
    
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleBtn setFrame:CGRectMake(0, 0, (appFrame.size.width - 20)/3, 30)];
    [_titleBtn setBackgroundColor:color(darkGrayColor)];
    [_titleBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    UIImage *titleImage = imageNameAndType(@"bg_home_title_btn", nil);
    [_titleBtn setBackgroundImage:[titleImage stretchableImageWithLeftCapWidth:titleImage.size.width/2 topCapHeight:titleImage.size.height/2] forState:UIControlStateNormal];
    [_titleBtn setTitle:[_params objectForKey:@"title"] forState:UIControlStateNormal];
    [self addSubview:_titleBtn];
    
    CGRect frame = CGRectMake(_titleBtn.frame.origin.x, controlYLength(_titleBtn), _titleBtn.frame.size.width, _titleBtn.frame.size.height-10);
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    [bgView setBackgroundColor:color(whiteColor)];
    [self addSubview:bgView];
    
    frame = CGRectMake(_titleBtn.frame.origin.x, controlYLength(_titleBtn), _titleBtn.frame.size.width, _titleBtn.frame.size.height);
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setFrame:frame];
    [_selectBtn setBackgroundColor:color(whiteColor)];
    [_selectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_selectBtn setTitle:[items objectAtIndex:1] forState:UIControlStateNormal];
    [_selectBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    _selectBtn.layer.cornerRadius = 5;
    [_selectBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    _selectBtn.layer.masksToBounds = YES;
    [self addSubview:_selectBtn];
}

- (void)unfoldViewShow
{
    _unfold = !_unfold;
    if (_unfold) {
        NSArray *items = [_params objectForKey:@"params"];
        if (!_unfoldView) {
            _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(_titleBtn.frame.origin.x, controlYLength(_titleBtn), _titleBtn.frame.size.width, 30 * [items count])];
            [_unfoldView setBackgroundColor:color(clearColor)];
            
            for (int i = 0;i<[items count];i++) {
                NSString *title = [items objectAtIndex:i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:title forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [btn setFrame:CGRectMake(0, 30 * i, _unfoldView.frame.size.width, 30)];
                [btn setTitleColor:color(blackColor) forState:UIControlStateNormal];
                [btn setBackgroundColor:color(whiteColor)];
                [btn addTarget:self action:@selector(pressSubitem:) forControlEvents:UIControlEventTouchUpInside];
                [_unfoldView addSubview:btn];
                if (title != [items lastObject]) {
                    [_unfoldView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(btn), _unfoldView.frame.size.width, 1)];
                }
                _unfoldView.layer.cornerRadius = 5;
                _unfoldView.layer.masksToBounds = YES;
            }
        }
        [self addSubview:_unfoldView];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, controlYLength(_unfoldView) + 30 * [items count])];
        [self.delegate BtnItemUnfold];
    }else{
        if (_unfoldView) {
            [_unfoldView removeFromSuperview];
            _unfoldView = nil;
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, controlYLength(_selectBtn))];
            [self.delegate BtnItemUnfold];
        }
    }
}

- (void)pressSubitem:(UIButton*)sender
{
    [_selectBtn.titleLabel setText:sender.titleLabel.text];
    [self unfoldViewShow];
}

@end

@interface CustomDateTextField ()

@property (strong, nonatomic) UILabel           *leftLabel;
@property (strong, nonatomic) UILabel           *weekLabel;
@property (strong, nonatomic) UILabel           *yearLabel;

@end

@implementation CustomDateTextField

@synthesize leftPlaceholder;
@synthesize week;
@synthesize year;
@synthesize monthAndDay;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    NSDate *date = [Utils dateWithString:text withFormat:@"yyyy-MM-dd"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setLocale:[NSLocale currentLocale]];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    [self setWeek:[[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1]];
    [self setYear:[NSString stringWithFormat:@"%@年",[Utils stringWithDate:date withFormat:@"yyyy"]]];
    [self setMonthAndDay:[NSString stringWithFormat:@"%@",[Utils stringWithDate:date withFormat:@"MM月dd日"]]];
}

- (void)setSubviewFrame
{
    
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/4, self.frame.size.height)];
    [_leftLabel setFont:[UIFont systemFontOfSize:13]];
    [_leftLabel setBackgroundColor:color(clearColor)];
    [_leftLabel setTextColor:color(darkGrayColor)];
    [self setLeftView:_leftLabel ];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (self.frame.size.width - _leftLabel.frame.size.width)*2/5 + self.frame.size.height, self.frame.size.height)];
    [self setRightView:rightView];
    [self setRightViewMode:UITextFieldViewModeAlways];
    
    _weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (rightView.frame.size.width - self.frame.size.height * 2/3)/2, self.frame.size.height)];
    [_weekLabel setBackgroundColor:color(clearColor)];
    [_weekLabel setAutoSize:YES];
    [_weekLabel setFont:[UIFont systemFontOfSize:12]];
    [_weekLabel setTextColor:color(grayColor)];
    [rightView addSubview:_weekLabel];
    
    _yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_weekLabel), _weekLabel.frame.origin.y, _weekLabel.frame.size.width, _weekLabel.frame.size.height)];
    [_yearLabel setBackgroundColor:color(clearColor)];
    [_yearLabel setAutoSize:YES];
    [_yearLabel setFont:[UIFont systemFontOfSize:12]];
    [_yearLabel setTextColor:color(grayColor)];
    [rightView addSubview:_yearLabel];
}

- (void)setLeftPlaceholder:(NSString *)_leftPlaceholder
{
    [_leftLabel setText:_leftPlaceholder];
    leftPlaceholder = _leftPlaceholder;
}

- (void)setWeek:(NSString *)_week
{
    [_weekLabel setText:_week];
    week = _week;
}

- (void)setYear:(NSString *)_year
{
    [_yearLabel setText:_year];
    year = _year;
}

- (void)setMonthAndDay:(NSString *)_monthAndDay
{
    [super setText:_monthAndDay];
}

@end
