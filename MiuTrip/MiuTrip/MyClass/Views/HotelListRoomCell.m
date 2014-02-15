//
//  HotelListRoomCell.m
//  MiuTrip
//
//  Created by stevencheng on 14-1-4.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "HotelListRoomCell.h"
#import "HotelDataCache.h"
#import "HotelOrderViewController.h"

@implementation HotelListRoomCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    //房型名称
    _roomName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 30)];
    [_roomName setFont:[UIFont systemFontOfSize:13]];
    [_roomName setTextColor:color(blackColor)];
    [_roomName setNumberOfLines:2];
    [self addSubview:_roomName];
    
    //床型，早餐
    _bedAndBreakfast = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 50, 30)];
    [_bedAndBreakfast setFont:[UIFont systemFontOfSize:10]];
    [_bedAndBreakfast setTextColor:color(blackColor)];
    [_bedAndBreakfast setNumberOfLines:2];
    [self addSubview:_bedAndBreakfast];
    
    //WIFI
    _wifi = [[UILabel alloc] initWithFrame:CGRectMake(160, 13, 60, 14)];
    [_wifi setFont:[UIFont systemFontOfSize:12]];
    [_wifi setTextColor:color(blackColor)];
    [self addSubview:_wifi];
    
    //price
    _price = [[UILabel alloc] initWithFrame:CGRectMake(220, 13, 40, 14)];
    [_price setFont:[UIFont systemFontOfSize:12]];
    [_price setTextColor:PriceColor];
    [self addSubview:_price];
    
    //预定按钮
    UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookBtn setBackgroundImage:[UIImage imageNamed:@"button_booking"] forState:UIControlStateNormal];
    [bookBtn setBackgroundImage:[UIImage imageNamed:@"button_booking_pressed"] forState:UIControlStateHighlighted];
    [bookBtn setBackgroundColor:color(clearColor)];
    [bookBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [bookBtn.titleLabel setTextColor:color(whiteColor)];
    [bookBtn setTitle:@"预定" forState:UIControlStateNormal];
    [bookBtn setFrame:CGRectMake(self.frame.size.width - 48, 4, 45, 30)];
    [bookBtn addTarget:self action:@selector(bookBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bookBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, self.frame.size.width, 0.5)];
    [line setBackgroundColor:color(lightGrayColor)];
    [self addSubview:line];
}

-(void)bookBtnPressed:(UIButton *)sender{
    
    [HotelDataCache sharedInstance].selectedHotelId = _hotelId;
    [HotelDataCache sharedInstance].selectedHotelName = _hotelName;
    [HotelDataCache sharedInstance].selectedRoomData = _roomData;

    NSArray *pricePolicies = [_roomData objectForKey:@"PricePolicies"];
    NSDictionary *priceDic = [pricePolicies objectAtIndex:0];
    NSArray *priceInfos = [priceDic objectForKey:@"PriceInfos"];
    NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
    int price = [[roomPriceDic objectForKey:@"SalePrice"] intValue];
    if(price >  _viewController.policyMaxPrice){
        [_viewController showRuleView];
        return;
    }
    
    HotelOrderViewController *orderViewController = [[HotelOrderViewController alloc] init];
    [_viewController.navigationController pushViewController:orderViewController animated:YES];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
