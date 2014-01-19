//
//  DatePickerViewController.h
//  Recruitment
//
//  Created by M J on 13-11-5.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import <UIKit/UIKit.h>

#define             DatePickerAnimationDuration         0.35f

@protocol DatePickerDelegate <NSObject>

- (void)datePickerFinished:(NSDate*)date;
- (void)datePickerCancel;

@end

@interface DatePickerViewController : UIViewController

@property (assign, nonatomic) id <DatePickerDelegate> delegate;

- (id)initWithDelegate:(id)delegate;

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode;

- (void)fire;

- (IBAction)done:(UIButton*)sender;
- (IBAction)cancel:(UIButton*)sender;

@end
