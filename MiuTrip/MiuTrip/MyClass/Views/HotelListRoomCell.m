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

- (void)setPriceDic:(NSDictionary *)priceDic
{
    if (_priceDic != priceDic) {
        _priceDic = priceDic;
    }
    
    HotelDataCache *data = [HotelDataCache sharedInstance];
    
    UIButton *bookBtn = (UIButton*)[self viewWithTag:1000];
    NSInteger guaranteeType = [[priceDic objectForKey:@"GuaranteeType"] integerValue];
    if (!data.isPrePay) {
        if (guaranteeType == 0) {
            [bookBtn setEnabled:YES];
        }else{
            [bookBtn setEnabled:NO];
        }
    }
}

-(void)setUpView{
    
    //房型名称
    _roomName = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 90, 30)];
    [_roomName setFont:[UIFont systemFontOfSize:13]];
    [_roomName setBackgroundColor:color(clearColor)];
    [_roomName setTextColor:color(blackColor)];
    [_roomName setNumberOfLines:2];
    [self addSubview:_roomName];
    
    //床型，早餐
    _bedAndBreakfast = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 50, 30)];
    [_bedAndBreakfast setFont:[UIFont systemFontOfSize:10]];
    [_bedAndBreakfast setBackgroundColor:color(clearColor)];
    [_bedAndBreakfast setTextColor:color(blackColor)];
    [_bedAndBreakfast setNumberOfLines:2];
    [self addSubview:_bedAndBreakfast];
    
    //WIFI
    _wifi = [[UILabel alloc] initWithFrame:CGRectMake(160, 13, 60, 14)];
    [_wifi setFont:[UIFont systemFontOfSize:12]];
    [_wifi setBackgroundColor:color(clearColor)];
    [_wifi setTextColor:color(blackColor)];
    [self addSubview:_wifi];
    
    //price
    _price = [[UILabel alloc] initWithFrame:CGRectMake(220, 13, 40, 14)];
    [_price setFont:[UIFont systemFontOfSize:12]];
    [_price setTextColor:PriceColor];
    [_price setBackgroundColor:color(clearColor)];
    [self addSubview:_price];
    
    //预定按钮
    UIButton *bookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bookBtn setBackgroundImage:[UIImage imageNamed:@"button_booking"] forState:UIControlStateNormal];
    [bookBtn setBackgroundImage:[UIImage imageNamed:@"button_booking_pressed"] forState:UIControlStateHighlighted];
    [bookBtn setBackgroundColor:color(clearColor)];
    [bookBtn setTag:1000];
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
    
    HotelDataCache *data = [HotelDataCache sharedInstance];
    data.selectedHotelId = _hotelId;
    data.selectedHotelName = _hotelName;
    data.selectedRoomData = _roomData;
//    data.selectedCityName = _cityName;

    NSArray *pricePolicies = [_roomData objectForKey:@"PricePolicies"];
    NSDictionary *priceDic = [pricePolicies objectAtIndex:0];
    NSArray *priceInfos = [priceDic objectForKey:@"PriceInfos"];
    NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
    int price = [[roomPriceDic objectForKey:@"SalePrice"] intValue];
    if(!data.isPrivte && _viewController.hasPriceRc && price >  _viewController.policyMaxPrice){
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
