//
//  HotelCompileViewController.h
//  MiuTrip
//
//  Created by Y on 14-1-22.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "HotelChooseViewController.h"

@protocol CostCenterDelegate <NSObject>
@optional

- (void)selectDone:(NSArray*)params Path:(NSIndexPath *)indexPath;

@end

@interface HotelCompileViewController : BaseUIViewController<CostCenterDelegate>
@property (strong ,nonatomic)  UILabel  *costCenterNameLabel;
@property (strong ,nonatomic)  UITextField  *nameTextField;
@property (strong ,nonatomic)  NSMutableDictionary *dic;
@property (strong ,nonatomic) NSString *userName;
@property (strong ,nonatomic) NSString *costCenter;

+(HotelCompileViewController*)sharedHotelCompile;
@end

#define   ContactItemHeight    30;
@interface CostCenterController : UIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>

@property (assign, nonatomic) id<CostCenterDelegate> delegate;

@end

@interface CostDetailCell : UITableViewCell

@property(strong, nonatomic)  UILabel  *cost;

- (void)setViewContentWithParams:(NSString*)params;

@end
