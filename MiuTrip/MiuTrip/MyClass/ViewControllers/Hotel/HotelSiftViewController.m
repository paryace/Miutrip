//
//  HotelSiftViewController.m
//  MiuTrip
//
//  Created by MB Pro on 14-3-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelSiftViewController.h"
#import "SiftCorpCell.h"
#import "HotelDataCache.h"
#import "GetHotelDistrictsRequest.h"
#import "Utils.h"

@interface HotelSiftViewController ()

@property (strong, nonatomic) NSArray      *keys;
@property (strong, nonatomic) NSArray      *dataSource;
@property (strong, nonatomic) UITableView  *priceRangeTableView;
@property (strong, nonatomic) UITableView  *hotelLocTableView;

@property (strong, nonatomic) NSNumber       *priceRangeIndex;
@property (strong, nonatomic) NSDictionary   *canton;

@end

@implementation HotelSiftViewController

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
    self = [super init];
    if (self) {
        [self.contentView setHidden:NO];
        [self setUpView];
    }
    return self;
}

- (void)GetDistricts
{
    [self addLoadingView];
    GetHotelDistrictsRequest *request = [[GetHotelDistrictsRequest alloc]initWidthBusinessType:BUSINESS_COMMON methodName:@"GetDistricts"];
    [request setCityId:[NSNumber numberWithInt:[HotelDataCache sharedInstance].checkInCityId]];
    [self.requestManager sendRequest:request];
}

- (void)getDistrictsDone:(GetHotelDistrictsResponse*)response
{
    [self removeLoadingView];
    _dataSource = response.Data;
    [self setUpSubView];
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetHotelDistrictsResponse class]]) {
        [self getDistrictsDone:(GetHotelDistrictsResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

- (void)pressRightBtn:(UIButton*)sender
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (![Utils isEmpty:_canton]) {
        [dict setObject:_canton forKey:@"canton"];
    }
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate hotelSiftSelectDone:dict];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCELLHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _priceRangeTableView) {
        return [[HotelDataCache sharedInstance].priceRangeArray count];
    }else if (tableView == _hotelLocTableView){
        return [_dataSource count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    SiftCorpCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[SiftCorpCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (tableView == _priceRangeTableView) {
        NSString *priRange = [[HotelDataCache sharedInstance].priceRangeArray objectAtIndex:indexPath.row];
        [cell setDetail:priRange];
        [cell setIsSelected:([HotelDataCache sharedInstance].priceRangeIndex == indexPath.row)];
    }else if (tableView == _hotelLocTableView) {
        NSDictionary *dic = [_dataSource objectAtIndex:indexPath.row];
        [cell setDetail:[dic objectForKey:@"DistrictName"]];
        BOOL equal = ([HotelDataCache sharedInstance].queryCantonId == [[dic objectForKey:@"ID"] integerValue]);
        [cell setIsSelected:equal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _priceRangeTableView) {
        [HotelDataCache sharedInstance].priceRangeIndex = indexPath.row;
        [tableView reloadData];
    }else{
        NSDictionary *district = [_dataSource objectAtIndex:indexPath.row];
        HotelDataCache *data = [HotelDataCache sharedInstance];
        [data setQueryCantonName:[district objectForKey:@"DistrictName"]];
        [data setQueryCantonId:[[district objectForKey:@"ID"] intValue]];
        [tableView reloadData];
    }
}

- (void)setHotelSiftRule:(NSDictionary *)hotelSiftRule
{
    if (_hotelSiftRule != hotelSiftRule) {
        _hotelSiftRule = hotelSiftRule;
    }
    _canton          = [_hotelSiftRule objectForKey:@"canton"];
}

- (void)setUpView
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    [self setTitle:@"酒店筛选"];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setFrame:CGRectMake(appFrame.size.width - returnBtn.frame.size.width, returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
    [rightBtn setScaleX:0.7 scaleY:0.7];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_dark", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_light", nil) forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)setUpSubView
{
    UILabel *priceRangeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar), self.view.frame.size.width - 20, 40)];
    [priceRangeLb setFont:[UIFont systemFontOfSize:14]];
    [priceRangeLb setText:@"价格范围"];
    [self.contentView addSubview:priceRangeLb];
    
    _priceRangeTableView = [[UITableView alloc]initWithFrame:CGRectMake(priceRangeLb.frame.origin.x, controlYLength(priceRangeLb), priceRangeLb.frame.size.width, [[HotelDataCache sharedInstance].priceRangeArray count] * kCELLHEIGHT)];
    [_priceRangeTableView setDelegate:self];
    [_priceRangeTableView setDataSource:self];
    [_priceRangeTableView setScrollEnabled:NO];
    [_priceRangeTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_priceRangeTableView setBackgroundColor:color(whiteColor)];
    [_priceRangeTableView setCornerRadius:5.0];
    [_priceRangeTableView setBorderColor:color(lightGrayColor) width:0.5];
    [self.contentView addSubview:_priceRangeTableView];
    
    if ([_dataSource count] != 0) {
        UILabel *hotelLocLb = [[UILabel alloc]initWithFrame:CGRectMake(priceRangeLb.frame.origin.x, controlYLength(_priceRangeTableView), priceRangeLb.frame.size.width, priceRangeLb.frame.size.height)];
        [hotelLocLb setFont:priceRangeLb.font];
        [hotelLocLb setText:@"酒店位置"];
        [self.contentView addSubview:hotelLocLb];
        
        _hotelLocTableView = [[UITableView alloc]initWithFrame:CGRectMake(priceRangeLb.frame.origin.x, controlYLength(hotelLocLb), priceRangeLb.frame.size.width, [_dataSource count] * kCELLHEIGHT)];
        [_hotelLocTableView setDelegate:self];
        [_hotelLocTableView setDataSource:self];
        [_hotelLocTableView setScrollEnabled:NO];
//        [_hotelLocTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_hotelLocTableView setBackgroundColor:color(whiteColor)];
        [_hotelLocTableView setCornerRadius:5.0];
        [_hotelLocTableView setBorderColor:color(lightGrayColor) width:0.5];
        [self.contentView addSubview:_hotelLocTableView];
    }
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
