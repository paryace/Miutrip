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

- (id)init
{
    self = [super init];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    [_datePicker setDatePickerMode:datePickerMode];
}

- (void)setSubviewFrame
{
    [self.view setHidden:YES];
    [self.view setFrame:appBounds];
    UIView *backgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    [backgroundView setBackgroundColor:color(blackColor)];
    [backgroundView setAlpha:0.35];
    [self.view addSubview:backgroundView];
    
    _pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    [_pickerView setBackgroundColor:color(whiteColor)];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundColor:color(colorWithRed:220.0/255.0 green:230.0/255.0 blue:240.0/255.0 alpha:1)];
    [cancelBtn setFrame:CGRectMake(_pickerView.frame.size.width/5, 0, _pickerView.frame.size.width/5 + 10, 44)];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_pickerView addSubview:cancelBtn];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundColor:color(colorWithRed:140.0/255.0 green:160.0/255.0 blue:210.0/255.0 alpha:1)];
    [doneBtn setFrame:CGRectMake(self.view.frame.size.width - cancelBtn.frame.origin.x - cancelBtn.frame.size.width, cancelBtn.frame.origin.y, cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_pickerView addSubview:doneBtn];
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, cancelBtn.frame.origin.y + cancelBtn.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height - cancelBtn.frame.origin.y - cancelBtn.frame.size.height)];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setDate:[NSDate date]];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans"];
    [_datePicker setLocale:locale];
    [_pickerView addSubview:_datePicker];
}

- (void)fire
{
    [_pickerView setFrame:CGRectMake(0, self.view.frame.size.height, _pickerView.frame.size.width, _pickerView.frame.size.height)];
    [self.view addSubview:_pickerView];
    [self.view setHidden:NO];
    [self.view.superview bringSubviewToFront:self.view];
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
                         [self.delegate datePickerFinished:[_datePicker date]];
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
                         [self.delegate datePickerCancel];
                     }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self cancel:nil];
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
