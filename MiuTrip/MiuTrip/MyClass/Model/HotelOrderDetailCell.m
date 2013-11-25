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

@interface HotelOrderDetailCell ()

@property (strong, nonatomic) UILabel               *mainDateLabel;                 //月/日
@property (strong, nonatomic) UILabel               *subDateLabel;                  //年份&week
@property (strong, nonatomic) UILabel               *timeLabel;                     //时间

@property (strong, nonatomic) UILabel               *hotelName;                     //酒店名称&房间类型
@property (strong, nonatomic) UILabel               *location;                      //酒店位置

@property (strong, nonatomic) UILabel               *orderNumLabel;                 //订单号
@property (strong, nonatomic) UILabel               *orderStatusLabel;              //订单状态
@property (strong, nonatomic) UILabel               *payType;                       //支付类型

@property (strong, nonatomic) UILabel               *orderType;                     //房间数&入住时间&价格

@property (strong, nonatomic) UIView                *unfoldView;                    //展开页面
@property (strong, nonatomic) UILabel               *nameLabel;                     //联系人姓名
@property (strong, nonatomic) UILabel               *phoneLabel;                    //联系人电话

@property (strong, nonatomic) NSMutableArray        *itemArray;                     //item集合

@property (strong, nonatomic) CustomBtn             *cancleBtn;
@property (strong, nonatomic) CustomBtn             *doneBtn;

@end

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
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_subDateLabel), _mainDateLabel.frame.origin.y, titleBGImage.frame.size.width/2, _mainDateLabel.frame.size.height)];
    [_timeLabel setBackgroundColor:color(clearColor)];
    [_timeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_timeLabel setTextColor:color(whiteColor)];
    [_timeLabel setText:[Utils stringWithDate:date withFormat:@"HH:mm"]];
    [_timeLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_timeLabel];
    
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
    
    _rightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(AirOrderCellWidth - _hotelName.frame.size.height * 2, _hotelName.frame.origin.y, _hotelName.frame.size.height * 2, _hotelName.frame.size.height * 2)];
    [_rightArrow setBackgroundColor:color(clearColor)];
    [_rightArrow setTag:100];
    [_rightArrow setScaleX:0.25 scaleY:0.25];
    [_rightArrow setImage:imageNameAndType(@"cell_arrow_up", nil)];
    [_rightArrow setHighlightedImage:imageNameAndType(@"cell_arrow_down", nil)];
    [self.contentView addSubview:_rightArrow];
}

- (void)setSubjoinViewFrameWithPrarams:(HotelOrderDetail*)params
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
    [_orderNumLabel setText:[NSString stringWithFormat:@"订单号:%@",params.orderNum]];
    [_unfoldView addSubview:_orderNumLabel];
    
    _orderStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_orderNumLabel), _orderNumLabel.frame.origin.y, _orderNumLabel.frame.size.width, _orderNumLabel.frame.size.height)];
    [_orderStatusLabel setBackgroundColor:color(clearColor)];
    [_orderStatusLabel setFont:[UIFont systemFontOfSize:12]];
    [_orderStatusLabel setText:[NSString stringWithFormat:@"订单状态:"]];
    [_unfoldView addSubview:_orderStatusLabel];
    
    _payType = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.frame.origin.x, controlYLength(_orderNumLabel), _unfoldView.frame.size.width - 20, _orderNumLabel.frame.size.height)];
    [_payType setBackgroundColor:color(clearColor)];
    [_payType setFont:[UIFont systemFontOfSize:12]];
    [_payType setText:[NSString stringWithFormat:@"前台现付"]];
    [_unfoldView addSubview:_payType];
    
    _orderType = [[UILabel alloc]initWithFrame:CGRectMake(_payType.frame.origin.x, controlYLength(_payType), _payType.frame.size.width, _payType.frame.size.height)];
    [_orderType setBackgroundColor:color(clearColor)];
    [_orderType setText:[NSString stringWithFormat:@"2间房 入住3晚 ￥1020"]];
    [_orderType setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_orderType];
    
    [_unfoldView addSubview:[self createLineWithFrame:CGRectMake(_orderType.frame.origin.x, controlYLength(_orderType), _orderType.frame.size.width, 1.5)]];
    
    UILabel *unPassengersLabel = [[UILabel alloc]initWithFrame:CGRectMake(_orderNumLabel.frame.origin.x, controlYLength(_orderType), _orderNumLabel.frame.size.width, _orderNumLabel.frame.size.height)];
    [unPassengersLabel setBackgroundColor:color(clearColor)];
    [unPassengersLabel setText:@"入住人:"];
    [unPassengersLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:unPassengersLabel];
    
    [_itemArray removeAllObjects];
    NSArray *array = params.passengers;
    for (int i = 0;i<[array count];i++) {
        CommonlyName *detail = [array objectAtIndex:i];
        //AirOrderDetailCellItem *item = [[AirOrderDetailCellItem alloc]initWithFrame:CGRectMake(_orderType.frame.origin.x, controlYLength(unPassengersLabel) + HotelItemHeight * i, _orderType.frame.size.width, HotelItemHeight)];
        UIView *view = [self createCellItemWithParams:detail frame:CGRectMake(_orderType.frame.origin.x, controlYLength(unPassengersLabel) + HotelItemHeight * i, _orderType.frame.size.width, HotelItemHeight)];
        //[item setContentWithParams:detail];
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
    [_nameLabel setText:@"那谁谁"];
    [_nameLabel setFont:[UIFont systemFontOfSize:12]];
    [_unfoldView addSubview:_nameLabel];
    
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_nameLabel), _nameLabel.frame.origin.y, _payType.frame.size.width * 2/3, _payType.frame.size.height)];
    [_phoneLabel setBackgroundColor:color(clearColor)];
    [_phoneLabel setText:@"电话号码:"];
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
    [_doneBtn setTitle:@"重新支付" forState:UIControlStateNormal];
    [_doneBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [_doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_doneBtn setBackgroundImage:imageNameAndType(@"hotel_done_nromal", nil) forState:UIControlStateNormal];
    [_doneBtn setBackgroundImage:imageNameAndType(@"hotel_done_press", nil) forState:UIControlStateHighlighted];
    [_doneBtn setBackgroundImage:imageNameAndType(@"hotel_done_press", nil) forState:UIControlStateSelected];
    [_unfoldView addSubview:_doneBtn];
    
    [_unfoldView setFrame:CGRectMake(_unfoldView.frame.origin.x, _unfoldView.frame.origin.y, _unfoldView.frame.size.width, controlYLength(_cancleBtn) + 10)];
    [_unfoldView setHidden:YES];
    
    UIImageView *unfoldBackImage = [[UIImageView alloc]initWithFrame:_unfoldView.bounds];
    [unfoldBackImage setBackgroundColor:color(colorWithRed:242.0/255.0 green:244.0/255.0 blue:247.0/255.0 alpha:1)];
    [unfoldBackImage setBorderColor:color(lightGrayColor) width:1];
    [unfoldBackImage setAlpha:0.5];
    [_unfoldView insertSubview:unfoldBackImage belowSubview:subjoinImageView];
    
}

