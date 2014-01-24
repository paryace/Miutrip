//
//  SqliteManager.m
//  MiuTrip
//
//  Created by apple on 13-12-7.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "SqliteManager.h"
#import "Common.h"
#import "DBAirLine.h"
#import "DBFlightCitys.h"
#import "DBHotCitys.h"
#import "Nation.h"
#import "HotCityData.h"
#import "SelectShopCityData.h"
static  SqliteManager   *shareSqliteManager;

@interface SqliteManager ()

@property (strong, nonatomic) FMDatabase    *database;

@end

@implementation SqliteManager

+ (SqliteManager*)shareSqliteManager
{
    @synchronized(self){
        if (shareSqliteManager == nil) {
            shareSqliteManager = [[SqliteManager alloc]init];
        }
    }
    return shareSqliteManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        _database = [[FMDatabase alloc]initWithPath:PATH_DATABASE_SOUCE];
    }
    return self;
}

+ (BOOL)isExistDatabase
{
    BOOL exist = NO;
    if ([SandboxFile IsFileExists:PATH_DATABASE_SOUCE]) {
        exist = YES;
    }
     
    return exist;
}

- (BOOL)openDatabase
{
    BOOL openDone = NO;
    if ([SqliteManager isExistDatabase]) {
        openDone = [_database open];
    }
    return openDone;
}

- (NSArray*)mappingCityInfo
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM wineshopcity"];
        while ([resultSet next]) {
            CityDTO *city = [[CityDTO alloc]init];
            city.CityID   = [NSNumber numberWithInteger:[resultSet intForColumn:@"CityID_TongCheng"]];
            city.CityRequestParams = [resultSet stringForColumn:@"CityCode"];
            city.CityName = [resultSet stringForColumn:@"CityName"];
            city.CityCode = [NSString stringWithUTF8String:(const char *)[resultSet UTF8StringForColumnName:@"StartChar"]];
            city.ProvinceID = [NSNumber numberWithInteger:[resultSet intForColumn:@"ProvinceID"]];
            
            [array addObject:city];
        }
    }
    return array;
}

- (NSString*)getCityCNNameWithCityCode:(NSString*)cityCode
{
    NSString *cityCNName = nil;
    NSArray *allCity = [self mappingCityInfo];
    for (CityDTO *city in allCity) {
        if ([city.CityRequestParams isEqualToString:cityCode]) {
            cityCNName = city.CityName;
        }
    }
    return cityCNName;
}

- (NSArray*)mappingAirLineInfo
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM airLine"];
        while ([resultSet next]) {
            DBAirLine *airLine = [[DBAirLine alloc]init];
            airLine.airLine = [resultSet stringForColumn:@"airline"];
            airLine.name  = [resultSet stringForColumn:@"name"];
            airLine.short_name = [resultSet stringForColumn:@"short_name"];
            [array addObject:airLine];
        }
    }
    return array;
}

- (NSArray*)mappingFlightCitysInfo
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM flightcitys"];
        while ([resultSet next]) {
            DBFlightCitys *flightCity = [[DBFlightCitys alloc]init];
            flightCity.en_name = [resultSet stringForColumn:@"englishcity_name"];
            flightCity.cn_name = [resultSet stringForColumn:@"name"];
            flightCity.nameCode = [resultSet stringForColumn:@"number_name"];
            [array addObject:flightCity];
        }
    }
    return array;
}

- (NSArray*)mappingHotCitysInfo
{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM hotcity"];
        while ([resultSet next]) {
            DBHotCitys *hotCity = [[DBHotCitys alloc]init];
            hotCity.en_name = [resultSet stringForColumn:@"englishcity_name"];
            hotCity.cn_name = [resultSet stringForColumn:@"name"];
            hotCity.nameCode = [resultSet stringForColumn:@"number_name"];
            [array addObject:hotCity];
        }
    }
    return array;
}
- (NSArray*)mappingNationInfo{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM nation"];
        while ([resultSet next]) {
            Nation *nation = [[Nation alloc]init];
            nation.name=[resultSet stringForColumn:@"name"];
            nation.china_name=[resultSet stringForColumn:@"china_name"];
            nation.abb_name =[resultSet stringForColumn:@"abb_name"];
            
            
            
            [array addObject:nation];
        }
    }
    return array;
}
-(NSArray*)mappingHotCityInfo{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM hotcity"];
        while ([resultSet next]) {
            HotCityData *hotcity = [[HotCityData alloc]init];
            hotcity.EnglishCityName=[resultSet stringForColumn:@"english_name"];
            hotcity.CityName=[resultSet stringForColumn:@"city_name"];
            hotcity.AddreName =[resultSet stringForColumn:@"abbre_name"];
            [array addObject:hotcity];
        }
    }
    return array;
}
-(NSArray*)mappingWineShopCityInfo{
    NSMutableArray *array = [NSMutableArray array];
    if ([self openDatabase]) {
        FMResultSet *resultSet = [_database executeQuery:@"SELECT * FROM wineshopcity"];
        while ([resultSet next]) {
            SelectShopCityData *wineShopCity =[[SelectShopCityData alloc]init];
            wineShopCity.CityName=[resultSet stringForColumn:@"CityName"];
            wineShopCity.StartChar=[resultSet stringForColumn:@"StartChar"];
            [array addObject:wineShopCity];
        }
    }
    return array;
    
}
@end
