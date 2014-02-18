//
//  SelectDeliverViewController.h
//  MiuTrip
//
//  Created by apple on 14-2-13.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol SelectDeliverDelegate <NSObject>

- (void)selectDeliverDone:(MemberDeliverDTO*)deliverDTO;

@end

@interface SelectDeliverViewController : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) id<SelectDeliverDelegate> delegate;

- (void)getMemberDeliverList:(id)policyPerson;

@end
