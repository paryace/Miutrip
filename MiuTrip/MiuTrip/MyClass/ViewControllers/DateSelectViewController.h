//
//  DateSelectViewController.h
//  MiuTrip
//
//  Created by stevencheng on 14-1-5.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "BaseUIViewController.h"
#import "CKCalendarView.h"


typedef NS_ENUM(NSUInteger, DateSelectType){
    
    CHECK_IN_DATE = 0,
    CHECK_OUT_DATE = 1
} ;

@interface DateSelectViewController : BaseUIViewController<CKCalendarDelegate>

@property (nonatomic,strong) NSDate           *selectedDate;
@property (nonatomic)        DateSelectType   dateType;

-(id)initWithSelectedDate:(NSDate *) date type:(DateSelectType) type;

@end
