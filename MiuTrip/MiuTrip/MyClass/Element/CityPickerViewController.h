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

@protocol CityPickerDelegate;


@interface CityPickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,BusinessDelegate>

@property (assign, nonatomic) id <CityPickerDelegate> delegate;

- (void)fire;

@end

@protocol CityPickerDelegate <NSObject>

- (void)cityPickerFinished:(CityDTO*)city;
- (void)cityPickerCancel;

@end