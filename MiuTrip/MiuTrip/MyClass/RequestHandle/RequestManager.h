//
//  RequestManager.h
//  MiuTrip
//
//  Created by apple on 13-11-27.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "BaseRequestModel.h"
#import "BaseResponseModel.h"

#define KEY_REQUEST_CLASS_NAME  @"request_class_name"


@protocol BusinessDelegate <NSObject>

@optional

/**
 *  发送的请求成功
 *
 *  @param response 请求对应的响应对象
 */
-(void)requestDone:(BaseResponseModel *) response;

/**
 *  请求失败
 *
 *  @param errorCode 错误代码
 *  @param errorMsg  错误消息
 */
-(void)requestFailedWithErrorCode:(NSNumber *) errorCode withErrorMsg:(NSString *) errorMsg;

/**
 *  请求被取消（暂不处理）
 */
-(void)requestCanceled;

@end


@interface RequestManager : NSObject


@property (nonatomic,strong) id<BusinessDelegate> delegate;

/**
 *  发送一个请求到服务端
 *
 *  @param request
 */
-(void)sendRequest:(BaseRequestModel*)request;

/**
 *  发送一个请求到服务端（请求中不包含TOKEN 目前只有登录的时候用）
 *
 *  @param request
 */
-(void)sendRequestWithoutToken:(BaseRequestModel *)request;



@end
