//
//  AirListViewController.m
//  MiuTrip
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "AirListViewController.h"

@interface AirListViewController ()

@property (strong, nonatomic) UILabel               *titleLabel;
@property (strong, nonatomic) UILabel               *detailLabel;
@property (strong, nonatomic) UILabel               *dateLabel;

@end

@implementation AirListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setSubviewFrame];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self.contentView setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}

#pragma mark - tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AirListViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierStr = @"cell";
    AirListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    if (cell == Nil) {
        cell = [[AirListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStr];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - view init
- (void)setSubviewFrame
{
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(returnBtn) + 10, 0, self.topBar.frame.size.width/2 - 10 - controlXLength(returnBtn), self.topBar.frame.size.height/2)];
    [_titleLabel setText:@"上海 - 北京"];
    [_titleLabel setAutoSize:YES];
    [_titleLabel setTextColor:color(whiteColor)];
    [_titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.view addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, controlYLength(_titleLabel), _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
    [_detailLabel setFont:[UIFont systemFontOfSize:13]];
    [_detailLabel setAutoSize:YES];
    [_detailLabel setTextColor:color(whiteColor)];
    [_detailLabel setText:@"12个航班"];
    [self.view addSubview:_detailLabel];
    
    UIImageView *dateLabelBackImage = [self createLineWithParam:color(colorWithRed:35.0/255.0 green:110.0/255.0 blue:185.0/255.0 alpha:1) frame:CGRectMake(controlXLength(_titleLabel) + 10, 7.5, (self.topBar.frame.size.width/2 - 20), self.topBar.frame.size.height - 15)];
    [dateLabelBackImage setCornerRadius:2.5];
    [dateLabelBackImage setShaowColor:dateLabelBackImage.backgroundColor offset:CGSizeMake(4, 4) opacity:1 radius:5];
    [self.view addSubview:dateLabelBackImage];
    
    [dateLabelBackImage createLineWithParam:color(darkGrayColor) frame:CGRectMake(dateLabelBackImage.frame.size.width/5, 0, 1, dateLabelBackImage.frame.size.height)];
    [dateLabelBackImage createLineWithParam:color(darkGrayColor) frame:CGRectMake(dateLabelBackImage.frame.size.width*4/5, 0, 1, dateLabelBackImage.frame.size.height)];

    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn setTitle:@"prev" forState:UIControlStateNormal];
    [prevBtn.titleLabel setAutoSize:YES];
    [prevBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 6.5, 0)];
    [prevBtn setFrame:CGRectMake(dateLabelBackImage.frame.origin.x, dateLabelBackImage.frame.origin.y, dateLabelBackImage.frame.size.width/5, dateLabelBackImage.frame.size.height)];
    [self.view addSubview:prevBtn];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(prevBtn), prevBtn.frame.origin.y, prevBtn.frame.size.width * 3, prevBtn.frame.size.height)];
    [_dateLabel setFont:[UIFont systemFontOfSize:13]];
    [_dateLabel setAutoSize:YES];
    [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateLabel setTextColor:color(whiteColor)];
    [_dateLabel setText:[Utils stringWithDate:[NSDate date] withFormat:@"MM月dd日"]];
    [self.view addSubview:_dateLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"next" forState:UIControlStateNormal  ];
    [nextBtn.titleLabel setAutoSize:YES];
    [nextBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 6.5, 0)];
    [nextBtn setFrame:CGRectMake(controlXLength(_dateLabel), prevBtn.frame.origin.y, prevBtn.frame.size.width, prevBtn.frame.size.height)];
    [self.view addSubview:nextBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    UIButton *dateCompareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dateCompareBtn setFrame:CGRectMake(10, 5 + controlYLength(self.topBar), self.view.frame.size.width/4, 30)];
    [dateCompareBtn setTitle:@"时间" forState:UIControlStateNormal];
    [dateCompareBtn setBackgroundColor:color(cyanColor)];
    [self.view addSubview:dateCompareBtn];
    
    UIButton *priceCompareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceCompareBtn setFrame:CGRectMake(controlXLength(dateCompareBtn) + 10, dateCompareBtn.frame.origin.y, dateCompareBtn.frame.size.width, dateCompareBtn.frame.size.height)];
    [priceCompareBtn setTitle:@"价格" forState:UIControlStateNormal];
    [priceCompareBtn setBackgroundColor:color(redColor)];
    [self.view addSubview:priceCompareBtn];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setFrame:CGRectMake(self.view.frame.size.width - controlXLength(dateCompareBtn), dateCompareBtn.frame.origin.y, dateCompareBtn.frame.size.width, dateCompareBtn.frame.size.height)];
    [filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [filterBtn setBackgroundColor:color(blueColor)];
    [self.view addSubview:filterBtn];
    
    UIImageView *titleImage = [self createLineWithParam:imageNameAndType(@"shadow", nil) frame:CGRectMake(0, controlYLength(dateCompareBtn) + 5, self.contentView.frame.size.width, 15)];
    [self.view addSubview:titleImage];
    
    _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, controlYLength(titleImage), self.contentView.frame.size.width, self.contentView.frame.size.height - 40 - controlYLength(titleImage))];
    [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_theTableView setDataSource:self];
    [_theTableView setDelegate:self];
    [self.contentView addSubview:_theTableView];
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

