//
//  SelectDeliverViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

//regular intervals

typedef NS_OPTIONS(NSInteger, DeliverType){
    DeliverAtRegular,
    DeliverCommon
};

@protocol SelectDeliverDelegate <NSObject>

- (void)selectDeliverDone:(id)deliverDTO;

@end

@interface SelectDeliverViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<SelectDeliverDelegate> delegate;

- (id)initWithDeliverType:(DeliverType)deliverType;

- (void)getMemberDeliverList:(id)policyPerson;

- (void)getDeliverList:(id)policyPerson;

@end
