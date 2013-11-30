//
//  BaseRequestModel.h
//  MiuTrip
//
//  Created by stevencheng on 13-11-28.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "RequestDelegate.h"
#import "SBJson.h"
#import "Utils.h"
#import "UserDefaults.h"


@interface BaseRequestModel : NSObject<RequestDelegate>
    
@end

