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

@interface OrderFillInViewController ()

@property (strong, nonatomic) NSMutableArray        *dataSource;
@property (strong, nonatomic) UITableView           *theTableView;

@property (strong, nonatomic) UIView                *subjoinView;

@property (strong, nonatomic) UILabel               *flightTimeLb;          //起飞时间
@property (strong, nonatomic) UILabel               *fromAndToLb;           //起始地&目的地
@property (strong, nonatomic) UILabel               *flightNumLb;           //航班号
@property (strong, nonatomic) UILabel               *seatTypeLb;            //舱位类型
@property (strong, nonatomic) UILabel               *priceLb;               //价格

@property (strong, nonatomic) UILabel               *positionLb;            //乘机人职位
@property (strong, nonatomic) UILabel               *passengerNameLb;       //乘机人姓名

@property (strong, nonatomic) UITextField           *contactNameTf;         //联系人姓名
@property (strong, nonatomic) UITextField           *contactPhoneNumTf;     //联系人号码

@property (strong, nonatomic) UITextField           *postTypeTf;            //配送方式
@property (strong, nonatomic) UITextField           *payTypeTf;             //支付方式

@property (strong, nonatomic) UITextView            *detailTextTv;          //附加信息

@property (strong, nonatomic) DomesticFlightDataDTO *flight;

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

- (id)initWithFlight:(DomesticFlightDataDTO *)flight
{
    if (self = [super init]) {
        _flight = flight;
        [self setSubviewFrame];
    }
    return self;
}

- (void)tableViewReloadData:(UITableView*)tableView
{
    if ([_dataSource count] != 0) {
        [tableView setFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, OrderFillCellHeight * [_dataSource count])];
    }else{
        [tableView setHidden:YES];
    }

}

