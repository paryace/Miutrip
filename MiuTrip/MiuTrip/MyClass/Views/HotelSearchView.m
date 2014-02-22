//
//  HotelSearchView.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-6.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelSearchView.h"
#import "HotelListViewController.h"
#import "HomeViewController.h"
@implementation HotelSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(id)initWidthFrame:(CGRect)frame widthdata:(HotelDataCache *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _data = data;
        [self setUpView];
    }
    return self;
}


-(void)setUpView{
    
    UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, - 1.5, self.frame.size.width, 15)];
    [titleImage setBackgroundColor:color(clearColor)];
    [titleImage setImage:imageNameAndType(@"shadow", nil)];
    [self addSubview:titleImage];

    
    UIView *pageHotelBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,60,self.frame.size.width, 0)];
    [pageHotelBottomView setBackgroundColor:color(clearColor)];
    [pageHotelBottomView setUserInteractionEnabled:YES];
    [pageHotelBottomView setTag:600];
    [self addSubview:pageHotelBottomView];
    
    UIImageView *topItemBG = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, pageHotelBottomView.frame.size.width - 10, 40 * 3)];
    [topItemBG setBackgroundColor:color(whiteColor)];
    [topItemBG setBorderColor:color(lightGrayColor) width:1.0];
    [topItemBG setCornerRadius:5.0];
    [topItemBG setAlpha:0.5];
    [pageHotelBottomView addSubview:topItemBG];
    
    //入住城市
    ImageAndTextTilteView *cityView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y, topItemBG.frame.size.width, 40) withImageName:@"query_city_name" withLabelName:@"城市名称" isValueEditabel:NO];
    cityView.tag = 500;
    [pageHotelBottomView addSubview:cityView];
    
    
    [cityView setValue:[UserDefaults shareUserDefault].goalCity];
    
    //check city btn
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn setFrame:cityView.frame];
    [cityBtn setTag:501];
    [pageHotelBottomView addSubview:cityBtn];
    
    [pageHotelBottomView addSubview:[self createLineWithFrame:CGRectMake(topItemBG.frame.origin.x, controlYLength(cityView), topItemBG.frame.size.width, 1)]];
    
    //入住时间
    UIView *checkInDateView = [[UIView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y+40, topItemBG.frame.size.width, 40)];
    
    //图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"query_checkIn.png"]];
    [imageView setFrame:CGRectMake(0, (checkInDateView.frame.size.height-40)/2, 40, 40)];
    [imageView setBackgroundColor:color(clearColor)];
    [checkInDateView addSubview:imageView];
    
    //标题
    NSString *dateTile = @"入住时间";
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [dateTile sizeWithFont:font];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(imageView), 0, size.width+5, 40)];
    [title setBackgroundColor:color(clearColor)];
    [title setTextColor:color(darkGrayColor)];
    [title setFont:font];
    [title setText:dateTile];
    [checkInDateView addSubview:title];
    
    
    //日期
    _checkInDate = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+5, 0, 70, checkInDateView.frame.size.height)];
    [_checkInDate setBackgroundColor:color(clearColor)];
    [_checkInDate setFont:[UIFont boldSystemFontOfSize:15]];
    [_checkInDate setTextColor:color(darkGrayColor)];
    [checkInDateView addSubview:_checkInDate];
    
    //星期
    _checkInDateWeek = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+_checkInDate.frame.size.width+5, 0, 40, checkInDateView.frame.size.height)];
    [_checkInDateWeek setBackgroundColor:color(clearColor)];
    [_checkInDateWeek setFont:[UIFont boldSystemFontOfSize:10]];
    [_checkInDateWeek setTextColor:color(lightGrayColor)];
    [checkInDateView addSubview:_checkInDateWeek];
    
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [arrow setFrame:CGRectMake(checkInDateView.frame.size.width - 17, 12, 12, 16)];
    [arrow setBackgroundColor:color(clearColor)];
    [checkInDateView addSubview:arrow];
    
    
    _checkInDateYear = [[UILabel alloc] initWithFrame:CGRectMake(checkInDateView.frame.size.width - 50, 13, 30, 14)];
    [_checkInDateYear setBackgroundColor:color(clearColor)];
    [_checkInDateYear setFont:[UIFont systemFontOfSize:10]];
    [_checkInDateYear setTextColor:color(lightGrayColor)];
    [checkInDateView addSubview:_checkInDateYear];
    
    [pageHotelBottomView addSubview:checkInDateView];
    
    //checkin btn
    UIButton *checkInDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkInDateBtn setFrame:checkInDateView.frame];
    [checkInDateBtn setTag:502];
    [pageHotelBottomView addSubview:checkInDateBtn];
    
    //line
    [pageHotelBottomView addSubview:[self createLineWithFrame:CGRectMake(topItemBG.frame.origin.x, controlYLength(checkInDateView), topItemBG.frame.size.width, 1)]];
    
    
    //离店时间
    UIView *checkOutDateView = [[UIView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y+80, topItemBG.frame.size.width, 40)];
    
    //图片
    UIImageView *coImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"query_leave.png"]];
    [coImageView setFrame:CGRectMake(0, (checkOutDateView.frame.size.height-40)/2, 40, 40)];
    [coImageView setBackgroundColor:color(clearColor)];
    [checkOutDateView addSubview:coImageView];
    
    //标题
    NSString *coDateTile = @"离店时间";
    size = [coDateTile sizeWithFont:font];
    UILabel *coTitle = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(imageView), 0, size.width+5, 40)];
    [coTitle setBackgroundColor:color(clearColor)];
    [coTitle setTextColor:color(darkGrayColor)];
    [coTitle setFont:font];
    [coTitle setText:coDateTile];
    [checkOutDateView addSubview:coTitle];
    
    

    
    //日期
    _checkOutDate = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+5, 0, 70, checkInDateView.frame.size.height)];
    [_checkOutDate setBackgroundColor:color(clearColor)];
    [_checkOutDate setFont:[UIFont boldSystemFontOfSize:15]];
    [_checkOutDate setTextColor:color(darkGrayColor)];
    [checkOutDateView addSubview:_checkOutDate];
    
    //星期
    _checkOutDateWeek = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+_checkOutDate.frame.size.width+5, 0, 40, checkOutDateView.frame.size.height)];
    [_checkOutDateWeek setBackgroundColor:color(clearColor)];
    [_checkOutDateWeek setFont:[UIFont boldSystemFontOfSize:10]];
    [_checkOutDateWeek setTextColor:color(lightGrayColor)];
    [checkOutDateView addSubview:_checkOutDateWeek];
    
    
    //箭头
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [arrow2 setFrame:CGRectMake(checkInDateView.frame.size.width - 17, 12, 12, 16)];
    [arrow2 setBackgroundColor:color(clearColor)];
    [checkOutDateView addSubview:arrow2];
    
    
    _checkOutDateYear = [[UILabel alloc] initWithFrame:CGRectMake(checkOutDateView.frame.size.width - 50, 13, 30, 14)];
    [_checkOutDateYear setBackgroundColor:color(clearColor)];
    [_checkOutDateYear setFont:[UIFont systemFontOfSize:10]];
    [_checkOutDateYear setTextColor:color(lightGrayColor)];
    [checkOutDateView addSubview:_checkOutDateYear];
    

    [pageHotelBottomView addSubview:checkOutDateView];
    
    
    //checkout btn
    UIButton *checkOutDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkOutDateBtn setFrame:checkOutDateView.frame];
    [checkOutDateBtn setTag:503];
    [pageHotelBottomView addSubview:checkOutDateBtn];
    
    //下半部背景
    UIImageView *bottomItemBG = [[UIImageView alloc]initWithFrame:CGRectMake(topItemBG.frame.origin.x, controlYLength(topItemBG) + 10, topItemBG.frame.size.width, topItemBG.frame.size.height)];
    [bottomItemBG setBackgroundColor:color(whiteColor)];
    [bottomItemBG setBorderColor:color(lightGrayColor) width:1.0];
    [bottomItemBG setCornerRadius:5.0];
    [bottomItemBG setAlpha:0.5];
    [pageHotelBottomView addSubview:bottomItemBG];
    
    
    //价格范围
     _priceRangeView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(bottomItemBG.frame.origin.x, bottomItemBG.frame.origin.y, bottomItemBG.frame.size.width, 40) withImageName:@"query_price" withLabelName:@"价格范围" isValueEditabel:NO];
    
    [_priceRangeView setValue:[_data.priceRangeArray objectAtIndex:_data.priceRangeIndex]];
    
    [pageHotelBottomView addSubview:_priceRangeView];
    
    UIButton *priceRangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceRangeBtn setFrame:_priceRangeView.frame];
    [priceRangeBtn setTag:504];
    [pageHotelBottomView addSubview:priceRangeBtn];
    
    //LINE
    [pageHotelBottomView addSubview:[self createLineWithFrame:CGRectMake(topItemBG.frame.origin.x,controlYLength(priceRangeBtn),topItemBG.frame.size.width,1)]];
    
    //酒店位置
    _hotelLoactionView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(bottomItemBG.frame.origin.x, bottomItemBG.frame.origin.y+40, bottomItemBG.frame.size.width, 40) withImageName:@"query_location" withLabelName:@"酒店位置" isValueEditabel:NO];
    [_hotelLoactionView setValue:_data.queryCantonName];
    [pageHotelBottomView addSubview:_hotelLoactionView];
    
    UIButton *hotelLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelLocationBtn setFrame:_hotelLoactionView.frame];
    [hotelLocationBtn setTag:505];
    [pageHotelBottomView addSubview:hotelLocationBtn];
    
    [pageHotelBottomView addSubview:[self createLineWithFrame:
                                     CGRectMake(topItemBG.frame.origin.x,
                                                controlYLength(_hotelLoactionView),
                                                topItemBG.frame.size.width,
                                                1)]];

    
    //酒店名称
    ImageAndTextTilteView *hotelNameView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(bottomItemBG.frame.origin.x, bottomItemBG.frame.origin.y+80, bottomItemBG.frame.size.width, 40) withImageName:@"query_location" withLabelName:@"酒店名称" isValueEditabel:YES];
    [hotelNameView setValue:_data.keyWord];
    [pageHotelBottomView addSubview:hotelNameView];
    
    
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryBtn setImage:imageNameAndType(@"hotel_done_nromal", nil)
        highlightImage:imageNameAndType(@"hotel_done_press", nil)
              forState:ButtonImageStateBottom];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [queryBtn setFrame:CGRectMake(pageHotelBottomView.frame.size.width/6, controlYLength(bottomItemBG)+20, pageHotelBottomView.frame.size.width * 2/3, 45)];
    [queryBtn setTag:550];
    [pageHotelBottomView addSubview:queryBtn];
    
    UIImageView *shakeImage = [[UIImageView alloc]initWithFrame:CGRectMake(queryBtn.frame.size.height/2, 0, queryBtn.frame.size.height, queryBtn.frame.size.height)];
    [shakeImage setImage:imageNameAndType(@"shake", nil)];
    [queryBtn addSubview:shakeImage];
    [shakeImage setBounds:CGRectMake(0, 0, shakeImage.frame.size.width * 0.7, shakeImage.frame.size.height * 0.7)];
    
    [pageHotelBottomView setFrame:CGRectMake(pageHotelBottomView.frame.origin.x,
                                             pageHotelBottomView.frame.origin.y,
                                             pageHotelBottomView.frame.size.width,
                                             controlYLength(queryBtn))];
    
    [self setFrame:CGRectMake(self.frame.origin.x,
                                        self.frame.origin.y,
                                        self.frame.size.width,
                                        controlYLength(pageHotelBottomView))];
    [self updateDate];
}

