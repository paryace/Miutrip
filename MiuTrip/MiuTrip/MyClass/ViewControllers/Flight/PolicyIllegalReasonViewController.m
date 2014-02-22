//
//  PolicyIllegalReasonViewController.m
//  MiuTrip
//
//  Created by apple on 14-2-8.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "PolicyIllegalReasonViewController.h"
#import "CustomMethod.h"
#import "GetNormalFlightsResponse.h"
#import "AirListViewController.h"

@interface PolicyIllegalReasonViewController ()

@property (assign, nonatomic) PolicyIllegalType illegalType;
@property (strong, nonatomic) id    corpPolicy;

@property (strong, nonatomic) NSMutableArray *PreBookReasonCodeN;   //国内提前预定RC	List<ReasonCodeDTO>
@property (strong, nonatomic) NSMutableArray *FltPricelReasonCodeN; //国内飞机票最低价RC	List<ReasonCodeDTO>

@property (strong, nonatomic) UIView         *contentView;

//@property (strong, nonatomic) UIView         *RCView;
//@property (strong, nonatomic) UITableView    *theTableView;
@property (strong, nonatomic) NSArray        *dataSource;

@property (strong, nonatomic) RCPickerViewController *RCPickerView;

@property (strong, nonatomic) NSMutableDictionary    *RCDatas;

@property (strong, nonatomic) UIButton       *selectDateReasonBtn;
@property (strong, nonatomic) UIButton       *selectPriceReasonBtn;

@end

@implementation PolicyIllegalReasonViewController

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
        [self setSubviewFrame];
        
        _RCPickerView = [[RCPickerViewController alloc]init];
        [_RCPickerView setDelegate:self];
        [self.view addSubview:_RCPickerView.view];
    }
    return self;
}

- (void)fireWithIllegalType:(PolicyIllegalType)illegalType corpPolicy:(id)corpPolicy
{
    _illegalType = illegalType;
    _corpPolicy  = corpPolicy;
    [self createContentView];
    
    [_contentView setFrame:CGRectMake(0, appFrame.size.height, _contentView.frame.size.width, _contentView.frame.size.height)];
    [self.view setHidden:NO];
    if (self.view.superview){
        [self.view.superview bringSubviewToFront:self.view];
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         [_contentView setFrame:CGRectMake(0, self.view.frame.size.height - _contentView.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height)];
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)order
{
    [_RCDatas setValue:_flight forKey:@"flight"];
    if (_illegalType == PolicyIllegalDate) {
        ReasonCodeDTO *reasonDTO = [_RCDatas objectForKey:@"PreBookReasonCodeN"];
        if (!reasonDTO) {
            [[Model shareModel] showPromptText:@"请选择提前预定原因" model:YES];
            return;
        }
    }else if (_illegalType == PolicyIllegalPrice){
        ReasonCodeDTO *reasonDTO = [_RCDatas objectForKey:@"FltPricelReasonCodeN"];
        if (!reasonDTO) {
            [[Model shareModel] showPromptText:@"请选择未预订最低价原因" model:YES];
            return;
        }
    }else if (_illegalType == PolicyIllegalDateAndPrice){
        ReasonCodeDTO *dateRC = [_RCDatas objectForKey:@"PreBookReasonCodeN"];
        ReasonCodeDTO *priceRC = [_RCDatas objectForKey:@"FltPricelReasonCodeN"];
        if (!dateRC) {
            [[Model shareModel] showPromptText:@"请选择提前预定原因" model:YES];
            return;
        }else if (!priceRC){
            [[Model shareModel] showPromptText:@"请选择未预订最低价原因" model:YES];
            return;
        }
    }
    [self pickerFinished:_RCDatas];
}

#pragma mark - picker handle
- (void)pickerFinished:(NSDictionary*)RCData
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         [_contentView setFrame:CGRectMake(0, self.view.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height)];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate PolicyIllegalReasonPickerFinished:RCData];
                     }];
}

- (void)pickerCalcel
{
    [UIView animateWithDuration:0.35
                     animations:^{
                         [_contentView setFrame:CGRectMake(0, self.view.frame.size.height, _contentView.frame.size.width, _contentView.frame.size.height)];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate PolicyIllegalReasonPickerCancel];
                     }];
}

#pragma mark - RC picker handle
- (void)selectDateIllegalReason:(UIButton*)sender
{
    NSLog(@"date");
    _dataSource = self.PreBookReasonCodeN;
    [self showRCView];
}

