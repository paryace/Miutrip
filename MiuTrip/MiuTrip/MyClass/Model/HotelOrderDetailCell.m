//
//  HotelOrderDetailCell.m
//  MiuTrip
//
//  Created by SuperAdmin on 13-11-23.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelOrderDetailCell.h"
#import "AirOrderDetailCell.h"
#import "CustomMethod.h"
#import "CommonlyName.h"
#import "CustomBtn.h"



@implementation HotelOrderDetailCell

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
    [titleBGImage setBackgroundColor:color(colorWithRed:241.0/255.0 green:122.0/255.0 blue:90.0/255.0 alpha:1)];
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
    
    //    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_subDateLabel), _mainDateLabel.frame.origin.y, titleBGImage.frame.size.width/2, _mainDateLabel.frame.size.height)];
    //    [_timeLabel setBackgroundColor:color(clearColor)];
    //    [_timeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    //    [_timeLabel setTextColor:color(whiteColor)];
    //    [_timeLabel setText:[Utils stringWithDate:date withFormat:@"HH:mm"]];
    //    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    //    [self.contentView addSubview:_timeLabel];
    
    _hotelName = [[UILabel alloc]initWithFrame:CGRectMake(_mainDateLabel.frame.origin.x, controlYLength(_mainDateLabel), AirOrderCellWidth - _mainDateLabel.frame.origin.x * 2, (AirOrderCellHeight - 25 - titleBGImage.frame.size.height)/2)];
    [_hotelName setBackgroundColor:color(clearColor)];
    [_hotelName setText:@"北京万豪酒店 行政豪华房"];
    [_hotelName setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:_hotelName];
    
    _location = [[UILabel alloc]initWithFrame:CGRectMake(_hotelName.frame.origin.x, controlYLength(_hotelName), _hotelName.frame.size.width, _hotelName.frame.size.height)];
    [_location setBackgroundColor:color(clearColor)];
    [_location setText:@"海淀区区车站东路265号"];
    [_location setTextColor:color(grayColor)];
    [_location setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_location];
    
    
    _rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightArrow setFrame:CGRectMake(HotelOrderCellWidth - _hotelName.frame.size.height * 2, _hotelName.frame.origin.y, _hotelName.frame.size.height * 2, _hotelName.frame.size.height * 2)];
    [_rightArrow setBackgroundColor:color(clearColor)];
    [_rightArrow setTag:100];
    [_rightArrow setScaleX:0.25 scaleY:0.25];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_down", nil) forState:UIControlStateNormal];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_up", nil) forState:UIControlStateHighlighted];
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
    NSString *orderId = [params objectForKey:@"OrderID"];
    [_orderNumLabel setText:[NSString stringWithFormat:@"订单号:%@",orderId]];
    //[_orderNumLabel setText:@"订单号:"];
    [_unfoldView addSubview:_orderNumLabel];
    
    _orderStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_orderNumLabel), _orderNumLabel.frame.origin.y, _orderNumLabel.frame.size.width, _orderNumLabel.frame.size.height)];
    [_orderStatusLabel setBackgroundColor:color(clearColor)];
    [_orderStatusLabel setFont:[UIFont systemFontOfSize:12]];
    //_orderStatusLabel.text = [params objectForKey:@"Status"];
    int status = [[params objectForKey:@"Status"]intValue];
    NSString *stat = [self getStatus:status];
    [_orderStatusLabel setText:[NSString stringWithFormat:@"订单状态:%@",stat]];
    [_unfoldView addSubview:_orderStatusLabel];
    
    
    _payType = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.frame.origin.x, controlYLength(_orderNumLabel), _unfoldView.frame.size.width - 20, _orderNumLabel.frame.size.height)];
    [_payType setBackgroundColor:color(clearColor)];
    [_payType setFont:[UIFont systemFontOfSize:12]];
    //_payType.text = [params objectForKey:@"OrderType"];
    int ordertype = [[params objectForKey:@"OrderType"] intValue];
    NSString *type = [self getOrderType:(int)ordertype];
    [_payType setText:[NSString stringWithFormat:@"%@",type]];
    [_unfoldView addSubview:_payType];
    
    _orderType = [[UILabel alloc]initWithFrame:CGRectMake(_payType.frame.origin.x, controlYLength(_payType), _payType.frame.size.width, _payType.frame.size.height)];
    [_orderType setBackgroundColor:color(clearColor)];
    NSString *comeDate = [params objectForKey:@"ComeDate" ];
    NSString *leavedata = [params objectForKey:@"LeaveDate" ];
    NSString *night = [self intervalFromLastDate:comeDate toTheDate:leavedata];
    NSString *money = [params objectForKey:@"Amount"];
    NSString *roomNum = [params objectForKey:@"RoomNumber"];
    //[_orderType setText:[NSString stringWithFormat:@"2间房 入住3晚 ￥1020"]];
    [_orderType setText:[NSString stringWithFormat:@"%@间房 入住%@晚 ￥%@",roomNum,night,money]];
    [_orderType setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_orderType];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_orderType.frame.origin.x, controlYLength(_orderType), _orderType.frame.size.width, 1.5)]];
    
    UILabel *unPassengersLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.frame.origin.x, controlYLength(_orderType), _orderNumLabel.frame.size.width, _orderNumLabel.frame.size.height)];
    [unPassengersLabel setBackgroundColor:color(clearColor)];
    [unPassengersLabel setText:@"入住人:"];
    [unPassengersLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:unPassengersLabel];
    
    [_itemArray removeAllObjects];
    NSArray *array = [params objectForKey:@"Guests"];
    // NSArray *array = params.passengers;
    for (int i = 0;i<[array count];i++) {
        NSDictionary *guests = [(NSArray *)[params objectForKey:@"Guests"] objectAtIndex:i];
        UIView *view = [self createCellItemWithParams:guests frame:CGRectMake(_orderType.frame.origin.x, controlYLength(unPassengersLabel) + HotelItemHeight * i, _orderType.frame.size.width, HotelItemHeight)];
        [_unfoldView addSubview:view];
        [_itemArray addObject:view];
    }
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_orderType.frame.origin.x, controlYLength(unPassengersLabel) + HotelItemHeight * [array count], _orderType.frame.size.width, 1.5)]];
    
    UILabel *contactsLabel = [[UILabel alloc]initWithFrame:CGRectMake(_payType.frame.origin.x, controlYLength(unPassengersLabel) + HotelItemHeight * [array count], _payType.frame.size.width, _payType.frame.size.height)];
    [contactsLabel setBackgroundColor:color(clearColor)];
    [contactsLabel setText:@"联系人:"];
    [contactsLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:contactsLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_payType.frame.origin.x, controlYLength(contactsLabel), _payType.frame.size.width/3, _payType.frame.size.height)];
    [_nameLabel setBackgroundColor:color(clearColor)];
    NSString *contactname = [params objectForKey:@"ContactName"];
    [_nameLabel setText:[NSString stringWithFormat:@"%@",contactname]];
    [_nameLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_nameLabel];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_nameLabel), _nameLabel.frame.origin.y, _payType.frame.size.width * 2/3, _payType.frame.size.height)];
    [_phoneLabel setBackgroundColor:color(clearColor)];
    NSString *contactTel = [params objectForKey:@"ContactMobile"];
    [_phoneLabel setText:[NSString stringWithFormat:@"电话号码:%@",contactTel]];
    //[_phoneLabel setText:@"电话号码:"];
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
    
    //    _doneBtn = [CustomBtn buttonWithType:UIButtonTypeCustom];
    //    [_doneBtn setBackgroundColor:color(clearColor)];
    //    [_doneBtn setFrame:CGRectMake(_unfoldView.frame.size.width - controlXLength(_cancleBtn), _cancleBtn.frame.origin.y, _cancleBtn.frame.size.width, _cancleBtn.frame.size.height)];
    //    [_doneBtn setTitle:@"重新支付" forState:UIControlStateNormal];
    //    [_doneBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    //    [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    //    [_doneBtn setBackgroundImage:imageNameAndType(@"hotel_done_nromal", nil) forState:UIControlStateNormal];
    //    [_doneBtn setBackgroundImage:imageNameAndType(@"hotel_done_press", nil) forState:UIControlStateHighlighted];
    //    [_doneBtn setBackgroundImage:imageNameAndType(@"hotel_done_press", nil) forState:UIControlStateSelected];
    //    [_unfoldView addSubview:_doneBtn];
    
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
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/4, (frame.size.height - 10)/3)];
    [nameLabel setBackgroundColor:color(clearColor)];
    NSString *userName = [detail objectForKey:@"UserName"];
    [nameLabel setText:[NSString stringWithFormat:@"%@",userName]];
    //[nameLabel setText:@"黄大力"];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:nameLabel];
    
    UILabel *cardNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(nameLabel), nameLabel.frame.origin.y, frame.size.width * 3/4, nameLabel.frame.size.height)];
    [cardNumLabel setBackgroundColor:color(clearColor)];
    [cardNumLabel setFont:[UIFont systemFontOfSize:12]];
    UILabel *cardNumLabelLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cardNumLabel.frame.size.width/3, cardNumLabel.frame.size.height)];
    [cardNumLabelLeft setBackgroundColor:color(clearColor)];
    [cardNumLabelLeft setText:@"手  机:"];
    [cardNumLabelLeft setTextAlignment:NSTextAlignmentRight];
    [cardNumLabelLeft setFont:[UIFont systemFontOfSize:12]];
    UILabel *cardNumLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(cardNumLabelLeft), cardNumLabelLeft.frame.origin.y, cardNumLabel.frame.size.width/3*2, cardNumLabel.frame.size.height)];
    [cardNumLabelRight setFont:[UIFont systemFontOfSize:12]];
    NSString *cardNum = [detail objectForKey:@""];
    [cardNumLabelRight setText:[NSString stringWithFormat:@"%@",cardNum]];
    [cardNumLabel addSubview:cardNumLabelRight];
    [cardNumLabel addSubview:cardNumLabelLeft];
    [view addSubview:cardNumLabel];
    
    UILabel *costCenterLabel = [[UILabel alloc]initWithFrame:CGRectMake(cardNumLabel.frame.origin.x, controlYLength(cardNumLabel), cardNumLabel.frame.size.width, cardNumLabel.frame.size.height)];
    [costCenterLabel setBackgroundColor:color(clearColor)];
    [costCenterLabel setFont:[UIFont systemFontOfSize:12]];
    UILabel *costCenterLabelLeft = [[UILabel alloc]initWithFrame:cardNumLabelLeft.bounds];
    [costCenterLabelLeft setBackgroundColor:color(clearColor)];
    [costCenterLabelLeft setText:@"成本中心:"];
    [costCenterLabelLeft setTextAlignment:NSTextAlignmentRight];
    [costCenterLabelLeft setFont:[UIFont systemFontOfSize:12]];
    UILabel *costCenterLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(costCenterLabelLeft), costCenterLabelLeft.frame.origin.y, cardNumLabelLeft.frame.size.width*2, cardNumLabelLeft.frame.size.height)];
    [costCenterLabelRight setFont:[UIFont systemFontOfSize:12]];
    NSString *costcenter = [detail objectForKey:@"CostCenter"];
    [costCenterLabelRight setText:[NSString stringWithFormat:@"%@",costcenter]];
    [costCenterLabel addSubview:costCenterLabelRight];
    [costCenterLabel addSubview:costCenterLabelLeft];
    [view addSubview:costCenterLabel];
    
    UILabel *costLabel = [[UILabel alloc]initWithFrame:CGRectMake(cardNumLabel.frame.origin.x, controlYLength(costCenterLabel), cardNumLabel.frame.size.width, cardNumLabel.frame.size.height)];
    [costLabel setBackgroundColor:color(clearColor)];
    [costLabel setFont:[UIFont systemFontOfSize:12]];
    UILabel *costLabelLeft = [[UILabel alloc]initWithFrame:cardNumLabelLeft.bounds];
    [costLabelLeft setBackgroundColor:color(clearColor)];
    [costLabelLeft setText:@"费  用:"];
    [costLabelLeft setTextAlignment:NSTextAlignmentRight];
    [costLabelLeft setFont:[UIFont systemFontOfSize:12]];
    UILabel *costLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(costLabelLeft), costLabelLeft.frame.origin.y, costLabelLeft.frame.size.width*2, costLabelLeft.frame.size.height)];
    [costLabelRight setFont:[UIFont systemFontOfSize:12]];
    NSString *shareAmount = [detail objectForKey:@"ShareAmount"];
    [costLabelRight setText:[NSString stringWithFormat:@"%@",shareAmount]];
    [costLabel addSubview:costLabelRight];
    [costLabel addSubview:costLabelLeft];
    [view addSubview:costLabel];
    
    return view;
}

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"t_line", nil)];
    return line;
}

