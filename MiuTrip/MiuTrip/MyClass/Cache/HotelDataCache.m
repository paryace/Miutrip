//
//  HotelCache.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-29.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelDataCache.h"

@implementation HotelDataCache

+(HotelDataCache*)sharedInstance{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

-(id)init{
    
    if(self = [super init]){
        [self initData];
    }
    return self;
}

-(void)initData{
    
    _priceRangeArray = [[NSArray alloc] initWithObjects:@"不限",@"0-150元",@"151-300元",@"301-450元",@"451-600元",@"600元以上", nil];
    
    _isPrivte = NO;
    _isForSelf = YES;
    _isPrePay = NO;
    
    _checkInCityName = @"上海";
    _checkInCityId = 448;
    
    _checkInDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24];
    _checkOutDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*2];
    
    _priceRangeIndex = 0;
    
    _queryCantonName = @"不限";
    _queryCantonId = 0;
    
    _keyWord = @"";
    
}

@end
