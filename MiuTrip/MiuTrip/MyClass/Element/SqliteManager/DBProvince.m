//
//  DBProvince.m
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "DBProvince.h"
#import "SqliteManager.h"

@implementation DBProvince

+ (NSArray*)DBProvinceList
{
    return [[SqliteManager shareSqliteManager] mappingProvinceInfo];
}

@end
