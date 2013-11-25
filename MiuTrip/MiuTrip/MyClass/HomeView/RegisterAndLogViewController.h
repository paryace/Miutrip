//
//  RegisterAndLogViewController.h
//  MiuTrip
//  登陆页面
//  Created by SuperAdmin on 11/13/13.
//  Copyright (c) 2013 michael. All rights reserved.
//

#import "BaseUIViewController.h"

@interface RegisterAndLogViewController : BaseUIViewController

@property (strong, nonatomic) UITextField                   *userName;
@property (strong, nonatomic) UITextField                   *passWord;

@property (assign, nonatomic) BOOL                          autoLogStatus;

@end
