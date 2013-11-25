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

- (void)pickerFinished:(NSDate*)date;
- (void)pickerCancel;

@end

@interface DatePickerViewController : UIViewController

@property (assign, nonatomic) id <DatePickerDelegate> delegate;

- (void)fire;

- (IBAction)done:(UIButton*)sender;
- (IBAction)cancel:(UIButton*)sender;

@end
