//
//  AirOrderDetailCell.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "AirOrderDetailCell.h"
#import "CustomMethod.h"
#import "CommonlyName.h"
#import "CustomBtn.h"



@implementation AirOrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _itemArray = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:color(clearColor)];
    
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, AirOrderCellWidth - 20, AirOrderCellHeight - 20)];
    [backGroundImageView setBackgroundColor:color(whiteColor)];
    [backGroundImageView setBorderColor:color(lightGrayColor) width:1];
    [backGroundImageView setAlpha:0.5];
    [backGroundImageView setTag:300];
    [backGroundImageView.layer setMasksToBounds:YES];
    [backGroundImageView.layer setCornerRadius:2.0];
    [self.contentView addSubview:backGroundImageView];
    
    UIImageView *titleBGImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, AirOrderCellWidth - 20, 35)];
    [titleBGImage setBackgroundColor:color(colorWithRed:64.0/255.0 green:137.0/255.0 blue:211.0/255.0 alpha:1)];
    [titleBGImage.layer setMasksToBounds:YES];
    [titleBGImage.layer setCornerRadius:2.0];
    [self.contentView addSubview:titleBGImage];
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    [calendar setLocale:[NSLocale currentLocale]];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    
    _mainDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleBGImage.frame.origin.x + 10, titleBGImage.frame.origin.y, titleBGImage.frame.size.width/4 - 10, titleBGImage.frame.size.height)];
    [_mainDateLabel setBackgroundColor:color(clearColor)];
    [_mainDateLabel setTextAlignment:NSTextAlignmentLeft];
    [_mainDateLabel setTextColor:color(whiteColor)];
    [_mainDateLabel setText:[Utils stringWithDate:date withFormat:@"MM月dd日"]];
    [_mainDateLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.contentView addSubview:_mainDateLabel];
    
    _subDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_mainDateLabel), _mainDateLabel.frame.origin.y, _mainDateLabel.frame.size.width, _mainDateLabel.frame.size.height)];
    [_subDateLabel setBackgroundColor:color(clearColor)];
    [_subDateLabel setFont:[UIFont systemFontOfSize:12]];
    [_subDateLabel setAutoBreakLine:YES];
    [_subDateLabel setText:[NSString stringWithFormat:@"%@\n%@",[Utils stringWithDate:date withFormat:@"yyyy年"],[[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1]]];
    [_subDateLabel setTextColor:color(whiteColor)];
    [_subDateLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_subDateLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_subDateLabel), _mainDateLabel.frame.origin.y, titleBGImage.frame.size.width/2, _mainDateLabel.frame.size.height)];
    [_timeLabel setBackgroundColor:color(clearColor)];
    [_timeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_timeLabel setTextColor:color(whiteColor)];
    [_timeLabel setText:[Utils stringWithDate:date withFormat:@"HH:mm"]];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
    _routeLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(_mainDateLabel.frame.origin.x, controlYLength(_mainDateLabel), AirOrderCellWidth - _mainDateLabel.frame.origin.x * 2, (AirOrderCellHeight - 25 - titleBGImage.frame.size.height)/2)];
    [_routeLineLabel setBackgroundColor:color(clearColor)];
    [_routeLineLabel setText:@"北京 - 上海"];
    [_routeLineLabel setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_routeLineLabel];
    
    _flightNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_routeLineLabel.frame.origin.x, controlYLength(_routeLineLabel), _routeLineLabel.frame.size.width, _routeLineLabel.frame.size.height)];
    [_flightNumLabel setBackgroundColor:color(clearColor)];
    [_flightNumLabel setText:@"上海航空 FM2908"];
    [_flightNumLabel setTextColor:color(grayColor)];
    [_flightNumLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_flightNumLabel];
    
    _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightArrow setFrame:CGRectMake(AirOrderCellWidth - _routeLineLabel.frame.size.height * 2, _routeLineLabel.frame.origin.y, _routeLineLabel.frame.size.height * 2, _routeLineLabel.frame.size.height * 2)];
    [_rightArrow setBackgroundColor:color(clearColor)];
    [_rightArrow setTag:100];
    [_rightArrow setScaleX:0.25 scaleY:0.25];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_up", nil) forState:UIControlStateNormal];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_down", nil) forState:UIControlStateHighlighted];
    //    [_rightArrow setUserInteractionEnabled:YES];
    [self.contentView addSubview:_rightArrow];
}
- (void)setSubjoinViewFrameWithPrarams:(NSDictionary*)params
{
    UIView *prevView = [self.contentView viewWithTag:300];
    
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(prevView), AirOrderCellWidth - 20, 0)];
    [_unfoldView setBackgroundColor:color(clearColor)];
    [self.contentView addSubview:_unfoldView];
    
    UIImageView *subjoinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _unfoldView.frame.size.width, 15)];
    [subjoinImageView setBackgroundColor:color(clearColor)];
    [subjoinImageView setImage:imageNameAndType(@"shadow", nil)];
    [_unfoldView addSubview:subjoinImageView];
    
    _orderNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(subjoinImageView), _unfoldView.frame.size.width/2, 30)];
    [_orderNumLabel setBackgroundColor:color(clearColor)];
    [_orderNumLabel setFont:[UIFont systemFontOfSize:12]];
    NSDictionary *passengers =  [(NSArray*)[params objectForKey:@"FltPassengers"]objectAtIndex:0 ];
    NSString *order = [passengers objectForKey:@"OrderID"];
    [_orderNumLabel setText:[NSString stringWithFormat:@"订单号:%@",order]];
    [_unfoldView addSubview:_orderNumLabel];
    
    _orderStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_orderNumLabel), _orderNumLabel.frame.origin.y, _orderNumLabel.frame.size.width, _orderNumLabel.frame.size.height)];
    [_orderStatusLabel setBackgroundColor:color(clearColor)];
    NSNumber *status = [passengers objectForKey:@"Status"];
    [_orderStatusLabel setText:[NSString stringWithFormat:@"订单状态:%@",status]];
    [_orderStatusLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_orderStatusLabel];
    
    _startAndEndStation = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.frame.origin.x, controlYLength(_orderNumLabel), _unfoldView.frame.size.width - 20, _orderNumLabel.frame.size.height)];
    [_startAndEndStation setBackgroundColor:color(clearColor)];
    [_startAndEndStation setFont:[UIFont systemFontOfSize:12]];
    NSDictionary *flts = [(NSArray*)[params objectForKey:@"Flts"]objectAtIndex:0];
    NSString *acity = [flts objectForKey:@"ACityName"];
    NSString *dcity = [flts objectForKey:@"DCityName"];
    [_startAndEndStation setText:[NSString stringWithFormat:@"起始站－终点站 : %@ - %@",acity,dcity]];
    [_unfoldView addSubview:_startAndEndStation];
    
    _ticketType = [[UILabel alloc]initWithFrame:CGRectMake(_startAndEndStation.frame.origin.x, controlYLength(_startAndEndStation), _startAndEndStation.frame.size.width, _startAndEndStation.frame.size.height)];
    [_ticketType setBackgroundColor:color(clearColor)];
    [_ticketType setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_ticketType];
    NSString *class = [flts objectForKey:@"Class"];
    NSNumber *price = [flts objectForKey:@"Price"];
    [_ticketType setText:[NSString stringWithFormat:@"舱位类型:%@     价格:%@" ,class,price]];
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_ticketType.frame.origin.x, controlYLength(_ticketType), _ticketType.frame.size.width, 1.5)]];
    
    UILabel *unPassengersLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.frame.origin.x, controlYLength(_ticketType), _orderNumLabel.frame.size.width, _orderNumLabel.frame.size.height)];
    [unPassengersLabel setBackgroundColor:color(clearColor)];
    //    NSString *passenger = [passengers objectForKey:@"PassengerName"];
    [unPassengersLabel setText:@"乘机人:"];
    [unPassengersLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:unPassengersLabel];
    
    [_itemArray removeAllObjects];
    NSArray *array = [params objectForKey:@"FltPassengers"];
    for (int i = 0;i<[array count];i++) {
        //        CommonlyName *detail = [array objectAtIndex:i];
        //AirOrderDetailCellItem *item = [[AirOrderDetailCellItem alloc]initWithFrame:CGRectMake(_ticketType.frame.origin.x, controlYLength(unPassengersLabel) + AirItemHeight * i, _ticketType.frame.size.width, AirItemHeight)];
        UIView *view = [self createCellItemWithParams:passengers frame:CGRectMake(_ticketType.frame.origin.x, controlYLength(unPassengersLabel) + AirItemHeight * i, _ticketType.frame.size.width, AirItemHeight)];
        //[item setContentWithParams:detail];
        [_unfoldView addSubview:view];
        [_itemArray addObject:view];
    }
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_ticketType.frame.origin.x, controlYLength(unPassengersLabel) + AirItemHeight * [array count], _ticketType.frame.size.width, 1.5)]];
    
    UILabel *contactsLabel = [[UILabel alloc]initWithFrame:CGRectMake(_startAndEndStation.frame.origin.x, controlYLength(unPassengersLabel) + AirItemHeight * [array count], _startAndEndStation.frame.size.width, _startAndEndStation.frame.size.height)];
    [contactsLabel setBackgroundColor:color(clearColor)];
    [contactsLabel setText:@"联系人:"];
    [contactsLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:contactsLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_startAndEndStation.frame.origin.x, controlYLength(contactsLabel), _startAndEndStation.frame.size.width/3, _startAndEndStation.frame.size.height)];
    [_nameLabel setBackgroundColor:color(clearColor)];
    NSDictionary *fltdeliver=[params objectForKey:@"FltDeliver"];
    NSString *name = [fltdeliver objectForKey:@"ContactName"];
    [_nameLabel setText:[NSString stringWithFormat:@"%@",name]];
    [_nameLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_nameLabel];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_nameLabel), _nameLabel.frame.origin.y, _startAndEndStation.frame.size.width * 2/3, _startAndEndStation.frame.size.height)];
    [_phoneLabel setBackgroundColor:color(clearColor)];
    NSString *mobile = [fltdeliver objectForKey:@"ContactMobile"];
    [_phoneLabel setText:[NSString stringWithFormat:@"电话号码:%@",mobile]];
    [_phoneLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_phoneLabel];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, controlYLength(_nameLabel), _unfoldView.frame.size.width, 0.5)];
    [line setBackgroundColor:color(lightGrayColor)];
    [line setAlpha:0.5];
    [_unfoldView addSubview:line];
    
    _cancleBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setBackgroundColor:color(clearColor)];
    [_cancleBtn setFrame:CGRectMake(_unfoldView.frame.size.width/(5 * 3), 10 + controlYLength(line), _unfoldView.frame.size.width * 2/5 - 20, 30)];
    [_cancleBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_cancleBtn setBackgroundImage:imageNameAndType(@"order_cancle", nil) forState:UIControlStateNormal];
    [_unfoldView addSubview:_cancleBtn];
    
    _doneBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    [_doneBtn setBackgroundColor:color(clearColor)];
    [_doneBtn setFrame:CGRectMake(_unfoldView.frame.size.width - controlXLength(_cancleBtn), _cancleBtn.frame.origin.y, _cancleBtn.frame.size.width, _cancleBtn.frame.size.height)];
    [_doneBtn setTitle:@"支付订单" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_doneBtn setBackgroundImage:imageNameAndType(@"order_done", nil) forState:UIControlStateNormal];
    [_unfoldView addSubview:_doneBtn];
    
    [_unfoldView setFrame:CGRectMake(_unfoldView.frame.origin.x, _unfoldView.frame.origin.y, _unfoldView.frame.size.width, controlYLength(_cancleBtn) + 10)];
    [_unfoldView setHidden:YES];
    
    UIImageView *unfoldBackImage = [[UIImageView alloc]initWithFrame:_unfoldView.bounds];
    [unfoldBackImage setBackgroundColor:color(colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1)];
    [unfoldBackImage setBorderColor:color(lightGrayColor) width:1];
    [unfoldBackImage setAlpha:0.5];
    [_unfoldView insertSubview:unfoldBackImage belowSubview:subjoinImageView];
    
}