@interface AirListViewCell ()

@property (strong, nonatomic) UIView            *unfoldView;

@end

@implementation AirListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _startTimeLb = [[UILabel alloc]initWithFrame:CGRectMake(0, AirListViewCellHeight/2 - 25, appFrame.size.width/5, 30)];
    [_startTimeLb setTextColor:color(colorWithRed:0.0 green:90.0/255.0 blue:180.0/255.0 alpha:1)];
    [_startTimeLb setTextAlignment:NSTextAlignmentCenter];
    [_startTimeLb setFont:[UIFont systemFontOfSize:17]];
    [_startTimeLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"HH:mm"]];
    [self.contentView addSubview:_startTimeLb];
    
    _endTileLb = [[UILabel alloc]initWithFrame:CGRectMake(0, controlYLength(_startTimeLb) - 10, _startTimeLb.frame.size.width, _startTimeLb.frame.size.height)];
    [_endTileLb setTextColor:color(darkGrayColor)];
    [_endTileLb setTextAlignment:NSTextAlignmentCenter];
    [_endTileLb setFont:[UIFont systemFontOfSize:12]];
    [_endTileLb setText:[Utils stringWithDate:[NSDate date] withFormat:@"HH:mm"]];
    [self.contentView addSubview:_endTileLb];
    
    _fromAndToLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_startTimeLb), 5, (appFrame.size.width - controlXLength(_startTimeLb))*3/4, (AirListViewCellHeight - 10)/3)];
    [_fromAndToLb setText:@"上海虹桥机场 - 深圳宝安机场"];
    [_fromAndToLb setAutoSize:YES];
    [self.contentView addSubview:_fromAndToLb];
    
    _lineNumLb = [[UILabel alloc]initWithFrame:CGRectMake(_fromAndToLb.frame.origin.x, controlYLength(_fromAndToLb), (appFrame.size.width - controlXLength(_startTimeLb))/2, _fromAndToLb.frame.size.height)];
    [_lineNumLb setTextColor:color(darkGrayColor)];
    [_lineNumLb setFont:[UIFont systemFontOfSize:12]];
    [_lineNumLb setText:@"上海航空 FM2908"];
    [self.contentView addSubview:_lineNumLb];
    
    _recommonSeatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(_lineNumLb.frame.origin.x, controlYLength(_lineNumLb), _lineNumLb.frame.size.width/2, _lineNumLb.frame.size.height)];
    [_recommonSeatTypeLb setText:@"经济舱/A"];
    [_recommonSeatTypeLb setAutoSize:YES];
    [self.contentView addSubview:_recommonSeatTypeLb];
    
    _virginiaTicketLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_recommonSeatTypeLb), _recommonSeatTypeLb.frame.origin.y, _recommonSeatTypeLb.frame.size.width, _recommonSeatTypeLb.frame.size.height)];
    [_virginiaTicketLb setText:@"剩12张"];
    [_virginiaTicketLb setTextAlignment:NSTextAlignmentRight];
    [_virginiaTicketLb setFont:[UIFont systemFontOfSize:12]];
    [_virginiaTicketLb setTextColor:color(darkGrayColor)];
    [self.contentView addSubview:_virginiaTicketLb];
    
    _ticketPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_lineNumLb), controlYLength(_fromAndToLb) - 7.5, _recommonSeatTypeLb.frame.size.width, _startTimeLb.frame.size.height)];
    [_ticketPriceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_ticketPriceLb setFont:[UIFont systemFontOfSize:13]];
    [_ticketPriceLb setTextAlignment:NSTextAlignmentCenter];
    [_ticketPriceLb setText:[NSString stringWithFormat:@"¥1020"]];
    [self.contentView addSubview:_ticketPriceLb];
    
    _discountLb = [[UILabel alloc]initWithFrame:CGRectMake(_ticketPriceLb.frame.origin.x, controlYLength(_ticketPriceLb) - 15, _ticketPriceLb.frame.size.width, _ticketPriceLb.frame.size.height)];
    [_discountLb setTextColor:color(grayColor)];
    [_discountLb setFont:[UIFont systemFontOfSize:12]];
    [_discountLb setText:@"全价"];
    [_discountLb setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_discountLb];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(controlXLength(_ticketPriceLb), AirListViewCellHeight/2 - 20, _ticketPriceLb.frame.size.width, 40)];
    [doneBtn setTitle:@"预定" forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:color(colorWithRed:30.0/255.0 green:100.0/255.0 blue:185.0/255.0 alpha:1)];
    [doneBtn setBounds:CGRectMake(0, 0, doneBtn.frame.size.width * 0.7, doneBtn.frame.size.height * 0.7)];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:doneBtn ];
}

