//
//  PassengerListViewController.h
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

#define     PassengerCustomCellHeight       35.0f

@protocol PassengerListViewDelegate <NSObject>

- (void)selectDone:(NSMutableArray*)array;

@end

@interface PassengerListViewController : BaseUIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<PassengerListViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray  *selectedPassengers;

- (void)dataSource:(NSArray*)dataSource removeObject:(id)object;
- (BOOL)dataSource:(NSArray*)dataSource containsObject:(id)object;

@end


@interface PassengerListCustomCell : UITableViewCell

@property (strong, nonatomic) NSString      *Name;
@property (strong, nonatomic) NSString      *UID;
@property (strong, nonatomic) NSString      *DeptName;

@property (assign, nonatomic) BOOL          leftImageHighlighted;

@property (assign, nonatomic) BOOL          withoutLeftImage;

@end