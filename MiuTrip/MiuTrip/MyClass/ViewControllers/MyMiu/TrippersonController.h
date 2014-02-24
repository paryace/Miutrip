//
//  TrippersonController.h
//  MiuTrip
//
//  Created by GX on 14-1-20.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
@protocol TripDelegate <NSObject>

- (void)savepassengersDone;//代理方法,非请求成功方法,是另外写的一个专门代理方法

@end
@interface TrippersonController : BaseUIViewController<UITextFieldDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,BusinessDelegate>{
    
}

@property (nonatomic,strong) NSMutableDictionary *param;

@property (nonatomic,assign) id<TripDelegate> tripDelegate;
@property (nonatomic,assign) id<BusinessDelegate> delegate;
@property (strong, nonatomic) SavePassengerResponse *passengerInfomation;
-(id)initWithParams:(NSDictionary*)param;
-(void)updatetrip;
@end
