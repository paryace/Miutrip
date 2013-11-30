//
//  RequestManager.m
//  MiuTrip
//
//  Created by apple on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "RequestManager.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "UserDefaults.h"
#import "Utils.h"
#import "Model.h"
#import "AppDelegate.h"

@implementation RequestManager

- (void)logIn:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/login/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              LogIn,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)logOut
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/logout/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              Logout,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:nil userInfo:userInfo];
}

- (void)getUserLoginInfo
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetUserLoginInfo/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetUserLoginInfo,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:nil userInfo:userInfo];
}

- (void)getTravelLifeInfo
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetTravelLifeInfo/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetTravelLifeInfo,           @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:nil userInfo:userInfo];
}

- (void)changePassword:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/ChangePassword/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              ChangePassword,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getContact:(NSDictionary*)params
{
    if (!params) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInteger:[UserDefaults shareUserDefault].loginInfo.CorpID], @"CorpID",
                  nil];
        NSLog(@"corpId = %@",[params objectForKey:@"CorpID"]);
    }
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetContact/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetContact,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)deleteMemberPassenger:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/DeleteMemberPassenger/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              DeleteMemberPassenger,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCorpServerCardList:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetCorpServerCardList/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCorpServerCardList,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)searchPassengers:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/SearchPassengers/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              SearchPassengers,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCorpStaff:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetCorpStaff/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCorpStaff,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCorpUserBaseInfo:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetCorpUserBaseInfo/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCorpUserBaseInfo,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCorpPolicy:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetCorpPolicy/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCorpPolicy,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCorpCost:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetCorpCost/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCorpCost,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCorpInfo:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetCorpInfo/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCorpInfo,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getMemberDeliverList:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/GetMemberDeliverList/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetMemberDeliverList,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)deleteMemberDeliver:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/DeleteMemberDeliver/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              DeleteMemberDeliver,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)deleteDeliver:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/DeleteDeliver/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              DeleteDeliver,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)savePassengerList:(NSDictionary*)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:@"/account_1_0/SavePassengerList/api"];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              SavePassengerList,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)cancelOrder:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:CancelOrder];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              CancelOrder,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCraftType:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetCraftType];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCraftType,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAPIInsuranceConfig:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAPIInsuranceConfig];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAPIInsuranceConfig,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAPIMailConfig:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAPIMailConfig];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAPIMailConfig,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAPIStopInfo:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAPIStopInfo];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAPIStopInfo,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAPIChangeRule:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAPIChangeRule];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAPIChangeRule,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAirport:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAirport];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAirport,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getCabin:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetCabin];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCabin,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAllAirLine
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetCabin];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetCabin,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:nil userInfo:userInfo];
}

- (void)getAirportByCity:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAirportByCity];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAirportByCity,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAirLine:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAirLine];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAirLine,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getAllAirport
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetAllAirport];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetAllAirport,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:nil userInfo:userInfo];
}

- (void)getOrder:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetOrder];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetOrder,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)getNormalFlights:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:GetNormalFlights];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              GetNormalFlights,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)saveOnlineOrder:(NSDictionary *)params
{
    NSString *urlString = [MiuTripURL stringByAppendingString:SaveOnlineOrder];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                              SaveOnlineOrder,            @"requestType",
                              nil];
    [self sendRequestWithURL:urlString params:params userInfo:userInfo];
}

- (void)sendRequestWithURL:(NSString*)URLString params:(NSDictionary*)_params userInfo:(NSDictionary*)userInfo
{
    NSString *requestType = [userInfo objectForKey:@"requestType"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URLString]];
    [request setUserInfo:userInfo];
    NSMutableDictionary *params = nil;
    if (_params) {
        params = [NSMutableDictionary dictionaryWithDictionary:_params];
    }else{
        params = [NSMutableDictionary dictionary];
    }
    [params setObject:deviceId forKey:@"deviceId"];
    [params setObject:@"0" forKey:@"appId"];
    [params setObject:[Utils stringWithDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"processTime"];
    if (![requestType isEqualToString:LogIn]) {
        if ([UserDefaults shareUserDefault].authTkn) {
            [params setObject:[UserDefaults shareUserDefault].authTkn forKey:@"authTkn"];
        }
    }
    
    [request setPostValue:[params JSONRepresentation] forKey:@"Json"];
    [request setDelegate:self];
    
    [request setTimeOutSeconds:30];
    [request setUseCookiePersistence:NO];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *requestType = [request.userInfo objectForKey:@"requestType"];
    NSLog(@"responseString = %@",[request.responseString JSONValue]);
    NSDictionary *dic = [request.responseString JSONValue];
    if ([[dic objectForKey:@"process_status"] isEqualToString:@"0"]) {
        if ([requestType isEqualToString:LogIn]) {
            [UserDefaults shareUserDefault].authTkn = [dic objectForKey:@"authTkn"];
            [self.delegate logInDone];
        }else if ([requestType isEqualToString:Logout]){
            [[UserDefaults shareUserDefault] clearDefaults];
            [self.delegate logOutDone];
        }else if ([requestType isEqualToString:GetUserLoginInfo]){
            [UserDefaults shareUserDefault].loginInfo = [[LoginInfoDTO alloc]initWithData:dic];
            [self.delegate getUserLoginInfoDone:[UserDefaults shareUserDefault].loginInfo];
        }else if ([requestType isEqualToString:GetTravelLifeInfo]){
            TravelLifeInfo *travelLife = [[TravelLifeInfo alloc]initWithData:dic];
            [self.delegate getTravelLifeInfoDone:travelLife];
        }else if ([requestType isEqualToString:ChangePassword]){
            
        }else if ([requestType isEqualToString:GetContact]){
            NSArray *passengersList = [BookPassengersDTO getListWithData:[dic objectForKey:@"result"]];
            [self.delegate getContactDone:passengersList];
        }else if ([requestType isEqualToString:DeleteMemberPassenger]){
            
        }else if ([requestType isEqualToString:GetCorpServerCardList]){
            
        }else if ([requestType isEqualToString:SearchPassengers]){
            
        }else if ([requestType isEqualToString:GetCorpStaff]){
            
        }else if ([requestType isEqualToString:GetCorpUserBaseInfo]){
            
        }else if ([requestType isEqualToString:GetCorpPolicy]){
            
        }else if ([requestType isEqualToString:GetCorpCost]){
            
        }else if ([requestType isEqualToString:GetCorpInfo]){
            
        }else if ([requestType isEqualToString:GetMemberDeliverList]){
            
        }else if ([requestType isEqualToString:DeleteMemberDeliver]){
            
        }else if ([requestType isEqualToString:DeleteDeliver]){
            
        }else if ([requestType isEqualToString:SavePassengerList]){
            
        }else{
            [self.delegate requestDone:request];
        }
    }else{
        [[Model shareModel] showPromptText:[NSString stringWithFormat:@"%@\n错误码%@",[dic objectForKey:@"errorMessage"],[dic objectForKey:@"errorCode"]] model:YES];
        [self.delegate requestError:request];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[Model shareModel] showPromptText:@"请求失败" model:YES];
    [self.delegate requestError:request];
}


@end