-(void)setPriceRange:(NSString *) rangeText
{
    [_priceRangeView setValue:rangeText];
}

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(lightGrayColor)];
    return line;
}

-(void)setHotelCanton:(NSString *)hotelCanton
{
    [_hotelLoactionView setValue:hotelCanton];
}

-(void)updateCity
{
    ImageAndTextTilteView *cityView = (ImageAndTextTilteView*)[self viewWithTag:500];
    [cityView setValue:_data.checkInCityName];
}

-(void)updateDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:_data.checkInDate];
    NSString *week = [[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1];
    NSString *year = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkInDate withFormat:@"yyyy"]];
    NSString *mathAndDay = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkInDate withFormat:@"MM月dd日"]];
    
    [_checkInDate setText:mathAndDay];
    [_checkInDateWeek setText:week];
    [_checkInDateYear setText:year];
    
    NSCalendar *checkOutCalendar = [NSCalendar currentCalendar];
    comps =[checkOutCalendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:_data.checkOutDate];
    NSString *checkOutWeek = [[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1];
    NSString *checkOutYear = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkOutDate withFormat:@"yyyy"]];
    NSString *checkOutMonthAndDay = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkOutDate withFormat:@"MM月dd日"]];
    
    [_checkOutDate setText:checkOutMonthAndDay];
    [_checkOutDateWeek setText:checkOutWeek];
    [_checkOutDateYear setText:checkOutYear];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
