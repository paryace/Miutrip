//
//  TakeOffTimePickerViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-8.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol TakeOffTimePickerDelegate <NSObject>

@optional
- (void)takeOffTimePickerFinished:(NSString*)time;
- (void)takeOffTimePickerCancel;

@end

@interface TakeOffTimePickerViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) id<TakeOffTimePickerDelegate> delegate;

- (void)fire;

@end
