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
    
    NSMutableArray *customers = data.customers;
    if(!customers){
        data.customers = [[NSMutableArray alloc] init];
    }
    
    if(data.isForSelf){
        HotelCustomerModel *customer = [[HotelCustomerModel alloc] init];
        customer.name = [UserDefaults shareUserDefault].loginInfo.UserName;
        customer.apportionRate = 1;
        [customers addObject:customer];
    }
}

-(void) initView{
    [self.contentView setBackgroundColor:UIColorFromRGB(0xffe9e9e9)];
    [self addTitleWithTitle:@"填写订单"];
    [self addLoadingView];
    [self getContacts];
}

- (void)addChildView{
    
    float width = self.contentView.frame.size.width;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40,width,660)];
    scrollView.tag = 1000;
    scrollView.delaysContentTouches = NO;
    [self.contentView addSubview:scrollView];
    
    
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
        [executor setText:@"张三男"];
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
    [star2 setFont:[UIFont systemFontOfSize:13]];
    [star2 setText:@"*"];
    [scrollView addSubview:star2];
    
    UILabel *arriveTime = [[UILabel alloc] initWithFrame:CGRectMake(110, y+4, width - 140, 40)];
    [arriveTime setTextColor:color(blackColor)];
    [arriveTime setFont:[UIFont systemFontOfSize:14]];
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
    [star3 setFont:[UIFont systemFontOfSize:13]];
    [star3 setText:@"*"];
    [scrollView addSubview:star3];
    
    UILabel *roomCount = [[UILabel alloc] initWithFrame:CGRectMake(100, y+4, width - 140, 34)];
    [roomCount setTextColor:color(blackColor)];
    [roomCount setFont:[UIFont systemFontOfSize:14]];
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
    
    UIImageView *costBg = [[UIImageView alloc] init];
    [costBg setFrame:CGRectMake(10, y+38, width-20, 125)];
    [costBg setBackgroundColor:color(whiteColor)];
    [costBg setBorderColor:color(lightGrayColor) width:1.0];
    [costBg setCornerRadius:5.0];
    [costBg setAlpha:1.0f];
    [scrollView addSubview:costBg];
    
    UIView *costView = [[UIView alloc] initWithFrame:CGRectMake(10, y+40, width-20, 0)];
    [scrollView addSubview:costView];

    UILabel *orderAmount = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    [orderAmount setBackgroundColor:color(clearColor)];
    [orderAmount setFont:[UIFont systemFontOfSize:13]];
    [orderAmount setTextColor:color(grayColor)];
    
    NSString *orderAmountText = [NSString stringWithFormat:@"订单总额：￥%d",_roomPrice];
    [orderAmount setText:orderAmountText];
    [costView addSubview:orderAmount];
    
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
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 75, width - 22, 40)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [costView addSubview:tableView];
    
    y += 168;
    
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
    [nameText setFont:[UIFont systemFontOfSize:13]];
    [nameText setText:[UserDefaults shareUserDefault].loginInfo.UserName];
    [contactorView addSubview:nameText];
    
    UITextField *mobileText = [[UITextField alloc] initWithFrame:CGRectMake(65, 44, width - 130, 34)];
    [mobileText setBorderStyle:UITextBorderStyleRoundedRect];
    [mobileText setTextColor:color(blackColor)];
    [mobileText setFont:[UIFont systemFontOfSize:13]];
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
    [scrollView addSubview:submitOrderBtn];
}


-(void)onBtnPressed:(UIButton*)sender{
    int tag = sender.tag;
    switch(tag){
        case 1001:
            [self showPopupListWithTitle:@"到店时间" withType:0 withData:_arriveTimeArray];
            break;
        case 1002:
            [self showRoomCountPopView];
        case 1003:
            [self showPopupListWithTitle:@"选择联系人" withType:2 withData:_contactorArray];
            break;
    }
}

#pragma mark - request handle

-(void) getContacts
{
    GetContactRequest *request = [[GetContactRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetContact"];
    request.CorpID = [NSNumber numberWithInteger:[UserDefaults shareUserDefault].loginInfo.CorpID];
    [self.requestManager sendRequest:request];
}

-(void)requestDone:(BaseResponseModel*)response
{
    GetContactResponse *contactResponse = (GetContactResponse*)response;
    _contactorArray = contactResponse.result;
    [self removeLoadingView];
    [self addChildView];
}


-(void)showRoomCountPopView{
     NSArray *array = [[NSArray alloc]initWithObjects:@"1", nil];
    [self showPopupListWithTitle:@"房间数量" withType:0 withData:array];
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
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [HotelDataCache sharedInstance].customers.count;
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

