//
//  MyMiuViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "MyMiuViewController.h"
#import "AirOrderDetailCell.h"
#import "HotelOrderDetailCell.h"

@interface MyMiuViewController ()

@end

@implementation MyMiuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];

    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    [self setSubjoinViewFrame];
}

#pragma mark - the tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)setSubjoinViewFrame
{
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake((self.contentView.frame.size.width - AirOrderCellWidth)/2, controlYLength(self.topBar), AirOrderCellWidth, self.contentView.frame.size.height - self.bottomBar.frame.size.height - 10 - controlYLength(self.topBar))];
    [_theTableView setBackgroundColor:color(clearColor)];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_theTableView setDelegate:self];
    [_theTableView setDataSource:self];
    [self.contentView addSubview:_theTableView];
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
