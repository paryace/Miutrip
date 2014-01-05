//
//  HotelSearchView.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-6.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelSearchView.h"
#import "HotelListViewController.h"


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

    
    UIView *pageHotelBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,70,self.frame.size.width, 0)];
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
    
    ImageAndTextTilteView *cityView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y, topItemBG.frame.size.width, 40) withImageName:@"query_city_name" withLabelName:@"城市名称" isValueEditabel:NO];
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
    

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:_data.checkInDate];
    
    NSString *week = [[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1];
    NSString *year = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkInDate withFormat:@"yyyy"]];
    NSString *mathAndDay = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkInDate withFormat:@"MM月dd日"]];
    
    //日期
    UILabel *checkInDate = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+5, 0, 70, checkInDateView.frame.size.height)];
    [checkInDate setBackgroundColor:color(clearColor)];
    [checkInDate setFont:[UIFont boldSystemFontOfSize:15]];
    [checkInDate setTextColor:color(darkGrayColor)];
    [checkInDate setText:mathAndDay];
    [checkInDateView addSubview:checkInDate];
    
    //星期
    UILabel *checkInDateWeek = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+checkInDate.frame.size.width+5, 0, 40, checkInDateView.frame.size.height)];
    [checkInDateWeek setBackgroundColor:color(clearColor)];
    [checkInDateWeek setFont:[UIFont boldSystemFontOfSize:10]];
    [checkInDateWeek setTextColor:color(lightGrayColor)];
    [checkInDateWeek setText:week];
    [checkInDateView addSubview:checkInDateWeek];
    
    
    //箭头
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [arrow setFrame:CGRectMake(checkInDateView.frame.size.width - 17, 12, 12, 16)];
    [arrow setBackgroundColor:color(clearColor)];
    [checkInDateView addSubview:arrow];
    
    
    UILabel *checkInYear = [[UILabel alloc] initWithFrame:CGRectMake(checkInDateView.frame.size.width - 50, 13, 30, 14)];
    [checkInYear setBackgroundColor:color(clearColor)];
    [checkInYear setFont:[UIFont systemFontOfSize:10]];
    [checkInYear setTextColor:color(lightGrayColor)];
    [checkInYear setText:year];
    [checkInDateView addSubview:checkInYear];
    
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
    
    
    NSCalendar *checkOutCalendar = [NSCalendar currentCalendar];
    NSDateComponents *cocomps =[checkOutCalendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:_data.checkOutDate];
    
    NSString *checkOutWeek = [[WeekDays componentsSeparatedByString:@","] objectAtIndex:[cocomps weekday] - 1];
    NSString *checkOutYear = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkOutDate withFormat:@"yyyy"]];
    NSString *checkOutMonthAndDay = [NSString stringWithFormat:@"%@",[Utils stringWithDate:_data.checkOutDate withFormat:@"MM月dd日"]];
    
    //日期
    UILabel *checkOutDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+5, 0, 70, checkInDateView.frame.size.height)];
    [checkOutDateLabel setBackgroundColor:color(clearColor)];
    [checkOutDateLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [checkOutDateLabel setTextColor:color(darkGrayColor)];
    [checkOutDateLabel setText:checkOutMonthAndDay];
    [checkOutDateView addSubview:checkOutDateLabel];
    
    //星期
    UILabel *checkOutDateWeek = [[UILabel alloc] initWithFrame:CGRectMake(controlXLength(title)+checkOutDateLabel.frame.size.width+5, 0, 40, checkOutDateView.frame.size.height)];
    [checkOutDateWeek setBackgroundColor:color(clearColor)];
    [checkOutDateWeek setFont:[UIFont boldSystemFontOfSize:10]];
    [checkOutDateWeek setTextColor:color(lightGrayColor)];
    [checkOutDateWeek setText:checkOutWeek];
    [checkOutDateView addSubview:checkOutDateWeek];
    
    
    //箭头
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    [arrow2 setFrame:CGRectMake(checkInDateView.frame.size.width - 17, 12, 12, 16)];
    [arrow2 setBackgroundColor:color(clearColor)];
    [checkOutDateView addSubview:arrow2];
    
    
    UILabel *checkOutYearLabel = [[UILabel alloc] initWithFrame:CGRectMake(checkOutDateView.frame.size.width - 50, 13, 30, 14)];
    [checkOutYearLabel setBackgroundColor:color(clearColor)];
    [checkOutYearLabel setFont:[UIFont systemFontOfSize:10]];
    [checkOutYearLabel setTextColor:color(lightGrayColor)];
    [checkOutYearLabel setText:checkOutYear];
    [checkOutDateView addSubview:checkOutYearLabel];
    

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
    [queryBtn setFrame:CGRectMake(pageHotelBottomView.frame.size.width/6, controlYLength(bottomItemBG)+20, pageHotelBottomView.frame.size.width * 2/3 - 50, 45)];
    [queryBtn setTag:550];
    [pageHotelBottomView addSubview:queryBtn];
    
    UIImageView *shakeImage = [[UIImageView alloc]initWithFrame:CGRectMake(queryBtn.frame.size.height/2, 0, queryBtn.frame.size.height, queryBtn.frame.size.height)];
    [shakeImage setImage:imageNameAndType(@"shake", nil)];
    [queryBtn addSubview:shakeImage];
    [shakeImage setBounds:CGRectMake(0, 0, shakeImage.frame.size.width * 0.7, shakeImage.frame.size.height * 0.7)];
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setFrame:CGRectMake(controlXLength(queryBtn) + 5, queryBtn.frame.origin.y, queryBtn.frame.size.height, queryBtn.frame.size.height)];
    [voiceBtn setTag:551];
    [voiceBtn setImage:imageNameAndType(@"voice_btn_normal", nil) highlightImage:imageNameAndType(@"voice_btn_press", nil) forState:ButtonImageStateBottom];
    [pageHotelBottomView addSubview:voiceBtn];
    
    [pageHotelBottomView setFrame:CGRectMake(pageHotelBottomView.frame.origin.x,
                                             pageHotelBottomView.frame.origin.y,
                                             pageHotelBottomView.frame.size.width,
                                             controlYLength(queryBtn))];
    
    [self setFrame:CGRectMake(self.frame.origin.x,
                                        self.frame.origin.y,
                                        self.frame.size.width,
                                        controlYLength(pageHotelBottomView))];

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

-(void)updateDate
{
    
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
