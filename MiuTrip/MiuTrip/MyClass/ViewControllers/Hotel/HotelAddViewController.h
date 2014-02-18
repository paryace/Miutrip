//
//  HotelAddViewController.h
//  MiuTrip
//
//  Created by Y on 14-1-22.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol HotelAddDelegate <NSObject>

- (void)saveLiveInfo:(NSDictionary*)dic;

@end

@protocol CoseCenterDelegate <NSObject>

- (void)selectDone:(NSArray*)params Path:(NSIndexPath *)indexPath;

@end


@interface HotelAddViewController : BaseUIViewController<CoseCenterDelegate,UITextFieldDelegate,BusinessDelegate>

@property (strong ,nonatomic) id<HotelAddDelegate> delegate;
@property (strong ,nonatomic)  UILabel  *costCenterNameLabel;
@property (strong ,nonatomic)  UITextField  *nameTextField;
@property (strong , nonatomic) NSArray *data;
@end

#define   ContactItemHeight    30;
@interface CoseCenterController : UIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>

@property (assign, nonatomic) id<CoseCenterDelegate> delegate;

@end

@interface CostCell : UITableViewCell

@property(strong, nonatomic)  UILabel  *cost;

- (void)setViewContentWithParams:(NSString*)params;

@end