- (void)createUnfoldViewWithParams:(NSArray*)param
{
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(0, AirListViewCellHeight, appFrame.size.width, AirListViewSubjoinCellHeight * [param count])];
    for (int i = 0;i<4;i++) {
//        NSObject *object = [param objectAtIndex:i];
//        AirListViewSubjoinCell *subjoinCell = [[AirListViewSubjoinCell alloc]initWithFrame:CGRectMake(0, AirListViewSubjoinCellHeight * i, appFrame.size.height, AirListViewSubjoinCellHeight)];
    }
}

- (void)unfoldViewShowWithParams:(NSArray*)param
{
    if (!_unfoldView) {
        [self createUnfoldViewWithParams:param];
    }
}

@end

@interface AirListViewSubjoinCell ()

@property (strong, nonatomic) UILabel           *seatTypeLb;            //舱位类型
@property (strong, nonatomic) UILabel           *virginiaTicketLb;      //余票
@property (strong, nonatomic) UILabel           *priceLb;               //价格
@property (strong, nonatomic) UILabel           *discountLb;            //折扣

@end

@implementation AirListViewSubjoinCell

- (void)setSubviewFrame
{
    _seatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(appFrame.size.width/5, 0, appFrame.size.width/5, AirListViewSubjoinCellHeight/2)];
    [_seatTypeLb setText:@"经济舱/B"];
    [_seatTypeLb setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_seatTypeLb];
    
    _virginiaTicketLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_seatTypeLb), _seatTypeLb.frame.origin.y, _seatTypeLb.frame.size.width, _seatTypeLb.frame.size.height)];
    [_virginiaTicketLb setText:@"剩两张"];
    [_virginiaTicketLb setTextAlignment:NSTextAlignmentCenter];
    [_virginiaTicketLb setFont:[UIFont systemFontOfSize:12]];
    [_virginiaTicketLb setTextColor:color(grayColor)];
    [self addSubview:_virginiaTicketLb];
    
    _priceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_virginiaTicketLb), _virginiaTicketLb.frame.origin.y, _virginiaTicketLb.frame.size.width, _virginiaTicketLb.frame.size.height)];
    [_priceLb setText:@"¥599"];
    [_priceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_priceLb setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_priceLb];
    
    _discountLb = [[UILabel alloc]initWithFrame:CGRectMake(_priceLb.frame.origin.x, controlYLength(_priceLb), _seatTypeLb.frame.size.width, _seatTypeLb.frame.size.height)];
    [_discountLb setText:@"1折"];
    [_discountLb setTextAlignment:NSTextAlignmentCenter];
    [_discountLb setFont:[UIFont systemFontOfSize:12]];
    [_discountLb setTextColor:color(grayColor)];
    [self addSubview:_discountLb];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(controlXLength(_priceLb), _priceLb.frame.size.height/2, _priceLb.frame.size.width, _priceLb.frame.size.height)];
    [doneBtn setBackgroundColor:color(colorWithRed:30.0/255.0 green:100.0/255.0 blue:185.0/255.0 alpha:1)];
    [doneBtn setTitle:@"预定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(pressDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:doneBtn];
}

- (void)pressDoneBtn:(UIButton*)sender
{
    NSLog(@"done");
}

@end
