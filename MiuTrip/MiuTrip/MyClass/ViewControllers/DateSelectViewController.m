//
//  DateSelectViewController.m
//  MiuTrip
//
//  Created by stevencheng on 14-1-5.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "DateSelectViewController.h"
#import "HotelDataCache.h"

@interface DateSelectViewController ()

@end

@implementation DateSelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithSelectedDate:(NSDate *) date type:(DateSelectType) type
{
    if(self == [super init]){
        _selectedDate = date;
        _dateType = type;
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    [self.contentView setBackgroundColor:UIColorFromRGB(0xe9e9e9)];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirmBtn setTitleColor:color(whiteColor) forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setFrame:CGRectMake(self.contentView.frame.size.width - 40, 10, 30, 20)];
    confirmBtn.showsTouchWhenHighlighted = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self addTitleWithTitle:@"选择入住时间" withRightView:confirmBtn];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:_selectedDate];
    NSDate *convertedDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    CKCalendarView *view = [[CKCalendarView alloc] initWithStartDay:1 frame:CGRectMake(0, 40, 320, 320)];
    view.delegate = self;
    view.selectedDate = convertedDate;
    [self.contentView addSubview:view];
}

- (void)confirmBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    if(_dateType == CHECK_IN_DATE){
        [HotelDataCache sharedInstance].checkInDate = date;
    }else{
        [HotelDataCache sharedInstance].checkOutDate = date;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