- (void)selectPassengers:(UIButton*)sender
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OrderFillCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    OrderFillInViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == Nil) {
        cell = [[OrderFillInViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    UILabel *baseInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, controlYLength(self.topBar), self.contentView.frame.size.width - 20, 30)];
    [baseInfoLabel setText:@"基本信息"];
    [baseInfoLabel setTextColor:color(colorWithRed:130.0/255.0 green:140.0/255.0 blue:170.0/255.0 alpha:1)];
    [baseInfoLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:baseInfoLabel];
    
    UIView *baseInfoBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(5, controlYLength(baseInfoLabel), self.contentView.frame.size.width - 10, 50)];
    [baseInfoBackgroundView setBackgroundColor:color(whiteColor)];
    [baseInfoBackgroundView setCornerRadius:2.5];
    [baseInfoBackgroundView setShaowColor:baseInfoBackgroundView.backgroundColor offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [self.contentView addSubview:baseInfoBackgroundView];

    UILabel *airLineInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, baseInfoBackgroundView.frame.size.width - 20, 25)];
    [airLineInfo setText:@"航班信息"];
    [airLineInfo setTextColor:color(grayColor)];
    [airLineInfo setFont:[UIFont systemFontOfSize:12]];
    [baseInfoBackgroundView addSubview:airLineInfo];
    
    _flightTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(airLineInfo.frame.origin.x, controlYLength(airLineInfo), airLineInfo.frame.size.width/3, airLineInfo.frame.size.height)];
    [_flightTimeLb setFont:[UIFont systemFontOfSize:13]];
    [_flightTimeLb setAutoSize:YES];
    [_flightTimeLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd"]];
    [_flightTimeLb setText:[NSString stringWithFormat:@"%@",_flight.TakeOffDate]];
    [baseInfoBackgroundView addSubview:_flightTimeLb];
    
    _fromAndToLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_flightTimeLb), _flightTimeLb.frame.origin.y, baseInfoBackgroundView.frame.size.width - controlXLength(_flightTimeLb), _flightTimeLb.frame.size.height)];
    [_fromAndToLb setFont:[UIFont systemFontOfSize:14]];
    [_fromAndToLb setAutoSize:YES];
    [_fromAndToLb setText:@"上海航空-深圳宝安"];
    [_fromAndToLb setText:[NSString stringWithFormat:@"%@ - %@",_flight.Dairport.AirportName,_flight.Aairport.AirportName]];
    [baseInfoBackgroundView addSubview:_fromAndToLb];
    
    _flightNumLb = [[UILabel alloc]initWithFrame:CGRectMake(_flightTimeLb.frame.origin.x, controlYLength(_flightTimeLb), _flightTimeLb.frame.size.width, _flightTimeLb.frame.size.height)];
    [_flightNumLb setFont:[UIFont systemFontOfSize:12]];
    [_flightNumLb setAutoSize:YES];
    [_flightNumLb setText:@"深圳航空MU2001"];
    [_flightNumLb setText:[NSString stringWithFormat:@"%@ %@%@",_flight.AirLine.ShortName,_flight.AirLine.FlightClass,_flight.AirLine.AirLineCode]];
    [_flightNumLb setTextColor:color(grayColor)];
    [baseInfoBackgroundView addSubview:_flightNumLb];
    
    _seatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_flightNumLb), _flightNumLb.frame.origin.y, _flightNumLb.frame.size.width, _flightNumLb.frame.size.height)];
    [_seatTypeLb setFont:[UIFont systemFontOfSize:12]];
    [_seatTypeLb setAutoSize:YES];
    [_seatTypeLb setText:@"经济舱/G"];
    [_seatTypeLb setText:_flight.Class];
    [_seatTypeLb setTextAlignment:NSTextAlignmentCenter];
    [_seatTypeLb setTextColor:color(grayColor)];
    [baseInfoBackgroundView addSubview:_seatTypeLb];
    
    _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_seatTypeLb), _seatTypeLb.frame.origin.y, _seatTypeLb.frame.size.width, _seatTypeLb.frame.size.height)];
    [_priceLb setFont:[UIFont systemFontOfSize:12]];
    [_priceLb setText:@"¥1020"];
    [_priceLb setText:[NSString stringWithFormat:@"¥%@",_flight.Price]];
    [_priceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [baseInfoBackgroundView addSubview:_priceLb];
    
    [baseInfoBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(10, controlYLength(_priceLb), baseInfoBackgroundView.frame.size.width - 20, 0.5)];
    
    _positionLb = [[UILabel alloc]initWithFrame:CGRectMake(_flightNumLb.frame.origin.x, controlYLength(_flightNumLb), baseInfoBackgroundView.frame.size.width, _flightNumLb.frame.size.height)];
    [_positionLb setTextColor:color(grayColor)];
    [_positionLb setFont:[UIFont systemFontOfSize:12]];
    [_positionLb setText:@"政策执行人"];
    [baseInfoBackgroundView addSubview:_positionLb];
    
    _passengerNameLb = [[UILabel alloc]initWithFrame:CGRectMake(_positionLb.frame.origin.x, controlYLength(_positionLb), _positionLb.frame.size.width, _positionLb.frame.size.height)];
    [_passengerNameLb setFont:[UIFont systemFontOfSize:13]];
    [_passengerNameLb setText:@"徐小夏"];
    [_passengerNameLb setText:[UserDefaults shareUserDefault].loginInfo.UserName];
    [baseInfoBackgroundView addSubview:_passengerNameLb];
    
    [baseInfoBackgroundView setFrame:CGRectMake(baseInfoBackgroundView.frame.origin.x, baseInfoBackgroundView.frame.origin.y, baseInfoBackgroundView.frame.size.width, controlYLength(_passengerNameLb))];

    UILabel *fillInPassengerLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseInfoLabel.frame.origin.x, controlYLength(baseInfoBackgroundView), baseInfoLabel.frame.size.width, baseInfoLabel.frame.size.height)];
    [fillInPassengerLabel setFont:baseInfoLabel.font];
    [fillInPassengerLabel setTextColor:baseInfoLabel.textColor];
    [fillInPassengerLabel setText:@"添加乘客"];
    [self.contentView addSubview:fillInPassengerLabel];
    
    UIView *addPassengersBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(baseInfoBackgroundView.frame.origin.x, controlYLength(fillInPassengerLabel), baseInfoBackgroundView.frame.size.width, 0)];
    [addPassengersBackgroundView setBackgroundColor:color(whiteColor)];
    [addPassengersBackgroundView setCornerRadius:2.5];
    [addPassengersBackgroundView setShaowColor:addPassengersBackgroundView.backgroundColor offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [self.contentView addSubview:addPassengersBackgroundView];
    
    UILabel *selectedPassengerLabel = [[UILabel alloc]initWithFrame:CGRectMake(_passengerNameLb.frame.origin.x, 0, (addPassengersBackgroundView.frame.size.width - 20) * 2/3, _passengerNameLb.frame.size.height)];
    [selectedPassengerLabel setFont:[UIFont systemFontOfSize:13]];
    [selectedPassengerLabel setTextColor:color(grayColor)];
    [selectedPassengerLabel setText:@"已选乘客"];
    [addPassengersBackgroundView addSubview:selectedPassengerLabel];
    
    UIButton *clearPassengerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearPassengerBtn setTitle:@"清空" forState:UIControlStateNormal];
    [clearPassengerBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [clearPassengerBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [clearPassengerBtn setFrame:CGRectMake(controlXLength(selectedPassengerLabel), selectedPassengerLabel.frame.origin.y, selectedPassengerLabel.frame.size.width/4, selectedPassengerLabel.frame.size.height)];
    [addPassengersBackgroundView addSubview:clearPassengerBtn];
    
    UIButton *addPassengerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addPassengerBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addPassengerBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [addPassengerBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [addPassengerBtn setFrame:CGRectMake(controlXLength(clearPassengerBtn), clearPassengerBtn.frame.origin.y, clearPassengerBtn.frame.size.width, clearPassengerBtn.frame.size.height)];
    [addPassengersBackgroundView addSubview:addPassengerBtn];
    
    UIButton *pressToSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pressToSelectBtn setFrame:CGRectMake(selectedPassengerLabel.frame.origin.x, controlYLength(selectedPassengerLabel), controlXLength(addPassengerBtn) - selectedPassengerLabel.frame.origin.x, 40)];
    [pressToSelectBtn setBackgroundColor:color(colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1)];
    [pressToSelectBtn setTitle:@"点击进入姓名库选择" forState:UIControlStateNormal];
    [pressToSelectBtn setTitleColor:color(lightGrayColor) forState:UIControlStateNormal];
    [pressToSelectBtn setTitleColor:color(darkGrayColor) forState:UIControlStateHighlighted];
    [pressToSelectBtn setCornerRadius:2.5];
    [pressToSelectBtn setBorderColor:color(darkGrayColor) width:0.5];
    [pressToSelectBtn setShaowColor:color(darkGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [pressToSelectBtn addTarget:self action:@selector(selectPassengers:) forControlEvents:UIControlEventTouchUpInside];
    [addPassengersBackgroundView addSubview:pressToSelectBtn];
    
    [addPassengersBackgroundView setFrame:CGRectMake(addPassengersBackgroundView.frame.origin.x, addPassengersBackgroundView.frame.origin.y, addPassengersBackgroundView.frame.size.width, controlYLength(pressToSelectBtn) + 10)];
    
    _subjoinView = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(addPassengersBackgroundView), self.contentView.frame.size.width, 0)];
    [self.contentView addSubview:_subjoinView];
    
    UILabel *selectContactLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, _subjoinView.frame.size.width - 30, 25)];
    [selectContactLabel setFont:baseInfoLabel.font];
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
    _contactNameTf = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, selectContactBackgroundView.frame.size.width - contactNameLeft.frame.size.height - 10, contactNameLeft.frame.size.height)];
    [_contactNameTf setFont:[UIFont systemFontOfSize:13]];
    [_contactNameTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_contactNameTf setLeftView:contactNameLeft];
    [_contactNameTf setLeftViewMode:UITextFieldViewModeAlways];
    [_contactNameTf setText:@"赵大宝"];
    [_contactNameTf setText:[UserDefaults shareUserDefault].loginInfo.UserName];
    [_contactNameTf setEnabled:NO];
    [selectContactBackgroundView addSubview:_contactNameTf];
    
    [selectContactBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_contactNameTf), selectContactBackgroundView.frame.size.width - contactNameLeft.frame.size.height, 0.5)];
    
    UILabel *contactPhoneNumleft = [[UILabel alloc]initWithFrame:contactNameLeft.bounds];
    [contactPhoneNumleft setFont:contactNameLeft.font];
    [contactPhoneNumleft setTextColor:contactNameLeft.textColor];
    [contactPhoneNumleft setText:@"手机"];
    _contactPhoneNumTf = [[UITextField alloc]initWithFrame:CGRectMake(_contactNameTf.frame.origin.x, controlYLength(_contactNameTf), _contactNameTf.frame.size.width, _contactNameTf.frame.size.height)];
    [_contactPhoneNumTf setFont:_contactNameTf.font];
    [_contactPhoneNumTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_contactPhoneNumTf setLeftView:contactPhoneNumleft];
    [_contactPhoneNumTf setLeftViewMode:UITextFieldViewModeAlways];
    [_contactPhoneNumTf setText:@"13825546798"];
    [_contactPhoneNumTf setText:[UserDefaults shareUserDefault].loginInfo.Mobilephone];
    [_contactPhoneNumTf setEnabled:NO];
    [selectContactBackgroundView addSubview:_contactPhoneNumTf];
    
    [selectContactBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(controlXLength(contactNameLeft) - 10, 0, 0.5, controlYLength(_contactPhoneNumTf))];
    [selectContactBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(controlXLength(_contactPhoneNumTf), 0, 0.5, controlYLength(_contactPhoneNumTf))];
    
    UIButton *selectContactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectContactBtn setFrame:CGRectMake(controlXLength(_contactNameTf), 0, _contactPhoneNumTf.frame.size.height, controlYLength(_contactPhoneNumTf))];
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
    [postTypeLeft setFont:contactNameLeft.font];
    UIImageView *postTypeRight = [[UIImageView alloc]initWithImage:imageNameAndType(@"arrow", Nil)];
    [postTypeRight setFrame:CGRectMake(0, 0, 10, 15)];
    [postTypeRight setCenter:CGPointMake(selectContactRightArrow.center.x, postTypeLeft.center.y)];
    _postTypeTf = [[UITextField alloc]initWithFrame:CGRectMake(_contactNameTf.frame.origin.x, 0, postAndPayBackgroundView.frame.size.width - _contactNameTf.frame.origin.x, _contactNameTf.frame.size.height)];
    [_postTypeTf setFont:_contactNameTf.font];
    [_postTypeTf setText:@"无需"];
    [_postTypeTf setLeftView:postTypeLeft];
    [_postTypeTf setLeftViewMode:UITextFieldViewModeAlways];
    [_postTypeTf setEnabled:NO];
    [postAndPayBackgroundView addSubview:_postTypeTf];
    [postAndPayBackgroundView addSubview:postTypeRight];
    
    [postAndPayBackgroundView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(_postTypeTf), postAndPayBackgroundView.frame.size.width, 0.5)];

    UILabel *payTypeLeft = [[UILabel alloc]initWithFrame:postTypeLeft.bounds];
    [payTypeLeft setFont:postTypeLeft.font];
    [payTypeLeft setText:@"支付方式"];
    [payTypeLeft setTextColor:postTypeLeft.textColor];
    _payTypeTf = [[UITextField alloc]initWithFrame:CGRectMake(_postTypeTf.frame.origin.x, controlYLength(_postTypeTf), _postTypeTf.frame.size.width, _postTypeTf.frame.size.height)];
    [_payTypeTf setFont:_contactNameTf.font];
    [_payTypeTf setText:@"信用卡"];
    [_payTypeTf setLeftView:payTypeLeft];
    [_payTypeTf setEnabled:NO];
    [_payTypeTf setLeftViewMode:UITextFieldViewModeAlways];
    [postAndPayBackgroundView addSubview:_payTypeTf];
    
    [postAndPayBackgroundView setFrame:CGRectMake(postAndPayBackgroundView.frame.origin.x, postAndPayBackgroundView.frame.origin.y, postAndPayBackgroundView.frame.size.width, controlYLength(_payTypeTf))];
    
    UILabel *subjoinTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(baseInfoLabel.frame.origin.x, controlYLength(postAndPayBackgroundView), baseInfoLabel.frame.size.width, baseInfoLabel.frame.size.height)];
    [subjoinTextLabel setFont:baseInfoLabel.font];
    [subjoinTextLabel setTextColor:baseInfoLabel.textColor];
    [subjoinTextLabel setText:@"附加信息"];
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
}

