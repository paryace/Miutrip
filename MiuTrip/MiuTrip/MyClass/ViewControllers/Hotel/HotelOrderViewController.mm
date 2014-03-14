//
//  HotelOrderViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-21.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelOrderViewController.h"
#import "HotelDataCache.h"
#import "HotelCustomerModel.h"
#import "GetContactRequest.h"
#import "GetContactResponse.h"
#import "SubmitOrderRequest.h"
#import "Utils.h"
#import "SubmitOrderResponse.h"

#define KBtn_width        200
#define KBtn_height       80
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          80

#define kVCTitle          @"TN测试"
#define kBtnFirstTitle    @"新控件测试"
#define kBtnSecondTitle   @"老控件测试"
#define kWaiting          @"正在获取TN,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"


#define kMode             @"01"
#define kConfigTnUrl      @"http://222.66.233.198:8080/sim/app.jsp?user=%@"
#define kNormalTnUrl      @"http://222.66.233.198:8080/sim/gettn"


@interface HotelOrderViewController ()

@end

@implementation HotelOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initParams];
        [self initView];
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        [self initParams];
        [self initView];
    }
    return self;
}

-(void)initParams{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i=0;i<=23;i++){
        [array addObject:[NSString stringWithFormat:@"%d:00",i]];
    }
    _arriveTimeArray = array;
    
    HotelDataCache *data = [HotelDataCache sharedInstance];
    
    NSArray *pricePolicies = [data.selectedRoomData objectForKey:@"PricePolicies"];
    NSDictionary *priceDic = [pricePolicies objectAtIndex:0];
    NSArray *priceInfos = [priceDic objectForKey:@"PriceInfos"];
    NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
    _roomPrice = [[roomPriceDic objectForKey:@"SalePrice"]intValue];
    
    data.arriveTime = @"18:00";
    
    NSMutableArray *customers = data.customers;
    if(!customers){
        data.customers = [[NSMutableArray alloc] init];
    }
    
    if(data.isForSelf){
        HotelCustomerModel *customer = [[HotelCustomerModel alloc] init];
        customer.name = [UserDefaults shareUserDefault].loginInfo.UserName;
        customer.UID = [UserDefaults shareUserDefault].loginInfo.UID;
        customer.passengerId = [UserDefaults shareUserDefault].loginInfo.UID;
        customer.corpUID = [NSString stringWithFormat:@"%@",[UserDefaults shareUserDefault].loginInfo.CorpID];
        customer.apportionRate = 1;
        [customers addObject:customer];
        
        data.contactorId = [[UserDefaults shareUserDefault].loginInfo.UID intValue];
        data.contactorMobile = [UserDefaults shareUserDefault].loginInfo.Mobilephone;
        data.contactorName = [UserDefaults shareUserDefault].loginInfo.UserName;
        
        data.roomCount = 1;
        data.guestMobile = [UserDefaults shareUserDefault].loginInfo.Mobilephone;
        
        data.executor = customer;
    }else{
        data.roomCount = data.customers.count;
    }
}

-(void) initView{
    [self.contentView setBackgroundColor:UIColorFromRGB(0xffe9e9e9)];
    [self addTitleWithTitle:@"填写订单" withRightView:nil];
    [self addLoadingView];
    [self getContacts];
}

