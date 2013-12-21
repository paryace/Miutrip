//
//  HotelOrderViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelOrderViewController.h"

@interface HotelOrderViewController ()

@end

@implementation HotelOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setUpChildView];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView{
    
    [self.contentView setBackgroundColor:UIColorFromRGB(0xffe9e9e9)];
    [self addTitleWithTitle:@"填写订单"];
    
    float width = self.contentView.frame.size.width;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40,width,600)];
    [self.contentView addSubview:scrollView];
    
    UIView *view  = [[UIView alloc] init];
    [scrollView addSubview:view];
    
    
    UILabel *infoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
    [infoTitle setTextColor:UIColorFromRGB(0xff606c97)];
    [infoTitle setFont:[UIFont systemFontOfSize:15]];
    [infoTitle setText:@"基本信息"];
    [view addSubview:infoTitle];
    

    UIImageView *introBgView = [[UIImageView alloc] init];
    [introBgView setFrame:CGRectMake(10, 25, width-20, 245)];
    [introBgView setBackgroundColor:color(whiteColor)];
    [introBgView setBorderColor:color(lightGrayColor) width:1.0];
    [introBgView setCornerRadius:5.0];
    [introBgView setAlpha:1.0f];
    [view addSubview:introBgView];
    
    UIView *hotelInfoView = [[UIView alloc] initWithFrame:CGRectMake(10, 25, width-20, 0)];
    [view addSubview:hotelInfoView];
    
    UILabel *hotelInfoTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 5, 100, 15)];
    [hotelInfoTitle setTextColor:color(grayColor)];
    [hotelInfoTitle setFont:[UIFont systemFontOfSize:10]];
    [hotelInfoTitle setText:@"酒店信息"];
    [hotelInfoView addSubview:hotelInfoTitle];
    
    //日期
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, width - 30, 20)];
    [date setFont:[UIFont systemFontOfSize:15]];
    [date setTextColor:color(blackColor)];
    [date setText:@"2013年12月23日-2013年12月25日"];
    [hotelInfoView addSubview:date];
    
    //酒店名称
    UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, width - 30, 18)];
    [hotelName setFont:[UIFont systemFontOfSize:14]];
    [hotelName setTextColor:color(grayColor)];
    [hotelName setText:@"上海航空酒店（浦东机场店）"];
    [hotelInfoView addSubview:hotelName];
    
    //房型
    UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(10, 58, width - 30, 18)];
    [roomName setFont:[UIFont systemFontOfSize:14]];
    [roomName setTextColor:color(grayColor)];
    [roomName setText:@"豪华大床房"];
    [hotelInfoView addSubview:roomName];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 78, width-20, 1)];
    [line1  setBackgroundColor:color(lightGrayColor)];
    [hotelInfoView addSubview:line1];
    
    UILabel *executorTitle = [[UILabel alloc] initWithFrame:CGRectMake(6, 80, 100, 15)];
    [executorTitle setTextColor:color(grayColor)];
    [executorTitle setFont:[UIFont systemFontOfSize:10]];
    [executorTitle setText:@"政策执行人"];
    [hotelInfoView addSubview:executorTitle];
    
    //政策执行人
    UILabel *executor = [[UILabel alloc] initWithFrame:CGRectMake(10, 96, width - 30, 18)];
    [executor setTextColor:color(blackColor)];
    [executor setFont:[UIFont systemFontOfSize:14]];
    [executor setText:@"张三男"];
    [hotelInfoView addSubview:executor];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 120, width-20, 1)];
    [line2 setBackgroundColor:color(lightGrayColor)];
    [hotelInfoView addSubview:line2];
    
    //入住人手机
    UILabel *mobileTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 123, 86, 40)];
    [mobileTitle setTextColor:color(blackColor)];
    [mobileTitle setFont:[UIFont systemFontOfSize:13]];
    [mobileTitle setTextAlignment:NSTextAlignmentCenter];
    [mobileTitle setText:@"入住人手机"];
    [hotelInfoView addSubview:mobileTitle];
    
    UILabel *star1 = [[UILabel alloc] initWithFrame:CGRectMake(81, 123, 10, 40)];
    [star1 setTextColor:color(redColor)];
    [star1 setFont:[UIFont systemFontOfSize:13]];
    [star1 setText:@"*"];
    [hotelInfoView addSubview:star1];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(100, 121, 1, 42)];
    [line3 setBackgroundColor:color(lightGrayColor)];
    [hotelInfoView addSubview:line3];
    
    UITextField *customerMobile = [[UITextField alloc] initWithFrame:CGRectMake(105, 124, width - 130, 34)];
    [customerMobile setTextColor:color(blackColor)];
    [customerMobile setBorderStyle:UITextBorderStyleRoundedRect];
    [customerMobile setFont:[UIFont systemFontOfSize:14]];
    [hotelInfoView addSubview:customerMobile];
    
    //到点时间
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 163, width - 20, 1)];
    [line4 setBackgroundColor:color(grayColor)];
    [hotelInfoView addSubview:line4];
    
    UILabel *arriveTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 164, 86, 40)];
    [arriveTimeTitle setTextColor:color(blackColor)];
    [arriveTimeTitle setFont:[UIFont systemFontOfSize:13]];
    [arriveTimeTitle setTextAlignment:NSTextAlignmentCenter];
    [arriveTimeTitle setText:@"到店时间"];
    [hotelInfoView addSubview:arriveTimeTitle];
    
    UILabel *star2 = [[UILabel alloc] initWithFrame:CGRectMake(81, 164, 10, 40)];
    [star2 setTextColor:color(redColor)];
    [star2 setFont:[UIFont systemFontOfSize:13]];
    [star2 setText:@"*"];
    [hotelInfoView addSubview:star2];
    
    UILabel *arriveTime = [[UILabel alloc] initWithFrame:CGRectMake(100, 164, width - 140, 40)];
    [arriveTime setTextColor:color(blackColor)];
    [arriveTime setFont:[UIFont systemFontOfSize:14]];
    [hotelInfoView addSubview:arriveTime];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow1 setFrame:CGRectMake(width - 38, 171, 12, 18)];
    [hotelInfoView addSubview:arrow1];
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(0, 203, width - 20, 1)];
    [line5 setBackgroundColor:color(lightGrayColor)];
    [hotelInfoView addSubview:line5];
    
    //房间数量
    UILabel *roomCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 204, 86, 40)];
    [roomCountTitle setTextColor:color(blackColor)];
    [roomCountTitle setFont:[UIFont systemFontOfSize:13]];
    [roomCountTitle setTextAlignment:NSTextAlignmentCenter];
    [roomCountTitle setText:@"房间数量"];
    [hotelInfoView addSubview:roomCountTitle];
    
    UILabel *star3 = [[UILabel alloc] initWithFrame:CGRectMake(81, 204, 10, 40)];
    [star3 setTextColor:color(redColor)];
    [star3 setFont:[UIFont systemFontOfSize:13]];
    [star3 setText:@"*"];
    [hotelInfoView addSubview:star3];
    
    UILabel *roomCount = [[UILabel alloc] initWithFrame:CGRectMake(100, 204, width - 140, 34)];
    [roomCount setTextColor:color(blackColor)];
    [roomCount setFont:[UIFont systemFontOfSize:14]];
    [hotelInfoView addSubview:roomCount];
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow2 setFrame:CGRectMake(width - 38, 215, 12, 18)];
    [hotelInfoView addSubview:arrow2];
    
    //费用结算
    UILabel *costTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 275, 150, 18)];
    [costTitle setTextColor:UIColorFromRGB(0xff606c97)];
    [costTitle setFont:[UIFont systemFontOfSize:15]];
    [costTitle setText:@"费用结算"];
    [view addSubview:costTitle];
    
    UIImageView *costBg = [[UIImageView alloc] init];
    [costBg setFrame:CGRectMake(10, 298, width-20, 115)];
    [costBg setBackgroundColor:color(whiteColor)];
    [costBg setBorderColor:color(lightGrayColor) width:1.0];
    [costBg setCornerRadius:5.0];
    [costBg setAlpha:1.0f];
    [view addSubview:costBg];
    
    UIView *costView = [[UIView alloc] initWithFrame:CGRectMake(10, 298, width-20, 0)];
    [view addSubview:costView];

    UILabel *orderAmount = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    [orderAmount setFont:[UIFont systemFontOfSize:13]];
    [orderAmount setTextColor:color(grayColor)];
    [orderAmount setText:@"订单总额："];
    [costView addSubview:orderAmount];
    
    UIColor *costBgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_hotel_cost.png"]];
    UIView *consumerTitle = [[UIView alloc] initWithFrame:CGRectMake(1,30,width-22,35)];
    [consumerTitle setBackgroundColor:costBgColor];
    [costView addSubview:consumerTitle];

    UILabel *consumerNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (width-20)/3, 35)];
    [consumerNameTitle setFont:[UIFont systemFontOfSize:12]];
    [consumerNameTitle setTextAlignment:NSTextAlignmentCenter];
    [consumerNameTitle setTextColor:color(whiteColor)];
    [consumerNameTitle setText:@"入住人"];
    [consumerTitle addSubview:consumerNameTitle];
    
    UILabel *costCenterTitle = [[UILabel alloc] initWithFrame:CGRectMake((width-20)/3, 0, (width-20)/3, 35)];
    [costCenterTitle setFont:[UIFont systemFontOfSize:12]];
    [costCenterTitle setTextColor:color(whiteColor)];
    [costCenterTitle setTextAlignment:NSTextAlignmentCenter];
    [costCenterTitle setText:@"成本中心"];
    [consumerTitle addSubview:costCenterTitle];
    
    UILabel *costApportionTitle = [[UILabel alloc] initWithFrame:CGRectMake((width-20)/3*2, 0, (width-20)/3, 35)];
    [costApportionTitle setFont:[UIFont systemFontOfSize:12]];
    [costApportionTitle setTextColor:color(whiteColor)];
    [costApportionTitle setTextAlignment:NSTextAlignmentCenter];
    [costApportionTitle setText:@"费用分摊"];
    [consumerTitle addSubview:costApportionTitle];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 75, width - 22, 40)];
    [costView addSubview:tableView];
    
    
    //填写联系人
    UILabel *contactorTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 420, 150, 18)];
    [contactorTitle setTextColor:UIColorFromRGB(0xff606c97)];
    [contactorTitle setFont:[UIFont systemFontOfSize:15]];
    [contactorTitle setText:@"填写联系人"];
    [view addSubview:contactorTitle];
    
    UIImageView *contactorBg = [[UIImageView alloc] init];
    [contactorBg setFrame:CGRectMake(10, 440, width-20, 81)];
    [contactorBg setBackgroundColor:color(whiteColor)];
    [contactorBg setBorderColor:color(lightGrayColor) width:1.0];
    [contactorBg setCornerRadius:5.0];
    [contactorBg setAlpha:1.0f];
    [view addSubview:contactorBg];
    
    
    UIView *contactorView = [[UIView alloc] initWithFrame:CGRectMake(10, 440, width-20, 81)];
    [view addSubview:contactorView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [nameLabel setTextColor:color(grayColor)];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setText:@"姓名"];
    [contactorView addSubview:nameLabel];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 60, 40)];
    [mobileLabel setTextColor:color(grayColor)];
    [mobileLabel setFont:[UIFont systemFontOfSize:13]];
    [mobileLabel setTextAlignment:NSTextAlignmentCenter];
    [mobileLabel setText:@"手机"];
    [contactorView addSubview:mobileLabel];
    
    UIView *lin6 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, width-20, 1)];
    [lin6 setBackgroundColor:color(lightGrayColor)];
    [contactorView addSubview:lin6];
    
    UIView *lin7 = [[UIView alloc] initWithFrame:CGRectMake(60, 1, 1, 80)];
    [lin7 setBackgroundColor:color(lightGrayColor)];
    [contactorView addSubview:lin7];
    
    UIView *lin8 = [[UIView alloc] initWithFrame:CGRectMake(width - 60, 1, 1, 80)];
    [lin8 setBackgroundColor:color(lightGrayColor)];
    [contactorView addSubview:lin8];
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(65, 3, width - 130, 34)];
    [nameText setBorderStyle:UITextBorderStyleRoundedRect];
    [contactorView addSubview:nameText];
    
    UITextField *mobileText = [[UITextField alloc] initWithFrame:CGRectMake(65, 44, width - 130, 34)];
    [mobileText setBorderStyle:UITextBorderStyleRoundedRect];
    [contactorView addSubview:mobileText];
    
    
    UIButton *submitOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitOrderBtn setBackgroundImage:[UIImage imageNamed:@"done_btn_normal.png"] forState:UIControlStateNormal];
    [submitOrderBtn setBackgroundImage:[UIImage imageNamed:@"done_btn_press.png"] forState:UIControlStateHighlighted];
    [submitOrderBtn setTitleColor:color(whiteColor) forState:UIControlStateNormal];
    [submitOrderBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [submitOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitOrderBtn setFrame:CGRectMake(80, 535, width-80*2, 40)];
    [view addSubview:submitOrderBtn];
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