- (void)pressNextBtn:(UIButton*)sender
{
    OrderResultViewController *orderResultView = [[OrderResultViewController alloc]init];
    [self pushViewController:orderResultView transitionType:TransitionPush completionHandler:nil];
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
@property (strong, nonatomic) UILabel       *jobNumLb;
@property (strong, nonatomic) UILabel       *deptLb;

@end

@implementation OrderFillInViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setSubviewFrame
{
    _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (OrderFillCellWidth - OrderFillCellHeight)/3, OrderFillCellHeight)];
    [_nameLb setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_nameLb];
    
    _jobNumLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_nameLb), _nameLb.frame.origin.y, _nameLb.frame.size.width, _nameLb.frame.size.height)];
    [_jobNumLb setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_jobNumLb];
    
    _deptLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_jobNumLb), _jobNumLb.frame.origin.y, _jobNumLb.frame.size.width, _jobNumLb.frame.size.height)];
    [_deptLb setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:_deptLb];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(controlXLength(_deptLb), _deptLb.frame.origin.y, _deptLb.frame.size.height, _deptLb.frame.size.height)];
    [editBtn setImage:imageNameAndType(@"button_bj", Nil) forState:UIControlStateNormal];
    [self.contentView addSubview:editBtn];
    [editBtn setScaleX:0.65 scaleY:0.65];
}

- (void)setContentWithParams:(NSObject *)param
{
    if ([param isKindOfClass:[BookPassengersDTO class]]) {
        BookPassengersDTO *passenger = (BookPassengersDTO*)param;
        [_nameLb setText:passenger.UserName];
        [_jobNumLb setText:passenger.EmployeeID];
        [_deptLb setText:passenger.DeptName];
    }
}

@end