- (void)addChildView{
    
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height - 78;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40,width,height)];
    scrollView.tag = 1000;
    scrollView.delaysContentTouches = NO;
    [self.view addSubview:scrollView];
    
    
    UILabel *infoTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
    [infoTitle setBackgroundColor:color(clearColor)];
    [infoTitle setTextColor:UIColorFromRGB(0xff606c97)];
    [infoTitle setFont:[UIFont systemFontOfSize:15]];
    [infoTitle setText:@"基本信息"];
    [scrollView addSubview:infoTitle];
    

    UIImageView *introBgView = [[UIImageView alloc] init];
    [introBgView setFrame:CGRectMake(10, 25, width-20, 245)];
    [introBgView setBackgroundColor:color(whiteColor)];
    [introBgView setBorderColor:color(lightGrayColor) width:1.0];
    [introBgView setCornerRadius:5.0];
    [introBgView setAlpha:1.0f];
    [scrollView addSubview:introBgView];
    
    
    UILabel *hotelInfoTitle = [[UILabel alloc] initWithFrame:CGRectMake(20,30, 100, 15)];
    [hotelInfoTitle setTextColor:color(grayColor)];
    [hotelInfoTitle setBackgroundColor:color(clearColor)];
    [hotelInfoTitle setFont:[UIFont systemFontOfSize:10]];
    [hotelInfoTitle setText:@"酒店信息"];
    [scrollView addSubview:hotelInfoTitle];
    
    HotelDataCache *data = [HotelDataCache sharedInstance];
    
    //日期
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, width - 30, 20)];
    [date setBackgroundColor:color(clearColor)];
    [date setFont:[UIFont systemFontOfSize:15]];
    [date setTextColor:color(blackColor)];
    NSString *checkInDateString = [NSString stringWithFormat:@"%@",[Utils stringWithDate:data.checkInDate withFormat:@"YYYY年MM月dd日"]];
    NSString *checkOutDateString = [NSString stringWithFormat:@"%@",[Utils stringWithDate:data.checkOutDate withFormat:@"YYYY年MM月dd日"]];
    [date setText:[NSString stringWithFormat:@"%@ - %@",checkInDateString,checkOutDateString]];
    [scrollView addSubview:date];
    
    //酒店名称
    UILabel *hotelName = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, width - 30, 18)];
    [hotelName setBackgroundColor:color(clearColor)];
    [hotelName setFont:[UIFont systemFontOfSize:14]];
    [hotelName setTextColor:color(grayColor)];
    [hotelName setText:data.selectedHotelName];
    [scrollView addSubview:hotelName];
    
    //房型
    UILabel *roomName = [[UILabel alloc] initWithFrame:CGRectMake(20, 83, width - 30, 18)];
    [roomName setBackgroundColor:color(clearColor)];
    [roomName setFont:[UIFont systemFontOfSize:14]];
    [roomName setTextColor:color(grayColor)];
    [roomName setText:[data.selectedRoomData objectForKey:@"roomName"]];
    [scrollView addSubview:roomName];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(10, 103, width-20, 1)];
    [line1  setBackgroundColor:color(lightGrayColor)];
    [scrollView addSubview:line1];
    
    float y = 105;
    int firstSectionHeight = 245;
    
    if(data.isPrivte == NO){
        
        //政策执行人
        UILabel *executorTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 100, 15)];
        [executorTitle setBackgroundColor:color(clearColor)];
        [executorTitle setTextColor:color(grayColor)];
        [executorTitle setFont:[UIFont systemFontOfSize:10]];
        [executorTitle setText:@"政策执行人"];
        [scrollView addSubview:executorTitle];
        
        UILabel *executor = [[UILabel alloc] initWithFrame:CGRectMake(20, y+16, width - 30, 18)];
        [executor setBackgroundColor:color(clearColor)];
        [executor setTextColor:color(blackColor)];
        [executor setFont:[UIFont systemFontOfSize:14]];
        [executor setText:data.executor.name];
        [scrollView addSubview:executor];
        
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(10, y+40, width-20, 1)];
        [line2 setBackgroundColor:color(lightGrayColor)];
        [scrollView addSubview:line2];
        
        y += 40;
    }else{
        firstSectionHeight -= 40;
    }
    
    [introBgView setFrame:CGRectMake(10, 25, width-20, firstSectionHeight)];
   
    
    //入住人手机
    UILabel *mobileTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, y+3, 70, 40)];
    [mobileTitle setBackgroundColor:color(clearColor)];
    [mobileTitle setTextColor:color(blackColor)];
    [mobileTitle setFont:[UIFont systemFontOfSize:13]];
    [mobileTitle setTextAlignment:NSTextAlignmentCenter];
    [mobileTitle setText:@"入住人手机"];
    [scrollView addSubview:mobileTitle];
    
    UILabel *star1 = [[UILabel alloc] initWithFrame:CGRectMake(88, y+3, 10, 40)];
    [star1 setBackgroundColor:color(clearColor)];
    [star1 setTextColor:color(redColor)];
    [star1 setFont:[UIFont systemFontOfSize:13]];
    [star1 setText:@"*"];
    [scrollView addSubview:star1];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(100, y+1, 1, 42)];
    [line3 setBackgroundColor:color(lightGrayColor)];
    [scrollView addSubview:line3];
    
    UITextField *customerMobile = [[UITextField alloc] initWithFrame:CGRectMake(105, y+4, width - 130, 34)];
    [customerMobile setTextColor:color(blackColor)];
    [customerMobile setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [customerMobile setBorderStyle:UITextBorderStyleRoundedRect];
    [customerMobile setFont:[UIFont systemFontOfSize:14]];
    [scrollView addSubview:customerMobile];
    
    y += 40;
    
    //到店时间
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(11, y+3, width - 22, 1)];
    [line4 setBackgroundColor:color(grayColor)];
    [scrollView addSubview:line4];
    
    UILabel *arriveTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, y+4, 60, 40)];
    [arriveTimeTitle setBackgroundColor:color(clearColor)];
    [arriveTimeTitle setTextColor:color(blackColor)];
    [arriveTimeTitle setFont:[UIFont systemFontOfSize:13]];
    [arriveTimeTitle setTextAlignment:NSTextAlignmentCenter];
    [arriveTimeTitle setText:@"到店时间"];
    [scrollView addSubview:arriveTimeTitle];
    
    UILabel *star2 = [[UILabel alloc] initWithFrame:CGRectMake(75, y+4, 10, 40)];
    [star2 setTextColor:color(redColor)];
    [star2 setBackgroundColor:color(clearColor)];
    [star2 setFont:[UIFont systemFontOfSize:13]];
    [star2 setText:@"*"];
    [scrollView addSubview:star2];
    
    UILabel *arriveTime = [[UILabel alloc] initWithFrame:CGRectMake(110, y+4, width - 140, 40)];
    [arriveTime setTextColor:color(blackColor)];
    [arriveTime setBackgroundColor:color(clearColor)];
    [arriveTime setFont:[UIFont systemFontOfSize:14]];
    [arriveTime setTextAlignment:NSTextAlignmentCenter];
    [arriveTime setText:data.arriveTime];
    [scrollView addSubview:arriveTime];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow1 setFrame:CGRectMake(width - 28, y+15, 12, 18)];
    [scrollView addSubview:arrow1];
    
    UIButton *arriveTimebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arriveTimebtn setFrame:CGRectMake(0, y+3, width-20, 40)];
    arriveTimebtn.tag = 1001;
    [arriveTimebtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:arriveTimebtn];
    
    y += 40;
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(11, y+3, width - 22, 1)];
    [line5 setBackgroundColor:color(lightGrayColor)];
    [scrollView addSubview:line5];
    
    //房间数量
    UILabel *roomCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, y+4, 60, 40)];
    [roomCountTitle setBackgroundColor:color(clearColor)];
    [roomCountTitle setTextColor:color(blackColor)];
    [roomCountTitle setFont:[UIFont systemFontOfSize:13]];
    [roomCountTitle setTextAlignment:NSTextAlignmentCenter];
    [roomCountTitle setText:@"房间数量"];
    [scrollView addSubview:roomCountTitle];
    
    UILabel *star3 = [[UILabel alloc] initWithFrame:CGRectMake(75, y+4, 10, 40)];
    [star3 setTextColor:color(redColor)];
    [star3 setBackgroundColor:color(clearColor)];
    [star3 setFont:[UIFont systemFontOfSize:13]];
    [star3 setText:@"*"];
    [scrollView addSubview:star3];
    
    UILabel *roomCount = [[UILabel alloc] initWithFrame:CGRectMake(100, y+4, width - 140, 34)];
    [roomCount setTextColor:color(blackColor)];
    [roomCount setBackgroundColor:color(clearColor)];
    [roomCount setFont:[UIFont systemFontOfSize:14]];
    [roomCount setTextAlignment:NSTextAlignmentCenter];
    [roomCount setText:[NSString stringWithFormat:@"%d间",data.roomCount]];
    [scrollView addSubview:roomCount];
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow2 setFrame:CGRectMake(width - 28, y+15, 12, 18)];
    [scrollView addSubview:arrow2];
    
    UIButton *roomCountbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, y+3, width - 20, 40)];
    roomCountbtn.tag = 1002;
    [roomCountbtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:roomCountbtn];
    
    y += 60;
    
    //费用结算
    UILabel *costTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, y+15, 150, 18)];
    [costTitle setBackgroundColor:color(clearColor)];
    [costTitle setTextColor:UIColorFromRGB(0xff606c97)];
    [costTitle setFont:[UIFont systemFontOfSize:15]];
    [costTitle setText:@"费用结算"];
    [scrollView addSubview:costTitle];
    
    int tableHeight = 40*data.customers.count;
    UIImageView *costBg = [[UIImageView alloc] init];
    [costBg setFrame:CGRectMake(10, y+38, width-20, tableHeight+85)];
    [costBg setBackgroundColor:color(whiteColor)];
    [costBg setBorderColor:color(lightGrayColor) width:1.0];
    [costBg setCornerRadius:5.0];
    [costBg setAlpha:1.0f];
    [scrollView addSubview:costBg];
    
    UIView *costView = [[UIView alloc] initWithFrame:CGRectMake(10, y+40, width-20, 0)];
    [scrollView addSubview:costView];

    UILabel *orderAmount = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    [orderAmount setBackgroundColor:color(clearColor)];
    [orderAmount setFont:[UIFont systemFontOfSize:13]];
    [orderAmount setAutoSize:YES];
    [orderAmount setTextColor:color(grayColor)];
    
    NSString *orderAmountText = [NSString stringWithFormat:@"订单总额：￥%d",_roomPrice];
    [orderAmount setText:orderAmountText];
    [costView addSubview:orderAmount];
    
    if (!data.isForSelf) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setFrame:CGRectMake(controlXLength(orderAmount) + 10, orderAmount.frame.origin.y, (costView.frame.size.width - controlXLength(orderAmount) - 10 - orderAmount.frame.origin.x/2)/3, orderAmount.frame.size.height)];
        [addBtn setBackgroundImage:imageNameAndType(@"flight_btn_bg", nil) forState:UIControlStateNormal];
        [addBtn setBackgroundImage:imageNameAndType(@"flight_btn_selected", nil) forState:UIControlStateHighlighted];
        [addBtn setTitle:@"选择" forState:UIControlStateNormal];
        [addBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [addBtn setTag:500];
        [addBtn addTarget:self action:@selector(pressEditCustomersBtn:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
        [costView addSubview:addBtn];
        
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [editBtn setFrame:CGRectMake(controlXLength(addBtn), addBtn.frame.origin.y, addBtn.frame.size.width, addBtn.frame.size.height)];
        [editBtn setBackgroundImage:imageNameAndType(@"flight_btn_bg", nil) forState:UIControlStateNormal];
        [editBtn setBackgroundImage:imageNameAndType(@"flight_btn_selected", nil) forState:UIControlStateHighlighted];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [editBtn addTarget:self action:@selector(pressEditCustomersBtn:) forControlEvents:UIControlEventTouchUpInside];
        [editBtn setTag:501];
        [editBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
        [costView addSubview:editBtn];
        
        UIButton *newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [newBtn setFrame:CGRectMake(controlXLength(editBtn), editBtn.frame.origin.y, editBtn.frame.size.width, editBtn.frame.size.height)];
        [newBtn setBackgroundImage:imageNameAndType(@"flight_btn_bg", nil) forState:UIControlStateNormal];
        [newBtn setBackgroundImage:imageNameAndType(@"flight_btn_selected", nil) forState:UIControlStateHighlighted];
        [newBtn setTitle:@"新增" forState:UIControlStateNormal];
        [newBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [newBtn setTag:502];
        [newBtn addTarget:self action:@selector(pressEditCustomersBtn:) forControlEvents:UIControlEventTouchUpInside];
        [newBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
        [costView addSubview:newBtn];
    }
    
    UIColor *costBgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg_hotel_cost.png"]];
    UIView *consumerTitle = [[UIView alloc] initWithFrame:CGRectMake(1,30,width-22,35)];
    [consumerTitle setBackgroundColor:costBgColor];
    [costView addSubview:consumerTitle];

    UILabel *consumerNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (width-20)/4, 35)];
    [consumerNameTitle setBackgroundColor:color(clearColor)];
    [consumerNameTitle setFont:[UIFont systemFontOfSize:12]];
    [consumerNameTitle setTextAlignment:NSTextAlignmentCenter];
    [consumerNameTitle setTextColor:color(whiteColor)];
    [consumerNameTitle setText:@"入住人"];
    [consumerTitle addSubview:consumerNameTitle];
    
    UILabel *costCenterTitle = [[UILabel alloc] initWithFrame:CGRectMake((width-20)/4, 0, (width-20)/4, 35)];
    [costCenterTitle setBackgroundColor:color(clearColor)];
    [costCenterTitle setFont:[UIFont systemFontOfSize:12]];
    [costCenterTitle setTextColor:color(whiteColor)];
    [costCenterTitle setTextAlignment:NSTextAlignmentCenter];
    [costCenterTitle setText:@"成本中心"];
    [consumerTitle addSubview:costCenterTitle];
    
    UILabel *costApportionTitle = [[UILabel alloc] initWithFrame:CGRectMake((width-20)/4*2, 0, (width-20)-(width-20)/4*2, 35)];
    [costApportionTitle setBackgroundColor:color(clearColor)];
    [costApportionTitle setFont:[UIFont systemFontOfSize:12]];
    [costApportionTitle setTextColor:color(whiteColor)];
    [costApportionTitle setTextAlignment:NSTextAlignmentCenter];
    [costApportionTitle setText:@"费用分摊"];
    [consumerTitle addSubview:costApportionTitle];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 75, width - 22, tableHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [costView addSubview:tableView];
    
    [costView setFrame:CGRectMake(costView.frame.origin.x, costView.frame.origin.y, costView.frame.size.width, controlYLength(tableView))];
    
    y += 125+tableHeight;
    
    //填写联系人
    UILabel *contactorTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, y+5, 150, 18)];
    [contactorTitle setBackgroundColor:color(clearColor)];
    [contactorTitle setTextColor:UIColorFromRGB(0xff606c97)];
    [contactorTitle setFont:[UIFont systemFontOfSize:15]];
    [contactorTitle setText:@"填写联系人"];
    [scrollView addSubview:contactorTitle];
    
    UIImageView *contactorBg = [[UIImageView alloc] init];
    [contactorBg setFrame:CGRectMake(10, y+30, width-20, 81)];
    [contactorBg setBackgroundColor:color(whiteColor)];
    [contactorBg setBorderColor:color(lightGrayColor) width:1.0];
    [contactorBg setCornerRadius:5.0];
    [contactorBg setAlpha:1.0f];
    [scrollView addSubview:contactorBg];
    
    
    UIView *contactorView = [[UIView alloc] initWithFrame:CGRectMake(10, y+31, width-20, 81)];
    [scrollView addSubview:contactorView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    [nameLabel setBackgroundColor:color(clearColor)];
    [nameLabel setTextColor:color(grayColor)];
    [nameLabel setFont:[UIFont systemFontOfSize:13]];
    [nameLabel setTextAlignment:NSTextAlignmentCenter];
    [nameLabel setText:@"姓名"];
    [contactorView addSubview:nameLabel];
    
    UILabel *mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 60, 40)];
    [mobileLabel setBackgroundColor:color(clearColor)];
    [mobileLabel setTextColor:color(grayColor)];
    [mobileLabel setFont:[UIFont systemFontOfSize:13]];
    [mobileLabel setTextAlignment:NSTextAlignmentCenter];
    [mobileLabel setText:@"手机"];
    [contactorView addSubview:mobileLabel];
    
    UIView *lin6 = [[UIView alloc] initWithFrame:CGRectMake(0, 40, width-60, 1)];
    [lin6 setBackgroundColor:color(lightGrayColor)];
    [contactorView addSubview:lin6];
    
    UIView *lin7 = [[UIView alloc] initWithFrame:CGRectMake(60, 0, 1, 80)];
    [lin7 setBackgroundColor:color(lightGrayColor)];
    [contactorView addSubview:lin7];
    
    UIView *lin8 = [[UIView alloc] initWithFrame:CGRectMake(width - 60, 0, 1, 80)];
    [lin8 setBackgroundColor:color(lightGrayColor)];
    [contactorView addSubview:lin8];
    
    UITextField *nameText = [[UITextField alloc] initWithFrame:CGRectMake(65, 3, width - 130, 34)];
    [nameText setBorderStyle:UITextBorderStyleRoundedRect];
    [nameText setTextColor:color(blackColor)];
    [nameText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [nameText setFont:[UIFont systemFontOfSize:13]];
    [nameText setText:[UserDefaults shareUserDefault].loginInfo.UserName];
    [contactorView addSubview:nameText];
    
    UITextField *mobileText = [[UITextField alloc] initWithFrame:CGRectMake(65, 44, width - 130, 34)];
    [mobileText setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileText setTextColor:color(blackColor)];
    [mobileText setFont:[UIFont systemFontOfSize:13]];
    [mobileText setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [mobileText setText:[UserDefaults shareUserDefault].loginInfo.Mobilephone];
    [contactorView addSubview:mobileText];
    
    UIImageView *arrow6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow6 setFrame:CGRectMake(width - 46, 32, 12, 18)];
    [contactorView addSubview:arrow6];
    
    UIButton *contactBtn = [[UIButton alloc] initWithFrame:CGRectMake(width-60, y+31, 40, 81)];
    contactBtn.tag = 1003;
    [contactBtn addTarget:self action:@selector(onBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:contactBtn];
    
    
    UIButton *submitOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitOrderBtn setBackgroundImage:[UIImage imageNamed:@"done_btn_normal.png"] forState:UIControlStateNormal];
    [submitOrderBtn setBackgroundImage:[UIImage imageNamed:@"done_btn_press.png"] forState:UIControlStateHighlighted];
    [submitOrderBtn setTitleColor:color(whiteColor) forState:UIControlStateNormal];
    [submitOrderBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [submitOrderBtn setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitOrderBtn setFrame:CGRectMake(80, y+130, width-80*2, 40)];
    [submitOrderBtn addTarget:self action:@selector(userPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:submitOrderBtn];
    
    scrollView.contentSize = CGSizeMake(width,  y+200);

}

#pragma mark - customers edit handle
- (void)pressEditCustomersBtn:(UIButton*)sender
{
    switch (sender.tag) {
        case 500:{
            PassengerListViewController *passengerListView = [[PassengerListViewController alloc]init];
            [passengerListView setDelegate:self];
            [self pushViewController:passengerListView transitionType:TransitionPush completionHandler:^{
                
            }];
            break;
        }case 501:{
            
            break;
        }case 502:{
            
            break;
        }
        default:
            break;
    }
}

- (void)selectDone:(NSMutableArray*)array
{
    
}

-(void)onBtnPressed:(UIButton*)sender{
    int tag = sender.tag;
    switch(tag){
        case 1001:
            [self showPopupListWithTitle:@"到店时间" withType:0 withData:_arriveTimeArray];
            break;
        case 1002:
            [self showRoomCountPopView];
            break;
        case 1003:
            [self showPopupListWithTitle:@"选择联系人" withType:2 withData:_contactorArray];
            break;
    }
}

#pragma mark - request handle

-(void)requestDone:(BaseResponseModel*)response
{
    if([response isKindOfClass:[GetContactResponse class]]){
        GetContactResponse *contactResponse = (GetContactResponse*)response;
        _contactorArray = contactResponse.result;
        [self removeLoadingView];
        [self addChildView];
    }else if([response isKindOfClass:[SubmitOrderResponse class]]){
//        SubmitOrderResponse *orderResponse = (SubmitOrderResponse*)response;
    }
}

-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg{
    NSLog(@"%@",errorMsg);
}


-(void) getContacts
{
    GetContactRequest *request = [[GetContactRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    request.CorpID = [UserDefaults shareUserDefault].loginInfo.CorpID;
    [self.requestManager sendRequest:request];
}


-(void)showRoomCountPopView{
    NSArray *customers = [HotelDataCache sharedInstance].customers;
    NSMutableArray *objects = [NSMutableArray array];
    for ( int i = 0; i<[customers count]; i++) {
        NSString *str = [NSString stringWithFormat:@"%d间",i + 1];
        [objects addObject:str];
    }
    [self showPopupListWithTitle:@"房间数量" withType:0 withData:objects];
}

-(void)submitOrder{
    
    SubmitOrderRequest *request = [[SubmitOrderRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"SubmitOrder"];
    
    HotelDataCache *data = [HotelDataCache sharedInstance];
    
    if(data.isPrivte){
        request.FeeType = [NSNumber numberWithInt:2];
        request.ReasonCode = @"";
        request.CcIndex = [NSNumber numberWithInt:0];
        request.CcValue  = @"";
        request.ReserveType = [NSNumber numberWithInt:0];
    }else{
        request.FeeType = [NSNumber numberWithInt:1];
        if(data.isForSelf){
            request.ReserveType = [NSNumber numberWithInt:1];
        }else{
            request.ReserveType = [NSNumber numberWithInt:2];
        }
        if(!data.executor){
            return;
        }
        NSString *uid = data.executor.corpUID;
        if([Utils textIsEmpty:uid]){
            request.PolicyUid = data.executor.UID;
        }else{
            request.PolicyUid = uid;
        }
        request.ReasonCode = data.selectedReasonCode;
        request.CcIndex = [NSNumber numberWithInt:1];
        NSArray *cutomers =  data.customers;
        HotelCustomerModel *customer = [cutomers objectAtIndex:0];
        if(customer){
            NSString *costCenter = customer.costCenter;
            if([Utils textIsEmpty:costCenter]){
                request.ccValue = @"";
            }else{
                request.ccValue = costCenter;
            }
        }else{
            request.ccValue = @"";
        }

    }
    
    request.CityId = [NSNumber numberWithInt:data.checkInCityId];
    request.HotelID = [NSNumber numberWithInt:data.selectedHotelId];
    request.RoomOTAType = [NSNumber numberWithInt:[[data.selectedRoomData objectForKey:@"RoomOTAType"] intValue]];
    request.RoomTypeID = [NSNumber numberWithInt:[[data.selectedRoomData objectForKey:@"roomTypeId"] intValue]];
    NSArray *pricePolicies = [data.selectedRoomData objectForKey:@"PricePolicies"];
    NSDictionary *policies = [pricePolicies objectAtIndex:0];
    request.OTAType = [NSNumber numberWithInt:[[policies objectForKey:@"OTAType"] intValue]];
    request.OTAPolicyID = [NSNumber numberWithInt:[[policies objectForKey:@"OTAPolicyID"]intValue]];
    
    request.ComeDate = [Utils stringWithDate:data.checkInDate withFormat:@"yyyy-MM-dd"];
    request.LeaveDate = [Utils stringWithDate:data.checkOutDate withFormat:@"yyyy-MM-dd"];
    request.ArriveTime = data.arriveTime;
    
    request.Remarks = @"";
    request.RoomNumber = [NSNumber numberWithInt:1];
    request.GuestMobile = data.guestMobile;

    request.ContactID = [NSNumber numberWithInt:data.contactorId];
    request.ContactName = data.contactorMobile;
    request.ContactMobile = data.contactorMobile;
    
    NSArray *priceInfos = [policies objectForKey:@"PriceInfos"];
    NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
    int roomPrice = [[roomPriceDic objectForKey:@"SalePrice"] intValue];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(HotelCustomerModel *customer in data.customers){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:customer.passengerId forKey:@"PID"];
        [dic setObject:customer.corpUID forKey:@"UID"];
        [dic setObject:customer.name forKey:@"UserName"];
        [dic setObject:[NSString stringWithFormat:@"%f",roomPrice*customer.apportionRate] forKey:@"ShareAmout"];
        [array addObject:dic];
    }
    
    request.Guests = array;
    request.ConfirmType = [NSNumber numberWithInt:0];
    request.UserIP = @"127.0.0.1";
    
    [self.requestManager sendRequest:request];
    
}

- (void)showPopupListWithTitle:(NSString*)title withType:(int)type withData:(NSArray *)data{
    
    CGFloat xWidth = self.contentView.bounds.size.width - 20.0f;
    CGFloat yHeight = 240;
    CGFloat yOffset = (self.contentView.bounds.size.height - yHeight)/2.0f;
    _popupListData = data;
    _popupType = type;
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = YES;
    [poplistview setTitle:title];
    [poplistview show];
}

#pragma mark - UIPopoverListViewDataSource
- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:identifier];
    
    int row = indexPath.row;
    if(_popupType == 2){
        NSDictionary *dic = [_popupListData objectAtIndex:row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"UserName"],[dic objectForKey:@"Mobilephone"]];
    }else{
        cell.textLabel.text = [_popupListData objectAtIndex:row];
    }
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return _popupListData.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

#pragma mark - Passenager tableView dataSource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [HotelDataCache sharedInstance].customers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"passenagerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    customerTableViewCell *cellView = nil;
    if(cell){
        cellView = (customerTableViewCell *)cell;
    }else{
        cellView = [[customerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    HotelCustomerModel *customer = [[HotelDataCache sharedInstance].customers objectAtIndex:indexPath.row];
    cellView.name.text = customer.name;
    cellView.costCenter.text = @"";
    NSString *apportionString = nil;
    if(customer.apportionRate == 1){
        apportionString = [NSString stringWithFormat:@"￥%d承担全价",_roomPrice];
    }else{
        apportionString = [NSString stringWithFormat:@"￥%d承担半价",_roomPrice/2];
    }
    cellView.costApportion.text = apportionString;
    
    return cellView;
}


#pragma mark - uppay Alert

- (void)showAlertWait
{
    _mAlert = [[UIAlertView alloc] initWithTitle:kWaiting message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    [_mAlert show];
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    aiv.center = CGPointMake(_mAlert.frame.size.width / 2.0f - 15, _mAlert.frame.size.height / 2.0f + 10 );
    [aiv startAnimating];
    [_mAlert addSubview:aiv];
}

- (void)showAlertMessage:(NSString*)msg
{
    _mAlert = [[UIAlertView alloc] initWithTitle:kNote message:msg delegate:nil cancelButtonTitle:kConfirm otherButtonTitles:nil, nil];
    [_mAlert show];
}
- (void)hideAlert
{
    if (_mAlert != nil)
    {
        [_mAlert dismissWithClickedButtonIndex:0 animated:YES];
        _mAlert = nil;
    }
}

#pragma mark - UPPayPlugin Test


- (void)userPayAction:(id)sender
{
    
//    [UPPayPlugin startPay:@"201401050307110027842" mode:kMode viewController:self delegate:self];
    
//    NSString* urlString = [NSString stringWithFormat:kConfigTnUrl, @"201401050307110027842"];
//    NSURL* url = [NSURL URLWithString:urlString];
//	NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
//    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//    [urlConn start];
//    [self showAlertWait];
}


- (void)normalPayAction:(id)sender
{
    NSURL* url = [NSURL URLWithString:kNormalTnUrl];
	NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
    NSURLConnection* urlConn = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    [urlConn start];
    [self showAlertWait];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* rsp = (NSHTTPURLResponse*)response;
    int code = [rsp statusCode];
    if (code != 200)
    {
        [self hideAlert];
        [self showAlertMessage:kErrorNet];
        [connection cancel];
        connection = nil;
    }
    else
    {
        if (_mData != nil)
        {
            _mData = nil;
        }
        _mData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self hideAlert];
    NSString* tn = [[NSMutableString alloc] initWithData:_mData encoding:NSUTF8StringEncoding];
    if (tn != nil && tn.length > 0)
    {
        NSLog(@"tn=%@",tn);
        
    }
    connection = nil;
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self hideAlert];
    [self showAlertMessage:kErrorNet];
    connection = nil;
}

- (void)UPPayPluginResult:(NSString *)result
{
    NSString* msg = [NSString stringWithFormat:kResult, result];
    [self showAlertMessage:msg];
}

//- (NSString*)currentUID
//{
//    int                 mib[6];
//    size_t              len;
//    char                *buf;
//    unsigned char       *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl  *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    NSString* noUID = @"";
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        return noUID;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        return noUID;
//    }
//    
//    if ((buf = (char*)malloc(len)) == NULL) {
//        return noUID;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        free(buf);
//        return noUID;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
//                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
//    
//    return outstring;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end


@implementation customerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width/4, height)];
    [_name setBackgroundColor:color(clearColor)];
    [_name setTextColor:color(blackColor)];
    [_name setFont:[UIFont systemFontOfSize:13]];
    [_name setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_name];
    
    _costCenter = [[UILabel alloc] initWithFrame:CGRectMake(width/4, 0, width/4, height)];
    [_costCenter setBackgroundColor:color(clearColor)];
    [_costCenter setTextColor:color(blackColor)];
    [_costCenter setFont:[UIFont systemFontOfSize:13]];
    [_costCenter setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_costCenter];
    
    int left = (width/4)*2;
    _costApportion = [[UILabel alloc] initWithFrame:CGRectMake(left,0,width-left, height)];
    [_costApportion setBackgroundColor:color(clearColor)];
    [_costApportion setTextColor:color(blackColor)];
    [_costApportion setFont:[UIFont systemFontOfSize:11]];
    [_costApportion setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_costApportion];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    [arrow setFrame:CGRectMake(width - 40, 14, 12, 18)];
    [self addSubview:arrow];
    
}

@end

