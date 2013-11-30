//
//  ResponseDelegate.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResponseDelegate <NSObject>

@required
//解析响应并赋值给当前response
-(void) parshJsonToResponse:(NSDictionary *)jsonData;

@end
