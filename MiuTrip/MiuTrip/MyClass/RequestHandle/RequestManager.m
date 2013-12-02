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


-(void)sendRequest:(BaseRequestModel*)request{
    
    if(request == nil){
        return;
    }
    
    NSString *URLString = [request getRequestURLString];
    NSLog(@"URL = %@",URLString);
    ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求类名称放入到请求中
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:  [NSString stringWithUTF8String:object_getClassName(request)],KEY_REQUEST_CLASS_NAME,nil];
    [asiRequest setUserInfo:dic];
    
    //解析request,生成对应的请求JSON
    NSString *jsonString = [request getRequestJsonString:YES];
    NSLog(@"JSON = %@",jsonString);
    
    [asiRequest setPostValue:jsonString forKey:@"Json"];
    [asiRequest setDelegate:self];
    
    [asiRequest setTimeOutSeconds:30];
    [asiRequest setUseCookiePersistence:NO];
    [asiRequest startAsynchronous];
    
}

-(void)sendRequestWithoutToken:(BaseRequestModel *)request{
    
    if(request == nil){
        return;
    }
    
    NSString *URLString = [request getRequestURLString];
    NSLog(@"URL = %@",URLString);
    ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:  [NSString stringWithUTF8String:object_getClassName(request)],KEY_REQUEST_CLASS_NAME,nil];
    [asiRequest setUserInfo:dic];
    
    //解析request,生成对应的请求JSON
    NSString *jsonString = [request getRequestJsonString:YES];
    NSLog(@"JSON = %@",jsonString);

    
    [asiRequest setPostValue:jsonString forKey:@"Json"];
    [asiRequest setDelegate:self];
    
    [asiRequest setTimeOutSeconds:30];
    [asiRequest setUseCookiePersistence:NO];
    [asiRequest startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseString = %@",[request.responseString JSONValue]);
    if ([[request.responseString JSONValue] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *reposneData = [request.responseString JSONValue];
        if ([[reposneData objectForKey:@"process_status"] isEqualToString:@"0"]) {
            
            NSDictionary *userInfo = [request userInfo];
            if(userInfo != nil){
                //获取请求的类名称
                NSString *requestClassName = [userInfo objectForKey:KEY_REQUEST_CLASS_NAME];
                
                if([requestClassName hasSuffix:@"Request"]){
                    //替换字符串生成对应的RESPONSE类名称
                    NSString *responseClassName = [requestClassName stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
                    //反射出对应的类
                    Class responseClass = NSClassFromString(responseClassName);
                    //没找到该类，或出错
                    if(!responseClass){
                        return;
                    }
                    //生成对应的对象
                    BaseResponseModel *response = [[responseClass alloc] init];
                    //反射解析赋值
                    [response parshJsonToResponse:reposneData];
                    
                    [_delegate requestDone:response];
                }
                
            }
            
        }else{
            [[Model shareModel] showPromptText:[NSString stringWithFormat:@"%@\n错误码%@",[reposneData objectForKey:@"errorMessage"],[reposneData objectForKey:@"errorCode"]] model:YES];
            [_delegate requestFailedWithErrorCode:[reposneData objectForKey:@"errorCode"] withErrorMsg:[reposneData objectForKey:@"errorMessage"]];
        }
    }
}

- (void)failWithError:(NSError *)theError{
    
    [_delegate requestFailedWithErrorCode:[NSNumber numberWithInteger:theError.code] withErrorMsg:theError.localizedDescription];

}


@end
