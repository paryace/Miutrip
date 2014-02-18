//
//  SelectAddressViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "DBProvince.h"
#import "SqliteManager.h"

@interface SelectAddressViewController ()

@property (strong, nonatomic) NSArray       *showDataSource;
@property (strong, nonatomic) UITableView   *theTableView;

@property (assign, nonatomic) SelectAddressType     addressType;

@property (strong, nonatomic) ProvinceDTO   *province;
@property (strong, nonatomic) CityDTO       *city;
@property (strong, nonatomic) CantonDTO     *canton;

@property (strong, nonatomic) id            object;

@end

@implementation SelectAddressViewController

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
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithObject:(id)object
{
    self = [super init];
    if (self) {
        _object = object;
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - request handle
- (void)getAddressList
{
    [self getSelectType];
    if (_addressType == SelectAddressCity){
        GetCitysByProvinceIDRequest *request = [self getCitysRequest];
        [self.requestManager sendRequest:request];
    }else if (_addressType == SelectAddressCanton){
        GetCantonsByCityIDRequest *request = [self getCantonsRequest];
        [self.requestManager sendRequest:request];
    }else {
        _showDataSource = [SqliteManager shareSqliteManager].mappingProvinceInfo;
        [_theTableView reloadData];
    }
}

- (void)getSelectType
{
    if ([_object isKindOfClass:[DBProvince class]]) {
        _addressType = SelectAddressCity;
    }else if ([_object isKindOfClass:[CityDTO class]]){
        _addressType = SelectAddressCanton;
    }else{
        _addressType = SelectAddressProvince;
    }
}

- (GetCitysByProvinceIDRequest*)getCitysRequest
{
    if ([_object isKindOfClass:[DBProvince class]]) {
        DBProvince *province = _object;
        GetCitysByProvinceIDRequest *request = [[GetCitysByProvinceIDRequest alloc]initWidthBusinessType:BUSINESS_COMMON methodName:@"GetCitysByProvinceID"];
        [request setProvinceId:[NSNumber numberWithInteger:[province.ProvinceID integerValue]]];
        return request;
    }else{
        [[Model shareModel] showPromptText:@"获取城市列表请求失败" model:YES];
        return nil;
    }

}

- (void)getCitysDone:(GetCitysByProvinceIDResponse*)response
{
    [response getObjects];
    _showDataSource = response.citys;
    [_theTableView reloadData];
}

- (GetCantonsByCityIDRequest *)getCantonsRequest
{
    if ([_object isKindOfClass:[CityDTO class]]) {
        CityDTO *city = _object;
        GetCantonsByCityIDRequest *request = [[GetCantonsByCityIDRequest alloc]initWidthBusinessType:BUSINESS_COMMON methodName:@"GetCantonsByCityID"];
        [request setCityID:[NSNumber numberWithInteger:[city.CityID integerValue]]];
        return request;
    }else{
        [[Model shareModel] showPromptText:@"获取区域列表请求失败" model:YES];
        return nil;
    }
}

- (void)getCantonsDone:(GetCantonsByCityIDResponse*)response
{
    [response getObjects];
    _showDataSource = response.cantons;
    [_theTableView reloadData];
}

- (void)requestDone:(BaseResponseModel *)response
{
    if ([response isKindOfClass:[GetCitysByProvinceIDResponse class]]) {
        [self getCitysDone:(GetCitysByProvinceIDResponse*)response];
    }else if ([response isKindOfClass:[GetCantonsByCityIDResponse class]]){
        [self getCantonsDone:(GetCantonsByCityIDResponse*)response];
    }
}

- (void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}

#pragma mark - table view handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        [cell.textLabel setAutoSize:YES];
        [cell.detailTextLabel setAutoSize:YES];
    }
    id object = [_showDataSource objectAtIndex:indexPath.row];
    if ([object isKindOfClass:[DBProvince class]]) {
        DBProvince *province = object;
        [cell.textLabel setText:province.ProvinceName];
    }else if ([object isKindOfClass:[CityDTO class]]){
        CityDTO *city = object;
        [cell.textLabel setText:city.CityName];
    }else if ([object isKindOfClass:[CantonDTO class]]){
        CantonDTO *canton = object;
        [cell.textLabel setText:canton.Canton_Name];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [_showDataSource objectAtIndex:indexPath.row];
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate selectAddressDone:object];
    }];
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"配送地址"];
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
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(self.topBar), self.view.frame.size.width, self.view.frame.size.height - controlYLength(self.topBar) - self.bottomBar.frame.size.height)];
    [_theTableView setBackgroundColor:color(whiteColor)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.view addSubview:_theTableView];
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
