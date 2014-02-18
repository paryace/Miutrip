//
//  AddNewPassengerViewController.h
//  MiuTrip
//
//  Created by apple on 1/24/14.
//  Copyright (c) 2014 michael. All rights reserved.
//

#import "BaseUIViewController.h"
//#import "BookPassengersDTO.h"

typedef NS_OPTIONS(NSInteger, PassengerInitType){
    PassengerEdit,
    PassengerAdd
};

@interface AddNewPassengerViewController : BaseUIViewController<UITextFieldDelegate>

- (id)initWithParams:(id)params;

@end