- (void)selectPriceIllegalReason:(UIButton*)sender
{
    NSLog(@"price");
    _dataSource = self.FltPricelReasonCodeN;
    [self showRCView];
}

- (void)RCPickerFinished:(ReasonCodeDTO *)rcDTO
{
    if (_dataSource == self.PreBookReasonCodeN) {
        [_RCDatas setValue:rcDTO forKey:@"PreBookReasonCodeN"];
        [_selectDateReasonBtn setTitle:rcDTO.ReasonCode forState:UIControlStateNormal];
    }else if (_dataSource == self.FltPricelReasonCodeN){
        [_RCDatas setValue:rcDTO forKey:@"FltPricelReasonCodeN"];
        [_selectPriceReasonBtn setTitle:rcDTO.ReasonCode forState:UIControlStateNormal];
    }
}

- (void)RCPickerCancel
{
    
}

- (void)showRCView
{
    [_RCPickerView setDataSource:_dataSource];
    [_RCPickerView fire];
}

#pragma mark - tableview handle
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    ReasonCodeDTO *rcDTO = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:rcDTO.ReasonCode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSMutableArray *)PreBookReasonCodeN
{
    SEL selector = NSSelectorFromString(@"PreBookReasonCodeN");
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id value = [_corpPolicy performSelector:selector];
    
    if (value) {
        _PreBookReasonCodeN = value;
        
    }else{
        [[Model shareModel]showPromptText:@"未找到提前预定RC." model:YES];
    }
    
    return _PreBookReasonCodeN;
}

- (NSMutableArray *)FltPricelReasonCodeN
{
    SEL selector = NSSelectorFromString(@"FltPricelReasonCodeN");
    
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id value = [_corpPolicy performSelector:selector];
    
    if (value) {
        _FltPricelReasonCodeN = value;
        
    }else{
        [[Model shareModel]showPromptText:@"未找到飞机票最低价RC." model:YES];
    }
    
    return _FltPricelReasonCodeN;
}

- (void)setSubviewFrame
{
    [self.view setBackgroundColor:color(clearColor)];
    
    UIView *coverBGView = [[UIView alloc]initWithFrame:self.view.bounds];
    [coverBGView setBackgroundColor:color(blackColor)];
    [coverBGView setAlpha:0.35];
    [self.view addSubview:coverBGView];
    
    [self.view setHidden:YES];
}

