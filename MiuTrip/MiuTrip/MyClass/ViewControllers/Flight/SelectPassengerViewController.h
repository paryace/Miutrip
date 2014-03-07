//
//  SelectPassengerViewController.h
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "PassengerListViewController.h"

@protocol SelectPassengerDelegate <NSObject>

- (void)selectPassengerDone:(NSArray *)passengers policyName:(id)policy bussinessType:(int)type;

@end

@protocol SelectPolicyDelegate <NSObject>

- (void)selectPolicyDone:(id)policy;
- (void)selectPolicyCancel;

@end

@interface SelectPassengerViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,PassengerListViewDelegate,SelectPolicyDelegate>

@property (assign, nonatomic) id<SelectPassengerDelegate> delegate;
@property (nonatomic)         int businessType;


-(id)initWithBusinessType:(int)type;

@end

@interface SelectProlicyViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<SelectPolicyDelegate>  delegate;
@property (strong, nonatomic) NSArray                   *dataSource;

- (void)fire;

@end