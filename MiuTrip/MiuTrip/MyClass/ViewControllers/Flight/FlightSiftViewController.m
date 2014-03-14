//
//  FlightSiftViewController.m
//  MiuTrip
//
//  Created by Samrt_baot on 14-1-16.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "FlightSiftViewController.h"
#import "DBAirLine.h"
#import "SiftCorpCell.h"





@interface FlightSiftViewController ()

@property (strong, nonatomic) NSMutableArray    *seatTypeBtnArray;
@property (strong, nonatomic) NSMutableArray    *airCompanyOfSift;

@property (strong, nonatomic) UITableView       *airCompanyList;





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
        [_airCompanyBtnArray addObject:@"不限"];
        _airCompanyOfSift = [NSMutableArray array];
    
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSubviewFrame];
    _airCompanyList.frame = CGRectMake(0, 0, _airCompanyList.frame.size.width, kCELLHEIGHT * _airCompanyBtnArray.count);
    [_airCompanyList reloadData];
}

#pragma mark --筛选条件确认

- (void)pressRightBtn:(UIButton *)sender
{
    NSString *seatTypeStr = nil;
    for (FlightSiftViewCustomBtn *btn in _seatTypeBtnArray) {
        if (btn.leftImageHighlighted) {
            seatTypeStr = btn.titleLabel.text;
            break;
        }
    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         seatTypeStr,               @"seatType",
                         _airCompanyOfSift,          @"airCompany",
                         nil];
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate siftDone:dic];
    }];
}

- (void)setSubviewFrame
{
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    [self setTitle:@"机票筛选"];
    
    UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setBackgroundColor:color(clearColor)];
    [returnBtn setImage:imageNameAndType(@"return", nil) forState:UIControlStateNormal];
    [returnBtn setFrame:CGRectMake(0, 0, self.topBar.frame.size.height, self.topBar.frame.size.height)];
    [self setReturnButton:returnBtn];
    [self.view addSubview:returnBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundColor:color(clearColor)];
    [rightBtn setFrame:CGRectMake(appFrame.size.width - returnBtn.frame.size.width, returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
    [rightBtn setScaleX:0.7 scaleY:0.7];
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
    
    FlightSiftViewCustomBtn *seatNoneBtn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, 0, seatTypeBGView.frame.size.width , 40)];
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
    
//    NSArray *companyArray = [[SqliteManager shareSqliteManager] mappingAirLineInfo];
    
    UILabel *airCompanyLb = [[UILabel alloc]initWithFrame:CGRectMake(seatTypeLb.frame.origin.x, controlYLength(seatTypeBGView), seatTypeLb.frame.size.width, seatTypeLb.frame.size.height)];
    [airCompanyLb setBackgroundColor:color(clearColor)];
    [airCompanyLb setFont:[UIFont systemFontOfSize:13]];
    [airCompanyLb setText:@"航空公司"];
    [self.contentView addSubview:airCompanyLb];
    
    UIView *airCompanyBGView = [[UIView alloc]initWithFrame:CGRectMake(seatTypeBGView.frame.origin.x, controlYLength(airCompanyLb), seatTypeBGView.frame.size.width, kCELLHEIGHT * [_airCompanyBtnArray count])];
    [airCompanyBGView setBackgroundColor:color(whiteColor)];
    [airCompanyBGView setBorderColor:color(lightGrayColor) width:1];
    [airCompanyBGView setCornerRadius:5];
    [self.contentView addSubview:airCompanyBGView];
    
#pragma mark --修改
    
    _airCompanyList = [[UITableView alloc] initWithFrame:airCompanyBGView.bounds style:UITableViewStylePlain];
    _airCompanyList.delegate = self;
    _airCompanyList.dataSource = self;
    _airCompanyList.bounces = NO;
    _airCompanyList.separatorStyle = UITableViewCellSeparatorStyleNone;
   // _airCompanyList.editing = YES;
    
    [airCompanyBGView addSubview:_airCompanyList];

