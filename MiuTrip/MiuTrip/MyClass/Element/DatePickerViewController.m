//
//  DatePickerViewController.m
//  Recruitment
//
//  Created by M J on 13-11-5.
//  Copyright (c) 2013年 M J. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@property (strong, nonatomic) IBOutlet UIView               *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker         *datePicker;

@end

@implementation DatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self.view setHidden:YES];
}

- (void)fire
{
    [_pickerView setFrame:CGRectMake(0, self.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
    [self.view addSubview:_pickerView];
    [self.view setHidden:NO];
    [UIView animateWithDuration:DatePickerAnimationDuration
                     animations:^{
                         [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x, self.view.frame.size.height - _pickerView.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
                     }completion:^(BOOL finished){
                         
                     }];
}

- (IBAction)done:(UIButton*)sender
{
    [UIView animateWithDuration:DatePickerAnimationDuration
                     animations:^{
                         [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x, self.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
                     }completion:^(BOOL finished){
                         [_pickerView removeFromSuperview];
                         [self.view setHidden:YES];
                         [self.delegate pickerFinished:[_datePicker date]];
                     }];
}

- (IBAction)cancel:(UIButton*)sender
{
    [UIView animateWithDuration:DatePickerAnimationDuration
                     animations:^{
                         [_pickerView setFrame:CGRectMake(_pickerView.frame.origin.x, self.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
                     }completion:^(BOOL finished){
                         [_pickerView removeFromSuperview];
                         [self.view setHidden:YES];
                         [self.delegate pickerCancel];
                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
