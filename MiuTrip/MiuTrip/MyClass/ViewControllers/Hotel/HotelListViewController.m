//
//  HotelListViewController.m
//  MiuTrip
//
//  Created by stevencheng on 13-12-4.
//  Copyright (c) 2013年 michael. All rights reserved.
//

#import "HotelListViewController.h"
#import "SearchHotelsResponse.h"
#import "HotelListCellviewCell.h"
#import "HotelCommentViewController.h"
#import "HotelDetailViewController.h"
#import "HotelOrderViewController.h"
#import "HotelMapViewControler.h"
#import "Utils.h"
#import "HotelListBtnCellView.h"
#import "HotelListRoomCell.h"
#import "GetCorpPolicyRequest.h"
#import "GetCorpPolicyResponse.h"
#import "HotelCompileViewController.h"
#import "HotelCantonViewController.h"

@interface HotelListViewController ()

@property (strong, nonatomic) NSMutableDictionary  *hotelSiftRule;

@end

@implementation HotelListViewController

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
    if (self = [super init]) {
        [self.view setHidden:NO];
        [self setSubviewFrame];
    }
    return self;
}


-(void)setSubviewFrame{
    
    _hotelListData = [[NSMutableArray alloc] init];
    _pageIndex = 1;
    _isFiltered = NO;
    _hasPriceRc = YES;
    _currentSortType = SORT_BY_RECOMMEND;
    
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapBtn setTitleColor:color(whiteColor) forState:UIControlStateNormal];
    [mapBtn setTitleColor:color(grayColor) forState:UIControlStateHighlighted];
    [mapBtn setTitle:@"地图" forState:UIControlStateNormal];
    [mapBtn setTitle:@"地图" forState:UIControlStateHighlighted];
    mapBtn.showsTouchWhenHighlighted = YES;
    mapBtn.frame = CGRectMake(self.contentView.frame.size.width - 40, 10, 30, 20);
    [mapBtn addTarget:self action:@selector(mapBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    _titleView = [self addTitleWithTitle:@"上海" withRightView:mapBtn];
    [self addLoadingView];
    [self loadData];
}

-(void)mapBtnPressed:(UIButton *) sender{
    HotelMapViewControler *viewController = [[HotelMapViewControler alloc] initWithType:0 withData:_hotelListData];
    [self pushViewController:viewController transitionType:TransitionPush completionHandler:nil];
}


-(void)addTableView{
    
    int width = self.contentView.frame.size.width;
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, width, 35)];
    [filterView setBackgroundColor:color(whiteColor)];
    
    //推荐排序
    width = width - 20;
    UIButton *miuRecommend = [UIButton buttonWithType:UIButtonTypeCustom];
    [miuRecommend setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [miuRecommend setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [miuRecommend setHighlighted:YES];
    [miuRecommend setShowsTouchWhenHighlighted:NO];
    [miuRecommend setTitle:@"觅优推荐" forState:UIControlStateNormal];
    [miuRecommend setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [miuRecommend.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [miuRecommend setFrame:CGRectMake(5, 1, width/3, 33)];
    [miuRecommend setTag:101];
    [miuRecommend addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:miuRecommend];
    
    
    //价格排序
    UIButton *price = [UIButton buttonWithType:UIButtonTypeCustom];
    [price setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [price setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [price setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [price setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [price setFrame:CGRectMake(10+width/3, 1, width/3, 33)];
    [price setTag:102];
    
    int btnWidth = width/3;
    int left = (btnWidth - 50)/2;
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 28, 33)];
    [lable setBackgroundColor:color(clearColor)];
    [lable setText:@"价格"];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:color(blackColor)];
    [price addSubview:lable];
    
    _priceArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down.png"]];
    [_priceArrow setFrame:CGRectMake(left+30, 6, 20, 20)];
    [price addSubview:_priceArrow];
    [price addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:price];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"button_style1.png"] forState:UIControlStateNormal];
    [filterBtn setBackgroundImage:[UIImage imageNamed:@"button_style2.png"] forState:UIControlStateHighlighted];
    [filterBtn setTitleColor:color(blackColor) forState:UIControlStateNormal];
    [filterBtn setFrame:CGRectMake(15+width/3*2, 1,width/3, 33)];
    [filterBtn setTag:103];
    [filterBtn addTarget:self action:@selector(filteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    left = (btnWidth - 58)/2;
    lable = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 28, 33)];
    [lable setText:@"筛选"];
    [lable setBackgroundColor:color(clearColor)];
    [lable setFont:[UIFont systemFontOfSize:14]];
    [lable setTextColor:color(blackColor)];
    [filterBtn addSubview:lable];
    
    UIImageView *filterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_filter"]];
    [filterImage setFrame:CGRectMake(left+28, 6, 30, 20)];
    [filterBtn addSubview:filterImage];
    [filterView addSubview:filterBtn];
    

    [self.view addSubview:filterView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, self.contentView.frame.size.width, self.view.frame.size.height-110)];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self addPullToRefreshFooter];
}

