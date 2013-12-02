//
//  RequestDelegate.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestDelegate <NSObject>

@required
//是否要缓存当前的response
-(BOOL)isCacheabled;

//获取request对应的URL
-(NSString *)getRequestURLString;

//生成REQUEST的JSON字符串  hasToken - 请求中是否包含TOKEN
-(NSString *)getRequestJsonString:(BOOL)hasToken;

@optional

//响应缓存的时长，过时后将删除该缓存。
-(long)getCachePeriod;

//获取该请求对应的条件（条件字符串必须唯一）
-(NSString *)getRequestConditions;

@end
