//
//  CityPickerViewController.h
//  MiuTrip
//
//  Created by apple on 13-11-30.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "RequestManager.h"

typedef NS_OPTIONS(NSInteger, CityPickerMode) {
    CityPickerFlightMode,
    CityPickerHotelMode
};

@protocol CityPickerDelegate;


@interface CityPickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (assign, nonatomic) id <CityPickerDelegate> delegate;
@property (assign, nonatomic) CityPickerMode          cityPickerMode;

- (void)fire;

@end

@protocol CityPickerDelegate <NSObject>

- (void)cityPickerFinished:(CityDTO*)city;
- (void)cityPickerCancel;

@end