-(void)reloading
{
    [self.tableView removeFromSuperview];
    [self addLoadingView];
}

-(void)reAddTabaleView
{
    [self removeLoadingView];
    [self.view addSubview:self.tableView];
}

-(void)filteBtnPressed:(UIButton*)sender
{
    switch (sender.tag) {
        case 101:
            [self sortByRecommend];
            break;
        case 102:
            [self sortByPrice];
            break;
        case 103:
            [self cantonSelect];
            break;
        default:
            break;
    }
}

/**
 *酒店筛选
 */
- (void)cantonSelect {
    HotelSiftViewController *hcv = [[HotelSiftViewController alloc] init];
    [hcv setDelegate:self];
    [self pushViewController:hcv transitionType:TransitionPush completionHandler:^{
        [hcv GetDistricts];
    }];
}

- (void)hotelSiftSelectDone:(NSMutableDictionary*)data
{
    [_hotelListData removeAllObjects];
    [self addLoadingView];
    
    NSDictionary *canton = [data objectForKey:@"canton"];
    if (![Utils isEmpty:canton]) {
        [HotelDataCache sharedInstance].queryCantonName = [canton objectForKey:@"DistrictName"];
        [HotelDataCache sharedInstance].queryCantonId   = [[canton objectForKey:@"ID"] intValue];
    }
    [self searchHotels];
}

-(void)sortByRecommend
{
    if(_currentSortType == SORT_BY_RECOMMEND){
        return;
    }
    [self reloading];
    [self searchHotelsBySort:6];
}

-(void)sortByPrice
{
    if(_currentSortType == SORT_BY_RECOMMEND){
        _currentSortType = SORT_BY_PRICE_DOWN;
    }else if(_currentSortType == SORT_BY_PRICE_DOWN){
        _currentSortType = SORT_BY_PRICE_UP;
    }else{
         _currentSortType = SORT_BY_PRICE_DOWN;
    }
    [self reloading];
    if(_currentSortType == SORT_BY_PRICE_UP){
        [self searchHotelsBySort:1];
    }else{
        [self searchHotelsBySort:2];
    }
}