- (void)createContentView
{
    if (!_RCDatas) {
        _RCDatas = [NSMutableDictionary dictionary];;
    }
    [_RCDatas removeAllObjects];
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, appFrame.size.width, 100)];
    [_contentView setBackgroundColor:color(whiteColor)];
    [self.view addSubview:_contentView];
    
    UIImageView *contentTopBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 40)];
    [contentTopBar setImage:imageNameAndType(@"subitem_normal", nil)];
    [_contentView addSubview:contentTopBar];
    
    UIImageView *promptImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, contentTopBar.frame.size.height, contentTopBar.frame.size.height)];
    [promptImage setImage:imageNameAndType(@"icon_tip", nil)];
    [_contentView addSubview:promptImage];
    
    UILabel *promptLb = [[UILabel alloc]initWithFrame:CGRectMake(controlXLength(promptImage), 0, _contentView.frame.size.width - promptImage.frame.size.width * 2, promptImage.frame.size.height)];
    [promptLb setBackgroundColor:color(clearColor)];
    [promptLb setText:@"选择违规原因"];
    [_contentView addSubview:promptLb];
    
    UIButton *selectIllegalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectIllegalBtn setFrame:CGRectMake(controlXLength(promptLb), promptImage.frame.origin.x - 1.5, promptImage.frame.size.width, promptImage.frame.size.height)];
    [selectIllegalBtn setImage:imageNameAndType(@"button_ok.9", nil) forState:UIControlStateNormal];
    [selectIllegalBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:selectIllegalBtn];
    
    [promptImage setScaleX:0.65 scaleY:0.65];
    [selectIllegalBtn setScaleX:0.9 scaleY:0.9];
    
    if (_illegalType == PolicyIllegalDateAndPrice) {
        NSString *dateIllegalString = @"根据贵公司差旅政策规定,您没有提前3天预订机票,请您选择原因:";
        CGFloat dateLbHeight = [Utils heightForWidth:_contentView.frame.size.width - 20 text:dateIllegalString font:[UIFont systemFontOfSize:13]];
        UILabel *dateIllegalLb = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(contentTopBar) + 5, _contentView.frame.size.width - 20, dateLbHeight)];
        [dateIllegalLb setBackgroundColor:color(clearColor)];
        [dateIllegalLb setNumberOfLines:0];
        [dateIllegalLb setFont:[UIFont systemFontOfSize:13]];
        [dateIllegalLb setAutoBreakLine:YES];
        [dateIllegalLb setText:dateIllegalString];
        [dateIllegalLb setTextAlignment:NSTextAlignmentCenter];
        [_contentView addSubview:dateIllegalLb];
        
        _selectDateReasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectDateReasonBtn setFrame:CGRectMake(dateIllegalLb.frame.origin.x + 8, controlYLength(dateIllegalLb) + 5, dateIllegalLb.frame.size.width - 16, 35)];
        [_selectDateReasonBtn setCornerRadius:5.0];
        [_selectDateReasonBtn setBorderColor:color(lightGrayColor) width:1.0f];
        UIImageView *dateRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_selectDateReasonBtn.frame.size.width - _selectDateReasonBtn.frame.size.height, 0, _selectDateReasonBtn.frame.size.height, _selectDateReasonBtn.frame.size.height)];
        [dateRightArrow setImage:imageNameAndType(@"arrow", nil)];
        [_selectDateReasonBtn addSubview:dateRightArrow];
        [dateRightArrow setBounds:CGRectMake(0, 0, dateRightArrow.frame.size.width * 0.45, dateRightArrow.frame.size.height * 0.45)];
        [_selectDateReasonBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_selectDateReasonBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectDateReasonBtn setTitleColor:color(lightGrayColor) forState:UIControlStateNormal];
        [_selectDateReasonBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_selectDateReasonBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_selectDateReasonBtn addTarget:self action:@selector(selectDateIllegalReason:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_selectDateReasonBtn];
        
        NSString *priceIllegalString = @"根据贵公司差旅政策规定,您没有选择最低价航班,请您选择原因.";
        CGFloat priceLbHeight = [Utils heightForWidth:_contentView.frame.size.width - 20 text:priceIllegalString font:[UIFont systemFontOfSize:13]];
        UILabel *priceIllegalLb = [[UILabel alloc]initWithFrame:CGRectMake(dateIllegalLb.frame.origin.x, controlYLength(_selectDateReasonBtn) + 5, dateIllegalLb.frame.size.width, priceLbHeight)];
        [priceIllegalLb setBackgroundColor:color(clearColor)];
        [priceIllegalLb setNumberOfLines:0];
        [priceIllegalLb setFont:[UIFont systemFontOfSize:13]];
        [priceIllegalLb setAutoBreakLine:YES];
        [priceIllegalLb setText:priceIllegalString];
        [priceIllegalLb setTextAlignment:NSTextAlignmentCenter];
        [_contentView addSubview:priceIllegalLb];
        
        _selectPriceReasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPriceReasonBtn setFrame:CGRectMake(_selectDateReasonBtn.frame.origin.x, controlYLength(priceIllegalLb) + 5, _selectDateReasonBtn.frame.size.width, _selectDateReasonBtn.frame.size.height)];
        [_selectPriceReasonBtn setCornerRadius:5.0];
        [_selectPriceReasonBtn setBorderColor:color(lightGrayColor) width:1.0f];
        UIImageView *priceRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_selectPriceReasonBtn.frame.size.width - _selectPriceReasonBtn.frame.size.height, 0, _selectPriceReasonBtn.frame.size.height, _selectPriceReasonBtn.frame.size.height)];
        [priceRightArrow setImage:imageNameAndType(@"arrow", nil)];
        [_selectPriceReasonBtn addSubview:priceRightArrow];
        [priceRightArrow setBounds:CGRectMake(0, 0, priceRightArrow.frame.size.width * 0.45, priceRightArrow.frame.size.height * 0.45)];
        [_selectPriceReasonBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_selectPriceReasonBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectPriceReasonBtn setTitleColor:color(lightGrayColor) forState:UIControlStateNormal];
        [_selectPriceReasonBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_selectPriceReasonBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_selectPriceReasonBtn addTarget:self action:@selector(selectPriceIllegalReason:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_selectPriceReasonBtn];
        
        NSString *changeOtherString = @"您也可以改定时间段范围内最低价航班.";
        CGFloat changeOtherLbHeight = [Utils heightForWidth:_contentView.frame.size.width - 20 text:changeOtherString font:[UIFont systemFontOfSize:13]];
        UILabel *changeOtherLb = [[UILabel alloc]initWithFrame:CGRectMake(priceIllegalLb.frame.origin.x, controlYLength(_selectPriceReasonBtn) + 5, priceIllegalLb.frame.size.width, changeOtherLbHeight)];
        [changeOtherLb setBackgroundColor:color(clearColor)];
        [changeOtherLb setNumberOfLines:0];
        [changeOtherLb setAutoBreakLine:YES];
        [changeOtherLb setText:changeOtherString];
        [changeOtherLb setTextColor:color(lightGrayColor)];
        [changeOtherLb setTextAlignment:NSTextAlignmentCenter];
        [changeOtherLb setFont:[UIFont systemFontOfSize:13]];
        [_contentView addSubview:changeOtherLb];
        
        AirListViewCell   *cheapestCell = nil;
        if (_flight) {
            cheapestCell = [[AirListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cheapestCell setFrame:CGRectMake(0, controlYLength(changeOtherLb) + 5, _contentView.frame.size.width, AirListViewCellHeight)];
            [cheapestCell isShow:YES];
            [cheapestCell setViewContentWithParams:_flight];
            [_contentView addSubview:cheapestCell];
        }
        
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnBtn setFrame:CGRectMake(_contentView.frame.size.width/6, controlYLength((cheapestCell?cheapestCell:changeOtherLb)) + 5, _contentView.frame.size.width/4, 30)];
        [returnBtn setBackgroundImage:imageNameAndType(@"bg_btn_blue", nil) forState:UIControlStateNormal];
        [returnBtn setTitle:@"返回重选" forState:UIControlStateNormal];
        [returnBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [returnBtn addTarget:self action:@selector(pickerCalcel) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:returnBtn];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setFrame:CGRectMake(_contentView.frame.size.width - controlXLength(returnBtn), returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
        [orderBtn setBackgroundImage:imageNameAndType(@"button_booking", nil) forState:UIControlStateNormal];
        [orderBtn setTitle:@"预订" forState:UIControlStateNormal];
        [orderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [orderBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:orderBtn];
        
        
        [_contentView setFrame:CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, controlYLength(orderBtn) + 10)];
    }else if (_illegalType == PolicyIllegalDate){
        NSString *dateIllegalString = @"根据贵公司差旅政策规定,您没有提前3天预订机票,请您选择原因:";
        CGFloat dateLbHeight = [Utils heightForWidth:_contentView.frame.size.width - 20 text:dateIllegalString font:[UIFont systemFontOfSize:13]];
        UILabel *dateIllegalLb = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(contentTopBar) + 5, _contentView.frame.size.width - 20, dateLbHeight)];
        [dateIllegalLb setBackgroundColor:color(clearColor)];
        [dateIllegalLb setNumberOfLines:0];
        [dateIllegalLb setFont:[UIFont systemFontOfSize:13]];
        [dateIllegalLb setAutoBreakLine:YES];
        [dateIllegalLb setText:dateIllegalString];
        [dateIllegalLb setTextAlignment:NSTextAlignmentCenter];
        [_contentView addSubview:dateIllegalLb];
        
        _selectDateReasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectDateReasonBtn setFrame:CGRectMake(dateIllegalLb.frame.origin.x + 8, controlYLength(dateIllegalLb) + 5, dateIllegalLb.frame.size.width - 16, 35)];
        [_selectDateReasonBtn setCornerRadius:5.0];
        [_selectDateReasonBtn setBorderColor:color(lightGrayColor) width:1.0f];
        UIImageView *dateRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_selectDateReasonBtn.frame.size.width - _selectDateReasonBtn.frame.size.height, 0, _selectDateReasonBtn.frame.size.height, _selectDateReasonBtn.frame.size.height)];
        [dateRightArrow setImage:imageNameAndType(@"arrow", nil)];
        [_selectDateReasonBtn addSubview:dateRightArrow];
        [dateRightArrow setBounds:CGRectMake(0, 0, dateRightArrow.frame.size.width * 0.45, dateRightArrow.frame.size.height * 0.45)];
        [_selectDateReasonBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_selectDateReasonBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectDateReasonBtn setTitleColor:color(lightGrayColor) forState:UIControlStateNormal];
        [_selectDateReasonBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_selectDateReasonBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_selectDateReasonBtn addTarget:self action:@selector(selectDateIllegalReason:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_selectDateReasonBtn];
        
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnBtn setFrame:CGRectMake(_contentView.frame.size.width/6, controlYLength(_selectDateReasonBtn) + 5, _contentView.frame.size.width/4, 30)];
        [returnBtn setBackgroundImage:imageNameAndType(@"bg_btn_blue", nil) forState:UIControlStateNormal];
        [returnBtn setTitle:@"返回重选" forState:UIControlStateNormal];
        [returnBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [returnBtn addTarget:self action:@selector(pickerCalcel) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:returnBtn];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setFrame:CGRectMake(_contentView.frame.size.width - controlXLength(returnBtn), returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
        [orderBtn setBackgroundImage:imageNameAndType(@"button_booking", nil) forState:UIControlStateNormal];
        [orderBtn setTitle:@"预订" forState:UIControlStateNormal];
        [orderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [orderBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:orderBtn];
        
        
        [_contentView setFrame:CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, controlYLength(orderBtn) + 10)];
    }else{
        NSString *priceIllegalString = @"根据贵公司差旅政策规定,您没有选择最低价航班,请您选择原因.";
        CGFloat priceLbHeight = [Utils heightForWidth:_contentView.frame.size.width - 20 text:priceIllegalString font:[UIFont systemFontOfSize:13]];
        UILabel *priceIllegalLb = [[UILabel alloc]initWithFrame:CGRectMake(10, controlYLength(contentTopBar) + 5, _contentView.frame.size.width - 20, priceLbHeight)];
        [priceIllegalLb setBackgroundColor:color(clearColor)];
        [priceIllegalLb setNumberOfLines:0];
        [priceIllegalLb setFont:[UIFont systemFontOfSize:13]];
        [priceIllegalLb setAutoBreakLine:YES];
        [priceIllegalLb setText:priceIllegalString];
        [priceIllegalLb setTextAlignment:NSTextAlignmentCenter];
        [_contentView addSubview:priceIllegalLb];
        
        _selectPriceReasonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPriceReasonBtn setFrame:CGRectMake(priceIllegalLb.frame.origin.x + 8, controlYLength(priceIllegalLb) + 5, priceIllegalLb.frame.size.width - 16, 35)];
        [_selectPriceReasonBtn setCornerRadius:5.0];
        [_selectPriceReasonBtn setBorderColor:color(lightGrayColor) width:1.0f];
        UIImageView *priceRightArrow = [[UIImageView alloc]initWithFrame:CGRectMake(_selectPriceReasonBtn.frame.size.width - _selectPriceReasonBtn.frame.size.height, 0, _selectPriceReasonBtn.frame.size.height, _selectPriceReasonBtn.frame.size.height)];
        [priceRightArrow setImage:imageNameAndType(@"arrow", nil)];
        [_selectPriceReasonBtn addSubview:priceRightArrow];
        [priceRightArrow setBounds:CGRectMake(0, 0, priceRightArrow.frame.size.width * 0.45, priceRightArrow.frame.size.height * 0.45)];
        [_selectPriceReasonBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_selectPriceReasonBtn setTitle:@"请选择" forState:UIControlStateNormal];
        [_selectPriceReasonBtn setTitleColor:color(lightGrayColor) forState:UIControlStateNormal];
        [_selectPriceReasonBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_selectPriceReasonBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_selectPriceReasonBtn addTarget:self action:@selector(selectPriceIllegalReason:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:_selectPriceReasonBtn];
        
        NSString *changeOtherString = @"您也可以改定时间段范围内最低价航班.";
        CGFloat changeOtherLbHeight = [Utils heightForWidth:_contentView.frame.size.width - 20 text:changeOtherString font:[UIFont systemFontOfSize:13]];
        UILabel *changeOtherLb = [[UILabel alloc]initWithFrame:CGRectMake(priceIllegalLb.frame.origin.x, controlYLength(_selectPriceReasonBtn) + 5, priceIllegalLb.frame.size.width, changeOtherLbHeight)];
        [changeOtherLb setBackgroundColor:color(clearColor)];
        [changeOtherLb setNumberOfLines:0];
        [changeOtherLb setAutoBreakLine:YES];
        [changeOtherLb setText:changeOtherString];
        [changeOtherLb setTextColor:color(lightGrayColor)];
        [changeOtherLb setTextAlignment:NSTextAlignmentCenter];
        [changeOtherLb setFont:[UIFont systemFontOfSize:13]];
        [_contentView addSubview:changeOtherLb];
        
        AirListViewCell   *cheapestCell = nil;
        if (_flight) {
            cheapestCell = [[AirListViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cheapestCell setFrame:CGRectMake(0, controlYLength(changeOtherLb) + 5, _contentView.frame.size.width, AirListViewCellHeight)];
            [cheapestCell isShow:YES];
            [cheapestCell setViewContentWithParams:_flight];
            [_contentView addSubview:cheapestCell];
        }
        
        UIButton *returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [returnBtn setFrame:CGRectMake(_contentView.frame.size.width/6, controlYLength((cheapestCell?cheapestCell:changeOtherLb)) + 5, _contentView.frame.size.width/4, 30)];
        [returnBtn setBackgroundImage:imageNameAndType(@"bg_btn_blue", nil) forState:UIControlStateNormal];
        [returnBtn setTitle:@"返回重选" forState:UIControlStateNormal];
        [returnBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [returnBtn addTarget:self action:@selector(pickerCalcel) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:returnBtn];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setFrame:CGRectMake(_contentView.frame.size.width - controlXLength(returnBtn), returnBtn.frame.origin.y, returnBtn.frame.size.width, returnBtn.frame.size.height)];
        [orderBtn setBackgroundImage:imageNameAndType(@"button_booking", nil) forState:UIControlStateNormal];
        [orderBtn setTitle:@"预订" forState:UIControlStateNormal];
        [orderBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [orderBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:orderBtn];
        
        
        [_contentView setFrame:CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, _contentView.frame.size.width, controlYLength(orderBtn) + 10)];
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

@interface RCPickerViewController ()

@property (strong, nonatomic) UITableView    *theTableView;
@property (strong, nonatomic) UIView         *contentView;

@property (assign, nonatomic) CGAffineTransform transform;

@end

@implementation RCPickerViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setSubviewFrame];
    }
    return self;
}

