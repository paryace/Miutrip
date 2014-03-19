//
//  NewPersonViewController.h
//  MiuTrip
//
//  Created by MB Pro on 14-3-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UIPopoverListView.h"

typedef NS_OPTIONS(NSInteger, CustomerEditType){
    CustomerAdd,
    CustomerEdit
};


@protocol NewPersonDelegate <NSObject>

- (void)editOrNewPersonDone:(BookPassengersResponse*)passenger;

@end

@interface NewPersonViewController : BaseUIViewController<UIPopoverListViewDataSource,UIPopoverListViewDelegate>

@property (assign, nonatomic) id<NewPersonDelegate> delegate;

- (id)initWithObject:(BookPassengersResponse*)passenger;

@end
