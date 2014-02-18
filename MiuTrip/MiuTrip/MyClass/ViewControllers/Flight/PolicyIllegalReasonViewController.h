//
//  PolicyIllegalReasonViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-8.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DomesticFlightDataDTO;
@class AirListViewCell;
@class ReasonCodeDTO;


typedef NS_OPTIONS(NSInteger, PolicyIllegalType) {
    PolicyIllegalNone,
    PolicyIllegalDate,
    PolicyIllegalPrice,
    PolicyIllegalDateAndPrice
};

@protocol PolicyIllegalReasonDelegate <NSObject>

@optional
- (void)PolicyIllegalReasonPickerFinished:(NSDictionary*)RCData;
- (void)PolicyIllegalReasonPickerCancel;

@end

@protocol RCPickerDelegate <NSObject>

- (void)RCPickerFinished:(ReasonCodeDTO*)rcDTO;
- (void)RCPickerCancel;

@end

@interface PolicyIllegalReasonViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RCPickerDelegate>

@property (assign, nonatomic) id<PolicyIllegalReasonDelegate> delegate;

@property (assign, nonatomic) DomesticFlightDataDTO   *flight;

- (void)fireWithIllegalType:(PolicyIllegalType)illegalType corpPolicy:(id)corpPolicy;

@end

@interface RCPickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray        *dataSource;
@property (assign, nonatomic) id<RCPickerDelegate> delegate;

- (void)fire;

@end