- (void)fire
{
    [self createContentView];
    
    CGFloat contentViewHeight = 40 * ([_dataSource count] + 1) < (self.view.frame.size.height - 100)?40 * ([_dataSource count] + 1):(self.view.frame.size.height - 100);
    CGFloat tableViewHeight = 40 * ([_dataSource count] + 1) < (self.view.frame.size.height - 100)?40 * [_dataSource count]:(self.view.frame.size.height - 100);
    [_theTableView setFrame:CGRectMake(0, 40, _contentView.frame.size.width, tableViewHeight)];
    [_contentView setFrame:CGRectMake(0, 0, _contentView.frame.size.width, contentViewHeight)];
    [_contentView setCenter:self.view.center];
    _transform = _contentView.transform;
    
    CGAffineTransform transform = CGAffineTransformScale(_transform, 1, 0);
    [_contentView setTransform:transform];
    if (self.view.superview) {
        [self.view.superview bringSubviewToFront:self.view];
    }
    [self.view setHidden:NO];
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         [self.view setAlpha:1];
                         [_contentView setTransform:_transform];
                     }completion:^(BOOL finished){
                         
                     }];
}

- (void)pickerFinished:(ReasonCodeDTO*)rcDTO
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate RCPickerFinished:rcDTO];
                     }];
}

