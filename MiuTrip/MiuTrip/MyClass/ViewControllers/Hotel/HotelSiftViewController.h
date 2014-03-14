//
//  HotelSiftViewController.h
//  MiuTrip
//
//  Created by MB Pro on 14-3-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol HotelSiftDelegate <NSObject>

- (void)hotelSiftSelectDone:(NSMutableDictionary*)data;

@end

@interface HotelSiftViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<HotelSiftDelegate> delegate;
@property (strong, nonatomic) NSDictionary  *hotelSiftRule;

//- (id)initWithParams:(

- (void)GetDistricts;

@end

