//
//  SqliteManager.h
//  MiuTrip
//
//  Created by apple on 13-12-7.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SandboxFile.h"
#import "FMDatabase.h"

#define         PATH_DATABASE_SOUCE             [SandboxFile GetPathForResource:@"miutrip.db"]

@interface SqliteManager : NSObject

+ (SqliteManager*)shareSqliteManager;

+ (BOOL)isExistDatabase;
- (BOOL)openDatabase;

- (NSArray*)mappingCityInfo;//获取CityDTO列表
- (NSString*)getCityCNNameWithCityCode:(NSString*)cityCode;

- (NSArray*)mappingAirLineInfo;

- (NSArray*)mappingFlightCitysInfo;

- (NSArray*)mappingHotCitysInfo;

@end
