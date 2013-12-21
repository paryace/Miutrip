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
@property (strong, nonatomic) UIButton              *dateLabel;

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

    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn.titleLabel setAutoSize:YES];
    [prevBtn setImage:imageNameAndType(@"button_date-left", nil) forState:UIControlStateNormal];
    [prevBtn setFrame:CGRectMake(controlXLength(_titleLabel) + 10, 7.5, (self.topBar.frame.size.width/2 - 20)/5, self.topBar.frame.size.height - 15)];
    [self.view addSubview:prevBtn];
    
    _dateLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dateLabel setFrame:CGRectMake(controlXLength(prevBtn), prevBtn.frame.origin.y, prevBtn.frame.size.width * 3, prevBtn.frame.size.height)];
    [_dateLabel setBackgroundImage:imageNameAndType(@"bg_date", nil) forState:UIControlStateDisabled];
    [_dateLabel setEnabled:NO];
    [_dateLabel.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [_dateLabel.titleLabel setAutoSize:YES];
    [_dateLabel.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_dateLabel.titleLabel setTextColor:color(whiteColor)];
    [_dateLabel setTitle:[Utils stringWithDate:[NSDate date] withFormat:@"MM月dd日"] forState:UIControlStateNormal];
    [self.view addSubview:_dateLabel];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn.titleLabel setAutoSize:YES];
    [nextBtn setImage:imageNameAndType(@"button_date-right", nil) forState:UIControlStateNormal];
    [nextBtn setFrame:CGRectMake(controlXLength(_dateLabel), prevBtn.frame.origin.y, prevBtn.frame.size.width, prevBtn.frame.size.height)];
    [self.view addSubview:nextBtn];
    
    [self setSubjoinViewFrame];
}

- (void)setSubjoinViewFrame
{
    AirListCustomBtn *dateCompareBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(10, 5 + controlYLength(self.topBar), self.view.frame.size.width/4, 30)];
    [dateCompareBtn setTitle:@"时间"];
    [dateCompareBtn setBackgroundImage:imageNameAndType(@"button_style2", nil) forState:UIControlStateNormal];
    [dateCompareBtn setSubjoinImage:imageNameAndType(@"icon_arrow1", nil)];
    [dateCompareBtn setSubjoinHighlightedImage:imageNameAndType(@"icon_arrow2", nil)];
    [self.view addSubview:dateCompareBtn];
    
    AirListCustomBtn *priceCompareBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(controlXLength(dateCompareBtn) + 10, dateCompareBtn.frame.origin.y, dateCompareBtn.frame.size.width, dateCompareBtn.frame.size.height)];
    [priceCompareBtn setTitle:@"价格"];
    [priceCompareBtn setBackgroundImage:imageNameAndType(@"button_style1", nil) forState:UIControlStateNormal];
    [priceCompareBtn setSubjoinImage:imageNameAndType(@"icon_arrow1", nil)];
    [priceCompareBtn setSubjoinHighlightedImage:imageNameAndType(@"icon_arrow2", nil)];
    [self.view addSubview:priceCompareBtn];
    
    AirListCustomBtn *filterBtn = [[AirListCustomBtn alloc]initWithFrame:CGRectMake(self.view.frame.size.width - controlXLength(dateCompareBtn), dateCompareBtn.frame.origin.y, dateCompareBtn.frame.size.width, dateCompareBtn.frame.size.height)];
    [filterBtn setTitle:@"筛选"];
    [filterBtn setBackgroundImage:imageNameAndType(@"button_style1", nil) forState:UIControlStateNormal];
    [filterBtn setSubjoinImage:imageNameAndType(@"icon_screening", nil)];
    //[dateCompareBtn setSubjoinHighlightedImage:imageNameAndType(@"icon_screening", nil)];
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
    

    
    UIImageView *lineNumLeft = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_startTimeLb), 5, (AirListViewCellHeight - 10)/3, (AirListViewCellHeight - 10)/3)];
    [lineNumLeft setImage:imageNameAndType(@"logo_fm@2x", Nil)];
    [self.contentView addSubview:lineNumLeft];
    _lineNumLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(lineNumLeft), lineNumLeft.frame.origin.y, (appFrame.size.width - controlXLength(lineNumLeft))/2, lineNumLeft.frame.size.height)];
    [_lineNumLb setTextColor:color(darkGrayColor)];
    [_lineNumLb setFont:[UIFont systemFontOfSize:11]];
    [_lineNumLb setText:@"上海航空 FM2908"];
    [self.contentView addSubview:_lineNumLb];
    
    _fromAndToLb = [[UILabel alloc]initWithFrame:CGRectMake(lineNumLeft.frame.origin.x, controlYLength(lineNumLeft), _lineNumLb.frame.size.width + lineNumLeft.frame.size.width, _lineNumLb.frame.size.height)];
    [_fromAndToLb setText:@"上海虹桥机场 - 深圳宝安机场"];
    [_fromAndToLb setFont:[UIFont systemFontOfSize:11]];
    [_fromAndToLb setAutoSize:YES];
    [self.contentView addSubview:_fromAndToLb];
    
    _recommonSeatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(_fromAndToLb.frame.origin.x, controlYLength(_fromAndToLb), _fromAndToLb.frame.size.width/2, _fromAndToLb.frame.size.height)];
    [_recommonSeatTypeLb setText:@"经济舱/A"];
    [_recommonSeatTypeLb setFont:[UIFont systemFontOfSize:11]];
    [_recommonSeatTypeLb setAutoSize:YES];
    [self.contentView addSubview:_recommonSeatTypeLb];
    
    _virginiaTicketLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_recommonSeatTypeLb), _recommonSeatTypeLb.frame.origin.y, _recommonSeatTypeLb.frame.size.width, _recommonSeatTypeLb.frame.size.height)];
    [_virginiaTicketLb setText:@"剩12张"];
    [_virginiaTicketLb setTextAlignment:NSTextAlignmentRight];
    [_virginiaTicketLb setFont:[UIFont systemFontOfSize:12]];
    [_virginiaTicketLb setTextColor:color(darkGrayColor)];
    [self.contentView addSubview:_virginiaTicketLb];
    
    _ticketPriceLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(_fromAndToLb), _lineNumLb.center.y, (appFrame.size.width - controlXLength(_fromAndToLb))*2/5, _fromAndToLb.frame.size.height)];
    [_ticketPriceLb setTextColor:color(colorWithRed:245.0/255.0 green:117.0/255.0 blue:36.0/255.0 alpha:1)];
    [_ticketPriceLb setFont:[UIFont systemFontOfSize:12]];
    [_ticketPriceLb setTextAlignment:NSTextAlignmentCenter];
    [_ticketPriceLb setText:[NSString stringWithFormat:@"¥1020"]];
    [_ticketPriceLb setAutoSize:YES];
    [self.contentView addSubview:_ticketPriceLb];
    
    _discountLb = [[UILabel alloc]initWithFrame:CGRectMake(_ticketPriceLb.frame.origin.x, controlYLength(_ticketPriceLb), _ticketPriceLb.frame.size.width, _ticketPriceLb.frame.size.height)];
    [_discountLb setTextColor:color(grayColor)];
    [_discountLb setFont:[UIFont systemFontOfSize:12]];
    [_discountLb setText:@"全价"];
    [_discountLb setTextAlignment:NSTextAlignmentCenter];
    [_discountLb setAutoSize:YES];
    [self.contentView addSubview:_discountLb];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setFrame:CGRectMake(controlXLength(_ticketPriceLb), AirListViewCellHeight/2 - 20, appFrame.size.width - controlXLength(_ticketPriceLb), 40)];
    [doneBtn setTitle:@"预定" forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_normal", nil) forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:imageNameAndType(@"done_btn_press", nil) forState:UIControlStateHighlighted];
    [doneBtn setBounds:CGRectMake(0, 0, doneBtn.frame.size.width * 0.7, doneBtn.frame.size.height * 0.7)];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.contentView addSubview:doneBtn ];
}

