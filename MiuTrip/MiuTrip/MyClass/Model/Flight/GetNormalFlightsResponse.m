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
//    NSLog(@"jsonData = %@",[(NSDictionary*)jsonData objectForKey:@"flights"]);
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
//    NSLog(@"superdata = %@",data);
    NSMutableArray *flightsResponse = [NSMutableArray array];
    for (NSDictionary *flightDetail in data) {
        DomesticFlightDataDTO *flightData = [[DomesticFlightDataDTO alloc]init];
        [flightData parshJsonToResponse:flightDetail];
        [flightsResponse addObject:flightData];
        
    }
//    NSLog(@"flights count = %u",[flightsResponse count]);

    return flightsResponse;
}


@end

@implementation DomesticFlightDataDTO


- (id)init
{
    self = [super init];
    if (self) {
        _unfold = NO;

    }
    return self;
}

- (void)parshJsonToResponse:(NSObject *)jsonData
{
    NSLog(@"jsonData = %@",jsonData);
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *dicData = (NSDictionary*)jsonData;

    [super parshJsonToResponse:jsonData];
    NSLog(@"airline aaaaa= %@",[dicData objectForKey:@"Airline"]);
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
//    NSLog(@"source count = %u",[moreFlights count]);
    _MoreFlights = [GetNormalFlightsResponse getNormalFlightsResponseWithData:moreFlights];
}


@end