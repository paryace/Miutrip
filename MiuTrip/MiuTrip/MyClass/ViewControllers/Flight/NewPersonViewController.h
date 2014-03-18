//
//  NewPersonViewController.h
//  MiuTrip
//
//  Created by MB Pro on 14-3-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@protocol NewPersonDelegate <NSObject>

- (void)editOrNewPersonDone:(BookPassengersResponse*)passenger;

@end

@interface NewPersonViewController : BaseUIViewController

@property (assign, nonatomic) id<NewPersonDelegate> delegate;

@end
