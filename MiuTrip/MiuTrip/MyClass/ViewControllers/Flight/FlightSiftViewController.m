//
//  FlightSiftViewController.m
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-16.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "FlightSiftViewController.h"
#import "DBAirLine.h"
#import "SqliteManager.h"

@interface FlightSiftViewController ()

@property (strong, nonatomic) NSMutableArray    *seatTypeBtnArray;
@property (strong, nonatomic) NSMutableArray    *airCompanyBtnArray;

@end

@implementation FlightSiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _seatTypeBtnArray = [NSMutableArray array];
        _airCompanyBtnArray = [NSMutableArray array];
        [self setSubviewFrame];
    }
    return self;
}

- (void)pressRightBtn:(UIButton *)sender
{
    NSString *seatTypeStr = nil;
    for (FlightSiftViewCustomBtn *btn in _seatTypeBtnArray) {
        if (btn.leftImageHighlighted) {
            seatTypeStr = btn.titleLabel.text;
            break;
        }
    }
    NSString *airCompanyStr = nil;
    for (FlightSiftViewCustomBtn *btn in _airCompanyBtnArray) {
        if (btn.leftImageHighlighted) {
            airCompanyStr = btn.titleLabel.text;
            break;
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         seatTypeStr,               @"seatType",
                         airCompanyStr,             @"airCompany",
                         nil];
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate siftDone:dic];
    }];
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    [self setTitle:@"筛选"];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setFrame:CGRectMake(appFrame.size.width - returnBtn.frame.size.width, returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_dark", nil) forState:UIControlStateNormal];
    [rightBtn setImage:imageNameAndType(@"abs__ic_cab_done_holo_light", nil) forState:UIControlStateHighlighted];
    [rightBtn addTarget:self action:@selector(pressRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    UILabel *seatTypeLb = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar), appFrame.size.width - 20, 35)];
    [seatTypeLb setBackgroundColor:color(clearColor)];
    [seatTypeLb setFont:[UIFont systemFontOfSize:13]];
    [seatTypeLb setText:@"舱位等级"];
    [self.contentView addSubview:seatTypeLb];
    
    UIView *seatTypeBGView = [[UIView alloc]initWithFrame:CGRectMake(seatTypeLb.frame.origin.x, controlYLength(seatTypeLb), seatTypeLb.frame.size.width, 40 * 3)];
    [seatTypeBGView setBackgroundColor:color(whiteColor)];
    [seatTypeBGView setBorderColor:color(lightGrayColor) width:1];
    [seatTypeBGView setCornerRadius:5];