- (void)unfoldViewShow:(NSDictionary*)detail
{
    BOOL unfold = [[detail valueForKey:@"unfold"] boolValue];
    if (unfold) {
        if (_unfoldView) {
            [_unfoldView removeFromSuperview];
            _unfoldView = nil;
            
        }
        
        [self setSubjoinViewFrameWithPrarams:detail];
    }
    
    [_rightArrow setHighlighted:unfold];
    [_unfoldView setHidden:!unfold];
}

//ComeDate与LeaveDate的时间差，
- (NSString *)intervalFromLastDate: (NSString *) dateString1 toTheDate:(NSString *) dateString2
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *d1=[date dateFromString:dateString1];
    NSTimeInterval late1=[d1 timeIntervalSince1970]*1;
    
    NSDate *d2=[date dateFromString:dateString2];
    NSTimeInterval late2=[d2 timeIntervalSince1970]*1;
    
    NSTimeInterval cha=late2-late1;
    NSString *timeString=@"";
    NSString *night=@"";
    
    night = [NSString stringWithFormat:@"%d", (int)cha/(60*60*24)];
    night=[NSString stringWithFormat:@"%@", night];
    
    timeString=[NSString stringWithFormat:@"%@",night];
    
    return timeString;
}

- (void)setViewContentWithParams:(NSDictionary*)params
{
    [self unfoldViewShow:params];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//订单状态
- (NSString *)getStatus:(int)params
{
    //    (0) 全部    (1) 新建    (2) 已取消    (3) 已确认    (4) 客人入住
    //    (5) 客人未住    (6) 待支付   (7) 已支付   (8) 退款中    (9) 已退款    (10)删除
    
    NSString *status;
    if (params == 0) {
        status = @"全部";
    }else if (params == 1)
    {
        status = @"新建";
    }else if (params == 2)
    {
        status = @"已取消";
    }else if (params == 3)
    {
        status = @"已确认";
    }else if (params == 4)
    {
        status = @"客人入住";
    }else if (params == 5)
    {
        status = @"客人未住";
    }else if (params == 6)
    {
        status = @"待支付";
    }else if (params == 7)
    {
        status = @"已支付";
    }else if (params == 8)
    {
        status = @"退款中";
    }else if (params == 9)
    {
        status = @"已退款";
    }else if (params == 10)
    {
        status = @"删除";
    }
    
    return status;
}

//支付状态
- (NSString *)getOrderType:(int)ordertype
{
    //    无担保(0) 担保冻结(1) 担保预付(2) 代收代付(3)
    //    目前只有0和2
    
    NSString *orderType;
    if (ordertype == 0)
    {
        orderType = @"无担保";
    }else if (ordertype == 1)
    {
        orderType = @"担保冻结";
    }else if (ordertype == 2)
    {
        orderType = @"担保预付";
    }else if (ordertype == 3)
    {
        orderType = @"代收代付";
    }
    return orderType;
}


@end
