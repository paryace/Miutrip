//
//  GetNormalFlightsResponse.m
//  MiuTrip
//
//  Created by apple on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "GetNormalFlightsResponse.h"

@implementation GetNormalFlightsResponse

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    NSArray *parshData = nil;
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    parshData = [(NSDictionary*)jsonData objectForKey:@"flights"];
    if (![parshData isKindOfClass:[NSArray class]]) {
        return;
    }
    _flights = [GetNormalFlightsResponse getNormalFlightsResponseWithData:parshData];
}

+ (NSMutableArray *)getNormalFlightsResponseWithData:(NSArray*)data
{
    NSMutableArray *flightsResponse = [NSMutableArray array];
    for (NSDictionary *flightDetail in data) {
        DomesticFlightDataDTO *flightData = [[DomesticFlightDataDTO alloc]init];
        [flightData parshJsonToResponse:flightDetail];
        [flightsResponse addObject:flightData];
        
    }

    return flightsResponse;
}


@end

@implementation DomesticFlightDataDTO


- (id)init
{
    self = [super init];
    if (self) {
        _unfold = [NSNumber numberWithBool:NO];
    }
    return self;
}

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *dicData = (NSDictionary*)jsonData;

    [super parshJsonToResponse:jsonData];
    _AirLine = [[AirlineDTO alloc]init];
    _Dairport = [[AirportDTO alloc]init];
    _Aairport = [[AirportDTO alloc]init];
    [_AirLine parshJsonToResponse:[dicData objectForKey:@"Airline"]];
    [_Dairport parshJsonToResponse:[dicData objectForKey:@"DAirport"]];
    [_Aairport parshJsonToResponse:[dicData objectForKey:@"AAirport"]];
    
    NSArray *moreFlights = [dicData objectForKey:@"MoreFlights"];
    if (![moreFlights isKindOfClass:[NSArray class]]) {
        return;
    }
    
    _conformLevel = @"F";

    _MoreFlights = [GetNormalFlightsResponse getNormalFlightsResponseWithData:moreFlights];
}


@end