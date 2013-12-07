//
//  TestRequestViewController.m
//  MiuTrip
//
//  Created by Y on 13-12-3.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "TestRequestViewController.h"

#import "LoginRequest.h"//
#import "LoginResponse.h"//
#import "ChangePasswordRequest.h"//

#import "GetTravelLifeInfoRequest.h"//

#import "GetContactRequest.h"//
#import "GetCorpServerCardListRequest.h"//
#import "SearchPassengersRequest.h"//
#import "GetCorpUserBaseInfoRequest.h"//


#import "GetCorpPolicyRequest.h"//
#import "GetCorpCostRequest.h"//
#import "GetCorpStaffRequest.h"//
#import "GetCorpInfoRequest.h"//
#import "GetLoginUserInfoRequest.h"//

#import "DeleteMemberPassengerRequest.h"//1
#import "GetMemberDeliverListRequest.h"//

#import "DeleteMemberDeliverRequest.h"//2
#import "DeleteDeliverRequest.h"//
#import "SavePassengerListRequest.h"//3
#import "UpdateCropUserBaseByChinaUMSUIDRequest.h"//4
#import "GetCorpNameByMumberUIDRequest.h"//5错误信息：未知错误，请稍候再试。
#import "LogoutRequest.h"//



#import "GetCityByProvinceIDRequest.h"//
#import "SaveSMSRequest.h"//6错误信息：业务类型不正确
#import "GetDistrictsRequest.h"//



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
     

    SaveSMSRequest *request = [[SaveSMSRequest alloc] initWidthBusinessType:BUSINESS_COMMON methodName:@"SaveSMS"];
    
    //[request setAddID:[NSNumber numberWithInt:7]];
    //[request setPolicyid:[NSNumber numberWithInt:139]];
    //[request setUid:@"10000017"];
    //[request setCorpID:@"96"];
    //[request setCorpID:[NSNumber numberWithInt:96]];
    //[request setCorpId:[NSNumber numberWithInt:96]];
    
   // [request setPassengerID:[NSNumber numberWithInt:0 ]];
//    [request setUID:[NSNumber numberWithInt:10000017]];
//    [request setChinaUmsUID:[NSNumber numberWithInt:0]];
//    [request setCityID:@"0"];
//    [request setCropName:@"0"];
//    [request setSourceID:@"0"];
//    [request setOldPassword:@"10000017"];
//    [request setPassword:@"123456"];
//    [request setLoginToken:[UserDefaults shareUserDefault].authTkn];
    
//    [request setUID:[NSNumber numberWithInt:10000017]];
//    [request setChinaUmsUID:[NSNumber numberWithInt:100000]];
//    [request setCropName:@"觅优信息技术有限公司"];
//    [request setCityID:@"1"];
//    [request setTel:[NSNumber numberWithLongLong:13555297817]];
//    [request setUserName:@"10000017"];
//    [request setEmail:@"100000"];
//    [request setMobilephone:[NSNumber numberWithLongLong:13555297817]];
//    [request setLoginPass:@"123456"];
//    [request setSinaWeibUID:@"46523134"];
//    [request setSourceID:@"1"];
    
    
    
    
    
    //[request setProvinceID:[NSNumber numberWithInt:1]];
    //[request setCityID:[NSNumber numberWithInt:1]];
    
    [request setSMSID:[NSNumber numberWithInt:7]];
    [request setBussinessType:[NSNumber numberWithInt:7]];
    [request setOrderID:@"11001"];
    [request setMobile:@"13555297817"];
    [request setSmsContent:@"1111111"];
    [request setAddCode:@"13555297817"];
    [request setPriority:[NSNumber numberWithInt:1]];
    [request setSendTime:[NSDate date]];
    [request setScheduleTime:[[NSDate date]dateByAddingTimeInterval:60*60*24]];
    [request setDeadline:[[NSDate date]dateByAddingTimeInterval:60*60*24]];
    [request setSatatus:@"w"];
    [request setTotalCount:[NSNumber numberWithInt:100]];
    [request setRetry:[NSNumber numberWithInt:2]];
    [request setCreater:@"aaa"];
    [request setCreateTime:[[NSDate date]dateByAddingTimeInterval:60*60*24]];
    [request setChannel:@"1222"];
    [request setOperatreTime:[[NSDate date]dateByAddingTimeInterval:60*60*24]];
    [request setErrorCode:@"94"];
    
    
    [self.requestManager sendRequest:request];
    
    
    
}


-(void)requestDone:(BaseResponseModel *) response{

    [[Model shareModel] showPromptText:@"请求成功" model:YES];
//    GetLoginUserInfoResponse *loginUserInfo = (GetLoginUserInfoResponse*)response;
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
