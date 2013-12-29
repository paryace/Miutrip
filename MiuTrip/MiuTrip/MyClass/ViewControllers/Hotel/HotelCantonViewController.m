//
//  HotelCantonViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-22.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelCantonViewController.h"
#import "GetHotelDistrictsRequest.h"
#import "GetHotelDistrictsResponse.h"
#import "HotelDataCache.h"

@interface HotelCantonViewController ()

@end

@implementation HotelCantonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        [self setUpViews];
    }
    return self;
}


-(void)setUpViews
{
    [self addTitleWithTitle:@"酒店位置"];
    [self addLoadingView];
    [self getCityCantons];
    
}

-(void)addTableView{
    
    [self removeLoadingView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.contentView.frame.size.width, self.contentView.frame.size.height-50)];
    [tableView setTag:1001];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [self.contentView addSubview:tableView];
    
}

#pragma mark send and get data from server

-(void)getCityCantons
{
    GetHotelDistrictsRequest *request = [[GetHotelDistrictsRequest alloc] initWidthBusinessType:BUSINESS_COMMON methodName:@"GetDistricts"];
    request.cityId = [NSNumber numberWithInt:448];
    
    [self.requestManager sendRequest:request];
    
}


-(void)requestDone:(BaseResponseModel *)responseData
{
    GetHotelDistrictsResponse *reponse = (GetHotelDistrictsResponse*)responseData;
    _cantonData = reponse.Data;
    [self addTableView];
}

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    
}


#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _cantonData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cell = @"cantonCell";
    
    UITableViewCell *tableCellView = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cell];
    if(!tableCellView){
        tableCellView = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    NSDictionary *data = [_cantonData objectAtIndex:indexPath.row];
    tableCellView.textLabel.text = [data objectForKey:@"DistrictName"];
    return tableCellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = [_cantonData objectAtIndex:indexPath.row];
    HotelDataCache *hotelData = [HotelDataCache sharedInstance];
    hotelData.queryCantonName = [data objectForKey:@"DistrictName"];
    hotelData.queryCantonId = [[data objectForKey:@"ID"] intValue];
    [self dismissViewControllerAnimated:NO completion:nil];
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
