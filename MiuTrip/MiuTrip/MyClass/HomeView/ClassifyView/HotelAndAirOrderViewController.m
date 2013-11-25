//
//  HotelAndAirOrderViewController.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelAndAirOrderViewController.h"
#import "HotelOrderDetail.h"
#import "AirOrderDetail.h"
#import "AirOrderDetailCell.h"
#import "HotelOrderDetailCell.h"

@interface HotelAndAirOrderViewController ()

@end

@implementation HotelAndAirOrderViewController

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
    if (self = [super init]) {
        _dataSource = [NSMutableArray arrayWithArray:[AirOrderDetail getCommonDataWithNum:10]];
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

- (id)initWithOrderType:(OrderType)type
{
    if (self = [super init]) {
        if (type == OrderTypeAir) {
            _dataSource = [NSMutableArray arrayWithArray:[AirOrderDetail getCommonDataWithNum:10]];
        }else if (type == OrderTypeHotel){
            _dataSource = [NSMutableArray arrayWithArray:[HotelOrderDetail getCommonDataWithNum:10]];
        }
        _orderType = type;
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - the tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    if (_orderType == OrderTypeAir) {
        AirOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        if (detail.unfold) {
            rowHeight = AirOrderCellUnfoldHeight + AirItemHeight * [detail.passengers count];
        }else
            rowHeight = AirOrderCellHeight;
    }else if (_orderType == OrderTypeHotel){
        HotelOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        if (detail.unfold) {
            rowHeight = HotelOrderCellUnfoldHeight + HotelItemHeight * [detail.passengers count];
        }else
            rowHeight = HotelOrderCellHeight;
    }else
        rowHeight = 0;
    
    return rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == nil) {
        if (_orderType == OrderTypeAir) {
            cell = [[AirOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
            cell.tag = indexPath.row;
        }else if (_orderType == OrderTypeHotel){
            cell = [[HotelOrderDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
            cell.tag = indexPath.row;
        }

    }
    if (_orderType == OrderTypeAir) {
        AirOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        AirOrderDetailCell *airCell = (AirOrderDetailCell*)cell;
        [airCell setAirDetail:detail];
        [airCell unfoldViewShow:detail.unfold];
        [airCell setViewContentWithParams:detail];
    }else if (_orderType == OrderTypeHotel){
        HotelOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        HotelOrderDetailCell *hotelCell = (HotelOrderDetailCell*)cell;
        [hotelCell setHotelDetail:detail];
        [hotelCell unfoldViewShow:detail.unfold];
        [hotelCell setViewContentWithParams:detail];
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_orderType == OrderTypeAir) {
        AirOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        detail.unfold = !detail.unfold;
        
        AirOrderDetailCell *cell = (AirOrderDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.rightArrow setHighlighted:detail.unfold];
        [cell unfoldViewShow:detail.unfold];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else if (_orderType == OrderTypeHotel){
        HotelOrderDetail *detail = [_dataSource objectAtIndex:indexPath.row];
        detail.unfold = !detail.unfold;
        
        HotelOrderDetailCell *cell = (HotelOrderDetailCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell.rightArrow setHighlighted:detail.unfold];
        [cell unfoldViewShow:detail.unfold];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    if (_orderType == OrderTypeAir) {
        [self setTitle:@"机票订单"];
    }else if (_orderType == OrderTypeHotel){
        [self setTitle:@"酒店订单"];
    }
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