- (void)createUnfoldViewWithParams:(NSArray*)param
{
    _unfoldView = [[UIView alloc]initWithFrame:CGRectMake(0, AirListViewCellHeight, appFrame.size.width, AirListViewSubjoinCellHeight * [param count])];
    for (int i = 0;i<4;i++) {
        AirListViewSubjoinCell *subjoinCell = [[AirListViewSubjoinCell alloc]initWithFrame:CGRectMake(0, AirListViewSubjoinCellHeight * i, appFrame.size.width, AirListViewSubjoinCellHeight)];
        [_unfoldView addSubview:subjoinCell];
    }
}

- (void)unfoldViewShow:(BOOL)show
{
    if (show) {
        if (_unfoldView.superview) {
            [_unfoldView removeFromSuperview];
        }
        [self.contentView addSubview:_unfoldView];
    }else{
        if (_unfoldView.superview) {
            [_unfoldView removeFromSuperview];
        }
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

@interface AirListCustomBtn ()

@property (strong, nonatomic) UILabel       *textLabel;

@end

@implementation AirListCustomBtn

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)setSubviewFrame
{
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 2/3, self.frame.size.height)];
    [_textLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_textLabel];
    
    _subjoinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(controlXLength(_textLabel) - 5, _textLabel.frame.origin.y, _textLabel.frame.size.height, _textLabel.frame.size.height)];
    [_subjoinImageView setBackgroundColor:color(clearColor)];
    [self addSubview:_subjoinImageView];
    
    [_subjoinImageView setScaleX:0.7 scaleY:0.7];
    self.highlighted = _subjoinImageView.highlighted;
    
    [self addTarget:self action:@selector(pressSelf:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressSelf:(UIButton*)sender
{
    [_subjoinImageView setHighlighted:!_subjoinImageView.highlighted];
    self.highlighted = _subjoinImageView.highlighted;
}

- (void)setSubjoinImage:(UIImage *)image
{
    [_subjoinImageView setImage:image];
}

- (void)setSubjoinHighlightedImage:(UIImage*)image
{
    [_subjoinImageView setHighlightedImage:image];
}

- (void)setTitle:(NSString *)title
{
    [_textLabel setText:title];
}

- (void)setFont:(UIFont *)font
{
    [_textLabel setFont:font];
}

@end