- (UIView*)createCellItemWithParams:(CommonlyName*)detail frame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    [view setBackgroundColor:color(clearColor)];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width/4, (frame.size.height - 10)/3)];
    [nameLabel setBackgroundColor:color(clearColor)];
    [nameLabel setText:@"黄大力"];
    [nameLabel setFont:[UIFont systemFontOfSize:12]];
    [view addSubview:nameLabel];
    
    UITextField *cardNumTextField = [[UITextField alloc]initWithFrame:CGRectMake(controlXLength(nameLabel), nameLabel.frame.origin.y, frame.size.width * 3/4, nameLabel.frame.size.height)];
    [cardNumTextField setBackgroundColor:color(clearColor)];
    [cardNumTextField setFont:[UIFont systemFontOfSize:12]];
    UILabel *cardNumLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cardNumTextField.frame.size.width/3, cardNumTextField.frame.size.height)];
    [cardNumLeft setBackgroundColor:color(clearColor)];
    [cardNumLeft setText:@"身份证:"];
    [cardNumLeft setTextAlignment:NSTextAlignmentRight];
    [cardNumLeft setFont:[UIFont systemFontOfSize:12]];
    //UIWebView *cardLeft = [[UIWebView alloc]initWithFrame:cardNumLeft.bounds];
    //[cardLeft loadHTMLString:@"<div style=\"text-align:justify; font-size:12px;\">身份证:</div>" baseURL:nil];
    //[cardLeft setBackgroundColor:color(clearColor)];
    [cardNumTextField setLeftView:cardNumLeft];
    [cardNumTextField setLeftViewMode:UITextFieldViewModeAlways];
    [view addSubview:cardNumTextField];
    
    UITextField *costCenterTextField = [[UITextField alloc]initWithFrame:CGRectMake(cardNumTextField.frame.origin.x, controlYLength(cardNumTextField), cardNumTextField.frame.size.width, cardNumTextField.frame.size.height)];
    [costCenterTextField setBackgroundColor:color(clearColor)];
    [costCenterTextField setFont:[UIFont systemFontOfSize:12]];
    UILabel *costCenterLeft = [[UILabel alloc]initWithFrame:cardNumLeft.bounds];
    [costCenterLeft setBackgroundColor:color(clearColor)];
    [costCenterLeft setText:@"成本中心:"];
    [costCenterLeft setTextAlignment:NSTextAlignmentRight];
    [costCenterLeft setFont:[UIFont systemFontOfSize:12]];
    [costCenterTextField setLeftView:costCenterLeft];
    [costCenterTextField setLeftViewMode:UITextFieldViewModeAlways];
    [view addSubview:costCenterTextField];
    
    UITextField *costTextField = [[UITextField alloc]initWithFrame:CGRectMake(cardNumTextField.frame.origin.x, controlYLength(costCenterTextField), cardNumTextField.frame.size.width, cardNumTextField.frame.size.height)];
    [costTextField setBackgroundColor:color(clearColor)];
    [costTextField setFont:[UIFont systemFontOfSize:12]];
    UILabel *costLeft = [[UILabel alloc]initWithFrame:cardNumLeft.bounds];
    [costLeft setBackgroundColor:color(clearColor)];
    [costLeft setText:@"费用:"];
    [costLeft setTextAlignment:NSTextAlignmentRight];
    [costLeft setFont:[UIFont systemFontOfSize:12]];
    [costTextField setLeftView:costLeft];
    [costTextField setLeftViewMode:UITextFieldViewModeAlways];
    [view addSubview:costTextField];
    
    return view;
}

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(clearColor)];
    [line setImage:imageNameAndType(@"t_line", nil)];
    return line;
}

- (void)unfoldViewShow:(BOOL)show
{
    if (show) {
        if (_unfoldView) {
            [_unfoldView removeFromSuperview];
        }
        [self setSubjoinViewFrameWithPrarams:_hotelDetail];
    }
    
    [_rightArrow setHighlighted:show];
    [_unfoldView setHidden:!show];
}

- (void)setViewContentWithParams:(HotelOrderDetail*)params
{
    [_rightArrow setHighlighted:params.unfold];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
