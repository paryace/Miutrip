//
//  HomeViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UIPopoverListView.h"
#import "HotelSearchView.h"
#import "HotelDataCache.h"
#import <CoreLocation/CoreLocation.h>
#import "SelectPassengerViewController.h"
#import "TakeOffTimePickerViewController.h"

typedef NS_ENUM(NSInteger, popupListType)
{
    HOTEL_PRICE_RANGE = 0,
    HOTEL_LOCATION = 1
};

@class HomeCustomBtn;
@class BtnItem;

/** 
 HomeCustomBtn  delegate  method
 */
@protocol HomeCustomBtnDelegate <NSObject>

@optional
- (void)HomeCustomBtnUnfold:(BOOL)unfold;

@end
/**
 BtnItem  delegate  method
 */
@protocol BtnItemDelegate <NSObject>

@optional
- (void)BtnItemUnfold;

@end

@interface HomeViewController : BaseUIViewController<HomeCustomBtnDelegate,UIPopoverListViewDataSource,
                             UIPopoverListViewDelegate,CLLocationManagerDelegate,CityPickerDelegate,DatePickerDelegate,SelectPassengerDelegate,TakeOffTimePickerDelegate>

@property (strong, nonatomic) UILabel                   *userName;
@property (strong, nonatomic) UILabel                   *position;
@property (strong, nonatomic) UILabel                   *company;
@property (strong, nonatomic) HomeCustomBtn             *customBtn;
@property (strong,nonatomic) NSArray *popupListData;
@property (nonatomic) popupListType popListType;
- (void)showPopupListWithTitle:(NSString*)title withType:(popupListType)type withData:(NSArray*)data;

@end

@interface HomeCustomBtn : UIView<BtnItemDelegate>

@property (assign, nonatomic) id<HomeCustomBtnDelegate> delegate;
@property (assign, nonatomic) BOOL                      unfold;
@property (strong, nonatomic) BtnItem               *goalBtn;
@property (strong, nonatomic) BtnItem               *queryTypeBtn;
@property (strong, nonatomic) BtnItem               *payTypeBtn;


- (id)initWithParams:(NSObject*)params;

- (NSString *)goalTitle;
- (NSString *)queryTypeTitle;
- (NSString *)payTypeTitle;

@end

@interface BtnItem : UIView

@property (assign, nonatomic) id <BtnItemDelegate>  delegate;
@property (strong, nonatomic) UIButton              *titleBtn;
@property (strong, nonatomic) UIButton              *selectBtn;
@property (assign, nonatomic) BOOL                  unfold;

- (id)initWithParams:(NSDictionary*)params;

- (void)unfoldViewShow;

@end

@interface CustomDateTextField : UITextField

@property (strong, nonatomic) NSString      *week;
@property (strong, nonatomic) NSString      *year;
@property (strong, nonatomic) NSString      *monthAndDay;
@property (strong, nonatomic) NSString      *leftPlaceholder;
@property (strong, nonatomic, readonly) NSString      *date;

//setText       text need format @"yyyy-MM-dd"

@end