- (UIView*)createCellItemWithParams:(NSDictionary*)detail frame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:color(clearColor)];
    UILabel *passenger = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/4, (frame.size.height - 10)/3)];
    [passenger setBackgroundColor:color(clearColor)];
    NSString *pasName =  [detail objectForKey:@"PassengerName"];
    [passenger setText:[NSString stringWithFormat:@"%@",pasName ]];
    [passenger setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:passenger];
    
    UILabel *cardNumLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,frame.size.width/3, passenger.frame.size.height)];
    [cardNumLeft setBackgroundColor:color(clearColor)];
    NSString *type = [detail objectForKey:@"CardTypeName"];
    UILabel *cardNumRight = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(cardNumLeft), cardNumLeft.frame.origin.y, frame.size.width, passenger.frame.size.height)];
    [cardNumRight setBackgroundColor:color(clearColor)];
    NSString *number = [detail objectForKey:@"CardTypeNumber"];
    [cardNumLeft setText:[NSString stringWithFormat:@"%@:",type]];
    [cardNumRight setText:[NSString stringWithFormat:@"%@",number]];
    [cardNumLeft setTextAlignment:NSTextAlignmentRight];
    [cardNumLeft setFont:[UIFont systemFontOfSize:12]];
    [cardNumRight setFont:[UIFont systemFontOfSize:12]];
    //    UIWebView *cardLeft = [[UIWebView alloc]initWithFrame:cardNumLeft.bounds];
    //    [cardLeft loadHTMLString:@"<div style=\"text-align:justify; font-size:12px;\">身份证:</div>" baseURL:nil];
    //    [cardLeft setBackgroundColor:color(clearColor)];
    [view addSubview:cardNumLeft];
    [view addSubview:cardNumRight];
    
    UILabel *phoneNumLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(cardNumLeft), frame.size.width/3, passenger.frame.size.height)];
    //    UILabel *phoneNumRight = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(cardNumRight), controlYLength(cardNumLeft), frame.size.width, frame.size.height)];
    [phoneNumLeft setBackgroundColor:color(clearColor)];
    [phoneNumLeft setText:@"手机:"];
    [phoneNumLeft setTextAlignment:NSTextAlignmentRight];
    [phoneNumLeft setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:phoneNumLeft];
    
    UILabel *costCenterLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(phoneNumLeft), frame.size.width/3, passenger.frame.size.height)];
    [costCenterLeft setBackgroundColor:color(clearColor)];
    UILabel *costCenterRight = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(phoneNumLeft),controlYLength(phoneNumLeft), frame.size.width, passenger.frame.size.height)];
    [costCenterRight setBackgroundColor:color(clearColor)];
    NSString *custom = [detail objectForKey:@"CustomizeItem1"];
    [costCenterLeft setText:@"成本中心:"];
    [costCenterRight setText:[NSString stringWithFormat:@"%@",custom]];
    [costCenterRight setFont:[UIFont systemFontOfSize:12]];
    [costCenterLeft setTextAlignment:NSTextAlignmentRight];
    [costCenterLeft setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:costCenterLeft];
    [view addSubview:costCenterRight];
    return view;
}


- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"t_line", nil)];
    return line;
}


- (void)unfoldViewShow:(NSDictionary*)data
{
    
    BOOL unfold = [[data objectForKey:@"unfold"] boolValue];
    if (unfold) {
        if (_unfoldView) {
            [_unfoldView removeFromSuperview];
            _unfoldView = nil;
        }
        [self setSubjoinViewFrameWithPrarams:data];
    }
    
    [_rightArrow setHighlighted:unfold];
    [_unfoldView setHidden:!unfold];
}

- (void)setViewContentWithParams:(NSDictionary*)params
{
    [self unfoldViewShow:params];
}

//- (void)setViewContentWithParams
//{
//    [_rightArrow setHighlighted:_unfold];
//}

@end
