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
@class GetCorpPolicyResponse;

typedef NS_OPTIONS(NSInteger, PolicyIllegalType) {
    IllegalNone,
    IllegalDate,
    IllegalPrice,
    IllegalRate,
    IllegalDateAndPrice,
    IllegalDateAndRate,
    IllegalPriceAndRate,
    IllegalAll
};

#define PolicyIllegalNone   @"PolicyIllegalNone"
#define PolicyIllegalDate   @"PolicyIllegalDate"
#define PolicyIllegalPrice  @"PolicyIllegalPrice"
#define PolicyIllegalRate   @"PolicyIllegalRate"

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

@property (retain, nonatomic) DomesticFlightDataDTO   *flight;

- (void)fireWithIllegalType:(NSArray*)illegalType corpPolicy:(GetCorpPolicyResponse*)corpPolicy flight:(DomesticFlightDataDTO*)flight;

@end

@interface RCPickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray        *dataSource;
@property (assign, nonatomic) id<RCPickerDelegate> delegate;

- (void)fire;

@end