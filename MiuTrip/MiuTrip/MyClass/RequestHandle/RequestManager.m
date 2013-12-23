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


-(id)init{
    if(self == [super init]){
        //设置缓存路径
        ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
        NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        [cache setStoragePath:cachePath];
    }
    return self;
}


-(void)sendRequest:(BaseRequestModel*)request{
    
    if(request == nil){
        return;
    }
    
    //从缓存中读取上次缓存的响应
    if([request isCacheabled]){
        NSString *condition = [request getRequestConditions];
        if(condition){
            //从缓存中获取响应数据
            NSString *data = [[ASIDownloadCache sharedCache] cachedResponseDataFotCondition:condition withMaxAage:[request getCachePeriod]];
            
            if(data && data.length > 0){
                BaseResponseModel *response = [self getResponseFromRequestClassName: [NSString stringWithUTF8String:object_getClassName(request)]];
                if(response){
                    NSLog(@"从缓存中读取response = %@",data);
                    [response parshJsonToResponse:[data JSONValue]];
                    [_delegate requestDone:response];
                    return;
                }
            }
        }
    }
    
    NSString *URLString = [request getRequestURLString];
    NSLog(@"URL = %@",URLString);
    ASIFormDataRequest *asiRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    
    //将请求类名称放入到请求中
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSString stringWithUTF8String:object_getClassName(request)] forKey:KEY_REQUEST_CLASS_NAME];

    [dic setObject:[NSNumber numberWithBool:request.isCacheabled] forKey:KEY_REQUEST_CACHEABLE];
    if(request.isCacheabled){
        [dic setObject:request.getRequestConditions forKey:KEY_REQUEST_CONDITION];
    }
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
    NSString *jsonString = [request getRequestJsonString:NO];
    NSLog(@"JSON = %@",jsonString);

    
    [asiRequest setPostValue:jsonString forKey:@"Json"];
    [asiRequest setDelegate:self];
    
    [asiRequest setTimeOutSeconds:30];
    [asiRequest setUseCookiePersistence:NO];
    [asiRequest startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"responseString = %@",request.responseData);
    NSDictionary *reposneData = [request.responseString JSONValue];
    if ([[reposneData objectForKey:@"process_status"] isEqualToString:@"0"]) {
        
        NSDictionary *userInfo = [request userInfo];
        if(userInfo != nil){
            //获取请求的类名称
            NSString *requestClassName = [userInfo objectForKey:KEY_REQUEST_CLASS_NAME];
                
                BaseResponseModel *response = [self getResponseFromRequestClassName:requestClassName];
                
                [response parshJsonToResponse:reposneData];
                [_delegate requestDone:response];
            }
            
        }else{
            [[Model shareModel] showPromptText:[NSString stringWithFormat:@"%@\n错误码%@",[reposneData objectForKey:@"errorMessage"],[reposneData objectForKey:@"errorCode"]] model:YES];
            [_delegate requestFailedWithErrorCode:[reposneData objectForKey:@"errorCode"] withErrorMsg:[reposneData objectForKey:@"errorMessage"]];
        }
    
}

- (void)failWithError:(NSError *)theError{
    
    [_delegate requestFailedWithErrorCode:[NSNumber numberWithInteger:theError.code] withErrorMsg:theError.localizedDescription];

}

-(BaseResponseModel*) getResponseFromRequestClassName:(NSString*) requestClassName{
    
    if(requestClassName == nil || requestClassName.length == 0){
        return nil;
    }
    
    if([requestClassName hasSuffix:@"Request"]){
        //替换字符串生成对应的RESPONSE类名称
        NSString *responseClassName = [requestClassName stringByReplacingOccurrencesOfString:@"Request" withString:@"Response"];
        //反射出对应的类
        Class responseClass = NSClassFromString(responseClassName);
        //没找到该类，或出错
        if(!responseClass){
            return nil;
        }
        //生成对应的对象
        return [[responseClass alloc] init];
    }
    
    return nil;
}

@end
