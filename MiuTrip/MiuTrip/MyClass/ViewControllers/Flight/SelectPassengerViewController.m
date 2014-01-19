//
//  SelectPassengerViewController.m
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "SelectPassengerViewController.h"

@interface SelectPassengerViewController ()

@end

@implementation SelectPassengerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"选择乘客"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    [self.contentView setHidden:NO];
    
    UIView *topBGView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 10, appFrame.size.width - 20, 100)];
    [topBGView setBackgroundColor:color(whiteColor)];
    [topBGView setTag:100];
    [topBGView setBorderColor:color(lightGrayColor) width:1];
    [topBGView setCornerRadius:5];
    [self.contentView addSubview:topBGView];
    
    UILabel *selectedPassengerLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, topBGView.frame.size.width/3, 40)];
    [selectedPassengerLb setBackgroundColor:color(clearColor)];
    [selectedPassengerLb setText:@"已选乘客"];
    [selectedPassengerLb setFont:[UIFont systemFontOfSize:13]];
    [topBGView addSubview:selectedPassengerLb];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setFrame:CGRectMake(controlXLength(selectedPassengerLb), 5, (topBGView.frame.size.width - controlXLength(selectedPassengerLb) - 20)/3, 40 - 10)];
    [selectBtn setBackgroundImage:imageNameAndType(@"button_bg_gray", nil) forState:UIControlStateNormal];
    [selectBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [selectBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [topBGView addSubview:selectBtn];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [editBtn setFrame:CGRectMake(controlXLength(selectBtn) + 5, selectBtn.frame.origin.y, selectBtn.frame.size.width, selectBtn.frame.size.height)];
    [editBtn setBackgroundImage:imageNameAndType(@"button_bg_gray", nil) forState:UIControlStateNormal];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [editBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [topBGView addSubview:editBtn];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(controlXLength(editBtn) + 5, selectBtn.frame.origin.y, selectBtn.frame.size.width, selectBtn.frame.size.height)];
    [addBtn setBackgroundImage:imageNameAndType(@"button_bg_gray", nil) forState:UIControlStateNormal];
    [addBtn setTitle:@"新增" forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [addBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [topBGView addSubview:addBtn];
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