-(void)loadData{
    HotelDataCache *data = [HotelDataCache sharedInstance];
    if(data.isPrivte){
        _hasPriceRc = NO;
        [self searchHotels];
        return;
    }
    
    int policyID = 0;
    if(data.isForSelf){
        policyID = [[UserDefaults shareUserDefault].loginInfo.PolicyID intValue];
    }else{
        if(data.executor){
            policyID = data.executor.policyId;
        }
    }
    
    if(policyID == 0){
        _hasPriceRc = NO;
        [self searchHotels];
        return;
    }
    GetCorpPolicyRequest *request = [[GetCorpPolicyRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpPolicy"];
    request.policyid = [NSNumber numberWithInt:policyID];
    [self.requestManager sendRequest:request];
}


-(void)searchHotelsBySort:(int)sortType{
    
    _request.SortBy = [NSNumber numberWithInt:sortType];
    _pageIndex = 1;
    _request.page =[NSNumber numberWithInt:_pageIndex];
    [self.requestManager sendRequest:_request];
}

-(void)searchHotels{
    _request = [[SearchHotelsRequest alloc] initWidthBusinessType:BUSINESS_HOTEL methodName:@"SearchHotels"];
    
    HotelDataCache *data = [HotelDataCache sharedInstance];
    
    if(data.isPrivte){
        _request.FeeType = [NSNumber numberWithInt:2];
    }else{
        _request.FeeType = [NSNumber numberWithInt:1];
    }
    
    if(data.isForSelf){
        _request.ReserveType = @"1";
    }else{
        _request.ReserveType = @"2";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    _request.CityId = [NSNumber numberWithInt:data.checkInCityId];
    _request.ComeDate = [formatter stringFromDate:data.checkInDate];
    _request.LeaveDate = [formatter stringFromDate:data.checkOutDate];
    int index = data.priceRangeIndex;
    switch (index) {
        case 0:
            _request.PriceLow = @"0";
            _request.PriceHigh = @"10000";
            break;
        case 1:
            _request.PriceLow = @"0";
            _request.PriceHigh = @"150";
            break;
        case 2:
            _request.PriceLow = @"151";
            _request.PriceHigh = @"300";
            break;
        case 3:
            _request.PriceLow = @"301";
            _request.PriceHigh = @"450";
            break;
        case 4:
            _request.PriceLow = @"451";
            _request.PriceHigh = @"600";
            break;
        case 5:
            _request.PriceLow = @"601";
            _request.PriceHigh = @"10000";
            break;
        default:
            break;
    }
  
    _request.HotelName = data.keyWord;
    _request.page = [NSNumber numberWithInt:_pageIndex];
    _request.pageSize = [NSNumber numberWithInt:10];
    _request.SortBy = [NSNumber numberWithInt:6];
    _request.Facility = @"";
    _request.StarReted = @"";
    _request.latitude = @"";
    _request.longitude = @"";
    _request.radius = [NSNumber numberWithInt:0];
    _request.IsPrePay = [NSNumber numberWithBool:YES];
    
    _request.HotelPostion = data.queryCantonName;
    _request.HotelPostionId = [NSNumber numberWithInt:data.queryCantonId];
    
    [self.requestManager sendRequest:_request];
}

/**
 *  请求成功
 *
 *  @param response
 */
-(void)requestDone:(BaseResponseModel *) response{
    if(response){
        
        if([response isKindOfClass:[GetCorpPolicyResponse class]]){
            GetCorpPolicyResponse *policyResponse = (GetCorpPolicyResponse*)response;
            NSString *hotelRc = policyResponse.HotelRC;
            if([hotelRc isEqualToString:@"T"]){
                _hasPriceRc = YES;
                _policyMaxPrice = [policyResponse.HtlAmountLimtMax intValue];
                _popupListData = policyResponse.HotelReasonCodeN;
                NSString *policyTitle = [NSString stringWithFormat:@"%@ 价格上限:%@元",
                                         policyResponse.PolicyName,policyResponse.HtlAmountLimtMax];
                UILabel *titleLabel = (UILabel*)[_titleView viewWithTag:10000];
                titleLabel.text = policyTitle;
            }else{
                _hasPriceRc = NO;
            }
            [self searchHotels];
            
        }else{
            SearchHotelsResponse *hotelListResponse = (SearchHotelsResponse*)response;
            
            NSArray *hotels = [hotelListResponse.Data objectForKey:@"Hotels"];
            [_hotelListData addObjectsFromArray:hotels];
            _totalPage = [[hotelListResponse.Data objectForKey:@"TotalPage"] integerValue];
            
            if(_pageIndex == 1){
                [self removeLoadingView];
                if(self.tableView){
                    [self reAddTabaleView];
                }else{
                    [self addTableView];
                }
            }
            [self stopLoading];
            [self.tableView reloadData];
            self.hasMore = YES;
            
        }
    }
}

/**
 *  请求失败
 *
 *  @param errorCode 错误代码
 *  @param errorMsg  错误消息
 */
-(void)requestFailedWithErrorCode:(NSNumber *)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"error = %@",errorMsg);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_hotelListData count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(_isOpen && self.selectIndex.section == section){
        NSDictionary *dic = [_hotelListData objectAtIndex:section];
        NSArray *rooms = [dic objectForKey:@"Rooms"];
        return rooms.count + 2;
    }
    
    return 1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_isOpen){
        if(indexPath.row == 1){
            return 30;
        }
        if(indexPath.row > 1){
            return 40;
        }
        
    }
    
    return 75.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *hotelCell = @"hotelCell";
    static NSString *hotelBtn = @"hotelbtn";
    static NSString *hotelRoomsCell = @"hotelRoomsCell";
    
    NSDictionary *dic = [_hotelListData objectAtIndex:indexPath.section];
    
    if(self.isOpen && self.selectIndex.section == indexPath.section&&indexPath.row!=0){
        
        if(indexPath.row == 1){
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelBtn];
            HotelListBtnCellView *cellView = nil;
            
            if(cell){
                cellView = (HotelListBtnCellView*)cell;
            }else{
                cellView = [[HotelListBtnCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelBtn hasMapBtn:YES];
            }
            cellView.hotelData = dic;
            cellView.hotelId = [[dic objectForKey:@"hotelId"] integerValue];
            cellView.viewController = self;
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cellView;
        }else{
            
            UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelRoomsCell];
            HotelListRoomCell *cellView = nil;
            if(cell){
                cellView = (HotelListRoomCell*)cell;
            }else{
                cellView = [[HotelListRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelRoomsCell];
            }
            
            NSArray *rooms = [dic objectForKey:@"Rooms"];
            NSDictionary *roomDic = [rooms objectAtIndex:indexPath.row - 2];
            NSArray *pricePolicies = [roomDic objectForKey:@"PricePolicies"];
            NSDictionary *priceDic = [pricePolicies objectAtIndex:0];
            NSArray *priceInfos = [priceDic objectForKey:@"PriceInfos"];
            NSDictionary *roomPriceDic = [priceInfos objectAtIndex:0];
   
            cellView.roomData = roomDic;
            cellView.hotelId = [[dic objectForKey:@"hotelId"] intValue];
            cellView.hotelName = [dic objectForKey:@"hotelName"];
            cellView.roomName.text = [roomDic objectForKey:@"roomName"];
            
            NSString *bed = [roomDic objectForKey:@"bed"];
            NSString *breakfast = [NSString stringWithFormat:@"%@早餐",[roomPriceDic objectForKey:@"Breakfast"]];
            NSString *bb = [NSString stringWithFormat:@"%@\n%@",bed,breakfast];
            
            cellView.bedAndBreakfast.text = bb;
            
            int wifiInt = [[roomDic objectForKey:@"adsl"] integerValue];
            if(wifiInt == 1){
                cellView.wifi.text = @"宽带免费";
            }else{
                cellView.wifi.text = @"";
            }
            cellView.viewController = self;
            cellView.price.text = [NSString stringWithFormat:@"￥%@",[roomPriceDic objectForKey:@"SalePrice"]];
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cellView;
        }

        
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:hotelCell];
        HotelListCellviewCell *cellView = nil;
        if(cellView){
            cellView = (HotelListCellviewCell*)cell;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cellView.hotelImage];
        }else{
            cellView = [[HotelListCellviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hotelCell];
        }
        
        [cellView.address setText:[dic objectForKey:@"address"]];
        [cellView.hotelName setText:[dic objectForKey:@"hotelName"]];
        NSString *str = [dic objectForKey:@"lowestPrice"];
        NSString *price = [NSString stringWithFormat:@"￥%@起",str];
        [cellView.price setText:price];
        NSString *comment = [NSString stringWithFormat:@"%@好评率 点评%d条",[dic objectForKey:@"score"],[[dic objectForKey:@"commentTotal"]integerValue]];
        [cellView.comment setText:comment];
        cellView.hotelImage.imageURL = [NSURL URLWithString:[dic objectForKey:@"img"]];
        
        [cellView setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        return cellView;

    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;

    int section = self.selectIndex.section;
    NSDictionary *dic = [_hotelListData objectAtIndex:section];
    NSArray *rooms = [dic objectForKey:@"Rooms"];
    int contentCount = [rooms count] + 1;
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
    
    [self.tableView beginUpdates];
	if (firstDoInsert)
    {   [self.tableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.tableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	[self.tableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.tableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
}

// 加载更多数据，此处可以换成从远程服务器获取最新的_size条数据
-(void)loadMore
{
    if(_pageIndex == _totalPage){
       
        self.hasMore = NO;
        [self stopLoading];
        return;
    }
    
    _pageIndex ++;
    _request.page = [NSNumber numberWithInt:_pageIndex];
    [self.requestManager sendRequest:_request];


}

- (void)refresh {
    [self performSelector:@selector(loadMore) withObject:nil afterDelay:2.0];
}

-(void)showRuleView
{
    CustomIOS7AlertView *ruleAlert = [[CustomIOS7AlertView alloc] init];
    [ruleAlert setDelegate:self];
    [ruleAlert setContainerView:[self makeRuleAlertView]];
    [ruleAlert setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"取消",nil]];
    [ruleAlert setUseMotionEffects:true];
    [ruleAlert show];
    
}


-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex  == 0){
        if(![HotelDataCache sharedInstance].selcetedReason){
            return;
        }else{
            [alertView close];
            HotelOrderViewController *orderViewController = [[HotelOrderViewController alloc] init];
            [self.navigationController pushViewController:orderViewController animated:YES];
        }
    }else{
        [alertView close];
    }
}


-(UIView*)makeRuleAlertView
{
    
    int width = 300;
    UIView *contentView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 120)];
    [contentView setBackgroundColor:color(clearColor)];
    UIImageView *tipImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tip"]];
    tipImage.frame = CGRectMake(10, 5, 20, 20);
    [contentView addSubview:tipImage];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(32, 0, 100, 30)];
    [title setBackgroundColor:color(clearColor)];
    title.text = @"选择违规原因";
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = color(darkGrayColor);
    [contentView addSubview:title];
    
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(15,35, width-30, 30)];
    [text setBackgroundColor:color(clearColor)];
    text.text = @"因您的预订与贵公司差旅政策不符，故请您选择原因：";
    text.font = [UIFont systemFontOfSize:12];
    text.numberOfLines = 2;
    text.textColor = color(darkGrayColor);
    [contentView addSubview:text];
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 70, width-30, 40)];
    [bgView setBackgroundColor:color(whiteColor)];
    [bgView setBorderColor:color(lightGrayColor) width:.6];
    [bgView setCornerRadius:5.0];
    [bgView setAlpha:0.5];
    [contentView addSubview:bgView];
    
    UILabel *selectLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 70, 40, 40)];
    [selectLabel setBackgroundColor:color(clearColor)];
    selectLabel.text = @"请选择";
    selectLabel.font = [UIFont systemFontOfSize:11];
    selectLabel.textColor = color(lightGrayColor);
    [contentView addSubview:selectLabel];
    
    _selectedReason = [[UILabel alloc] initWithFrame:CGRectMake(60,70, width-100, 38)];
    [_selectedReason setBackgroundColor:color(clearColor)];
    NSDictionary *reason = [HotelDataCache sharedInstance].selcetedReason;
    if(reason){
        _selectedReason.text = [reason objectForKey:@"ReasonCode"];
    }
    _selectedReason.font = [UIFont systemFontOfSize:12];
    _selectedReason.textColor = color(darkGrayColor);
    [contentView addSubview:_selectedReason];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    arrow.frame = CGRectMake(width-30, 82, 12, 16);
    [contentView addSubview:arrow];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = bgView.frame;
    [btn addTarget:self action:@selector(alertBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn];
    
    return contentView;
    
}

-(void)alertBtnPressed:(UIButton*)button
{
    [self showPopupListWithTitle:@"选择原因"];
}


- (void)showPopupListWithTitle:(NSString*)title
{
    
    CGFloat xWidth = self.contentView.bounds.size.width - 20.0f;
    CGFloat yHeight = 240;
    CGFloat yOffset = (self.contentView.bounds.size.height - yHeight)/2.0f;
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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    int row = indexPath.row;
    NSDictionary *dic = [_popupListData objectAtIndex:row];
    cell.textLabel.text = [dic objectForKey:@"ReasonCode"];
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
    NSDictionary *dic = [_popupListData objectAtIndex:indexPath.row];
    [HotelDataCache sharedInstance].selcetedReason = dic;
    _selectedReason.text = [dic objectForKey:@"ReasonCode"];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}



@end

