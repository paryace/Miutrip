//
//  NewPersonViewController.m
//  MiuTrip
//
//  Created by MB Pro on 14-3-17.
//  Copyright (c) 2014年 michael. All rights reserved.
//

#import "NewPersonViewController.h"

@interface NewPersonViewController ()

@property (strong, nonatomic) UITextField   *nameTf;
@property (strong, nonatomic) UITextField   *costCenterTf;

@property (assign, nonatomic) CustomerEditType editType;
@property (strong, nonatomic) BookPassengersResponse *passenger;

@property (strong, nonatomic) NSArray       *dataSource;

@property (strong, nonatomic) NSArray        *popupListData;
@property (assign, nonatomic) NSInteger      popupType;

@end

@implementation NewPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithObject:(BookPassengersResponse*)passenger
{
    self = [super init];
    if (self) {
        _passenger = passenger;
        if (passenger) {
            _editType = CustomerEdit;
        }else{
            _editType = CustomerAdd;
        }
        [self setSubviewFrame];
        
        [self getCostCenter];
    }
    return self;
}

- (void)pressRightBtn:(UIButton*)sender
{
    if (_passenger) {
        if (![Utils textIsEmpty:_nameTf.text]) {
            _passenger.UserName = _nameTf.text;
        }if (![Utils textIsEmpty:_costCenterTf.text]) {
            _passenger.DeptName = _costCenterTf.text;
        }
    }else if (_editType == CustomerAdd){
        if ([Utils textIsEmpty:_nameTf.text]) {
            [[Model shareModel] showPromptText:@"请输入姓名" model:YES];
            return;
        }else if ([Utils textIsEmpty:_costCenterTf.text]){
            [[Model shareModel] showPromptText:@"请选择成本中心" model:YES];
            return;
        }
        _passenger = [self getPassenger];
    }
    
    [self popViewControllerTransitionType:TransitionPush completionHandler:^{
        [self.delegate editOrNewPersonDone:_passenger];
    }];
}

- (BookPassengersResponse*)getPassenger
{
    BookPassengersResponse *passenger = [[BookPassengersResponse alloc]init];
    passenger.UserName = _nameTf.text;
    passenger.DeptName = _costCenterTf.text;
    return passenger;
}

- (void)getCostCenter
{
    [self addLoadingView];
    GetCorpCostRequest *request = [[GetCorpCostRequest alloc] initWidthBusinessType:BUSINESS_ACCOUNT methodName:@"GetCorpCost"];
    request.corpId = [[[UserDefaults shareUserDefault] loginInfo] CorpID];
    [self.requestManager sendRequest:request];
}

- (void)getCostCenterDone:(GetCorpCostResponse*)response
{
    [response getObjects];
    if ([response.costs count] != 0) {
        CostCenterList *costList = [response.costs objectAtIndex:0];
        _dataSource = costList.SelectItem;
    }
    if (!_nameTf) {
        [self setSubjoinViewFrame];
    }
}

- (void)requestDone:(BaseResponseModel *)response
{
    [self removeLoadingView];

    if ([response isKindOfClass:[GetCorpCostResponse class]]) {
        [self getCostCenterDone:(GetCorpCostResponse*)response];
    }
}
- (void)pressCostCenterBtn:(UIButton*)sender
{
    [self showPopupListWithTitle:@"选择成本中心" withType:0 withData:_dataSource];
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
    UITableViewCell *cell = [popoverListView.listView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:identifier];
    }
    
    if (_popupType == 0) {
        CostCenterItem *item = [_dataSource objectAtIndex:indexPath.row];
        [cell.textLabel setText:item.ItemText];
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
    if (_popupType == 0) {
        CostCenterItem *item = [_dataSource objectAtIndex:indexPath.row];

        [_costCenterTf setText:item.ItemText];
    }
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

#pragma mark - view init
- (void)setSubviewFrame
{
//    _saveToCommonName = NO;
    
    [self setBackGroundImage:imageNameAndType(@"home_bg", nil)];
    [self setTitle:@"新增乘客"];
    [self setTopBarBackGroundImage:imageNameAndType(@"topbar", nil)];
    
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
    
}

- (void)setSubjoinViewFrame
{
    UIView *contentBG = [[UIView alloc]initWithFrame:CGRectMake(10, controlYLength(self.topBar) + 10, self.view.frame.size.width - 20, 40 * 2)];
    [contentBG setBackgroundColor:color(whiteColor)];
    [contentBG setBorderColor:color(lightGrayColor) width:0.5];
    [contentBG setCornerRadius:2.5];
    [self.view addSubview:contentBG];
    [contentBG createLineWithParam:color(lightGrayColor) frame:CGRectMake(0, contentBG.frame.size.height/2, contentBG.frame.size.width, 0.5)];
    
    UILabel *NameLeft = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [NameLeft setBackgroundColor:color(clearColor)];
    [NameLeft setText:@"  姓名"];
    [NameLeft setFont:[UIFont systemFontOfSize:13]];
    _nameTf = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, contentBG.frame.size.width, NameLeft.frame.size.height)];
    [_nameTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_nameTf setFont:[UIFont systemFontOfSize:13]];
    [_nameTf setLeftViewMode:UITextFieldViewModeAlways];
    [_nameTf setLeftView:NameLeft];
    [_nameTf setText:_passenger.UserName];
    [contentBG addSubview:_nameTf];
    [_nameTf createLineWithParam:color(lightGrayColor) frame:CGRectMake(70, 0, 0.5, _nameTf.frame.size.height)];
    
    UILabel *costCenterLeft = [[UILabel alloc]initWithFrame:NameLeft.bounds];
    [costCenterLeft setBackgroundColor:color(clearColor)];
    [costCenterLeft setFont:[UIFont systemFontOfSize:13]];
    [costCenterLeft setText:@"  成本中心"];
    _costCenterTf = [[UITextField alloc]initWithFrame:CGRectMake(_nameTf.frame.origin.x, controlYLength(_nameTf), _nameTf.frame.size.width, _nameTf.frame.size.height)];
    [_costCenterTf setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_costCenterTf setFont:[UIFont systemFontOfSize:13]];
    [_costCenterTf setLeftViewMode:UITextFieldViewModeAlways];
    [_costCenterTf setLeftView:costCenterLeft];
    [_costCenterTf setText:_passenger.DeptName];
    [contentBG addSubview:_costCenterTf];
    [_costCenterTf createLineWithParam:color(lightGrayColor) frame:CGRectMake(70, 0, 0.5, _costCenterTf.frame.size.height)];

    
    UIButton *costCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [costCenterBtn setFrame:_costCenterTf.frame];
    [costCenterBtn addTarget:self action:@selector(pressCostCenterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [costCenterBtn setBackgroundColor:color(clearColor)];
    [contentBG addSubview:costCenterBtn];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self clearKeyboard];
}

- (void)clearKeyboard
{
    if ([_nameTf isFirstResponder]) {
        [_nameTf resignFirstResponder];
    }else if ([_costCenterTf isFirstResponder]){
        [_costCenterTf resignFirstResponder];
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
