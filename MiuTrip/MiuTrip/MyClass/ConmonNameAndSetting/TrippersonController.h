//
//  TrippersonController.h
//  MiuTrip
//
//  Created by GX on 14-1-20.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
@protocol TripDelegate <NSObject>

- (void)savepassengersDone;

@end
@interface TrippersonController : BaseUIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,BusinessDelegate>{
    
}

@property (nonatomic,strong) NSDictionary *param;
@property (nonatomic,assign) id<TripDelegate> tripDelegate;
@property (nonatomic,assign) id<BusinessDelegate> delegate;

-(id)initWithParams:(NSDictionary*)param;
-(void)updatetrip;
@end
