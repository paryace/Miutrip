//
//  RegisterAndLogViewController.h
//  MiuTrip
//
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "LoginRequest.h"
#import "LoginResponse.h"

@interface RegisterAndLogViewController : BaseUIViewController<UITextFieldDelegate>

@property (strong, nonatomic) UITextField                   *userName;
@property (strong, nonatomic) UITextField                   *passWord;
@property (strong, nonatomic) UITextField                   *activeText;

@property (assign, nonatomic) BOOL                          autoLogStatus;

@end
