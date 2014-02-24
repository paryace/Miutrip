//
//  ContactController.h
//  MiuTrip
//
//  Created by GX on 14-1-20.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
@protocol ContactDelegate <NSObject>

- (void)saveContactsDone;

@end

@interface ContactController : BaseUIViewController<UITextFieldDelegate,BusinessDelegate>

@property (nonatomic,strong) NSMutableDictionary *param;
@property (nonatomic,assign) id<ContactDelegate> contactDelegate;
@property (strong, nonatomic) SavePassengerResponse *passengerInfomation;
-(id)initWithParamss:(NSDictionary*)param;
-(void)updatecontact;
@end