- (void)pickerCancel
{
    [UIView animateWithDuration:0.15
                     animations:^{
                         [self.view setAlpha:0];
                     }completion:^(BOOL finished){
                         [self.view setHidden:YES];
                         [self.delegate RCPickerCancel];
                     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    ReasonCodeDTO *rcDTO = [_dataSource objectAtIndex:indexPath.row];
    [cell.textLabel setText:rcDTO.ReasonCode];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReasonCodeDTO *rcDTO = [_dataSource objectAtIndex:indexPath.row];
    [self pickerFinished:rcDTO];
}

- (void)setSubviewFrame
{
    [self.view setBackgroundColor:color(clearColor)];
    
    UIView *coverBGView = [[UIView alloc]initWithFrame:self.view.bounds];
    [coverBGView setBackgroundColor:color(blackColor)];
    [coverBGView setAlpha:0.35];
    [self.view addSubview:coverBGView];
    
    [self.view setHidden:YES];
}


- (void)createContentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 0)];
        [_contentView setBackgroundColor:color(clearColor)];
        [self.view addSubview:_contentView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 40)];
        [label setText:[NSString stringWithFormat:@"  %@",@"违规原因"]];
        [label setBackgroundColor:color(blackColor)];
        [label setTextColor:color(whiteColor)];
        [_contentView addSubview:label];
        
        _theTableView = [[UITableView alloc]init];
        [_theTableView setDelegate:self];
        [_theTableView setDataSource:self];
        [_theTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [_contentView addSubview:_theTableView];
    }
    [_theTableView reloadData];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
//    [super touchesEnded:touches withEvent:event];
    [self pickerCancel];
}

@end
