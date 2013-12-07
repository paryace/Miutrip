//
//  HotelSearchView.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-6.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelSearchView.h"
#import "ImageAndTextTilteView.h"


@implementation HotelSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(id)initWidthFrame:(CGRect)frame widthdata:(HotelOrderDetail *)data widthDelegate:(HomeViewController*) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
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
    
    HomeCustomBtn *customBtn = [[HomeCustomBtn alloc]initWithParams:_data];
    [customBtn setFrame:CGRectMake(0, controlYLength(titleImage), appFrame.size.width, 60)];
    [customBtn setBackgroundColor:color(clearColor)];
    [customBtn setTag:300];
    [customBtn setDelegate:_delegate];
    [self addSubview:customBtn];
    
    UIView *pageHotelBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, controlYLength(customBtn) + 10, customBtn.frame.size.width, 0)];
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
    
    ImageAndTextTilteView *cityView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y, topItemBG.frame.size.width, 40) withImageName:@"query_city_name" withLabelName:@"城市名称"];
    [pageHotelBottomView addSubview:cityView];
    
    
    [cityView setValue:[UserDefaults shareUserDefault].goalCity];
    
    //check city btn
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cityBtn setFrame:cityView.frame];
    [cityBtn setTag:501];
    [cityBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pageHotelBottomView addSubview:cityBtn];
    
    [pageHotelBottomView addSubview:[self createLineWithFrame:CGRectMake(topItemBG.frame.origin.x, controlYLength(cityView), topItemBG.frame.size.width, 1)]];
    
    //入住时间
    ImageAndTextTilteView *checkInDateView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y+40, topItemBG.frame.size.width, 40) withImageName:@"query_checkIn" withLabelName:@"入住时间"];
    
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:date];
    
    NSString *week = [[WeekDays componentsSeparatedByString:@","] objectAtIndex:[comps weekday] - 1];
    NSString *year = [NSString stringWithFormat:@"%@年",[Utils stringWithDate:date withFormat:@"yyyy"]];
    NSString *mathAndDay = [NSString stringWithFormat:@"%@",[Utils stringWithDate:date withFormat:@"MM月dd日"]];
    
    NSString *checkIndateStr = [NSString stringWithFormat:@"%@ %@ %@",year,mathAndDay,week];
    [checkInDateView setValue:checkIndateStr];
    
    [pageHotelBottomView addSubview:checkInDateView];
    
    //checkin btn
    UIButton *checkInDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkInDateBtn setFrame:checkInDateView.frame];
    [checkInDateBtn setTag:502];
    [checkInDateBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pageHotelBottomView addSubview:checkInDateBtn];
    
    //line
    [pageHotelBottomView addSubview:[self createLineWithFrame:CGRectMake(topItemBG.frame.origin.x, controlYLength(checkInDateView), topItemBG.frame.size.width, 1)]];
    
    
    ImageAndTextTilteView *checkOutDateView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(topItemBG.frame.origin.x, topItemBG.frame.origin.y+80, topItemBG.frame.size.width, 40) withImageName:@"query_leave" withLabelName:@"离店时间"];
    
    [pageHotelBottomView addSubview:checkOutDateView];
    
    
    //checkout btn
    UIButton *checkOutDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkOutDateBtn setFrame:checkInDateView.frame];
    [checkOutDateBtn setTag:503];
    [checkOutDateBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pageHotelBottomView addSubview:checkOutDateBtn];
    
    //下半部背景
    UIImageView *bottomItemBG = [[UIImageView alloc]initWithFrame:CGRectMake(topItemBG.frame.origin.x, controlYLength(topItemBG) + 10, topItemBG.frame.size.width, topItemBG.frame.size.height)];
    [bottomItemBG setBackgroundColor:color(whiteColor)];
    [bottomItemBG setBorderColor:color(lightGrayColor) width:1.0];
    [bottomItemBG setCornerRadius:5.0];
    [bottomItemBG setAlpha:0.5];
    [pageHotelBottomView addSubview:bottomItemBG];
    
    
    //价格范围
    ImageAndTextTilteView *priceRangeView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(bottomItemBG.frame.origin.x, bottomItemBG.frame.origin.y, bottomItemBG.frame.size.width, 40) withImageName:@"query_price" withLabelName:@"价格范围"];
    
    [pageHotelBottomView addSubview:priceRangeView];
    
    UIButton *priceRangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceRangeBtn setFrame:priceRangeView.frame];
    [priceRangeBtn setTag:504];
    [priceRangeBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pageHotelBottomView addSubview:priceRangeBtn];
    
    //LINE
    [pageHotelBottomView addSubview:[self createLineWithFrame:CGRectMake(topItemBG.frame.origin.x,controlYLength(priceRangeBtn),topItemBG.frame.size.width,1)]];
    
    //酒店位置
    ImageAndTextTilteView *hotelLoactionView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(bottomItemBG.frame.origin.x, bottomItemBG.frame.origin.y+40, bottomItemBG.frame.size.width, 40) withImageName:@"query_location" withLabelName:@"酒店位置"];
    
    UIButton *hotelLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [hotelLocationBtn setFrame:hotelLoactionView.frame];
    [hotelLocationBtn setTag:505];
    [hotelLocationBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pageHotelBottomView addSubview:hotelLocationBtn];
    
    [pageHotelBottomView addSubview:[self createLineWithFrame:
                                     CGRectMake(topItemBG.frame.origin.x,
                                                controlYLength(hotelLoactionView),
                                                topItemBG.frame.size.width,
                                                1)]];
    
    
    [pageHotelBottomView addSubview:hotelLoactionView];
    
    //酒店名称
    ImageAndTextTilteView *hotelNameView = [[ImageAndTextTilteView alloc] initWithFrame:CGRectMake(bottomItemBG.frame.origin.x, bottomItemBG.frame.origin.y+80, bottomItemBG.frame.size.width, 40) withImageName:@"query_location" withLabelName:@"酒店名称"];
    
    [pageHotelBottomView addSubview:hotelNameView];
    
    
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryBtn setImage:imageNameAndType(@"hotel_done_nromal", nil)
        highlightImage:imageNameAndType(@"hotel_done_press", nil)
              forState:ButtonImageStateBottom];
    [queryBtn setTitle:@"查询" forState:UIControlStateNormal];
    [queryBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    [queryBtn setFrame:CGRectMake(pageHotelBottomView.frame.size.width/6, controlYLength(bottomItemBG)+20, pageHotelBottomView.frame.size.width * 2/3 - 50, 45)];
    [queryBtn setTag:550];
    [queryBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
    [pageHotelBottomView addSubview:queryBtn];
    UIImageView *shakeImage = [[UIImageView alloc]initWithFrame:CGRectMake(queryBtn.frame.size.height/2, 0, queryBtn.frame.size.height, queryBtn.frame.size.height)];
    [shakeImage setImage:imageNameAndType(@"shake", nil)];
    [queryBtn addSubview:shakeImage];
    [shakeImage setBounds:CGRectMake(0, 0, shakeImage.frame.size.width * 0.7, shakeImage.frame.size.height * 0.7)];
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voiceBtn setFrame:CGRectMake(controlXLength(queryBtn) + 5, queryBtn.frame.origin.y, queryBtn.frame.size.height, queryBtn.frame.size.height)];
    [voiceBtn setTag:551];
    [voiceBtn setImage:imageNameAndType(@"voice_btn_normal", nil) highlightImage:imageNameAndType(@"voice_btn_press", nil) forState:ButtonImageStateBottom];
    [voiceBtn addTarget:self action:@selector(pressHotelItemBtn:) forControlEvents:UIControlEventTouchUpInside];
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

- (UIImageView *)createLineWithFrame:(CGRect)rect
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:rect];
    [line setBackgroundColor:color(lightGrayColor)];
    return line;
}

-(void)pressHotelItemBtn:(UIButton *)sender
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