#if 0
//    for (int i = 0; i<=[_airCompanyBtnArray count]; i++) {
//        if (i > 0) {
//            NSString *airLine = [_airCompanyBtnArray objectAtIndex:i - 1];
//            FlightSiftViewCustomBtn *btn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, 40 * i, airCompanyBGView.frame.size.width, 40)];
//            [btn setTag:(200 + i)];
//            [btn setTitle:airLine forState:UIControlStateNormal];
//            [btn setTitleColor:color(blackColor) forState:UIControlStateNormal];
//            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//            [btn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
//            [btn addTarget:self action:@selector(pressAirCompanyBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [airCompanyBGView addSubview:btn];
//            //[_airCompanyBtnArray addObject:btn];
//            
//
//        }else{
//            FlightSiftViewCustomBtn *btn = [[FlightSiftViewCustomBtn alloc]initWithFrame:CGRectMake(0, 40 * i, airCompanyBGView.frame.size.width, 40)];
//            [btn setTag:(200 + i)];
//            [btn setTitle:@"不限" forState:UIControlStateNormal];
//            [btn setTitleColor:color(blackColor) forState:UIControlStateNormal];
//            [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
//            [btn setLeftImage:imageNameAndType(@"set_item_normal", nil) LeftHighlightedImage:imageNameAndType(@"set_item_select", nil)];
//            [btn addTarget:self action:@selector(pressAirCompanyBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [airCompanyBGView addSubview:btn];
//           // [_airCompanyBtnArray addObject:btn];
//        }
//        if (i < [companyArray count] - 1) {
//            [airCompanyBGView createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, 40 * i, airCompanyBGView.frame.size.width, 1)];
//        }
//    }
#endif
    [self pressSeatTypeBtn:seatNoneBtn];
   // [self pressAirCompanyBtn:(FlightSiftViewCustomBtn*)[airCompanyBGView viewWithTag:200]];
}

- (void)pressSeatTypeBtn:(FlightSiftViewCustomBtn*)sender
{
    for (FlightSiftViewCustomBtn *btn in _seatTypeBtnArray) {
        [btn setLeftImageHighlighted:(sender.tag == btn.tag)];
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _airCompanyBtnArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *company = @"airCompanyCell";
    
    SiftCorpCell *cell = [tableView dequeueReusableCellWithIdentifier:company];
    
    if (nil == cell) {
        cell = [[SiftCorpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:company];
    }
    
    cell.airCorpName.text = [_airCompanyBtnArray objectAtIndex:indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;

    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    

    
    if (indexPath.row == 0) {
        //第一个cell 不限
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        SiftCorpCell *cellA = (SiftCorpCell *)[tableView cellForRowAtIndexPath:path];
        cellA.isSelected = YES;
        
        
        for (NSUInteger i = 1 ; i < [_airCompanyBtnArray count]; i++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
            SiftCorpCell *cell = (SiftCorpCell *)[tableView cellForRowAtIndexPath:path];
            cell.isSelected = NO;
            
            if ([_airCompanyOfSift containsObject:cell.airCorpName.text]) {
                [_airCompanyOfSift removeObject:cell.airCorpName.text];
            }
        }
        [_airCompanyOfSift addObject:@"不限"];
    }else{
        //NSString *airLineName = [_airCompanyBtnArray objectAtIndex:indexPath.row];
        //第一个cell 设置为未选中状态
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        SiftCorpCell *cellA = (SiftCorpCell *)[tableView cellForRowAtIndexPath:path];
        cellA.isSelected = NO;
        
        //其他cell设置为相反的状态
        NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        SiftCorpCell *cellM = (SiftCorpCell *)[tableView cellForRowAtIndexPath:index];
        cellM.isSelected = !cellM.isSelected;
        
        //如果包含--不限--选项,则删除不限选项
        if ([_airCompanyOfSift containsObject:cellA.airCorpName.text]) {
            [_airCompanyOfSift removeObject:cellA.airCorpName.text];
        }
        //如果是选中状态,则把这个cell加入到筛选数组中
        if (cellM.isSelected) {
            [_airCompanyOfSift addObject:cellM.airCorpName.text];
        }else
            //如果不是选中状态,则从数组中移除
        {
            if ([_airCompanyOfSift containsObject:cellM.airCorpName.text]) {
                [_airCompanyOfSift removeObject:cellM.airCorpName.text];
            }
        }
    }
}



//- (void)pressAirCompanyBtn:(FlightSiftViewCustomBtn*)sender
//{
//    for (FlightSiftViewCustomBtn *btn in _airCompanyBtnArray) {
//        [btn setLeftImageHighlighted:(sender.tag == btn.tag)];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCELLHEIGHT;
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
