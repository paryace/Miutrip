//
//  HotelPassengerViewController.h
//  MiuTrip
//
//  Created by pingguo on 14-1-16.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseUIViewController.h"
@protocol HotelPassengerDelegate <NSObject>

@optional
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)clickedRow:(NSInteger)integer;
@end

@interface HotelPassengerViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate,BusinessDelegate>
@property (assign, nonatomic) id<HotelPassengerDelegate> delegate;
@property (strong ,nonatomic)UITableView *theTableView;
@property (strong, nonatomic)NSArray     *dataSource;
@property (strong ,nonatomic)NSMutableArray *array;

-(id)initWithFrame:(CGRect)frame;
@end