//    [seatTypeBGView setShaowColor:color(lightGrayColor) offset:CGSizeMake(4, 4) opacity:1 radius:2.5];
    [self.contentView addSubview:seatTypeBGView];
    
    FlightSiftViewCustomBtn *seatNoneBtn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, 0, seatTypeBGView.frame.size.width, 40)];
    [seatNoneBtn setTitle:@"不限" forState:UIControlStateNormal];
    [seatNoneBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [seatNoneBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [seatNoneBtn setTag:100];
    [seatNoneBtn addTarget:self action:@selector(pressSeatTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [seatNoneBtn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
    [seatTypeBGView addSubview:seatNoneBtn];
    [_seatTypeBtnArray addObject:seatNoneBtn];
    
    [seatTypeBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(seatNoneBtn), seatTypeBGView.frame.size.width, 1)];
    
    FlightSiftViewCustomBtn *seatEconomyBtn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, controlYLength(seatNoneBtn), seatNoneBtn.frame.size.width, seatNoneBtn.frame.size.height)];
    [seatEconomyBtn setTitle:@"经济舱" forState:UIControlStateNormal];
    [seatEconomyBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [seatEconomyBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [seatEconomyBtn setTag:101];
    [seatEconomyBtn addTarget:self action:@selector(pressSeatTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [seatEconomyBtn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
    [seatTypeBGView addSubview:seatEconomyBtn];
    [_seatTypeBtnArray addObject:seatEconomyBtn];
    
    [seatTypeBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, controlYLength(seatEconomyBtn), seatTypeBGView.frame.size.width, 1)];
    
    FlightSiftViewCustomBtn *seatBusinessBtn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, controlYLength(seatEconomyBtn), seatNoneBtn.frame.size.width, seatNoneBtn.frame.size.height)];
    [seatBusinessBtn setTitle:@"商务舱" forState:UIControlStateNormal];
    [seatBusinessBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [seatBusinessBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [seatBusinessBtn setTag:102];
    [seatBusinessBtn addTarget:self action:@selector(pressSeatTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [seatBusinessBtn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
    [seatTypeBGView addSubview:seatBusinessBtn];
    [_seatTypeBtnArray addObject:seatBusinessBtn];
    
    NSArray *companyArray = [[SqliteManager shareSqliteManager] mappingAirLineInfo];
    
    UILabel *airCompanyLb = [[UILabel alloc]initWithFrame:CGRectMake(seatTypeLb.frame.origin.x, controlYLength(seatTypeBGView), seatTypeLb.frame.size.width, seatTypeLb.frame.size.height)];
    [airCompanyLb setBackgroundColor:color(clearColor)];
    [airCompanyLb setFont:[UIFont systemFontOfSize:13]];
    [airCompanyLb setText:@"航空公司"];
    [self.contentView addSubview:airCompanyLb];
    
    UIView *airCompanyBGView = [[UIView alloc]initWithFrame:CGRectMake(seatTypeBGView.frame.origin.x, controlYLength(airCompanyLb), seatTypeBGView.frame.size.width, 40 * [companyArray count])];
    [airCompanyBGView setBackgroundColor:color(whiteColor)];
    [airCompanyBGView setBorderColor:color(lightGrayColor) width:1];
    [airCompanyBGView setCornerRadius:5];
    [self.contentView addSubview:airCompanyBGView];
    
    for (int i = 0; i<=[companyArray count]; i++) {
        if (i > 0) {
            DBAirLine *airLine = [companyArray objectAtIndex:i - 1];
            FlightSiftViewCustomBtn *btn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, 40 * i, airCompanyBGView.frame.size.width, 40)];
            [btn setTag:(200 + i)];
            [btn setTitle:airLine.short_name forState:UIControlStateNormal];
            [btn setTitleColor:color(blackColor) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
            [btn addTarget:self action:@selector(pressAirCompanyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [airCompanyBGView addSubview:btn];
            [_airCompanyBtnArray addObject:btn];
            

        }else{
            FlightSiftViewCustomBtn *btn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, 40 * i, airCompanyBGView.frame.size.width, 40)];
            [btn setTag:(200 + i)];
            [btn setTitle:@"不限" forState:UIControlStateNormal];
            [btn setTitleColor:color(blackColor) forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [btn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
            [btn addTarget:self action:@selector(pressAirCompanyBtn:) forControlEvents:UIControlEventTouchUpInside];
            [airCompanyBGView addSubview:btn];
            [_airCompanyBtnArray addObject:btn];
        }
        if (i < [companyArray count] - 1) {
            [airCompanyBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, 40 * i, airCompanyBGView.frame.size.width, 1)];
        }
    }
    
    [self pressSeatTypeBtn:seatNoneBtn];
    [self pressAirCompanyBtn:(FlightSiftViewCustomBtn*)[airCompanyBGView viewWithTag:200]];
}

- (void)pressSeatTypeBtn:(FlightSiftViewCustomBtn*)sender
{
    for (FlightSiftViewCustomBtn *btn in _seatTypeBtnArray) {
        [btn setLeftImageHighlighted:(sender.tag == btn.tag)];
    }
}

- (void)pressAirCompanyBtn:(FlightSiftViewCustomBtn*)sender
{
    for (FlightSiftViewCustomBtn *btn in _airCompanyBtnArray) {
        [btn setLeftImageHighlighted:(sender.tag == btn.tag)];
    }
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

@interface FlightSiftViewCustomBtn ()

@end

@implementation FlightSiftViewCustomBtn

@synthesize leftImageHighlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubviewFrame];
    }
    
    return self;
}

- (void)setSubviewFrame
{
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, self.frame.size.height, 0, 0)];
    
    _subjoinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    [_subjoinImageView setBackgroundColor:color(clearColor)];
    [_subjoinImageView setBounds:CGRectMake(0, 0, _subjoinImageView.frame.size.width * 0.7, _subjoinImageView.frame.size.height * 0.7)];
    [self addSubview:_subjoinImageView];
}

- (void)setLeftImage:(UIImage*)leftImage LeftHighlightedImage:(UIImage*)highlightImage
{
    [_subjoinImageView setImage:leftImage];
    [_subjoinImageView setHighlightedImage:highlightImage];
}

- (void)setLeftImageHighlighted:(BOOL)highlighted
{
    [_subjoinImageView setHighlighted:highlighted];
}

- (BOOL)leftImageHighlighted
{
    return _subjoinImageView.highlighted;
}

@end
