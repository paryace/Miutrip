//
//  DBProvince.h
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBProvince : NSObject

@property (strong, nonatomic) NSString      *ProvinceID;
@property (strong, nonatomic) NSString      *ProvinceName;

+ (NSArray*)DBProvinceList;

@end
