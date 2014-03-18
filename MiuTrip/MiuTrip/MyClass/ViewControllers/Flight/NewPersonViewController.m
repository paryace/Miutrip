//
//  NewPersonViewController.m
//  MiuTrip
//
//  Created by MB Pro on 14-3-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "NewPersonViewController.h"

@interface NewPersonViewController ()

@property (strong, nonatomic) UITextField   *nameTf;
@property (strong, nonatomic) UITextField   *costCenterTf;

@end

@implementation NewPersonViewController

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

- (void)pressRightBtn:(UIButton*)sender
{
    if ([Utils textIsEmpty:_nameTf.text]) {
        [[Model shareModel] showPromptText:@"请输入姓名" model:YES];
        return;
    }
    BookPassengersResponse *passenger = [[BookPassengersResponse alloc]init];
    passenger.UserName = _nameTf.text;
}


#pragma mark - view init
- (void)setSubviewFrame
{
//    _saveToCommonName = NO;
    
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"新增乘客"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setFrame:CGRectMake(appFrame.size.width - returnBtn.frame.size.width, returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
    [rightBtn setScaleX:0.7 scaleY:0.7];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_dark", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_light", nil) forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    UIView *contentBG = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 5, self.view.frame.size.width - 20, 35 * 2)];
    [contentBG setBackgroundColor:color(whiteColor)];
    [contentBG setBorderColor:color(lightGrayColor) width:0.5];
    [contentBG setCornerRadius:2.5];
    [self.view addSubview:contentBG];
    
    UILabel *NameLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 35)];
    [NameLeft setBackgroundColor:color(clearColor)];
    [NameLeft setText:@"姓名"];
    [NameLeft setFont:[UIFont systemFontOfSize:13]];
    _nameTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, contentBG.frame.size.width, NameLeft.frame.size.height)];
    [_nameTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_nameTf setFont:[UIFont systemFontOfSize:13]];
    [_nameTf setLeftViewMode:UITextFieldViewModeAlways];
    [_nameTf setLeftView:NameLeft];
    [contentBG addSubview:_nameTf];
    
    UILabel *costCenterLeft = [[UILabel alloc]initWithFrame:NameLeft.bounds];
    [costCenterLeft setBackgroundColor:color(clearColor)];
    [costCenterLeft setFont:[UIFont systemFontOfSize:13]];
    [costCenterLeft setText:@"成本中心"];
    _costCenterTf = [[UITextField alloc]initWithFrame:CGRectMake(_nameTf.frame.origin.x, controlYLength(_nameTf), _nameTf.frame.size.width, _nameTf.frame.size.height)];
    [_costCenterTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_costCenterTf setFont:[UIFont systemFontOfSize:13]];
    [_costCenterTf setLeftViewMode:UITextFieldViewModeAlways];
    [_costCenterTf setLeftView:costCenterLeft];
    [contentBG addSubview:_costCenterTf];
    
    UIButton *costCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [costCenterBtn setFrame:_costCenterTf.frame];
    [costCenterBtn setBackgroundColor:color(clearColor)];
    [contentBG addSubview:costCenterBtn];
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
