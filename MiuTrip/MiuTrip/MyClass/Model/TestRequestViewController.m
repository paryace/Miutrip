//
//  TestRequestViewController.m
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "TestRequestViewController.h"
//#import "SearchPassengersRequest.h"
//#import "GetDistrictsRequest.h"
#import "GetNormalFlightsRequest.h"
#import "Utils.h"
#import "GetFlightChangeRuleRequest.h"


@interface TestRequestViewController ()

@end

@implementation TestRequestViewController

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
        [self setSubviewFrame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)setSubviewFrame
{
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 50)];
    [testBtn setBackgroundColor:[UIColor grayColor]];
    [testBtn setTitle:@"测试" forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:testBtn];
    
    
}

-(void)testRequest:(UIButton*)sender{
    
    GetFlightChangeRuleRequest *request = [[GetFlightChangeRuleRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"GetAPIChangeRule"];
    
//
//    [request setCityId:[NSNumber numberWithInt:1]];
//
    [request setRoom:@"3"];
//    [request setArriceDate:@"2013-9-01"];
    [request setPType:[NSNumber numberWithInt:1]];
//    [request setHotelID:[NSNumber numberWithInt:1]];
//    [request setRoomNumber:[NSNumber numberWithInt:1]];
    [request setGuid:@"12"];
    [request setFNo:@"1"];
    [request setOTAType:[NSNumber numberWithInt:1]];
//    [request setDepartDate:@"2013-8-12"];
//    [request setOTAPolicyID:[NSNumber numberWithInt:1]];
    [self.requestManager sendRequest:request];
    
    
    
}


-(void)requestDone:(BaseResponseModel *) response{
    
    [[Model shareModel] showPromptText:@"请求成功" model:YES];
    
}

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    NSMutableString * msg = [[NSMutableString alloc] init];
    [msg appendString:@"请求失败,"];
    [msg appendString:@"错误代码："];
    [msg appendString:[NSString stringWithFormat:@"%@",errorCode]];
    [msg appendString:@"，错误信息："];
    [msg appendString:[NSString stringWithFormat:@"%@",errorMsg]];
    
    [[Model shareModel] showPromptText:msg model:YES];
    NSLog(@"error msg = %@",msg);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

